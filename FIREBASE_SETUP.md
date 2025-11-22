# Firebase Setup Guide

## Step 1: Create Firebase Project

Since you want to create a new Firebase project, follow these steps:

### Option A: Using Firebase Console (Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: **"Portfolio Web"** (or your preferred name)
4. Project ID will be auto-generated (e.g., `portfolio-web-xxxxx`)
5. **Disable** Google Analytics (not needed for hosting only)
6. Click **"Create project"**
7. Wait for project creation
8. **Copy the Project ID** - you'll need this!

### Option B: Using Firebase CLI

```bash
# Create new project
firebase projects:create portfolio-web-app

# Follow the prompts to set display name and region
```

## Step 2: Initialize Firebase Hosting

After creating the project, I'll initialize Firebase Hosting in your project directory.

**Project ID Format:** Usually `portfolio-web-xxxxx` where xxxxx is a random string

---

## What Will Be Configured

1. **Firebase Hosting**
   - Public directory: `build/web`
   - Single-page app routing
   - Optimized caching headers
   - SSL certificate (automatic)
   - CDN (automatic)

2. **Deployment Commands**
   - `make deploy-firebase` - Deploy to Firebase
   - `firebase deploy --only hosting` - Manual deploy
   - GitHub Actions auto-deploy (optional)

3. **Your Portfolio URL**
   - `https://PROJECT_ID.web.app`
   - `https://PROJECT_ID.firebaseapp.com`
   - Custom domain (optional)

---

## Next Steps

1. Create the Firebase project (follow Option A or B above)
2. Copy the Project ID
3. Let me know when done, and I'll initialize Firebase Hosting
4. Deploy your portfolio!

---

## App Configuration (for contact form)

1. Create a **Web App** in Firebase Console and copy the config snippet.
2. Update `assets/config/firebase_options.json` with the values:
   - `apiKey`, `authDomain`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`, `measurementId` (optional).
3. Enable **Cloud Firestore** and keep a `contactMessages` collection (security rules as needed).
4. Rebuild the app: `flutter pub get && flutter build web --release`.

---

## Files That Will Be Updated

- `.firebaserc` - Your project ID
- `.github/workflows/firebase-deploy.yml` - GitHub Actions deployment
- All set! Just create the project and provide the ID.
