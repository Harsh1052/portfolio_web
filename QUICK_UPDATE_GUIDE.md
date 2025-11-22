# Quick Update Guide

Fast checklist for refreshing the portfolio without digging through the whole codebase.

## 1) Update Content
- Edit `assets/data/resume.json`:
  - `personalInfo` → name, title, email, socials
  - `experience`, `projects`, `skills`, `education`
- Hot reload for local dev; rebuild for production (`flutter build web --release`).

## 2) Swap Media
- Place new hero/profile images in `assets/images/`.
- Update any widget references that point to old image names.
- Keep file sizes small (WebP/SVG preferred) to protect Lighthouse scores.

## 3) Contact Form (optional)
- Populate `assets/config/firebase_options.json` with your Firebase Web config.
- Ensure Firestore has a `contactMessages` collection.
- If Firebase is missing, the UI will show a helpful setup message instead of failing silently.

## 4) Run Checks
```bash
flutter pub get
dart analyze
flutter build web --release --tree-shake-icons
```

## 5) Deploy
- Firebase: `make deploy-firebase`
- Netlify: `make deploy-netlify`
- Vercel: `make deploy-vercel`
- GitHub Pages: `make deploy-github`

## 6) Smoke Test
- Open the build in Chrome/Firefox/Safari/Edge.
- Verify:
  - Splash → hero → sections render
  - Scroll progress + back-to-top button
  - Navigation links move to correct sections
  - 404 route (`/404`) shows friendly page
  - Contact form shows success/error states as expected

## 7) Performance Spot-Check
- Serve `build/web` locally (e.g., `python3 -m http.server 8080 -d build/web`).
- Run Lighthouse/Core Web Vitals in Chrome DevTools.
- Aim for optimized image sizes and minimal console warnings.
