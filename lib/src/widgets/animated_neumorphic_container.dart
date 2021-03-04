import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Animated version of Container styled as Neumorphism that gradually changes its values over a period of time.
///
/// The AnimatedNeumorphicContainer will automatically animate between the old and new values of properties when they change using the provided curve and duration. Its child and descendants are not animated.
///
/// The `depth` value is requied and expected as range from 0 to 1, that means Container's elevation.
class AnimatedNeumorphicContainer extends StatelessWidget {
  final double depth;
  final Color color;
  final double? width;
  final double? height;
  final Widget? child;
  final double radius;
  final Duration duration;
  final Curve curve;

  /// Creates a widget styled as Neumorphism that animates implicitly.
  ///
  /// The `color`, `radius`, `duration`, `curve` arguments must not be null.
  ///
  /// As default, `color` is defined `Color(0xFFF2F2F2)` that is little-grayish white. Because the Neumorphism is composed of base color, light color and dark color (for dropshadow), and this widget will calculate these automatically from the base color.
  const AnimatedNeumorphicContainer({
    Key? key,
    required this.depth,
    this.color = const Color(0xFFF2F2F2),
    this.width,
    this.height,
    this.child,
    this.radius = 8,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
  })  : assert(color != null),
        assert(depth >= 0.0 && depth <= 1.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _lightColor = _createLightColor();
    final _darkColor = _createDarkColor();
    final _tween = Tween<double>(begin: 0, end: depth);

    return TweenAnimationBuilder(
      tween: _tween,
      duration: this.duration,
      curve: this.curve,
      builder: (BuildContext context, double depthValue, Widget? child) {
        return Container(
          width: this.width,
          height: this.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _darkColor,
                this.color,
                _lightColor,
              ],
              stops: [0, 0.2, 0.8],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(this.radius),
            boxShadow: [
              BoxShadow(
                offset: _lerpedOffsetLight(depthValue)!,
                color: _lightColor,
                blurRadius: _lerpedBlur(depthValue)!,
                spreadRadius: lerpDouble(1, 2, depthValue)!,
              ),
              BoxShadow(
                offset: _lerpedOffsetDark(depthValue)!,
                color: _darkColor,
                blurRadius: _lerpedBlur(depthValue)!,
                spreadRadius: lerpDouble(1, 2, depthValue)!,
              ),
            ],
          ),
          child: child,
        );
      },
      child: this.child,
    );
  }

  Offset? _lerpedOffsetLight(double t) {
    final pulled = Offset(
      this.width != null ? -this.width! / 10 : -6,
      this.height != null ? -this.height! / 10 : -6,
    );
    final pushed = const Offset(-2, -2);
    return Offset.lerp(pushed, pulled, t);
  }

  Offset? _lerpedOffsetDark(double t) {
    final pulled = Offset(
      this.width != null ? this.width! / 10 : 6,
      this.height != null ? this.height! / 10 : 6,
    );
    final pushed = const Offset(2, 2);
    return Offset.lerp(pushed, pulled, t);
  }

  Color _createLightColor() {
    final hsv = HSVColor.fromColor(this.color);
    final newValue = (hsv.value + 0.2).clamp(0, 1.0);
    return hsv.withValue(newValue as double).toColor();
  }

  Color _createDarkColor() {
    final hsv = HSVColor.fromColor(this.color).withAlpha(0.4);
    final newValue = (hsv.value - 0.2).clamp(0, 1.0);
    return hsv.withValue(newValue as double).toColor();
  }

  double? _lerpedBlur(double t) {
    var metrics = this.width ?? 20;
    metrics = max(metrics, this.height ?? 20);
    return lerpDouble(0.5, metrics / 5, t);
  }
}
