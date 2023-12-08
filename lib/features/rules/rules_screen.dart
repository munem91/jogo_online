import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/audio_cubit/audio_cubit.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
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
              onTap: () async {
                await audioCubit.playSound1('sound/knopka.mp3');
                // Обработка нажатия на изображение "Play"
                if (context.mounted) {
                  // Ваш код для открытия другого экрана
                  Navigator.of(context).pushReplacementNamed('/');
                }
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
