# Harsh Sureja - Portfolio Web (Flutter)

A polished, responsive Flutter Web portfolio that showcases experience, projects, skills, and contact options with strong animation, accessibility, and deployment support.

## Overview
- Modern M3-inspired UI with animated hero, skills, experience, projects, and contact sections
- New animated splash screen, scroll progress indicator, and 404 page
- Smooth scrolling + floating navigation with keyboard/semantic support
- Dynamic content powered by `assets/data/resume.json` (no code changes needed)
- Firebase-ready contact form (Firestore) with graceful fallback messaging
- SEO + social meta tags, favicons, manifest, and PWA-friendly setup

## Screenshots
- _Add your screenshots in `assets/images/` and reference them here:_
  - Hero & navigation
  - Skills & experience timeline
  - Projects grid
  - Contact form

## Features
- 🌟 Animated splash + scroll progress + back-to-top control
- 🔀 Smooth section navigation with GetX + responsive layout
- ♿ Semantics labels, skip link (web), keyboard-focusable navigation
- 🔥 Firebase contact form (optional) with server timestamp + platform tagging
- 📦 Auto-reloadable resume data for fast content updates
- 🛠 Ready-to-use deployment targets (Firebase, Netlify, Vercel, GitHub Pages)

## Tech Stack
- **Flutter Web (3.x)**, **Dart (>=3.4)**, **GetX** (state + routing), **Responsive Framework**
- Animations: **flutter_animate**, **animated_text_kit**
- UI: **Google Fonts**, custom themes, gradients, shader warmup
- Utilities: **url_launcher**, **visibility_detector**, **firebase_core**, **cloud_firestore**

## Project Structure
```
lib/
├─ controllers/    # GetX controllers (navigation, contact form, theme, resume)
├─ models/         # Resume data models
├─ services/       # Resume loader + Firebase service
├─ screens/        # Home + 404
├─ widgets/        # Sections, animations, nav, cards, cursor, etc.
└─ utils/          # Design system, responsive helpers, themes, animation constants

assets/
├─ data/resume.json        # Primary content source (edit this!)
├─ config/firebase_options.json (optional)
├─ images/                 # Screenshots, avatars, illustrations
└─ icons/                  # Custom icons/favicons
```

## Local Setup
```bash
git clone <repository-url>
cd portfolio_web
flutter pub get
flutter run -d chrome
```

### Updating Content (`resume.json`)
1) Open `assets/data/resume.json`.  
2) Edit `personalInfo`, `experience`, `projects`, `skills`, `education`.  
3) Save and hot-reload; `ResumeService` auto-refreshes in debug (non-web) and reloads on startup for web.

### Enabling the Contact Form (Firebase)
1) Create a Firebase Web App.  
2) Put credentials in `assets/config/firebase_options.json` (replace placeholders).  
3) Enable Firestore and create a `contactMessages` collection.  
4) Deploy/build; the controller handles initialization and error messaging.

## Build & Deploy
```bash
# Production build
flutter build web --release

# Quick Make shortcuts
make build             # flutter build web --release
make deploy-firebase   # Firebase Hosting
make deploy-netlify    # Netlify
make deploy-vercel     # Vercel
make deploy-github     # GitHub Pages
```
See [DEPLOYMENT.md](DEPLOYMENT.md) for platform-specific setup.

## Accessibility
- Semantics on navigation, sections, and key controls (including back-to-top)
- Skip link in `web/index.html` for keyboard users
- Ensure screen readers announce sections; use tab/shift+tab to navigate menus/buttons

## Performance & Testing
- Run `dart analyze` to keep the code clean.
- For Lighthouse/Core Web Vitals: build (`flutter build web --release`), serve locally (`python3 -m http.server 8080 -d build/web`), then run Lighthouse in Chrome DevTools.
- Monitor bundle size in `build/web/` and use `flutter build web --release --tree-shake-icons`.

## Troubleshooting
- **Blank page / route not found:** unknown routes fall back to `/404`.
- **Firebase errors:** confirm `firebase_options.json` values and Firestore rules; ensure network access.
- **Slow first paint:** shader warmup is enabled; keep hero images optimized and prefer SVG where possible.
- **Assets not loading:** check `pubspec.yaml` assets section and rebuild.

## Quick Update Checklist
- Update `assets/data/resume.json` for content changes.
- Add new images to `assets/images/` and reference them in the UI/widgets.
- Run `flutter pub get`, `dart analyze`, then `flutter build web --release`.
- Deploy with the Make target for your host.

## License
This project is for portfolio use. Adapt and deploy for personal sites with attribution appreciated.

Edit `assets/data/resume.json`:

```json
{
  "personalInfo": {
    "name": "Your Name",
    "title": "Your Title",
    "email": "your.email@example.com",
    ...
  }
}
```

### Customize Theme

Edit `lib/utils/constants.dart` and `lib/utils/theme.dart`:

```dart
// Change primary color
static const Color primary = Color(0xFF2196F3);

// Update spacing, fonts, etc.
```

### Add New Sections

1. Create new model in `lib/models/`
2. Add data to `resume.json`
3. Create widget in `lib/widgets/`
4. Add to `home_screen.dart`

## How to Update Portfolio

This portfolio features **automatic hot reload** during development. Simply edit `assets/data/resume.json` and watch your changes appear instantly!

### Step 1: Edit Resume Data

Open `assets/data/resume.json` in your favorite editor and update your information:

```bash
# Open in VS Code
code assets/data/resume.json

# Or use any text editor
nano assets/data/resume.json
```

### Step 2: Run in Development Mode

```bash
flutter run -d chrome
```

The app will:
- ✅ Automatically load your resume data
- ✅ Watch for file changes (desktop/mobile only)
- ✅ Reload data when you save changes
- ✅ Validate your JSON structure
- ✅ Show validation errors in console

### Step 3: See Changes Instantly

- Save `resume.json` after making changes
- The app automatically reloads the data (in debug mode)
- Check the console for validation messages
- If validation fails, errors will be logged

### Validation Features

The resume service validates your JSON structure:

```
✓ All required fields are present
✓ Data types are correct
✓ Arrays are properly formatted
✓ No missing required properties
```

If validation fails, check the console for specific errors like:
```
Resume JSON validation errors:
  - personalInfo.email is required
  - experience[0].position is required
```

### Hot Reload Support

**Desktop/Mobile Development:**
- File changes are detected automatically
- Data reloads without restarting the app

**Web Development:**
- Hot reload works with `flutter run -d chrome`
- File watching is disabled on web (Flutter limitation)
- Use hot reload (r) or hot restart (R) to see changes

### Tips for Updating

1. **Validate JSON**: Use a JSON validator before saving
2. **Check Console**: Watch for validation errors
3. **Use Git**: Track changes to your resume data
4. **Backup**: Keep a copy before major changes
5. **Test Locally**: Always test before deploying

## Resume JSON Schema

Complete schema for `assets/data/resume.json`:

```json
{
  "personalInfo": {
    "name": "string (required)",
    "title": "string (required)",
    "email": "string (required)",
    "phone": "string (optional)",
    "location": "string (optional)",
    "bio": "string (required)",
    "avatarUrl": "string (optional)",
    "socialLinks": {
      "github": "string (optional)",
      "linkedin": "string (optional)",
      "twitter": "string (optional)",
      "website": "string (optional)",
      "medium": "string (optional)",
      "stackoverflow": "string (optional)",
      "others": {
        "key": "value"
      }
    }
  },
  "experience": [
    {
      "position": "string (required)",
      "company": "string (required)",
      "location": "string (required)",
      "startDate": "string (required)",
      "endDate": "string (required)",
      "employmentType": "string (optional)",
      "companyUrl": "string (optional)",
      "responsibilities": ["string"],
      "technologies": ["string"]
    }
  ],
  "projects": [
    {
      "name": "string (required)",
      "description": "string (required)",
      "technologies": ["string (required)"],
      "githubUrl": "string (optional)",
      "liveUrl": "string (optional)",
      "imageUrl": "string (optional)",
      "features": ["string (optional)"],
      "startDate": "string (optional)",
      "endDate": "string (optional)",
      "isFeatured": "boolean (default: false)",
      "category": "string (optional)"
    }
  ],
  "skills": [
    {
      "name": "string (category name)",
      "icon": "string (optional)",
      "skills": [
        {
          "name": "string",
          "category": "string",
          "proficiency": "number (1-100, optional)",
          "icon": "string (optional)",
          "subSkills": ["string (optional)"]
        }
      ]
    }
  ],
  "education": [
    {
      "degree": "string (required)",
      "institution": "string (required)",
      "location": "string (optional)",
      "startDate": "string (required)",
      "endDate": "string (required)",
      "gpa": "string (optional)",
      "achievements": ["string (optional)"],
      "description": "string (optional)"
    }
  ]
}
```

### Schema Notes

- **Required fields** must be present or validation will fail
- **Optional fields** can be omitted or set to `null`
- **proficiency** is 1-100 scale (automatically converts to level: Beginner, Intermediate, Advanced, Expert)
- **startDate/endDate** can be any string format ("June 2024", "2024-06", etc.)
- **isFeatured** determines if project shows prominently
- **socialLinks.others** accepts any custom key-value pairs

## Features Roadmap

- [ ] Dark mode toggle
- [ ] Section navigation with smooth scroll
- [ ] Contact form integration
- [ ] Blog section
- [ ] Project filtering and search
- [ ] PDF resume download
- [ ] Analytics integration
- [ ] Multi-language support

## Performance

- **First Contentful Paint**: < 2s
- **Time to Interactive**: < 3s
- **Lighthouse Score**: 90+
- **SEO Score**: 100

## Browser Support

- ✅ Chrome (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Edge (latest)
- ✅ Mobile browsers

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

## Contact

**Harsh Sureja**
- Email: surejapatel@gmail.com
- Phone: +91 9879776369
- GitHub: [github.com/harshsureja](https://github.com/harshsureja)
- LinkedIn: [linkedin.com/in/harshsureja](https://linkedin.com/in/harshsureja)

## Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for beautiful typography
- Material Design for design guidelines
- GetX community for state management solution

---

Built with ❤️ using Flutter
