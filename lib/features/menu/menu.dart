import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/audio_cubit/audio_cubit.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);
  // final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var audioCubit = BlocProvider.of<AudioCubit>(context);

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
                    await audioCubit.playSound1('sound/knopka.mp3');
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
                    await audioCubit.playSound1('sound/knopka.mp3');
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
                    await audioCubit.playSound1('sound/knopka.mp3');
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
                    await audioCubit.playSound1('sound/knopka.mp3');
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
