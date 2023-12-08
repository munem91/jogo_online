import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';
import 'package:jogo_bbrbet_online/features/export.dart';
import 'package:jogo_bbrbet_online/features/game/bloc/game_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioCubit>(create: (context) => AudioCubit()),
        BlocProvider<GameBloc>(
            create: (context) =>
                GameBloc(rows: 7, columns: 6)..add(InitializeGame())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const FirstScreen(),
          // MenuScreen(),
          '/settingScreen': (context) => const SettingScreen(),
          '/gameScreen': (context) => const GameScreen(),
          '/winnerScreen': (context) => const WinnerScreen(),
          '/rulesScreen': (context) => const RulesScreen(),
          '/exitScreen': (context) => const ExitScreen(),
          '/menuScreen': (context) => const MenuScreen(),
          '/startScreen': (context) => const StartGame(),
          '/orientationScreen': (context) => const OrientationScreen(),
                                              
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSwatch(backgroundColor: Colors.white).copyWith(
            primary: Colors.black,
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.galindo(
                color: Colors.white,
                fontSize: 32,
                shadows: [
                  const Shadow(
                      // bottomLeft
                      offset: Offset(-1.8, -1.8),
                      color: Colors.black),
                  const Shadow(
                      // bottomRight
                      offset: Offset(1.8, -1.8),
                      color: Colors.black),
                  const Shadow(
                      // topRight
                      offset: Offset(1.8, 1.8),
                      color: Colors.black),
                  const Shadow(
                      // topLeft
                      offset: Offset(-1.8, 1.8),
                      color: Colors.black),
                ]),
          ),
        ),
      ),
    );
  }
}
