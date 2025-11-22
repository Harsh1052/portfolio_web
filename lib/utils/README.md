# Design System Documentation

This document provides an overview of the design system implementation for the Portfolio Web application.

## Overview

The design system is built on **Material 3** principles with custom theming, responsive breakpoints, and a comprehensive design token system.

## File Structure

```
lib/utils/
├── app_theme.dart           # Main theme configuration
├── design_constants.dart    # Design tokens and constants
├── theme.dart              # Legacy theme (can be deprecated)
└── constants.dart          # App constants
```

## Color System

### Light Theme Colors

- **Primary**: Sky Blue (#0EA5E9)
  - Light: #7DD3FC
  - Dark: #0369A1

- **Secondary**: Violet Purple (#8B5CF6)
  - Light: #A78BFA
  - Dark: #6D28D9

- **Tertiary**: Teal (#14B8A6)
  - Light: #2DD4BF
  - Dark: #0F766E

### Dark Theme Colors

- **Background**: Slate 900 (#0F172A)
- **Surface**: Slate 800 (#1E293B)
- **Text**: Slate 100 (#F1F5F9)

### Gradients

```dart
// Primary Gradient - Blue to Purple
AppColors.primaryGradient

// Secondary Gradient - Teal to Blue
AppColors.secondaryGradient

// Hero Gradient - Multi-color
AppColors.heroGradient

// Dark Gradient - For dark mode backgrounds
AppColors.darkGradient
```

## Typography

### Font Families

- **Headings**: Space Grotesk (bold, modern geometric sans)
- **Titles**: Poppins (balanced, professional)
- **Body**: Inter (optimized for readability)

### Text Styles

```dart
// Display styles (57px, 45px, 36px)
Theme.of(context).textTheme.displayLarge
Theme.of(context).textTheme.displayMedium
Theme.of(context).textTheme.displaySmall

// Headline styles (32px, 28px, 24px)
Theme.of(context).textTheme.headlineLarge
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.headlineSmall

// Body styles (16px, 14px, 12px)
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.bodySmall
```

## Spacing System

```dart
DesignConstants.spacingXSmall   // 4px
DesignConstants.spacingSmall    // 8px
DesignConstants.spacingMedium   // 16px
DesignConstants.spacingLarge    // 24px
DesignConstants.spacingXLarge   // 32px
DesignConstants.spacing2XLarge  // 48px
DesignConstants.spacing3XLarge  // 64px
DesignConstants.spacing4XLarge  // 96px
```

## Border Radius

```dart
DesignConstants.borderRadiusXSmall  // 4px
DesignConstants.borderRadiusSmall   // 8px
DesignConstants.borderRadiusMedium  // 12px
DesignConstants.borderRadiusLarge   // 16px
DesignConstants.borderRadiusXLarge  // 24px
DesignConstants.borderRadiusFull    // Pill shape
```

## Responsive Breakpoints

```dart
DesignConstants.breakpointMobile        // < 600px
DesignConstants.breakpointTablet        // 600px - 1024px
DesignConstants.breakpointDesktop       // > 1024px
DesignConstants.breakpointLargeDesktop  // > 1440px
```

### Usage with Helper Methods

```dart
// Check device type
bool isMobile = ResponsiveHelper.isMobile(context);
bool isTablet = ResponsiveHelper.isTablet(context);
bool isDesktop = ResponsiveHelper.isDesktop(context);

// Get responsive values
double padding = ResponsiveHelper.getResponsiveValue(
  context,
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Get container padding
double padding = ResponsiveHelper.getContainerPadding(context);

// Get section spacing
double spacing = ResponsiveHelper.getSectionSpacing(context);
```

## Animations

### Durations

```dart
DesignConstants.animationFast       // 150ms - Micro-interactions
DesignConstants.animationNormal     // 300ms - Default
DesignConstants.animationSlow       // 500ms - Elaborate transitions
DesignConstants.animationVerySlow   // 800ms - Page transitions
```

### Curves

```dart
DesignConstants.curveStandard     // Ease in-out
DesignConstants.curveEmphasized   // Ease out cubic
DesignConstants.curveDecelerate   // Ease out
DesignConstants.curveAccelerate   // Ease in
```

## Shadows

```dart
// Light theme shadows
AppShadows.xSmall   // Subtle depth
AppShadows.small    // Cards and buttons
AppShadows.medium   // Elevated components
AppShadows.large    // Modals and popovers
AppShadows.xLarge   // Floating elements

// Dark theme shadows
AppShadows.smallDark
AppShadows.mediumDark
AppShadows.largeDark

// Colored shadows
AppShadows.primary    // Blue glow
AppShadows.secondary  // Purple glow
```

## Theme Controller

### Usage

```dart
// Get theme controller
final themeController = Get.find<ThemeController>();

// Check current theme
bool isDark = themeController.isDarkMode;
bool isLight = themeController.isLightMode;

// Change theme
await themeController.setLightMode();
await themeController.setDarkMode();
await themeController.setSystemMode();
await themeController.toggleTheme();
```

### Theme Toggle Widgets

```dart
// Simple icon button
ThemeToggleButton()

// Fancy button with gradient
FancyThemeToggleButton()

// Dropdown selector (Light/Dark/System)
ThemeModeSelector()
```

## Component Styling

### Cards

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(DesignConstants.spacingMedium),
    child: YourContent(),
  ),
)
```

### Buttons

```dart
// Elevated button
ElevatedButton(
  onPressed: () {},
  child: Text('Primary Action'),
)

// Outlined button
OutlinedButton(
  onPressed: () {},
  child: Text('Secondary Action'),
)

// Text button
TextButton(
  onPressed: () {},
  child: Text('Tertiary Action'),
)
```

### Gradient Containers

```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(
      DesignConstants.borderRadiusMedium,
    ),
  ),
  child: YourContent(),
)
```

## Best Practices

1. **Always use design tokens** instead of hardcoded values
2. **Use ResponsiveHelper** for adaptive layouts
3. **Leverage gradients** for visual interest
4. **Follow Material 3** component patterns
5. **Test both light and dark themes**
6. **Use semantic color names** from the theme
7. **Prefer theme text styles** over custom styles
8. **Apply consistent spacing** using the spacing system

## Migration from Old Theme

If you're using the old theme (`lib/utils/theme.dart`), migrate to the new system:

### Before
```dart
import 'utils/theme.dart';
import 'utils/constants.dart';

theme: AppTheme.lightTheme,
color: AppColors.primary,
padding: AppConstants.spacingM,
```

### After
```dart
import 'utils/app_theme.dart';
import 'utils/design_constants.dart';

theme: AppTheme.lightTheme,
color: AppColors.primaryBlue,
padding: DesignConstants.spacingMedium,
```

## Examples

### Responsive Layout

```dart
Widget build(BuildContext context) {
  final isMobile = ResponsiveHelper.isMobile(context);

  return Container(
    padding: EdgeInsets.all(
      ResponsiveHelper.getContainerPadding(context),
    ),
    child: Column(
      children: [
        Text(
          'Portfolio',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: DesignConstants.spacingLarge),
        if (isMobile)
          MobileLayout()
        else
          DesktopLayout(),
      ],
    ),
  );
}
```

### Gradient Card with Shadow

```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(
      DesignConstants.borderRadiusLarge,
    ),
    boxShadow: AppShadows.primary,
  ),
  padding: EdgeInsets.all(DesignConstants.spacingLarge),
  child: Text(
    'Featured Project',
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: Colors.white,
    ),
  ),
)
```

### Animated Theme-Aware Widget

```dart
AnimatedContainer(
  duration: DesignConstants.animationNormal,
  curve: DesignConstants.curveEmphasized,
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(
      DesignConstants.borderRadiusMedium,
    ),
  ),
  child: YourContent(),
)
```

## Support

For questions or issues with the design system, please refer to:
- Material 3 Guidelines: https://m3.material.io/
- Flutter Theme Documentation: https://docs.flutter.dev/cookbook/design/themes
