import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/audio_cubit/audio_cubit.dart';
import 'package:jogo_online/features/game/bloc/game_bloc.dart';

class WinnerScreen extends StatelessWidget {
  const WinnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var audioCubit = BlocProvider.of<AudioCubit>(context);
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameInProgressState) {
          return Scaffold(
            body: Container(
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/win.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 75),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await audioCubit.playSound1('sound/knopka.mp3');
                        if (context.mounted) {
                          BlocProvider.of<GameBloc>(context)
                              .add(InitializeGame());
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      },
                      child: SizedBox(
                        width: 24 * 3,
                        height: 24 * 3,
                        child: Image.asset(
                          "assets/images/back.png",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 280,
                      width: 200,
                    ),

                    Center(
                      child: Column(children: [
                        Text(
                          'Score: ${state.score}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Level: ${state.level}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ]),
                    ),
                    // Добавьте другие элементы интерфейса по мере необходимости
                  ],
                ),
              ),
            ),
          );
        } else {
          // Обработка других состояний, если необходимо
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
