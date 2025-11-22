# Web Optimization & Build Guide

Complete guide for optimizing and building your Flutter web portfolio for production.

## Table of Contents

1. [Build Commands](#build-commands)
2. [Renderer Options](#renderer-options)
3. [Optimization Techniques](#optimization-techniques)
4. [Asset Optimization](#asset-optimization)
5. [Caching Strategies](#caching-strategies)
6. [Performance Optimization](#performance-optimization)
7. [Deployment Checklist](#deployment-checklist)

## Build Commands

### Development Build

```bash
# Run in debug mode
fvm flutter run -d chrome

# Run in profile mode (for performance testing)
fvm flutter run -d chrome --profile

# Run with specific web renderer
fvm flutter run -d chrome --web-renderer html
fvm flutter run -d chrome --web-renderer canvaskit
```

### Production Build

```bash
# Standard production build (auto renderer)
fvm flutter build web --release

# HTML renderer (better compatibility, faster load)
fvm flutter build web --release --web-renderer html

# CanvasKit renderer (better graphics, larger bundle)
fvm flutter build web --release --web-renderer canvaskit

# Auto renderer (switches based on device)
fvm flutter build web --release --web-renderer auto
```

### Optimized Production Build

```bash
# With optimization flags
fvm flutter build web \
  --release \
  --web-renderer auto \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --source-maps \
  --pwa-strategy offline-first

# Tree shaking to remove unused code
fvm flutter build web \
  --release \
  --web-renderer html \
  --tree-shake-icons \
  --dart-define=FLUTTER_WEB_USE_SKIA=false
```

## Renderer Options

### HTML Renderer

**Best For:**
- Better browser compatibility
- Faster initial load time
- Smaller bundle size (~2-3 MB)
- Text-heavy applications

**Pros:**
- ✅ Works on all browsers
- ✅ Smaller download size
- ✅ Better text rendering
- ✅ Faster initial paint

**Cons:**
- ❌ Limited graphics capabilities
- ❌ May have rendering inconsistencies
- ❌ Some animations less smooth

**Use Case:** Your portfolio with text, images, and standard animations

**Command:**
```bash
fvm flutter build web --release --web-renderer html
```

### CanvasKit Renderer

**Best For:**
- Complex graphics and animations
- Consistent rendering across platforms
- Heavy animation applications
- Games or graphical tools

**Pros:**
- ✅ Pixel-perfect rendering
- ✅ Consistent across all browsers
- ✅ Better animation performance
- ✅ Full Skia graphics engine

**Cons:**
- ❌ Larger bundle (~7-8 MB)
- ❌ Slower initial load
- ❌ More memory intensive

**Use Case:** If you have complex animations or need pixel-perfect rendering

**Command:**
```bash
fvm flutter build web --release --web-renderer canvaskit
```

### Auto Renderer (Recommended)

**How it Works:**
- Uses CanvasKit on desktop browsers
- Falls back to HTML on mobile browsers
- Best of both worlds

**Command:**
```bash
fvm flutter build web --release --web-renderer auto
```

## Optimization Techniques

### 1. Code Splitting & Lazy Loading

**Enable Deferred Loading:**

```dart
// In pubspec.yaml, use deferred imports
import 'package:flutter/material.dart' deferred as ui;

// Load when needed
void loadUI() async {
  await ui.loadLibrary();
  // Use ui.* widgets
}
```

**Lazy Load Images:**

```dart
// Use OptimizedImage widget created in lib/widgets/optimized_image.dart
OptimizedImage(
  imageUrl: 'https://example.com/large-image.jpg',
  width: 400,
  height: 300,
)
```

### 2. Asset Optimization

**Image Optimization:**

```bash
# Install image optimization tools
brew install imagemagick webp

# Convert images to WebP
for file in assets/images/*.{jpg,png}; do
  cwebp -q 80 "$file" -o "${file%.*}.webp"
done

# Resize large images
for file in assets/images/*.jpg; do
  convert "$file" -resize 1920x1080\> "${file}"
done

# Compress PNGs
for file in assets/images/*.png; do
  pngquant --quality=65-80 --ext .png --force "$file"
done
```

**Recommended Image Sizes:**

| Image Type | Max Width | Format | Quality |
|------------|-----------|--------|---------|
| Hero Images | 1920px | WebP | 80% |
| Project Cards | 800px | WebP | 75% |
| Avatars | 200px | WebP/PNG | 85% |
| Icons | 512px | PNG/SVG | - |
| Thumbnails | 300px | WebP | 70% |

### 3. Font Optimization

**Use Font Subsetting:**

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: CustomFont
      fonts:
        - asset: fonts/CustomFont-Regular.ttf
          weight: 400
        - asset: fonts/CustomFont-Bold.ttf
          weight: 700
  # Only include needed fonts
```

**Google Fonts Optimization:**

```dart
// Use font display parameter
GoogleFonts.config.allowRuntimeFetching = true;

// Preload important fonts
void preloadFonts() {
  GoogleFonts.inter();
  GoogleFonts.spaceGrotesk();
}
```

### 4. Tree Shaking

**Enable Icon Tree Shaking:**

```bash
# Remove unused Material icons
fvm flutter build web --release --tree-shake-icons
```

**Remove Unused Code:**

```dart
// Use const constructors
const Text('Hello')  // ✅
Text('Hello')        // ❌

// Avoid importing entire packages
import 'package:flutter/material.dart' show MaterialApp, Scaffold;
```

### 5. Service Worker Configuration

**Caching Strategy:**

```javascript
// web/flutter_service_worker.js (auto-generated)
// Configure caching in flutter build

// For custom caching, create service-worker.js:
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});
```

## Caching Strategies

### 1. Image Caching

**Use OptimizedImage Widget:**

```dart
// Automatic caching with HTTP headers
OptimizedImage(
  imageUrl: 'https://example.com/image.jpg',
  enableMemoryCache: true,
  headers: {
    'Cache-Control': 'max-age=31536000',
  },
)
```

### 2. API Response Caching

```dart
// Add caching layer for API calls
class CachedApi {
  static final _cache = <String, dynamic>{};
  static const _cacheDuration = Duration(hours: 1);

  static Future<T> fetch<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (_cache.containsKey(url)) {
      return _cache[url] as T;
    }

    final response = await http.get(Uri.parse(url));
    final data = fromJson(json.decode(response.body));
    _cache[url] = data;

    return data;
  }
}
```

### 3. Font Caching

```dart
// Preload fonts to reduce FOIT (Flash of Invisible Text)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload Google Fonts
  await GoogleFonts.pendingFonts([
    GoogleFonts.inter(),
    GoogleFonts.spaceGrotesk(),
    GoogleFonts.poppins(),
  ]);

  runApp(MyApp());
}
```

## Performance Optimization

### 1. Initial Load Optimization

**Reduce Bundle Size:**

```bash
# Check bundle size
fvm flutter build web --release
ls -lh build/web/

# Analyze bundle
fvm flutter build web --release --analyze-size
```

**Optimize Main Bundle:**

```dart
// Use dynamic imports
import 'heavy_widget.dart' deferred as heavy;

void showHeavyWidget() async {
  await heavy.loadLibrary();
  // Use heavy.HeavyWidget()
}
```

### 2. Runtime Performance

**Use RepaintBoundary:**

```dart
// Isolate expensive widgets
RepaintBoundary(
  child: ExpensiveAnimatedWidget(),
)
```

**Optimize Animations:**

```dart
// Use const where possible
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Optimized');
  }
}
```

### 3. Memory Management

**Dispose Controllers:**

```dart
@override
void dispose() {
  _controller.dispose();
  _scrollController.dispose();
  super.dispose();
}
```

**Limit List Rendering:**

```dart
// Use ListView.builder instead of ListView
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 4. Network Optimization

**Compress API Responses:**

```dart
// Use GZIP compression
final response = await http.get(
  uri,
  headers: {'Accept-Encoding': 'gzip'},
);
```

**Batch API Calls:**

```dart
// Combine multiple requests
Future.wait([
  fetchProfile(),
  fetchProjects(),
  fetchSkills(),
]);
```

## Build Output Structure

```
build/web/
├── index.html              # Entry point
├── main.dart.js           # Main application code
├── flutter.js             # Flutter engine
├── flutter_service_worker.js  # PWA service worker
├── manifest.json          # PWA manifest
├── version.json           # Build version info
├── assets/
│   ├── AssetManifest.json
│   ├── FontManifest.json
│   ├── fonts/
│   ├── images/
│   └── packages/
├── canvaskit/             # CanvasKit files (if using)
└── icons/                 # PWA icons
```

## Deployment Checklist

### Pre-Deployment

- [ ] Run production build
- [ ] Test on multiple browsers (Chrome, Firefox, Safari, Edge)
- [ ] Test on mobile devices
- [ ] Verify all images load
- [ ] Check console for errors
- [ ] Test service worker
- [ ] Verify PWA install prompt
- [ ] Check Lighthouse score (target >90)
- [ ] Test offline functionality
- [ ] Verify meta tags (SEO)
- [ ] Check social media previews
- [ ] Test all animations
- [ ] Verify responsive design
- [ ] Check loading performance
- [ ] Test theme switching
- [ ] Verify all links work

### Build Command for Deployment

```bash
# Recommended production build
fvm flutter build web \
  --release \
  --web-renderer auto \
  --base-href / \
  --tree-shake-icons

# Or with source maps (for debugging)
fvm flutter build web \
  --release \
  --web-renderer auto \
  --source-maps \
  --tree-shake-icons
```

### Post-Build Optimization

**1. Compress Assets:**

```bash
# Compress JavaScript files
gzip -9 build/web/main.dart.js
gzip -9 build/web/flutter.js

# Or use Brotli (better compression)
brotli -q 11 build/web/main.dart.js
brotli -q 11 build/web/flutter.js
```

**2. Add Cache Headers:**

```nginx
# nginx configuration
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

**3. Enable GZIP:**

```nginx
# nginx gzip configuration
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types
  text/css
  text/javascript
  application/javascript
  application/json
  image/svg+xml;
```

## Hosting Recommendations

### Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy --only hosting
```

**firebase.json:**

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [{
      "source": "**",
      "destination": "/index.html"
    }],
    "headers": [{
      "source": "**/*.@(jpg|jpeg|gif|png|svg|webp)",
      "headers": [{
        "key": "Cache-Control",
        "value": "max-age=31536000"
      }]
    }]
  }
}
```

### Netlify

**netlify.toml:**

```toml
[build]
  publish = "build/web"
  command = "flutter build web --release"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.css"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/assets/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

### GitHub Pages

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release --base-href /${{ github.event.repository.name }}/
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

## Performance Targets

| Metric | Target | Excellent |
|--------|--------|-----------|
| Lighthouse Performance | >80 | >90 |
| First Contentful Paint | <2s | <1.5s |
| Largest Contentful Paint | <3s | <2.5s |
| Time to Interactive | <4s | <3s |
| Total Bundle Size | <5MB | <3MB |
| First Load JS | <200KB | <150KB |

## Monitoring

### Google Analytics

```html
<!-- Add to web/index.html -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### Web Vitals

```javascript
// Track Core Web Vitals
import {getCLS, getFID, getFCP, getLCP, getTTFB} from 'web-vitals';

getCLS(console.log);
getFID(console.log);
getFCP(console.log);
getLCP(console.log);
getTTFB(console.log);
```

## Troubleshooting

### Large Bundle Size

```bash
# Analyze what's taking space
fvm flutter build web --release --analyze-size

# Enable tree shaking
fvm flutter build web --release --tree-shake-icons

# Use HTML renderer
fvm flutter build web --release --web-renderer html
```

### Slow Initial Load

1. Use HTML renderer for smaller bundle
2. Implement code splitting
3. Optimize images
4. Enable caching
5. Use CDN for assets

### Service Worker Issues

```bash
# Rebuild with fresh service worker
rm -rf build/
fvm flutter build web --release

# Clear browser cache
# Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
```

## Best Practices

1. ✅ Use `--web-renderer auto` for production
2. ✅ Enable `--tree-shake-icons`
3. ✅ Optimize images to WebP format
4. ✅ Use lazy loading for images
5. ✅ Implement service worker caching
6. ✅ Add cache headers on server
7. ✅ Compress assets (GZIP/Brotli)
8. ✅ Monitor with Lighthouse
9. ✅ Test on real devices
10. ✅ Use CDN for static assets

## Conclusion

Following this guide will ensure your Flutter web portfolio:
- Loads quickly (<3s)
- Performs smoothly (60 FPS)
- Works offline (PWA)
- Scores >90 on Lighthouse
- Provides excellent UX across all devices

Happy deploying! 🚀
