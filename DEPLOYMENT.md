# Deployment Guide

Complete guide for deploying your Flutter Web portfolio to various hosting platforms.

## Table of Contents

- [Quick Start](#quick-start)
- [Firebase Hosting](#firebase-hosting)
- [GitHub Pages](#github-pages)
- [Netlify](#netlify)
- [Vercel](#vercel)
- [Custom Domain Setup](#custom-domain-setup)
- [CI/CD with GitHub Actions](#cicd-with-github-actions)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

### Prerequisites

- Flutter SDK 3.32.8 (or newer in the 3.x line)
- Git
- Node.js and npm (for Firebase, Netlify, or Vercel CLI)

### Build for Production

```bash
# Using Makefile (recommended)
make build

# Or using the build script directly
./scripts/build.sh

# Or using Flutter CLI
flutter build web --release --web-renderer canvaskit
```

The build output will be in `build/web/`

---

## Firebase Hosting

Firebase Hosting offers free hosting with SSL, CDN, and excellent performance.

### Step 1: Install Firebase CLI

```bash
# Using Makefile
make setup-firebase

# Or manually
npm install -g firebase-tools
```

### Step 2: Login to Firebase

```bash
firebase login
```

### Step 3: Initialize Firebase Project

```bash
firebase init hosting
```

Select the following options:
- **What do you want to use as your public directory?** `build/web`
- **Configure as a single-page app?** `Yes`
- **Set up automatic builds and deploys with GitHub?** `Optional`

### Step 4: Update Firebase Project ID

Edit `.firebaserc` and replace `portfolio-web-project` with your Firebase project ID:

```json
{
  "projects": {
    "default": "your-project-id"
  }
}
```

### Step 5: Deploy

```bash
# Using Makefile
make deploy-firebase

# Or manually
firebase deploy --only hosting
```

Your site will be live at: `https://your-project-id.web.app`

### Firebase Configuration

The `firebase.json` file includes:
- SPA routing (all routes go to index.html)
- Optimized caching headers
- Clean URLs
- Security headers

---

## GitHub Pages

Free hosting directly from your GitHub repository.

### Step 1: Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** > **Pages**
3. Under **Source**, select **GitHub Actions**

### Step 2: Push to GitHub

```bash
git add .
git commit -m "Add deployment configuration"
git push origin main
```

### Step 3: Automatic Deployment

The GitHub Actions workflow (`.github/workflows/github-pages.yml`) will:
- Automatically build your app
- Deploy to GitHub Pages
- Make it available at `https://yourusername.github.io/repository-name/`

### Manual Deployment

```bash
# Build with correct base-href
flutter build web --release --web-renderer canvaskit --base-href "/repository-name/"

# Deploy using GitHub Pages action or manually push to gh-pages branch
```

---

## Netlify

Netlify offers continuous deployment, serverless functions, and form handling.

### Option 1: Drag and Drop (Easiest)

1. Build your project:
   ```bash
   make build
   ```
2. Go to [Netlify Drop](https://app.netlify.com/drop)
3. Drag and drop the `build/web` folder
4. Done! Your site is live

### Option 2: CLI Deployment

#### Step 1: Install Netlify CLI

```bash
# Using Makefile
make setup-netlify

# Or manually
npm install -g netlify-cli
```

#### Step 2: Login

```bash
netlify login
```

#### Step 3: Initialize Site

```bash
netlify init
```

Follow the prompts to create a new site or link to an existing one.

#### Step 4: Deploy

```bash
# Using Makefile
make deploy-netlify

# Or manually
netlify deploy --prod --dir=build/web
```

### Option 3: Git Integration (Recommended)

1. Push your code to GitHub/GitLab/Bitbucket
2. Go to [Netlify](https://app.netlify.com)
3. Click **New site from Git**
4. Select your repository
5. Build settings are auto-configured from `netlify.toml`
6. Click **Deploy site**

Your site will auto-deploy on every push to main branch.

---

## Vercel

Vercel offers edge network deployment with excellent performance.

### Step 1: Install Vercel CLI

```bash
# Using Makefile
make setup-vercel

# Or manually
npm install -g vercel
```

### Step 2: Login

```bash
vercel login
```

### Step 3: Deploy

```bash
# Using Makefile
make deploy-vercel

# Or manually
vercel --prod
```

### Git Integration (Recommended)

1. Push your code to GitHub/GitLab/Bitbucket
2. Go to [Vercel](https://vercel.com)
3. Click **New Project**
4. Import your repository
5. Settings are auto-configured from `vercel.json`
6. Click **Deploy**

Auto-deploys on every push to main branch.

---

## Custom Domain Setup

### Firebase Hosting

```bash
firebase hosting:channel:deploy live --only hosting
firebase open hosting:site
```

In Firebase Console:
1. Go to Hosting section
2. Click **Add custom domain**
3. Follow the DNS configuration steps

### GitHub Pages

1. Add a `CNAME` file to `build/web/` with your domain:
   ```
   yourdomain.com
   ```
2. Configure DNS with your domain registrar:
   ```
   A Record: 185.199.108.153
   A Record: 185.199.109.153
   A Record: 185.199.110.153
   A Record: 185.199.111.153
   ```

### Netlify

1. Go to **Domain settings** in Netlify dashboard
2. Click **Add custom domain**
3. Follow DNS configuration or use Netlify DNS

### Vercel

1. Go to **Settings** > **Domains**
2. Add your custom domain
3. Follow DNS configuration steps

---

## CI/CD with GitHub Actions

Three workflows are included:

### 1. Firebase Deploy (`.github/workflows/firebase-deploy.yml`)

Automatically deploys to Firebase on push to main/master.

**Setup:**
1. Go to Firebase Console
2. Generate a service account key
3. Add it as `FIREBASE_SERVICE_ACCOUNT` secret in GitHub
4. Update `projectId` in the workflow file

### 2. GitHub Pages (`.github/workflows/github-pages.yml`)

Automatically deploys to GitHub Pages on push.

**Setup:**
1. Enable GitHub Pages in repository settings
2. Select "GitHub Actions" as source
3. Push to trigger deployment

### 3. CI Testing (`.github/workflows/ci.yml`)

Runs on every push and pull request to ensure code quality.

**Features:**
- Code formatting check
- Static analysis
- Test execution
- Build verification
- Size reporting

---

## Environment Variables

For production builds with different configurations:

```bash
flutter build web \
  --release \
  --web-renderer canvaskit \
  --dart-define=API_URL=https://api.production.com \
  --dart-define=ANALYTICS_ID=GA-XXXXXXXXX
```

Access in code:
```dart
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');
```

---

## Build Optimization

### 1. Reduce Bundle Size

```bash
# Use CanvasKit for better performance
flutter build web --web-renderer canvaskit

# Enable tree shaking
flutter build web --tree-shake-icons

# Enable code splitting
flutter build web --split-debug-info=build/debug_info
```

### 2. Enable PWA

```bash
flutter build web --pwa-strategy offline-first
```

### 3. Source Maps

Include source maps for debugging production issues:

```bash
flutter build web --source-maps
```

### 4. Performance Monitoring

Add to `web/index.html`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA-XXXXXXXXX"></script>

<!-- Firebase Performance -->
<script src="https://www.gstatic.com/firebasejs/9.x.x/firebase-performance.js"></script>
```

---

## Troubleshooting

### Build Issues

**Problem:** Build fails with memory error
```bash
# Solution: Increase memory
flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true
```

**Problem:** Assets not loading
```bash
# Solution: Check pubspec.yaml assets section
flutter:
  assets:
    - assets/data/
    - assets/images/
```

### Deployment Issues

**Problem:** 404 on refresh (SPA routing)
```bash
# Solution: Ensure rewrites are configured
# Firebase: Check firebase.json
# Netlify: Check netlify.toml
# Vercel: Check vercel.json
```

**Problem:** CORS errors
```bash
# Solution: Configure headers in hosting config
# Add Access-Control-Allow-Origin headers
```

### Performance Issues

**Problem:** Slow initial load
```bash
# Solution 1: Use CanvasKit renderer
flutter build web --web-renderer canvaskit

# Solution 2: Enable code splitting
flutter build web --split-debug-info=build/debug_info

# Solution 3: Optimize images (use WebP)
# Solution 4: Enable caching headers
```

**Problem:** Large bundle size
```bash
# Check what's in the bundle
du -sh build/web/*

# Use tree shaking
flutter build web --tree-shake-icons

# Remove unused dependencies
flutter pub deps
```

---

## Deployment Checklist

Before deploying to production:

- [ ] Update `assets/data/resume.json` with your information
- [ ] Update meta tags in `web/index.html`
- [ ] Add favicon and app icons
- [ ] Test on multiple browsers
- [ ] Test on mobile devices
- [ ] Run `flutter analyze` with no issues
- [ ] Optimize images (WebP, compression)
- [ ] Set up analytics (Google Analytics, Firebase)
- [ ] Configure custom domain (if applicable)
- [ ] Test all links and navigation
- [ ] Verify SEO meta tags
- [ ] Enable HTTPS
- [ ] Set up monitoring (Sentry, Firebase Crashlytics)
- [ ] Create backup/version control

---

## Useful Commands

```bash
# View all available commands
make help

# Build for production
make build

# Deploy to Firebase
make deploy-firebase

# Deploy to Netlify
make deploy-netlify

# Deploy to Vercel
make deploy-vercel

# Deploy to all platforms
make deploy-all

# Serve locally
make serve

# Development mode
make dev

# Run tests
make test

# Format code
make format

# Analyze code
make analyze
```

---

## Resources

- [Flutter Web Documentation](https://flutter.dev/web)
- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [Netlify Documentation](https://docs.netlify.com)
- [Vercel Documentation](https://vercel.com/docs)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

---

## Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review GitHub Issues
3. Consult platform-specific documentation

---

Built with Flutter Web | Updated: November 2025
