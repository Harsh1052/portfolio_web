# Harsh Sureja - Portfolio Web Application

A modern, responsive portfolio web application built with Flutter Web showcasing professional experience, projects, skills, and education.

## Features

- 🎨 Beautiful, responsive design using Material Design 3
- 📱 Mobile-first responsive layout (Mobile, Tablet, Desktop, 4K)
- 🎭 Dynamic content loaded from JSON resume data
- 🎯 Clean Architecture with GetX state management
- ⚡ Smooth animations and transitions
- 🌐 SEO-optimized with proper meta tags
- 🎨 Google Fonts integration (Poppins & Roboto)
- 📊 Professional stats showcase
- 🔗 Social media integration

## Tech Stack

### Core
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **GetX** - State management and routing
- **Responsive Framework** - Responsive layout management

### UI & Design
- **Material Design 3** - Design system
- **Google Fonts** - Typography (Poppins, Roboto)
- **Flutter Animate** - Smooth animations
- **Animated Text Kit** - Text animations
- **Flutter SVG** - SVG icon support

### Utilities
- **Dio** - HTTP client for API calls
- **URL Launcher** - Open external links
- **Visibility Detector** - Scroll-based animations

## Project Structure

```
lib/
├── controllers/          # GetX controllers
│   └── resume_controller.dart
├── models/              # Data models
│   ├── education.dart
│   ├── experience.dart
│   ├── personal_info.dart
│   ├── project.dart
│   ├── skill.dart
│   └── resume.dart
├── services/            # Services layer
│   └── resume_service.dart
├── screens/             # Screen widgets
│   └── home_screen.dart
├── widgets/             # Reusable widgets
├── animations/          # Custom animations
├── utils/               # Utilities and constants
│   ├── constants.dart
│   └── theme.dart
└── main.dart           # App entry point

assets/
├── data/               # JSON data files
│   └── resume.json
├── images/             # Image assets
└── icons/              # Icon assets
```

## Architecture

The application follows **Clean Architecture** principles:

1. **Presentation Layer** (`screens/`, `widgets/`)
   - UI components and screens
   - GetX controllers for state management

2. **Domain Layer** (`models/`)
   - Business entities and data models
   - JSON serialization/deserialization

3. **Data Layer** (`services/`)
   - Data sources and services
   - Resume data loading from assets

## Getting Started

### Prerequisites

- Flutter SDK (>=3.1.0)
- Dart SDK (>=3.1.0)
- Web browser (Chrome recommended for development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd portfolio_web
```

2. Install dependencies:
```bash
flutter pub get
```

3. Update resume data:
   - Edit `assets/data/resume.json` with your information

### Running the Application

#### Development Mode
```bash
flutter run -d chrome
```

#### Production Build
```bash
flutter build web --release
```

The build output will be in `build/web/`

### Deployment

#### Firebase Hosting
```bash
firebase deploy
```

#### GitHub Pages
```bash
flutter build web --base-href "/repository-name/"
# Copy build/web/ contents to gh-pages branch
```

#### Netlify / Vercel
Simply drag and drop the `build/web/` folder or connect your repository.

## Customization

### Update Personal Information

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

## Resume JSON Schema

```json
{
  "personalInfo": {
    "name": "string",
    "title": "string",
    "email": "string",
    "phone": "string",
    "location": "string",
    "bio": "string",
    "avatarUrl": "string?",
    "socialLinks": {
      "github": "string?",
      "linkedin": "string?",
      "twitter": "string?",
      ...
    }
  },
  "experience": [...],
  "projects": [...],
  "skills": [...],
  "education": [...]
}
```

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
