
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String iconName;
  final double wight;
  final double hight;

  const CustomIcon({
    Key? key,
    required this.iconName,
    required this.wight,
    required this.hight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wight,
      height: hight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/blue_container.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/$iconName.png',
          width: wight,
          height: hight,
          scale: 0.9,
        ),
      ),
    );
  }
}
