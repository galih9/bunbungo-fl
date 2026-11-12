import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Interactive button wrapper providing tactile press-down scale bounce,
/// optional hover scale for desktop, and haptic feedback without sacrificing performance.
class BouncingWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final Duration duration;
  final HitTestBehavior behavior;
  final bool enableHaptics;

  const BouncingWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 120),
    this.behavior = HitTestBehavior.opaque,
    this.enableHaptics = true,
  });

  @override
  State<BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    _isPressed = true;
    _controller.forward();
    if (widget.enableHaptics) {
      try {
        HapticFeedback.selectionClick();
      } catch (_) {}
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_isPressed) return;
    _isPressed = false;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!_isPressed) return;
    _isPressed = false;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null || widget.onLongPress != null;
    if (!isInteractive) return widget.child;

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Shake animation controller and widget for incorrect answers / validation alerts.
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double shakeDistance;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 380),
    this.shakeDistance = 10.0,
  });

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers a physical horizontal damped oscillation shake.
  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Damped sine wave: sin(t * pi * 4) * (1 - t)
        final progress = _controller.value;
        final offset = progress > 0 && progress < 1.0
            ? math.sin(progress * math.pi * 5) *
                (1.0 - progress) *
                widget.shakeDistance
            : 0.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Smooth hardware-accelerated animated progress bar (e.g. for Arena card progression or XP).
class SmoothAnimatedProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color backgroundColor;
  final Color fillColor;
  final Gradient? fillGradient;
  final BorderRadius borderRadius;

  const SmoothAnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor = const Color(0xFF27272A),
    this.fillColor = const Color(0xFF34D399),
    this.fillGradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return RepaintBoundary(
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: clamped),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * value,
                    height: height,
                    decoration: BoxDecoration(
                      color: fillGradient == null ? fillColor : null,
                      gradient: fillGradient,
                      borderRadius: borderRadius,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// An animated number counter that counts up to the target value smoothly.
class CountUpText extends StatelessWidget {
  final int targetValue;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;
  final Curve curve;

  const CountUpText({
    super.key,
    required this.targetValue,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetValue.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        return Text(
          '$prefix${value.round()}$suffix',
          style: style,
        );
      },
    );
  }
}

/// Subtle pulsating breathing glow widget for buttons or urgency badges.
/// Runs a finite number of pulses upon activation to preserve battery,
/// avoid idle GPU load, and guarantee test-framework compatibility.
class GlowPulseWidget extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double minScale;
  final double maxScale;
  final Duration duration;
  final bool animate;
  final int pulses;

  const GlowPulseWidget({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF34D399),
    this.minScale = 1.0,
    this.maxScale = 1.03,
    this.duration = const Duration(milliseconds: 650),
    this.animate = true,
    this.pulses = 2,
  });

  @override
  State<GlowPulseWidget> createState() => _GlowPulseWidgetState();
}

class _GlowPulseWidgetState extends State<GlowPulseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;
  int _completedPulses = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.15,
      end: 0.45,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _completedPulses++;
        if (mounted && _completedPulses < widget.pulses && widget.animate) {
          _controller.forward();
        }
      }
    });

    if (widget.animate) {
      _startPulse();
    }
  }

  void _startPulse() {
    _completedPulses = 0;
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant GlowPulseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _startPulse();
    } else if (!widget.animate && oldWidget.animate) {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate && _controller.value == 0.0) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: _glowAnimation.value),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Ultra-lightweight 60fps confetti shower for session complete / level ups.
/// Automatically disposes its ticker after playback to maintain 0 idle overhead.
class ConfettiBurst extends StatefulWidget {
  final Duration duration;
  final int particleCount;

  const ConfettiBurst({
    super.key,
    this.duration = const Duration(milliseconds: 2400),
    this.particleCount = 42,
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final colors = [
      const Color(0xFF34D399), // Emerald
      const Color(0xFFFBBF24), // Amber
      const Color(0xFF38BDF8), // Sky
      const Color(0xFFA855F7), // Purple
      const Color(0xFFFB7185), // Rose
      const Color(0xFFF4F4F5), // White
    ];

    _particles = List.generate(widget.particleCount, (i) {
      return _Particle(
        x: _random.nextDouble(),
        speedY: 0.6 + _random.nextDouble() * 0.9,
        speedX: (_random.nextDouble() - 0.5) * 0.5,
        rotationSpeed: (_random.nextDouble() - 0.5) * 8.0,
        size: 5.0 + _random.nextDouble() * 6.0,
        color: colors[_random.nextInt(colors.length)],
        shape: _random.nextBool() ? _ParticleShape.rect : _ParticleShape.circle,
        wobbleSpeed: 2.0 + _random.nextDouble() * 4.0,
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isCompleted) return const SizedBox.shrink();
            return CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(
                progress: _controller.value,
                particles: _particles,
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _ParticleShape { rect, circle }

class _Particle {
  final double x;
  final double speedY;
  final double speedX;
  final double rotationSpeed;
  final double size;
  final Color color;
  final _ParticleShape shape;
  final double wobbleSpeed;

  _Particle({
    required this.x,
    required this.speedY,
    required this.speedX,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.shape,
    required this.wobbleSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_Particle> particles;

  _ConfettiPainter({
    required this.progress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fade out smoothly during the final 25% of duration
    final opacity = (progress > 0.75 ? (1.0 - progress) / 0.25 : 1.0).clamp(0.0, 1.0);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final y = (p.speedY * progress * size.height * 1.2) - (p.size * 2);
      if (y > size.height + 20) continue;

      final wobble = math.sin(progress * math.pi * p.wobbleSpeed) * 16.0;
      final x = (p.x * size.width) + (p.speedX * progress * size.width) + wobble;

      paint.color = p.color.withValues(alpha: opacity * 0.9);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * p.rotationSpeed);

      if (p.shape == _ParticleShape.circle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
