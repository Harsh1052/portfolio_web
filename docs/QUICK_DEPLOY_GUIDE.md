# Quick Deployment Guide

One-page reference for deploying your Flutter Web portfolio.

## Prerequisites

```bash
# Ensure Flutter is installed
flutter --version

# Ensure Node.js is installed (for CLI tools)
node --version
npm --version
```

## Build for Production

```bash
# Recommended: Use Makefile
make build

# Or use build script
./scripts/build.sh

# Or manual build
flutter build web --release --web-renderer canvaskit
```

Output: `build/web/`

---

## Deploy to Firebase Hosting

### First Time Setup
```bash
# 1. Install & login
npm install -g firebase-tools
firebase login

# 2. Initialize project
firebase init hosting
# Select: build/web as public directory
# Select: Yes for SPA

# 3. Update project ID in .firebaserc
# Replace "portfolio-web-project" with your Firebase project ID

# 4. Deploy
make deploy-firebase
```

### Subsequent Deploys
```bash
make deploy-firebase
```

**Live URL:** `https://your-project-id.web.app`

---

## Deploy to GitHub Pages

### First Time Setup
```bash
# 1. Enable GitHub Pages
# Go to: Repository Settings > Pages
# Source: GitHub Actions

# 2. Push to GitHub
git add .
git commit -m "Add deployment setup"
git push origin main
```

### Subsequent Deploys
- Automatic on every push to main/master branch
- Workflow: `.github/workflows/github-pages.yml`

**Live URL:** `https://yourusername.github.io/repository-name/`

---

## Deploy to Netlify

### Method 1: Drag & Drop (Easiest)
```bash
# 1. Build
make build

# 2. Go to https://app.netlify.com/drop

# 3. Drag and drop build/web folder

# Done!
```

### Method 2: CLI
```bash
# First time
npm install -g netlify-cli
netlify login
netlify init

# Deploy
make deploy-netlify
```

### Method 3: Git Integration (Best)
```bash
# 1. Push code to GitHub
# 2. Go to netlify.com
# 3. Click "New site from Git"
# 4. Select repository
# 5. Deploy (auto-configured from netlify.toml)
```

**Live URL:** `https://your-site-name.netlify.app`

---

## Deploy to Vercel

### CLI Method
```bash
# First time
npm install -g vercel
vercel login

# Deploy
make deploy-vercel
```

### Git Integration (Recommended)
```bash
# 1. Push code to GitHub
# 2. Go to vercel.com
# 3. Click "New Project"
# 4. Import repository
# 5. Deploy (auto-configured from vercel.json)
```

**Live URL:** `https://your-project.vercel.app`

---

## Custom Domain

### Firebase
```bash
firebase hosting:channel:deploy live
# Then add domain in Firebase Console
```

### GitHub Pages
```bash
# Add CNAME file to build/web/
echo "yourdomain.com" > build/web/CNAME

# Configure DNS:
# A Record: 185.199.108.153
# A Record: 185.199.109.153
# A Record: 185.199.110.153
# A Record: 185.199.111.153
```

### Netlify/Vercel
- Add domain in dashboard
- Follow DNS configuration steps

---

## Useful Commands

```bash
# View all commands
make help

# Development
make dev                 # Run development server
make build              # Build for production
make serve              # Serve build locally
make analyze            # Analyze code
make test               # Run tests

# Deployment
make deploy-firebase    # Deploy to Firebase
make deploy-netlify     # Deploy to Netlify
make deploy-vercel      # Deploy to Vercel
make deploy-all         # Deploy to all platforms

# Setup
make setup-firebase     # Install Firebase CLI
make setup-netlify      # Install Netlify CLI
make setup-vercel       # Install Vercel CLI
```

---

## GitHub Actions (Auto-Deploy)

Three workflows included:

1. **firebase-deploy.yml** - Auto-deploy to Firebase
2. **github-pages.yml** - Auto-deploy to GitHub Pages
3. **ci.yml** - Run tests on every PR

All trigger automatically on push to main/master.

---

## Troubleshooting

### Build fails
```bash
flutter clean
flutter pub get
make build
```

### 404 on page refresh
- Ensure SPA rewrites are configured
- Check firebase.json / netlify.toml / vercel.json

### Assets not loading
```bash
# Check pubspec.yaml
flutter:
  assets:
    - assets/data/
    - assets/images/
```

### Large bundle size
```bash
# Enable tree shaking
flutter build web --tree-shake-icons

# Check size
du -sh build/web
```

---

## Pre-Deployment Checklist

- [ ] Updated `assets/data/resume.json`
- [ ] Updated meta tags in `web/index.html`
- [ ] Added favicon and icons
- [ ] Tested on Chrome, Firefox, Safari
- [ ] Tested on mobile devices
- [ ] Ran `flutter analyze` (no issues)
- [ ] Optimized images
- [ ] Configured analytics (optional)
- [ ] Set up custom domain (optional)
- [ ] Tested all links work

---

## One-Line Deploy Commands

```bash
# Firebase
make build && make deploy-firebase

# Netlify
make build && netlify deploy --prod --dir=build/web

# Vercel
make build && vercel --prod

# GitHub Pages
git push origin main  # Auto-deploys via Actions
```

---

## Need Help?

- **Detailed Guide:** See [DEPLOYMENT.md](DEPLOYMENT.md)
- **All Commands:** Run `make help`
- **Setup Wizard:** Run `./scripts/setup-deployment.sh`

---

**Ready to deploy?** Pick your platform above and follow the steps!
