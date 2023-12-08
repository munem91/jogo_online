import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
      body: BlocBuilder<AudioCubit, AudioState>(
        builder: (context, state) {
          var audioCubit = BlocProvider.of<AudioCubit>(context);

          return Center(
            child: Container(
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/settingscreen.png"), // Замените на путь к вашему изображению фона
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await audioCubit.playSound1('sound/knopka.mp3');
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      },
                      child: Image.asset(
                        "assets/images/back.png",
                      ),
                    ),
                    const SizedBox(
                        height: 230), // Добавленный отступ снизу от back.png
                    InkWell(
                      onTap: () async {
                        audioCubit.toggleButton1Sound();
                        await audioCubit.playSound1('sound/knopka.mp3');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 230.0),
                        child: Image.asset(
                          audioCubit.isButton1SoundEnabled
                              ? "assets/images/on.png"
                              : "assets/images/off.png",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        audioCubit.toggleButton2Sound();
                        if (!audioCubit.isButton2SoundEnabled) {
                          audioCubit.stopSound2();
                        }
                        await audioCubit.playSound2('sound/music.mp3');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 230.0),
                        child: Image.asset(
                          audioCubit.isButton2SoundEnabled
                              ? "assets/images/on.png"
                              : "assets/images/off.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
