# Quick Animation Reference Guide

## 🚀 Quick Start

```bash
# Run the app
fvm flutter run -d chrome

# Test performance
fvm flutter run -d chrome --profile

# Check for issues
fvm flutter analyze
```

## 🎨 Most Common Animations

### 1. Fade In on Scroll

```dart
import 'package:flutter/material.dart';
import '../widgets/animations/scroll_animated_widget.dart';

FadeInOnScroll(
  child: Text('Content'),
)
```

### 2. Slide In on Scroll

```dart
SlideInOnScroll.fromBottom(
  delay: Duration(milliseconds: 200),
  child: YourWidget(),
)
```

### 3. Staggered List

```dart
import '../widgets/animations/stagger_animation.dart';

StaggeredListAnimation(
  itemDelay: Duration(milliseconds: 100),
  children: [
    Item1(),
    Item2(),
    Item3(),
  ],
)
```

### 4. Hover Button

```dart
import '../widgets/animations/micro_interactions.dart';

AnimatedHoverButton(
  onPressed: () {},
  scale: 1.05,
  child: Text('Click Me'),
)
```

### 5. Hover Card

```dart
HoverScaleCard(
  scale: 1.03,
  onTap: () {},
  child: CardContent(),
)
```

### 6. Mouse Gradient (Desktop Only)

```dart
import '../widgets/animations/parallax_effect.dart';

MouseFollowerGradient(
  enabled: !isMobile,
  gradientColors: [
    Colors.blue.withOpacity(0.15),
    Colors.transparent,
  ],
  child: HeroSection(),
)
```

### 7. Loading Shimmer

```dart
ShimmerLoading(
  isLoading: true,
  child: SkeletonWidget(),
)
```

### 8. Pulse Animation

```dart
PulseAnimation(
  child: CTAButton(),
)
```

## 📏 Standard Animation Values

```dart
// Durations
const quickDuration = Duration(milliseconds: 200);
const normalDuration = Duration(milliseconds: 400);
const slowDuration = Duration(milliseconds: 600);

// Curves
Curves.easeOut         // Quick interactions
Curves.easeOutCubic    // Smooth slides
Curves.easeOutBack     // Bouncy scales
Curves.easeInOut       // Symmetrical

// Visibility Threshold
visibilityThreshold: 0.1  // 10% visible

// Stagger Delays
itemDelay: Duration(milliseconds: 100)  // Lists
itemDelay: Duration(milliseconds: 80)   // Grids
```

## 🎯 Animation Checklist

### Before Adding Animation

- [ ] Is it necessary?
- [ ] Does it improve UX?
- [ ] Will it perform well?
- [ ] Is it accessible?

### After Adding Animation

- [ ] Test on desktop
- [ ] Test on mobile
- [ ] Check 60 FPS
- [ ] Verify no jank
- [ ] Test theme switching
- [ ] Check memory usage

## 🔧 Common Patterns

### Section with Scroll Animation

```dart
class MySection extends StatefulWidget {
  @override
  _MySectionState createState() => _MySectionState();
}

class _MySectionState extends State<MySection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('my-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Column(
        children: [
          Text('Title')
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}
```

### Interactive Card

```dart
HoverScaleCard(
  scale: 1.05,
  onTap: () => navigate(),
  child: RippleCard(
    child: CardContent(),
  ),
)
```

### Custom Animation Controller

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();  // IMPORTANT!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Opacity(
          opacity: _animation.value,
          child: child,
        ),
        child: ExpensiveWidget(),
      ),
    );
  }
}
```

## 🎨 Animation Files Location

```
lib/widgets/animations/
├── scroll_animated_widget.dart    # Scroll animations
├── stagger_animation.dart          # List/grid stagger
├── micro_interactions.dart         # Hover, click
├── parallax_effect.dart            # Parallax, mouse
├── theme_transition.dart           # Theme switching
└── animations.dart                 # Exports
```

## 🚨 Common Mistakes to Avoid

### ❌ Don't Do This

```dart
// Forgetting to dispose
@override
void dispose() {
  // Missing: _controller.dispose();
  super.dispose();
}

// Not using RepaintBoundary
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) => ExpensiveWidget(),
)

// Animating everything
Column(
  children: allItems.map((item) =>
    AnimatedWidget(child: item)  // Too much!
  ).toList(),
)

// No const constructors
SizedBox(height: 16)  // Should be const
```

### ✅ Do This Instead

```dart
// Always dispose
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// Use RepaintBoundary
RepaintBoundary(
  child: AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => ...,
    child: ExpensiveWidget(),
  ),
)

// Selective animation
StaggeredListAnimation(
  children: allItems.map((item) => item).toList(),
)

// Use const
const SizedBox(height: 16)
```

## 📊 Performance Targets

| Metric | Good | OK | Poor |
|--------|------|-----|------|
| FPS | 60 | 45-60 | <45 |
| Frame Time | <14ms | 14-18ms | >18ms |
| Jank | 0% | <1% | >1% |
| Memory | Stable | +20MB | +50MB |
| Load Time | <1s | 1-2s | >2s |

## 🔍 Debug Commands

```bash
# Performance overlay
fvm flutter run -d chrome --profile

# Checkerboard layers
fvm flutter run -d chrome --checkerboard-offscreen-layers

# Checkerboard raster
fvm flutter run -d chrome --checkerboard-raster-cache-images

# Release build
fvm flutter build web --release
```

## 📱 Responsive Animation

```dart
final isMobile = MediaQuery.of(context).size.width < 768;

// Disable expensive animations on mobile
MouseFollowerGradient(
  enabled: !isMobile,
  child: Content(),
)

// Adjust animation speed
duration: isMobile
  ? Duration(milliseconds: 400)
  : Duration(milliseconds: 600),
```

## 🎯 Testing Procedure

### 1. Visual Test (2 min)
- Open app in Chrome
- Scroll through all sections
- Hover over interactive elements
- Toggle theme
- Check mobile view

### 2. Performance Test (5 min)
- Run with `--profile`
- Open DevTools
- Record scroll performance
- Check frame times
- Verify memory stable

### 3. Cross-Browser (5 min)
- Test in Firefox
- Test in Safari
- Test in Edge
- Check mobile browsers

## 💡 Pro Tips

1. **Always use const** where possible
2. **RepaintBoundary** for all animations
3. **AnimatedBuilder** over setState
4. **Dispose controllers** properly
5. **Test performance** early and often
6. **Keep animations subtle**
7. **Respect user preferences**
8. **Document custom animations**

## 🆘 Quick Fixes

### Animation not triggering
```dart
// Lower visibility threshold
visibilityThreshold: 0.05  // Instead of 0.1
```

### Stuttering animation
```dart
// Add RepaintBoundary
RepaintBoundary(
  child: YourAnimatedWidget(),
)
```

### Memory leak
```dart
// Check disposal
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### Slow theme switch
```dart
// Reduce complexity
// Split into multiple RepaintBoundaries
```

## 📚 Full Documentation

- **ANIMATION_SHOWCASE.md** - Complete animation catalog
- **ANIMATION_PERFORMANCE_TESTING.md** - Testing guide
- **ANIMATION_IMPLEMENTATION_COMPLETE.md** - Implementation summary

## 🎉 You're Ready!

This quick reference covers 90% of animation use cases. For advanced patterns, check the full documentation files.

Happy animating! ✨
