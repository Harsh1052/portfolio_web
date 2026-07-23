# 🏙️ Harsh Sureja — Portfolio

> **[Live Demo →](https://harsh-portfolio-web.web.app)** &nbsp;|&nbsp; **[City of Code (v2 Beta) →](https://harsh-portfolio-web.web.app/#/beta)**

A scroll-driven, story-based Flutter Web portfolio where each section of my career is a **district in a city**. Visitors don't read a resume — they explore eight districts, from the City Gate to the Harbor, collecting hidden stamps along the way.

Built with Flutter Web, custom `CustomPainter` artwork, a scroll-choreography engine inspired by [Wonderous](https://flutter.gskinner.com/wonderous/), and a first-party analytics dashboard.

---

## ✨ Highlights

| Feature | Details |
|---------|---------|
| 🏗️ **City of Code (v2)** | 8 scroll-driven districts, each a career chapter with procedural art |
| 🎨 **Procedural artwork** | Custom `CustomPainter` scenes — no pre-rendered images for backgrounds |
| 📜 **Story panels** | First-person narrative revealed through scroll choreography |
| 🎫 **Collectible stamps** | 8 hidden stamps + passport completion celebration |
| 🌦️ **Ambient intelligence** | Time-of-day sky, geo greeting, live weather effects |
| 📊 **Analytics dashboard** | Route-aware page views, dwell time, stamp tracking (hidden at `/#/analytics`) |
| 🎮 **Easter eggs** | Catch the Bug mini-game, visitor telemetry, city passport |
| ♿ **Accessible** | Semantics labels, keyboard navigation, `prefers-reduced-motion` support, skip links |

---

## 🗺️ The City Districts

| # | District | Career Chapter | Visual Identity |
|---|----------|---------------|-----------------|
| 1 | **The City Gate** | Welcome + headline stats | Monumental gate, layered skyline, time-of-day sky |
| 2 | **Foundation Square** | GTU + internship (2017–2021) | Blueprint grid, cranes, scaffolding |
| 3 | **Craftsman's Lane** | Tagline Infotech (2021–2022) | Workshop street, warm lanterns, gears |
| 4 | **Enterprise Heights** | Elision Infotech (2023–2024) | Glass towers, elevator shafts, night grid |
| 5 | **Harvest Valley** | FarmSetu (2024–2026) | Golden wheat fields, monsoon clouds |
| 6 | **The Exchange** | Kotak Securities (2026–now) | Candlestick skyline, ticker tape, neon pulses |
| 7 | **Tinkerers' Park** | Side projects + learning | Fairground, ferris wheel, string lights |
| 8 | **The Harbor** | Contact + departure | Docks at dusk, lighthouse, paper boats |

---

## 🏗️ Architecture

```
lib/
├── main.dart
├── core/
│   ├── ambience/          # Time-of-day palette, geo greeting, weather effects
│   ├── analytics/         # First-party event tracking + dashboard
│   ├── routing/           # GetX route definitions
│   ├── services/          # Firebase, resume loader
│   ├── theme/             # M3-inspired light/dark themes
│   └── widgets/           # Shared UI components
└── features/
    ├── home/              # v1 classic portfolio
    ├── content/           # Resume data layer (Clean Architecture)
    ├── experience/        # Experience & education timeline
    ├── skills/            # Skills visualization
    ├── work/              # Project showcases
    ├── analytics/         # Hidden analytics dashboard
    ├── github/            # GitHub integration
    ├── now/               # "What I'm doing now" section
    ├── visitor/           # Visitor telemetry
    └── v2/                # ← City of Code
        ├── core/          # Scroll engine, sky gradient, motion tokens, stamps
        ├── districts/     # 8 district implementations
        ├── widgets/       # Story panels, city map rail, stat counters
        └── pages/         # City page (/beta)
```

---

## 🛠️ Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![GetX](https://img.shields.io/badge/GetX-8B5CF6?style=flat-square&logoColor=white)

- **Framework:** Flutter Web 3.x + Dart ≥3.4
- **State & Routing:** GetX
- **Backend:** Firebase (Firestore, Hosting)
- **Fonts:** Space Grotesk (display) + Inter (body) via Google Fonts
- **Art:** Custom `CustomPainter` procedural scenes, scroll-driven choreography
- **Analytics:** First-party event system + Firestore
- **CI/CD:** GitHub Actions → Firebase Hosting (auto-deploy on merge)

---

## 🚀 Local Setup

> **Prerequisite:** This project uses [FVM](https://fvm.app/) for Flutter version management.

```bash
git clone https://github.com/harshsureja/portfolio_web.git
cd portfolio_web
fvm flutter pub get
fvm flutter run -d chrome
```

### Updating Content

Edit [`assets/data/resume.json`](assets/data/resume.json) — the entire portfolio renders from this single data file. Hot reload picks up changes automatically.

### Firebase Contact Form (Optional)

1. Create a Firebase Web App
2. Add credentials to `assets/config/firebase_options.json`
3. Enable Firestore + create `contactMessages` collection
4. See [`docs/FIREBASE_SETUP.md`](docs/FIREBASE_SETUP.md) for details

---

## 📦 Build & Deploy

```bash
fvm flutter build web --release --tree-shake-icons

# Or use Make shortcuts:
make build              # Production build
make deploy-firebase    # Firebase Hosting
make deploy-netlify     # Netlify
make deploy-vercel      # Vercel
make deploy-github      # GitHub Pages
```

See [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) for platform-specific setup.

---

## 🧪 Testing

```bash
fvm flutter test                    # Run all tests
fvm flutter analyze                 # Static analysis
```

Test suites cover: scroll engine, market simulator, progress bands, stamps controller.

---

## 📄 Documentation

All guides live in [`docs/`](docs/):

| Guide | Purpose |
|-------|---------|
| [V2_PLAN.md](docs/V2_PLAN.md) | City of Code design document |
| [DEPLOYMENT.md](docs/DEPLOYMENT.md) | Multi-platform deployment |
| [FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) | Firebase configuration |
| [PERFORMANCE_OPTIMIZATION_GUIDE.md](docs/PERFORMANCE_OPTIMIZATION_GUIDE.md) | Web vitals & perf budget |
| [QUICK_START.md](docs/QUICK_START.md) | Getting started fast |

---

## 📬 Contact

**Harsh Sureja** — Senior Flutter Developer

- 📧 [surejapatel@gmail.com](mailto:surejapatel@gmail.com)
- 🔗 [LinkedIn](https://linkedin.com/in/harshsureja)
- 🐙 [GitHub](https://github.com/harshsureja)

---

Built with ❤️ and a lot of `CustomPainter` code using Flutter
