import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double radius = 100;
  Offset position = Offset.zero;
  Color color = const Color.fromRGBO(163, 50, 184, 1);
  late AnimationController _animationController;

  _MyHomePageState();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _updateRadius();
  }

  void _updateRadius() {
    final size = MediaQuery.of(context).size;
    radius = _radius(size);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: AnimatedBuilder(
            builder: (BuildContext context, Widget? child) {
              return Stack(
                children: [
                  AnimatedContainer(
                    color: color,
                    duration: const Duration(seconds: 2),
                  ),
                  ClipPath(
                    clipper: CircularClipper(
                        _animationController.value * radius, position),
                    child: Container(
                      color: color,
                    ),
                  ),
                ],
              );
            },
            animation: _animationController,
          )),
          Expanded(
              child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      circle(const Color.fromRGBO(163, 50, 184, 1),Offset.zero),
                      circle(const Color.fromRGBO(219, 219, 219, 1),Offset(mediaQuery.size.width / 2, 0)),
                      circle(const Color.fromRGBO(168, 225, 255, 1),Offset(mediaQuery.size.width, 0)),
                      circle(const Color.fromRGBO(177, 142, 164, 1),Offset(
                          mediaQuery.size.width, mediaQuery.size.height / 4)),
                    ],
                  )),
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      circle(const Color.fromRGBO(250, 156, 232, 1),Offset(0, mediaQuery.size.height / 4)),
                      circle(const Color.fromRGBO(240, 192, 180, 1),Offset(0, mediaQuery.size.height / 2)),
                      circle(const Color.fromRGBO(200, 183, 227, 1),Offset(
                          mediaQuery.size.width / 2, mediaQuery.size.height / 2)),
                      circle(const Color.fromRGBO(183, 240, 234, 1),Offset(
                          mediaQuery.size.width, mediaQuery.size.height / 2)),
                    ],
                  )),
            ],
          ))
        ],
      ),
    );
  }

  double _radius(Size size) {
    final maxVal = max(size.width, size.height);
    return maxVal * 1.5;
  }

  Widget circle(Color mColor, Offset mPosition) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            color = mColor;
            position = mPosition;
            _animationController.reset();
            _animationController.forward();
          });
        },
        child: Container(
          width: double.infinity,
          height: 70,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: mColor, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class CircularClipper extends CustomClipper<Path> {
  const CircularClipper(this.radius, this.center);

  final double radius;
  final Offset center;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.addOval(Rect.fromCircle(radius: radius, center: center));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
