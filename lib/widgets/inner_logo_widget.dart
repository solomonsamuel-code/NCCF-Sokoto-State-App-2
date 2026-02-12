import 'package:flutter/material.dart';

class InnerLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const InnerLogoWidget({Key? key, this.width = 120, this.height = 120}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/inner_logo.png',
        width: width,
        height: height,
      ),
    );
  }
}