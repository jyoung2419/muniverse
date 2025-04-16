import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MuniverseLogo extends StatelessWidget {
  final double height;

  const MuniverseLogo({
    super.key,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/Muniverse.svg',
      height: height,
    );
  }
}
