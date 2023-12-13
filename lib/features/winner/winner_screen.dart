import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';
import 'package:jogo_bbrbet_online/features/game/bloc/game_bloc.dart';

class WinnerScreen extends StatefulWidget {
  const WinnerScreen({Key? key}) : super(key: key);

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
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
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          var audioCubit = BlocProvider.of<AudioCubit>(context);

          if (state is GameInProgressState) {
            return SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/images/win.png",
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

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 130.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Score: ${state.score}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Level: ${state.level}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ]),
                    ),
                  ),
                  
                ],
              ),
            );
          } else {
            
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
