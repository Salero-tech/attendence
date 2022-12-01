import 'package:flutter/material.dart';
import 'dart:async';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  static const double maxWidth = 100;
  static const double minWidth = 60;
  static const animationDuration = Duration(milliseconds: 750);
  late Timer timer;

  bool isSmall = true;
  double width = minWidth;

  void animate() {
    setState(() {
      if (isSmall) {
        width = maxWidth;
        isSmall = false;
      } else {
        width = minWidth;
        isSmall = true;
      }
    });
  }

  @override
  void initState() {
    timer = Timer.periodic(animationDuration, (Timer t) => animate());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("loading data ...")),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            AnimatedContainer(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              width: width,
              height: width,
              duration: animationDuration,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
