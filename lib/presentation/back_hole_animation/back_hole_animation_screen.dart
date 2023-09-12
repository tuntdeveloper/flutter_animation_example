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

  late final AnimationController cardOffsetAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..addListener(() => setState(() {}));

  late final Animatable<double> cardOffsetTween;
  late final Animatable<double> cardRotationTween;

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
        child: SizedBox(
          height: r * 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, cardOffset),
                child: Transform.rotate(
                  angle: cardRotationOffset,
                  child: Container(
                    height: r * 3 / 4,
                    width: r * 3 / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.amber,
                    ),
                    child: const Center(child: Text('Hello')),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/hole.png',
                width: holdSize,
              ),
            ],
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
            Future.delayed(const Duration(milliseconds: 450), () {
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
