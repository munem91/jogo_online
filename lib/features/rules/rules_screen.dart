import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/win.png"), // Замените на путь к вашему изображению фона
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}