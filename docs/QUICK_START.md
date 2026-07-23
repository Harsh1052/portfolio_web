# Quick Start - Update Your Portfolio in 3 Steps

## 🚀 Step 1: Edit Your Data

```bash
code assets/data/resume.json
```

Update your information:
- Personal info (name, title, email, bio)
- Work experience
- Projects
- Skills
- Education

## 🏃 Step 2: Run the App

```bash
flutter run -d chrome
```

The app will:
- ✅ Load your data automatically
- ✅ Watch for file changes
- ✅ Validate JSON structure
- ✅ Show errors in console

## 👀 Step 3: See Your Changes

**Save** `resume.json` → **Changes appear instantly!**

*On web: Press `r` for hot reload or `R` for hot restart*

---

## 📋 Common Tasks

### Update Your Name/Title
```json
{
  "personalInfo": {
    "name": "Your Name",
    "title": "Your Job Title"
  }
}
```

### Add Work Experience
```json
{
  "experience": [
    {
      "position": "Senior Developer",
      "company": "Company Name",
      "startDate": "Jan 2024",
      "endDate": "Present",
      "responsibilities": [
        "Built amazing features",
        "Led development team"
      ],
      "technologies": ["Flutter", "Dart"]
    }
  ]
}
```

### Add a Project
```json
{
  "projects": [
    {
      "name": "My Awesome Project",
      "description": "A revolutionary app",
      "technologies": ["Flutter", "Firebase"],
      "isFeatured": true,
      "githubUrl": "https://github.com/...",
      "liveUrl": "https://..."
    }
  ]
}
```

### Add Skills
```json
{
  "skills": [
    {
      "name": "Mobile Development",
      "skills": [
        {
          "name": "Flutter",
          "proficiency": 95
        }
      ]
    }
  ]
}
```

---

## ⚡ Tips

- **Validate JSON** before saving (VS Code does this automatically)
- **Check console** for validation errors
- **Use Git** to track changes
- **Test locally** before deploying

---

## 🐛 Troubleshooting

**Changes not showing?**
- Web: Press `r` or `R`
- Desktop/Mobile: Should auto-reload

**JSON errors?**
- Check console output
- Validate at https://jsonlint.com/
- Look for missing commas, quotes

**App crashes?**
- Check required fields are present
- Ensure arrays use `[]` not `{}`
- Verify all URLs are valid strings

---

## 📦 Deploy

```bash
# Build for web
flutter build web --release

# Output in build/web/
# Deploy to Firebase, Netlify, Vercel, etc.
```

---

## 📚 Full Documentation

- **Complete Guide**: `RESUME_AUTOMATION_GUIDE.md`
- **README**: `README.md`
- **Schema Reference**: See README.md → Resume JSON Schema

---

**That's it! Edit → Save → See changes. Simple! 🎉**
