import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/menu.png"),
            fit: BoxFit.fill,
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
                  onTap: () async {
                    await player.play(
                      AssetSource('sound/knopka.mp3'),
                    );
                    // Обработка нажатия на изображение "Play"
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/gameScreen');
                    }
                  },
                  child: Image.asset(
                    "assets/images/play.png",
                    width: 110,
                    height: 110,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await player.play(
                      AssetSource('sound/knopka.mp3'),
                    );
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushReplacementNamed('/settingScreen');
                    }
                  },
                  child: Image.asset(
                    "assets/images/setting.png",
                    width: 110,
                    height: 110,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await player.play(
                      AssetSource('sound/knopka.mp3'),
                    );
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushReplacementNamed('/rulesScreen');
                    }
                  },
                  child: Image.asset(
                    "assets/images/rules.png",
                    width: 110,
                    height: 110,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await player.play(
                      AssetSource('sound/knopka.mp3'),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/exitScreen');
                    }
                  },
                  child: Image.asset(
                    "assets/images/exitbutton.png",
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
