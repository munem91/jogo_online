import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'export.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fon.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: const Game(),
              ),
              Positioned(
                top: 696,
                right: 30.0,
                child: Image.asset(
                  'assets/images/spisok.png', // Путь к вашему изображению
                  width: 90, // Укажите нужную ширину
                  height: 90, // Укажите нужную высоту
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
