# Contact Form Setup Guide

This guide will help you configure the contact form to send emails using various services.

## Overview

The `ContactFormController` supports three methods for handling form submissions:

1. **Your Own Backend API** - Full control over email handling
2. **EmailJS** - Free service for sending emails from client-side
3. **Formspree** - Simple form backend service

Currently, the form uses a **simulated API call** for demo purposes. Follow the instructions below to set up a real email service.

---

## Option 1: Your Own Backend API

### Setup Steps:

1. Create a backend API endpoint that accepts POST requests with this structure:
   ```json
   {
     "name": "John Doe",
     "email": "john@example.com",
     "subject": "Project Inquiry",
     "message": "I'd like to discuss...",
     "timestamp": "2024-01-01T12:00:00.000Z"
   }
   ```

2. In `contact_form_controller.dart`, uncomment the `_sendToBackend` call in `submitForm()`:
   ```dart
   // Replace this line:
   await _simulateApiCall(formData);

   // With this:
   await _sendToBackend(formData);
   ```

3. Update the API URL in `_sendToBackend()`:
   ```dart
   const apiUrl = 'https://your-backend-api.com/contact';
   ```

### Example Backend Implementations:

#### Node.js/Express Example:
```javascript
const express = require('express');
const nodemailer = require('nodemailer');
const app = express();

app.post('/contact', async (req, res) => {
  const { name, email, subject, message } = req.body;

  const transporter = nodemailer.createTransporter({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS
    }
  });

  await transporter.sendMail({
    from: email,
    to: 'your-email@example.com',
    subject: `Portfolio Contact: ${subject}`,
    html: `
      <h3>New Contact Form Submission</h3>
      <p><strong>From:</strong> ${name} (${email})</p>
      <p><strong>Subject:</strong> ${subject}</p>
      <p><strong>Message:</strong></p>
      <p>${message}</p>
    `
  });

  res.status(200).json({ success: true });
});
```

#### Python/Flask Example:
```python
from flask import Flask, request, jsonify
from flask_mail import Mail, Message

app = Flask(__name__)
mail = Mail(app)

@app.route('/contact', methods=['POST'])
def contact():
    data = request.json

    msg = Message(
        subject=f"Portfolio Contact: {data['subject']}",
        sender=data['email'],
        recipients=['your-email@example.com']
    )

    msg.body = f"""
    New Contact Form Submission

    From: {data['name']} ({data['email']})
    Subject: {data['subject']}

    Message:
    {data['message']}
    """

    mail.send(msg)
    return jsonify({'success': True})
```

---

## Option 2: EmailJS (Recommended for Quick Setup)

EmailJS is a free service that sends emails directly from the client-side. Perfect for portfolios and landing pages.

### Setup Steps:

1. **Create an EmailJS Account:**
   - Visit [https://www.emailjs.com/](https://www.emailjs.com/)
   - Sign up for a free account (300 emails/month)

2. **Create an Email Service:**
   - Go to Email Services → Add New Service
   - Choose your email provider (Gmail, Outlook, etc.)
   - Follow the authentication steps
   - Note your **Service ID**

3. **Create an Email Template:**
   - Go to Email Templates → Create New Template
   - Use these template variables:
     ```
     From: {{name}} ({{email}})
     Subject: {{subject}}
     Message: {{message}}
     ```
   - Note your **Template ID**

4. **Get Your User ID:**
   - Go to Account → API Keys
   - Copy your **Public Key** (User ID)

5. **Configure in Flutter:**

   In `contact_form_controller.dart`, update the `submitForm()` method:
   ```dart
   // Replace this:
   await _simulateApiCall(formData);

   // With this:
   await _sendViaEmailJS(formData);
   ```

   Then update the credentials in `_sendViaEmailJS()`:
   ```dart
   const serviceId = 'service_xxxxxxx';  // Your Service ID
   const templateId = 'template_xxxxxx'; // Your Template ID
   const userId = 'user_xxxxxxxxxxxx';   // Your Public Key
   ```

### Example EmailJS Template:

```
Subject: Portfolio Contact - {{subject}}

From: {{name}}
Email: {{email}}
Subject: {{subject}}

Message:
{{message}}

---
Sent from: Portfolio Contact Form
Time: {{timestamp}}
```

---

## Option 3: Formspree

Formspree is another simple service for handling form submissions.

### Setup Steps:

1. **Create a Formspree Account:**
   - Visit [https://formspree.io/](https://formspree.io/)
   - Sign up for a free account (50 submissions/month)

2. **Create a New Form:**
   - Click "New Form"
   - Enter your email address
   - Note your **Form ID** (format: `xxxxxxxxxxx`)

3. **Configure in Flutter:**

   In `contact_form_controller.dart`, update the `submitForm()` method:
   ```dart
   // Replace this:
   await _simulateApiCall(formData);

   // With this:
   await _sendViaFormspree(formData);
   ```

   Then update the Form ID in `_sendViaFormspree()`:
   ```dart
   const formspreeId = 'xxxxxxxxxxx'; // Your Form ID
   ```

---

## Testing

After configuring your chosen service, test the form by:

1. Running your Flutter web app
2. Filling out the contact form
3. Submitting and checking for:
   - Success message appears
   - Email arrives in your inbox
   - Form fields clear after submission

---

## Security Best Practices

### For Backend API:
- ✅ Use HTTPS
- ✅ Implement rate limiting
- ✅ Validate and sanitize inputs
- ✅ Use environment variables for secrets
- ✅ Implement CORS properly
- ✅ Add spam protection (reCAPTCHA)

### For EmailJS/Formspree:
- ✅ Enable origin restrictions
- ✅ Set up email notifications
- ✅ Monitor usage limits
- ✅ Add honeypot fields for spam protection

---

## Adding reCAPTCHA (Optional)

To prevent spam, you can add Google reCAPTCHA:

1. Get reCAPTCHA keys from [https://www.google.com/recaptcha/](https://www.google.com/recaptcha/)

2. Add the `flutter_recaptcha_v2` package:
   ```yaml
   dependencies:
     flutter_recaptcha_v2: ^3.0.0
   ```

3. Integrate in the form:
   ```dart
   // Add reCAPTCHA verification before form submission
   final recaptchaV2 = RecaptchaV2Controller();
   final token = await recaptchaV2.show();

   if (token != null) {
     // Proceed with form submission
     await _contactController.submitForm();
   }
   ```

---

## Troubleshooting

### Email not received:
- Check spam folder
- Verify service credentials
- Check service dashboard for errors
- Test with different email addresses

### CORS errors:
- Configure backend to allow your domain
- For EmailJS/Formspree, add your domain in dashboard settings

### Rate limiting:
- Monitor your service usage
- Implement client-side rate limiting
- Upgrade to paid plan if needed

---

## Environment Variables

Store sensitive information in environment variables:

1. Create `.env` file (add to `.gitignore`):
   ```
   EMAILJS_SERVICE_ID=service_xxxxxxx
   EMAILJS_TEMPLATE_ID=template_xxxxxx
   EMAILJS_USER_ID=user_xxxxxxxxxxxx
   ```

2. Use the `flutter_dotenv` package:
   ```yaml
   dependencies:
     flutter_dotenv: ^5.1.0
   ```

3. Load and use in code:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   await dotenv.load();
   final serviceId = dotenv.env['EMAILJS_SERVICE_ID']!;
   ```

---

## Additional Resources

- [EmailJS Documentation](https://www.emailjs.com/docs/)
- [Formspree Documentation](https://help.formspree.io/)
- [Nodemailer Guide](https://nodemailer.com/about/)
- [Flutter url_launcher Package](https://pub.dev/packages/url_launcher)

---

## Support

If you encounter issues:
1. Check the Flutter console for error messages
2. Review service dashboard logs
3. Test with simpler configurations first
4. Verify all credentials are correct

For demo purposes, the form currently uses `_simulateApiCall()` which logs to console. Replace it with your chosen method above.
