import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/rulescrop.png"), // Замените на путь к вашему изображению фона
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 60),
            child: GestureDetector(
              onTap: () {
                // Ваш код для открытия другого экрана
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: SizedBox(
                width: 24 * 3,
                height: 24 * 3,
                child: Image.asset(
                  "assets/images/back.png", // Замените путь к вашему изображению
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
