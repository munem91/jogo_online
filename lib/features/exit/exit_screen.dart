import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
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
    var audioCubit = BlocProvider.of<AudioCubit>(context);

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/exit.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await audioCubit.playSound1('sound/knopka.mp3');
                    // Обработка нажатия на изображение "Play"
                    if (context.mounted) {
                      // Ваш код для открытия другого экрана
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 24 * 3,
                      height: 24 * 3,
                      child: Image.asset(
                        "assets/images/back.png",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 600,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Изменено на CrossAxisAlignment.center
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await audioCubit.playSound1('sound/knopka.mp3');
                          // Обработка нажатия на первое изображение
                          if (context.mounted) {
                            // Закрытие приложения
                            SystemNavigator.pop();
                          }
                        },
                        child: Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              "assets/images/yes.png",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 20), // Небольшое расстояние между кнопками
                      GestureDetector(
                        onTap: () async {
                          await audioCubit.playSound1('sound/knopka.mp3');
                          // Обработка нажатия на кнопку "Exit Yes"
                          if (context.mounted) {
                            // Ваш код для открытия другого экрана
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        },
                        child: Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              "assets/images/no.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
