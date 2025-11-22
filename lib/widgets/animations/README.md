# Portfolio Animation System

A comprehensive, performance-optimized animation library for Flutter web portfolio. All animations are designed to maintain 60+ FPS with smooth, delightful user experiences.

## 📚 Table of Contents

1. [Quick Start](#quick-start)
2. [Scroll-Based Animations](#scroll-based-animations)
3. [Micro-Interactions](#micro-interactions)
4. [Parallax Effects](#parallax-effects)
5. [Theme Transitions](#theme-transitions)
6. [Page Transitions](#page-transitions)
7. [Advanced Examples](#advanced-examples)

---

## 🚀 Quick Start

### Basic Fade-In on Scroll

```dart
import 'package:portfolio_web/widgets/animations/scroll_animated_widget.dart';

FadeInOnScroll(
  child: Text('Hello World'),
)
```

### Slide-In from Bottom

```dart
SlideInOnScroll.fromBottom(
  duration: Duration(milliseconds: 600),
  delay: Duration(milliseconds: 200),
  child: YourWidget(),
)
```

### Hover Effect Button

```dart
import 'package:portfolio_web/widgets/animations/micro_interactions.dart';

AnimatedHoverButton(
  onPressed: () => print('Clicked!'),
  child: Text('Click Me'),
)
```

---

## 📜 Scroll-Based Animations

### FadeInOnScroll

Fades in element when it enters viewport.

```dart
FadeInOnScroll(
  // How long the animation takes
  duration: Duration(milliseconds: 600),

  // Delay before starting
  delay: Duration(milliseconds: 200),

  // Animation curve
  curve: Curves.easeOut,

  // How much of widget must be visible to trigger (0.0-1.0)
  visibilityThreshold: 0.1,

  // Animate only once (true) or every time (false)
  animateOnce: true,

  child: YourWidget(),
)
```

**Use Cases**: Text content, cards, images

---

### SlideInOnScroll

Slides and fades in element from a direction.

```dart
// From bottom (default)
SlideInOnScroll.fromBottom(
  child: YourWidget(),
)

// From left
SlideInOnScroll.fromLeft(
  child: YourWidget(),
)

// From right
SlideInOnScroll.fromRight(
  child: YourWidget(),
)

// Custom direction
SlideInOnScroll(
  begin: Offset(0.5, 0.5), // Custom starting position
  end: Offset.zero,
  child: YourWidget(),
)
```

**Use Cases**: Section entries, cards appearing, side panels

---

### ScaleInOnScroll

Scales up element with fade when visible.

```dart
ScaleInOnScroll(
  duration: Duration(milliseconds: 600),
  curve: Curves.easeOutBack, // Bouncy effect
  beginScale: 0.8,
  endScale: 1.0,
  child: YourWidget(),
)
```

**Use Cases**: Icons, avatars, call-to-action buttons, emphasis

---

### StaggeredListAnimation

Animates list items sequentially.

```dart
StaggeredListAnimation(
  // List of children to animate
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],

  // Time between each item animation
  itemDelay: Duration(milliseconds: 100),

  // Animation duration for each item
  duration: Duration(milliseconds: 600),

  // Vertical or horizontal
  direction: Axis.vertical,

  child: YourWidget(),
)
```

**Example - Skills List**:
```dart
StaggeredListAnimation(
  itemDelay: Duration(milliseconds: 80),
  children: skills.map((skill) => SkillCard(skill)).toList(),
)
```

---

### StaggeredGridAnimation

Animates grid items with stagger effect.

```dart
StaggeredGridAnimation(
  children: projectCards,
  crossAxisCount: 3,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  itemDelay: Duration(milliseconds: 80),
)
```

**Use Cases**: Project grids, image galleries, card layouts

---

## 🎯 Micro-Interactions

### AnimatedHoverButton

Button with scale and shadow on hover.

```dart
AnimatedHoverButton(
  onPressed: () {
    // Handle click
  },
  backgroundColor: Colors.blue,
  hoverColor: Colors.blueAccent,
  elevation: 2.0,
  hoverElevation: 8.0,
  scale: 1.05, // How much to scale on hover
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  borderRadius: BorderRadius.circular(12),
  child: Text('Hover Me'),
)
```

---

### RippleCard

Card with tap ripple and scale effect.

```dart
RippleCard(
  onTap: () {
    // Handle tap
  },
  rippleColor: Colors.blue.withAlpha(0.1),
  padding: EdgeInsets.all(16),
  elevation: 2.0,
  child: YourCardContent(),
)
```

---

### HoverScaleCard

Card that scales up and lifts on hover.

```dart
HoverScaleCard(
  scale: 1.03,
  duration: Duration(milliseconds: 200),
  onTap: () {
    // Handle tap
  },
  child: YourCard(),
)
```

---

### ShimmerLoading

Shimmer effect for loading states.

```dart
ShimmerLoading(
  isLoading: true, // Toggle loading state
  duration: Duration(milliseconds: 1500),
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  child: YourContent(),
)
```

**Example - Skeleton Screen**:
```dart
ShimmerLoading(
  isLoading: isLoading,
  child: Column(
    children: [
      Container(height: 20, color: Colors.grey[300]), // Title skeleton
      SizedBox(height: 8),
      Container(height: 100, color: Colors.grey[300]), // Content skeleton
    ],
  ),
)
```

---

### PulseAnimation

Pulsing scale effect for attention.

```dart
PulseAnimation(
  duration: Duration(milliseconds: 1000),
  minScale: 1.0,
  maxScale: 1.05,
  repeat: true,
  child: Icon(Icons.notifications, size: 32),
)
```

**Use Cases**: Notification badges, new feature indicators

---

### AnimatedHoverIcon

Icon with rotation and scale on hover.

```dart
AnimatedHoverIcon(
  icon: Icons.settings,
  size: 24,
  color: Colors.blue,
  rotation: 0.1, // Rotation amount in turns
  onTap: () {
    // Handle tap
  },
)
```

---

## 🌊 Parallax Effects

### ParallaxBackground

Simple parallax effect on scroll.

```dart
ParallaxBackground(
  intensity: 0.3, // How strong the parallax (0.0-1.0)
  enableParallax: true,
  child: YourBackgroundWidget(),
)
```

**Use Case**: Hero section backgrounds

---

### MouseFollowerGradient

Gradient that follows mouse cursor (desktop only).

```dart
MouseFollowerGradient(
  gradientColors: [
    Colors.blue.withAlpha(0.3),
    Colors.purple.withAlpha(0.2),
    Colors.transparent,
  ],
  radius: 300, // Gradient radius
  opacity: 0.3,
  enabled: ResponsiveHelper.isDesktop(context),
  child: YourSection(),
)
```

---

### FloatingAnimation

Gentle floating motion.

```dart
FloatingAnimation(
  duration: Duration(seconds: 3),
  distance: 10.0, // Float distance in pixels
  axis: Axis.vertical,
  child: YourWidget(),
)
```

**Use Cases**: Decorative elements, avatars, icons

---

## 🎨 Theme Transitions

### AnimatedThemeIcon

Smooth icon transition for theme toggle.

```dart
AnimatedThemeIcon(
  size: 24,
  color: Theme.of(context).iconTheme.color,
  duration: Duration(milliseconds: 300),
)
```

Shows sun/moon icon with smooth rotation based on current theme.

---

### ThemeFadeTransition

Wrap app with fade transition on theme change.

```dart
ThemeFadeTransition(
  duration: Duration(milliseconds: 300),
  child: YourApp(),
)
```

---

### ThemeScaleTransition

Theme change with scale effect.

```dart
ThemeScaleTransition(
  duration: Duration(milliseconds: 400),
  beginScale: 0.8,
  child: YourApp(),
)
```

---

### ThemeCircularReveal

Circular reveal animation for theme change.

```dart
ThemeCircularReveal(
  duration: Duration(milliseconds: 600),
  revealOrigin: Offset(100, 100), // Where animation starts
  child: YourApp(),
)
```

---

## 🚪 Page Transitions

### Usage with GetX

```dart
import 'package:portfolio_web/utils/page_transitions.dart';

// Navigate with custom transition
PageTransitions.navigateTo(
  NewPage(),
  transition: TransitionType.fadeScale,
  duration: Duration(milliseconds: 400),
);
```

### Available Transitions

#### fadeScale
Fade in with subtle scale effect.
```dart
transition: TransitionType.fadeScale
```

#### slideFromBottom
Slide up from bottom edge.
```dart
transition: TransitionType.slideFromBottom
```

#### slideFromRight
iOS-style slide from right.
```dart
transition: TransitionType.slideFromRight
```

#### sharedAxisHorizontal
Material Design shared axis (horizontal).
```dart
transition: TransitionType.sharedAxisHorizontal
```

#### fadeThrough
Material Design fade through.
```dart
transition: TransitionType.fadeThrough
```

#### elasticScale
Bouncy scale entrance.
```dart
transition: TransitionType.elasticScale
```

#### circularReveal
Expanding circle reveal.
```dart
transition: TransitionType.circularReveal
```

---

## 🔥 Advanced Examples

### Complex Staggered Card Grid

```dart
class ProjectsSection extends StatelessWidget {
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return FadeInOnScroll(
      child: StaggeredGridAnimation(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : 2,
        itemDelay: Duration(milliseconds: 80),
        children: projects.map((project) =>
          HoverScaleCard(
            onTap: () => openProject(project),
            child: ProjectCard(project),
          ),
        ).toList(),
      ),
    );
  }
}
```

---

### Hero Section with Parallax

```dart
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Parallax background
        ParallaxBackground(
          intensity: 0.3,
          child: DecorativeBackground(),
        ),

        // Mouse gradient (desktop only)
        if (ResponsiveHelper.isDesktop(context))
          MouseFollowerGradient(
            gradientColors: [
              AppColors.primaryBlue.withAlpha(0.3),
              AppColors.accentPurple.withAlpha(0.2),
              Colors.transparent,
            ],
            radius: 300,
            child: SizedBox.expand(),
          ),

        // Content
        Center(
          child: Column(
            children: [
              FadeInOnScroll(
                delay: Duration(milliseconds: 200),
                child: Text('Hello, I\'m'),
              ),
              SlideInOnScroll.fromBottom(
                delay: Duration(milliseconds: 400),
                child: Text('Your Name', style: heroStyle),
              ),
              ScaleInOnScroll(
                delay: Duration(milliseconds: 600),
                child: FloatingAnimation(
                  child: Avatar(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

---

### Animated Skills Section

```dart
class SkillsSection extends StatelessWidget {
  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    return FadeInOnScroll(
      child: Column(
        children: [
          SlideInOnScroll.fromLeft(
            child: SectionTitle('Skills'),
          ),
          SizedBox(height: 32),
          StaggeredListAnimation(
            itemDelay: Duration(milliseconds: 100),
            children: skills.map((skill) =>
              AnimatedHoverButton(
                onPressed: () => showSkillDetails(skill),
                child: SkillChip(skill),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
```

---

### Loading State with Shimmer

```dart
class ContentLoader extends StatelessWidget {
  final bool isLoading;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ShimmerLoading(
        isLoading: true,
        child: Column(
          children: [
            _buildSkeleton(height: 40),
            SizedBox(height: 16),
            _buildSkeleton(height: 200),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSkeleton(height: 100)),
                SizedBox(width: 16),
                Expanded(child: _buildSkeleton(height: 100)),
              ],
            ),
          ],
        ),
      );
    }

    return FadeInOnScroll(child: content);
  }

  Widget _buildSkeleton({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
```

---

### Custom Navigation with Transition

```dart
void navigateToProject(Project project) {
  PageTransitions.navigateTo(
    ProjectDetailPage(project),
    transition: TransitionType.sharedAxisHorizontal,
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOutCubic,
  );
}
```

---

## 🎛️ Animation Constants

Use predefined constants for consistency:

```dart
import 'package:portfolio_web/utils/animation_constants.dart';

// Durations
AnimationConstants.fast         // 200ms
AnimationConstants.normal       // 300ms
AnimationConstants.medium       // 500ms
AnimationConstants.slow         // 800ms

// Stagger delays
AnimationConstants.staggerSmall  // 80ms
AnimationConstants.staggerMedium // 100ms

// Curves
AnimationConstants.easeOutCubic
AnimationConstants.easeOutBack   // Bouncy
CustomCurves.smooth
CustomCurves.snappy
```

---

## ⚡ Performance Tips

1. **Always use RepaintBoundary** - Already built into all animation widgets
2. **Dispose controllers** - Automatically handled in all provided widgets
3. **Use const constructors** - Where possible for child widgets
4. **Limit stagger items** - Don't animate 100+ items at once
5. **Test on target devices** - Especially low-end mobile

---

## 🐛 Common Issues

### Animations not triggering on scroll
- Check `visibilityThreshold` - might be too high
- Ensure widget is in a scrollable container
- Verify `animateOnce` setting

### Choppy animations
- Add `RepaintBoundary` around animated content
- Reduce complexity of animated widget tree
- Check Flutter DevTools performance tab

### Theme transition not working
- Ensure `ThemeController` is initialized with `Get.put()`
- Wrap app with theme transition widget
- Check `Obx()` is rebuilding

---

## 📖 Additional Resources

- [Performance Guide](../utils/ANIMATION_PERFORMANCE_GUIDE.md)
- [Animation Constants](../utils/animation_constants.dart)
- [Theme Transitions](theme_transition.dart)
- [Page Transitions](../utils/page_transitions.dart)

---

## 🤝 Contributing

When adding new animations:
1. Wrap with `RepaintBoundary`
2. Use `AnimatedBuilder` for efficiency
3. Provide const constructors
4. Dispose AnimationControllers
5. Add documentation
6. Test performance

---

**Happy Animating!** ✨
