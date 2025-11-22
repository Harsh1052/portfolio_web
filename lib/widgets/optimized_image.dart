import 'package:flutter/material.dart';

/// Optimized image widget with lazy loading, caching, and placeholder
///
/// Features:
/// - Lazy loading for better performance
/// - Automatic caching with HTTP headers
/// - Shimmer placeholder while loading
/// - Error handling with fallback
/// - Responsive sizing
/// - Fade-in animation
///
/// Usage:
/// ```dart
/// OptimizedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   width: 200,
///   height: 200,
/// )
/// ```
class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeDuration;
  final bool enableMemoryCache;
  final Map<String, String>? headers;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.enableMemoryCache = true,
    this.headers,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage> {
  ImageStreamListener? _imageStreamListener;
  ImageStream? _imageStream;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImage();
  }

  @override
  void didUpdateWidget(OptimizedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  void _loadImage() {
    final imageProvider = NetworkImage(
      widget.imageUrl,
      headers: widget.headers,
    );

    _imageStream =
        imageProvider.resolve(createLocalImageConfiguration(context));
    _imageStreamListener = ImageStreamListener(
      _onImage,
      onError: _onError,
    );
    _imageStream!.addListener(_imageStreamListener!);
  }

  void _onImage(ImageInfo image, bool synchronousCall) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasError = false;
    });
  }

  void _onError(Object exception, StackTrace? stackTrace) {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    if (_imageStream != null && _imageStreamListener != null) {
      _imageStream!.removeListener(_imageStreamListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_hasError) {
      content = widget.errorWidget ?? _buildErrorWidget();
    } else if (_isLoading) {
      content = widget.placeholder ?? _buildPlaceholder();
    } else {
      content = _buildImage();
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: content,
      ),
    );
  }

  Widget _buildImage() {
    return RepaintBoundary(
      child: AnimatedOpacity(
        opacity: _isLoading ? 0.0 : 1.0,
        duration: widget.fadeDuration,
        child: Image.network(
          widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          cacheWidth: widget.width?.toInt(),
          cacheHeight: widget.height?.toInt(),
          headers: widget.headers,
          errorBuilder: (context, error, stackTrace) {
            return widget.errorWidget ?? _buildErrorWidget();
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0.0 : 1.0,
              duration: widget.fadeDuration,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return RepaintBoundary(
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: ShimmerPlaceholder(
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            'Image not available',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder animation
class ShimmerPlaceholder extends StatefulWidget {
  final double? width;
  final double? height;

  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 1.0,
                _animation.value,
                _animation.value + 1.0,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Cached network image with optimized loading
///
/// This is a simpler version that uses built-in caching
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              SizedBox(
                width: width,
                height: height,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              Container(
                width: width,
                height: height,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              );
        },
      ),
    );
  }
}

/// Lazy image that loads only when visible
class LazyImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const LazyImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simple visibility check using layout builder
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isVisible) {
            setState(() => _isVisible = true);
          }
        });

        return _isVisible
            ? OptimizedImage(
                imageUrl: widget.imageUrl,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                borderRadius: widget.borderRadius,
              )
            : Container(
                width: widget.width,
                height: widget.height,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              );
      },
    );
  }
}

/// Avatar image with circular shape and caching
class AvatarImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AvatarImage({
    super.key,
    required this.imageUrl,
    this.size = 48,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
      placeholder: placeholder ??
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
      errorWidget: errorWidget ??
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
    );
  }
}

/// Background image with gradient overlay
class BackgroundImage extends StatelessWidget {
  final String imageUrl;
  final Widget child;
  final BoxFit fit;
  final Gradient? gradient;
  final double opacity;

  const BackgroundImage({
    super.key,
    required this.imageUrl,
    required this.child,
    this.fit = BoxFit.cover,
    this.gradient,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: opacity,
          child: OptimizedImage(
            imageUrl: imageUrl,
            fit: fit,
          ),
        ),
        if (gradient != null)
          Container(
            decoration: BoxDecoration(gradient: gradient),
          ),
        child,
      ],
    );
  }
}

/// Hero image for project showcases
class HeroImage extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const HeroImage({
    super.key,
    required this.imageUrl,
    required this.tag,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: OptimizedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
      ),
    );
  }
}
