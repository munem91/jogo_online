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

          return SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/settingscreen.png', // Укажите путь к вашему изображению
                  fit: BoxFit.fill,
                ),

                Positioned(
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: GestureDetector(
                    onTap: () async {
                      await audioCubit.playSound1('sound/knopka.mp3');
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    },
                    child: Image.asset(
                      "assets/images/back.png",
                      scale: 1.2,
                    ),
                  ),
                ),
                // Вертикальная колонка с плашкой и содержимым
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * 0.85,
                        height: MediaQuery.of(context).size.width * 0.85,
                        // color: Colors.black,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/plaska.png"),
                          ),
                        ),

                        // Строка с текстом "Settings"

                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Settings",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                              ),

                              // Блок Sound
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 55, bottom: 20),
                                      child: Text(
                                        "Sound",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, right: 50),
                                    child: InkWell(
                                      onTap: () async {
                                        audioCubit.toggleButton1Sound();
                                        await audioCubit
                                            .playSound1('sound/knopka.mp3');
                                      },
                                      child: Image.asset(
                                        audioCubit.isButton1SoundEnabled
                                            ? "assets/images/on.png"
                                            : "assets/images/off.png",
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Блок Music
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 55, bottom: 30),
                                    child: Text(
                                      "Music",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 30, right: 50),
                                    child: InkWell(
                                      onTap: () async {
                                        audioCubit.toggleButton2Sound();
                                        if (!audioCubit.isButton2SoundEnabled) {
                                          audioCubit.stopSound2();
                                        }
                                        await audioCubit
                                            .playSound2('sound/music.mp3');
                                      },
                                      child: Image.asset(
                                        audioCubit.isButton2SoundEnabled
                                            ? "assets/images/on.png"
                                            : "assets/images/off.png",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
