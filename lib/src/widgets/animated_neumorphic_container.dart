import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedNeumorphicContainer extends StatelessWidget {
  final double depth;
  final Color color;
  final double width;
  final double height;
  final Widget child;
  final double radius;

  const AnimatedNeumorphicContainer({
    Key key,
    @required this.depth,
    this.color = Colors.white,
    this.width,
    this.height,
    this.child,
    this.radius = 8,
  })  : assert(color != null),
        super(key: key);

  static final _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final _lightColor = _createLightColor();
    final _darkColor = _createDarkColor();
    final _tween = Tween<double>(begin: 0, end: depth);

    return TweenAnimationBuilder(
      tween: _tween,
      duration: const Duration(milliseconds: 250),
      curve: _curve,
      builder: (BuildContext context, double depthValue, Widget child) {
        return Container(
          width: this.width,
          height: this.height,
          padding: const EdgeInsets.all(8.0),
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
                offset: _lerpedOffsetLight(depthValue),
                color: _lightColor,
                blurRadius: _lerpedBlur(depthValue),
                spreadRadius: lerpDouble(2, 1, depthValue),
              ),
              BoxShadow(
                offset: _lerpedOffsetDark(depthValue),
                color: _darkColor,
                blurRadius: _lerpedBlur(depthValue),
                spreadRadius: lerpDouble(2, 1, depthValue),
              ),
            ],
          ),
          child: child,
        );
      },
      child: this.child,
    );
  }

  Offset _lerpedOffsetLight(double t) {
    final begin = Offset(
      this.width != null ? -this.width / 10 : -6,
      this.height != null ? -this.height / 10 : -6,
    );
    final end = const Offset(-2, -2);
    return Offset.lerp(begin, end, t);
  }

  Offset _lerpedOffsetDark(double t) {
    final begin = Offset(
      this.width != null ? this.width / 10 : 6,
      this.height != null ? this.height / 10 : 6,
    );
    final end = const Offset(2, 2);
    return Offset.lerp(begin, end, t);
  }

  Color _createLightColor() {
    final hsv = HSVColor.fromColor(this.color);
    final newValue = (hsv.value + 0.2).clamp(0, 1.0);
    return hsv.withValue(newValue).toColor();
  }

  Color _createDarkColor() {
    final hsv = HSVColor.fromColor(this.color).withAlpha(0.4);
    final newValue = (hsv.value - 0.2).clamp(0, 1.0);
    return hsv.withValue(newValue).toColor();
  }

  double _lerpedBlur(double t) {
    var metrics = this.width ?? 20;
    metrics = max(metrics, this.height ?? 20);
    return lerpDouble(metrics / 5, 0.5, t);
  }
}
