import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlackHoleAnimationScreen extends StatefulWidget {
  const BlackHoleAnimationScreen({super.key});

  static Future<void> push(BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const BlackHoleAnimationScreen()));
  }

  @override
  State<BlackHoleAnimationScreen> createState() =>
      _BlackHoleAnimationScreenState();
}

class _BlackHoleAnimationScreenState extends State<BlackHoleAnimationScreen>
    with TickerProviderStateMixin {
  late final AnimationController holeAnimationController;
  late final Animatable<double> holeAnimation;
  late final double r;

  late final AnimationController cardOffsetAnimationController;

  late final Animatable<double> cardOffsetTween;
  late final Animatable<double> cardRotationTween;
  late final Animatable<double> cardElevationTween;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    r = MediaQuery.of(context).size.width * 0.4;

    holeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() => setState(() {}));

    holeAnimation = Tween<double>(begin: r * 1.5, end: 0).chain(CurveTween(
      curve: Curves.ease,
    ));

    cardOffsetAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addListener(() => setState(() {}));

    cardOffsetTween = Tween<double>(begin: -90, end: r * 2)
        .chain(CurveTween(curve: Curves.easeInBack));

    cardRotationTween = Tween<double>(begin: 0, end: 1.5)
        .chain(CurveTween(curve: Curves.easeInBack));
  }

  double get holdSize => holeAnimation.evaluate(holeAnimationController);

  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotationOffset =>
      cardRotationTween.evaluate(cardOffsetAnimationController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: BlackHoleSclipper(),
          child: SizedBox(
            height: r * 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/hole.png',
                  width: holdSize,
                ),
                Transform.translate(
                  offset: Offset(0, cardOffset),
                  child: Transform.rotate(
                    angle: cardRotationOffset,
                    child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            height: r * 3 / 4,
                            width: r * 3 / 4,
                            margin: const EdgeInsets.only(
                                bottom: 6.0), //Same as `blurRadius` i guess
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.red,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CupertinoButton(
        onPressed: () {
          if (holeAnimationController.status == AnimationStatus.completed) {
            Future.delayed(const Duration(milliseconds: 150), () {
              holeAnimationController.reverse();
            });
            cardOffsetAnimationController.reverse();
          } else {
            Future.delayed(const Duration(milliseconds: 700), () {
              holeAnimationController.forward();
            });
            cardOffsetAnimationController.forward();
          }
        },
        child: const Text('Button'),
      ),
    );
  }
}

class BlackHoleSclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2 - 220)
      ..arcTo(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2 - 200),
            width: size.width,
            height: size.height,
          ),
          0,
          pi,
          true)
      ..lineTo(0, -1000)
      ..lineTo(size.width, -1000)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
