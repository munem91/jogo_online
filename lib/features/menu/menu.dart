import 'package:flutter/material.dart';

import '../export.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/menu.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView(
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () {
                    // Обработка нажатия на изображение "Play"
                    Navigator.of(context).pushReplacementNamed('/gameScreen');
                  },
                  child: Image.asset(
                    "assets/images/play.png",
                    width: 110,
                    height: 110,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Обработка нажатия на изображение "Setting"
                    Navigator.of(context)
                        .pushReplacementNamed('/settingScreen');
                  },
                  child: Image.asset(
                    "assets/images/setting.png",
                    width: 110,
                    height: 110,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Обработка нажатия на изображение "Rules"
                    Navigator.of(context).pushReplacementNamed('/rulesScreen');
                  },
                  child: Image.asset(
                    "assets/images/rules.png",
                    width: 110,
                    height: 110,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Обработка нажатия на изображение "Exit"
                    Navigator.of(context).pushReplacementNamed('/exitScreen');
                  },
                  child: Image.asset(
                    "assets/images/exit.png",
                    width: 110,
                    height: 110,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
