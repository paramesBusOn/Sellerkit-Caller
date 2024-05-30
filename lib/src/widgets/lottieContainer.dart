// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';

class LottieContainer extends StatelessWidget {
  const LottieContainer(
      {super.key, 
      required this.height,
      required this.width,
      required this.file});

  final double width;
  final double height;
  final String file;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Lottie.asset('$file',
          animate: true,
          repeat: true,
          height: Screens.padingHeight(context) * 0.2,
          width: Screens.width(context) * 0.2),
    );
  }
}
