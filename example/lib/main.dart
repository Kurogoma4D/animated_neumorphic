import 'package:animated_neumorphic/animated_neumorphic.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _width = 60.0;
  double _height = 60.0;
  double _depth = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Color(0xFFF2F2F2),
      body: Center(
          child: Column(
        children: <Widget>[
          const SizedBox(height: 32),
          NeumorphicButton(),
          const SizedBox(height: 32),
          AnimatedNeumorphicContainer(
            depth: _depth,
            width: _width,
            height: _height,
            color: const Color(0xFFF2F2F2),
            child: Icon(Icons.timeline),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _width,
            min: 60,
            max: 180,
            onChanged: (v) {
              setState(() => _width = v);
            },
          ),
          Slider(
            value: _height,
            min: 60,
            max: 180,
            onChanged: (v) {
              setState(() => _height = v);
            },
          ),
          Slider(
            value: _depth,
            min: 0.0,
            max: 1.0,
            onChanged: (v) {
              setState(() => _depth = v);
            },
          ),
        ],
      )),
    );
  }
}

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
        depth: _isActive ? 0.0 : 1.0,
        color: Color(0xFFF2F2F2),
        width: 60,
        height: 60,
        radius: 16,
        child: Icon(Icons.access_time),
      ),
    );
  }
}
