# Performance Optimization Guide

This guide covers all performance optimizations implemented in the portfolio to ensure smooth 60fps animations.

## Table of Contents
- [Shader Precompilation](#shader-precompilation)
- [Animation Optimizations](#animation-optimizations)
- [RepaintBoundary Usage](#repaintboundary-usage)
- [Memory Management](#memory-management)
- [Performance Testing](#performance-testing)

## Shader Precompilation

### What is Shader Warmup?
Flutter compiles shaders just-in-time (JIT) during the first render. This can cause jank (frame drops) the first time an animation runs. Shader warmup precompiles shaders during app initialization.

### Implementation
```dart
import 'package:portfolio_web/utils/shader_warmup.dart';

void main() {
  runApp(
    ShaderWarmup.builder(
      child: const PortfolioApp(),
    ),
  );
}
```

### What Gets Warmed Up?
- Linear, radial, and sweep gradients
- Box shadows and drop shadows
- Blur effects (gaussian, inner)
- Transform operations (scale, rotate, translate, skew)

## Animation Optimizations

### 1. RepaintBoundary
Isolates animated widgets to prevent unnecessary rebuilds of parent widgets.

```dart
RepaintBoundary(
  child: AnimatedWidget(...),
)
```

**When to use:**
- Around widgets that animate frequently
- Around complex widget trees that don't need to rebuild
- Around custom painters

### 2. AnimatedBuilder
Rebuilds only the specific widgets that need animation updates.

```dart
AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    return Transform.scale(
      scale: controller.value,
      child: child, // This child is cached!
    );
  },
  child: ExpensiveWidget(), // Built once, reused
)
```

### 3. Const Constructors
Use `const` wherever possible to prevent unnecessary widget creation.

```dart
const Text('Hello World')  // Good
Text('Hello World')         // Rebuilds every time
```

### 4. Avoid Animating Large Widget Trees
```dart
// BAD - Animates entire tree
AnimatedOpacity(
  opacity: _opacity,
  child: ComplexWidgetTree(),
)

// GOOD - Animates only necessary widget
Stack([
  ComplexWidgetTree(),
  AnimatedOpacity(
    opacity: _opacity,
    child: OverlayWidget(),
  ),
])
```

## Widget-Specific Optimizations

### Scroll Animations
All scroll-based animations use:
- VisibilityDetector for efficient viewport detection
- RepaintBoundary for isolation
- AnimatedBuilder to limit rebuilds
- `animateOnce` flag to prevent repeated animations

```dart
FadeInOnScroll(
  duration: const Duration(milliseconds: 600),
  delay: Duration.zero,
  visibilityThreshold: 0.1,
  animateOnce: true,
  child: MyWidget(),
)
```

### Stagger Animations
- Each item wrapped in RepaintBoundary
- Controlled delay between items
- Single VisibilityDetector for entire list

```dart
StaggeredListAnimation(
  duration: const Duration(milliseconds: 600),
  itemDelay: const Duration(milliseconds: 100),
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)
```

### Micro-Interactions
- AnimatedContainer for simple property animations
- MouseRegion for hover detection (desktop)
- Scale/elevation animations use AnimatedScale

```dart
AnimatedHoverButton(
  elevation: 2.0,
  hoverElevation: 8.0,
  scale: 1.05,
  onPressed: () {},
  child: Text('Click me'),
)
```

### Parallax Effects
- Uses Flow widget for efficient positioning
- RepaintBoundary on each layer
- Minimal rebuilds on scroll

```dart
ParallaxBackground(
  intensity: 0.3,
  enableParallax: true,
  child: BackgroundWidget(),
)
```

### Theme Transitions
- AnimatedSwitcher for smooth theme changes
- RepaintBoundary prevents full-screen rebuilds
- Multiple transition options (fade, slide, scale, rotation)

```dart
ThemeFadeTransition(
  duration: const Duration(milliseconds: 300),
  child: YourContent(),
)
```

## Memory Management

### Shader Cache
Frequently used shaders are cached to avoid recreation:

```dart
// Automatically cached
final shader = ShaderCache.getLinearGradient(
  colors: [Colors.blue, Colors.purple],
  rect: rect,
);

// Clear cache when needed
ShaderCache.clear();
```

### Controller Disposal
Always dispose animation controllers:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### Listener Removal
Remove scroll listeners in dispose:

```dart
@override
void dispose() {
  _scrollController.removeListener(_onScroll);
  super.dispose();
}
```

## Performance Testing

### Flutter DevTools

#### 1. Performance Overlay
Enable in your app during development:

```dart
MaterialApp(
  showPerformanceOverlay: true, // Shows FPS and frame rendering time
  ...
)
```

#### 2. Custom Performance Monitor
Use the built-in performance overlay:

```dart
AnimationPerformanceOverlay(
  enabled: true, // Set to false in production
  child: YourApp(),
)
```

#### 3. Timeline View
```bash
# Run app in profile mode
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

**What to check:**
- UI thread should stay below 16ms (60fps)
- Raster thread should stay below 16ms
- Look for red bars indicating jank

#### 4. Memory Profiling
In DevTools Memory tab:
- Check for memory leaks
- Monitor widget rebuilds
- Track controller disposal

#### 5. Rebuild Profiler
Add to your app during development:

```dart
class RebuildTracker extends StatelessWidget {
  final Widget child;
  final String name;

  const RebuildTracker({
    required this.child,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('$name rebuilt');
    return child;
  }
}
```

### Performance Checklist

- [ ] Shaders are prewarmed in main.dart
- [ ] RepaintBoundary used around animated widgets
- [ ] AnimatedBuilder used instead of setState for animations
- [ ] Const constructors used wherever possible
- [ ] Animation controllers are properly disposed
- [ ] Scroll listeners are removed in dispose
- [ ] Large widget trees are not animated
- [ ] No synchronous expensive operations in build methods
- [ ] Images are properly sized and cached
- [ ] Unnecessary rebuilds are prevented

### Common Performance Issues

#### 1. Jank on First Animation
**Problem:** First animation stutters
**Solution:** Use shader warmup in main.dart

#### 2. Entire Screen Rebuilds
**Problem:** Changing one widget rebuilds everything
**Solution:** Add RepaintBoundary around animated widgets

#### 3. Slow Scrolling
**Problem:** Scroll performance is poor
**Solution:**
- Use RepaintBoundary on list items
- Implement lazy loading
- Cache images and complex widgets

#### 4. Memory Leaks
**Problem:** Memory usage increases over time
**Solution:**
- Dispose controllers properly
- Remove listeners in dispose
- Clear caches when appropriate

## Best Practices

1. **Profile Before Optimizing**
   - Use DevTools to identify actual bottlenecks
   - Don't optimize prematurely

2. **Use the Right Animation Widget**
   - Simple property changes: AnimatedContainer, AnimatedOpacity
   - Complex custom animations: AnimatedBuilder with controllers
   - List animations: AnimatedList or stagger animations

3. **Limit Animation Complexity**
   - Animate transforms (translate, scale, rotate) - GPU accelerated
   - Avoid animating: clip, layout, paint operations - CPU heavy

4. **Test on Real Devices**
   - Test on low-end devices
   - Profile mode gives accurate performance metrics
   - Release mode for final performance validation

5. **Monitor Frame Budget**
   - Target: 16.67ms per frame (60fps)
   - Warning: 16.67ms - 33.33ms (30-60fps)
   - Problem: >33.33ms (<30fps)

## Resources

- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Flutter Performance Profiling](https://flutter.dev/docs/perf/ui-performance)
- [RepaintBoundary Documentation](https://api.flutter.dev/flutter/widgets/RepaintBoundary-class.html)
- [Animation Best Practices](https://flutter.dev/docs/development/ui/animations/tutorial)
