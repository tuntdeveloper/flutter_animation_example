import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_sample_app/presentation/back_hole_animation/back_hole_animation_screen.dart';

class OnboardingContentWidget extends StatefulWidget {
  const OnboardingContentWidget({super.key});

  @override
  State<OnboardingContentWidget> createState() =>
      _OnboardingContentWidgetState();
}

class _OnboardingContentWidgetState extends State<OnboardingContentWidget>
    with TickerProviderStateMixin {
  late final PageController pageController;
  final tabContentHeight = ValueNotifier<double>(0);
  final defaultDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    scheduleMicrotask(() {
      final height1 = MediaQuery.of(context).size.height * 0.4;
      final height2 = MediaQuery.of(context).size.height * 0.6;
      final width = MediaQuery.of(context).size.width;

      tabContentHeight.value = height1;

      pageController.addListener(() {
        final currentPosition = pageController.offset;
        final currentHeight = tabContentHeight.value;
        final ratio = currentPosition / width;
        final heightChanged = (height2 - height1) * ratio;

        if (currentPosition < 0) return;

        if (pageController.position.userScrollDirection ==
            ScrollDirection.forward) {
          final heightDecrease = currentHeight - heightChanged;

          if (heightDecrease > height1) {
            tabContentHeight.value -= heightChanged;
          }
        } else {
          final heightIncrease = currentHeight + heightChanged;

          if (heightIncrease < height2) {
            tabContentHeight.value += heightChanged;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: tabContentHeight,
        builder: (context, height, _) {
          return AnimatedContainer(
            height: height,
            duration: defaultDuration,
            child: PageView(
              controller: pageController,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text('Screen 1'),
                      buttonWidget,
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
        });
  }

  Widget get buttonWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 200,
        child: CupertinoButton(
          color: Colors.red,
          onPressed: () => BlackHoleAnimationScreen.push(context),
          child: const Center(child: Text('Button')),
        ),
      ),
    );
  }
}
