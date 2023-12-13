import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';

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
                      Padding(
                        padding: const EdgeInsets.only(top: 110.0),
                        child: Container(
                          width: MediaQuery.of(context).size.height * 1.2,
                          height: MediaQuery.of(context).size.width * 1.2,
                          // color: Colors.black,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/rulesplaska.png"),
                            ),
                          ),

                          // Строка с текстом "Settings"

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Text('Rules',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                  Text(
                                    "In a Match-3 game, the primary goal is to match a minimum of three identical items either horizontally or vertically. To do so, you'll need to swap adjacent items on the gameboard. Matching three or more of the same items makes them disappear, earning you points. You'll have a limited number of moves or a set time to achieve your objectives. Combining more than three items in one move can create powerful combos and special items. Enjoy fair play to maximize your fun."
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),

                                  // Блок Sound

                                  // Блок Music
                                ]),
                          ),
                        ),
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
