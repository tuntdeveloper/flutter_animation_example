import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OnboardingContentWidget1 extends StatefulWidget {
  const OnboardingContentWidget1({super.key});

  @override
  State<OnboardingContentWidget1> createState() =>
      _OnboardingContentWidgetState();
}

class _OnboardingContentWidgetState extends State<OnboardingContentWidget1>
    with TickerProviderStateMixin {
  late final PageController pageController;
  late final Animation<double> animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    double h1 = MediaQuery.of(context).size.height * 0.4;
    double h2 = MediaQuery.of(context).size.height * 0.6;

    const defaultDuration = Duration(milliseconds: 200);

    final animationController =
        AnimationController(duration: defaultDuration, vsync: this);

    animation = Tween<double>(begin: h1, end: h2).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    ));

    pageController = PageController()
      ..addListener(() {
        if (pageController.position.userScrollDirection ==
            ScrollDirection.forward) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return SizedBox(
          height: animation.value,
          child: PageView(
            controller: pageController,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('Screen 1'),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Screen 2'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
