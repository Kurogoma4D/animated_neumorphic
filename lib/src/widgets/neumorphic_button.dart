import 'package:flutter/material.dart';

import 'animated_neumorphic_container.dart';

class NeumorphicButton extends StatefulWidget {
  final bool isActive;

  const NeumorphicButton({Key key, this.isActive}) : super(key: key);

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isActive = !_isActive;
        });
      },
      child: AnimatedNeumorphicContainer(
        depth: _isActive ? 1.0 : 0.0,
        color: Color(0xFFF2F2F2),
        width: 60,
        height: 60,
        radius: 16,
        child: Icon(Icons.access_time),
      ),
    );
  }
}
