import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';
import 'package:jogo_bbrbet_online/features/export.dart';
import 'package:jogo_bbrbet_online/features/game/bloc/game_bloc.dart';

class MyApp extends StatelessWidget {
  static String? secondGenerator;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: DioRepository(dio: Dio()).fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            secondGenerator =
                snapshot.data; // Присвоение значения статическому свойству
          }

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
             
                '/settingScreen': (context) => const SettingScreen(),
                '/gameScreen': (context) => const GameScreen(),
                '/winnerScreen': (context) => const WinnerScreen(),
                '/rulesScreen': (context) => const RulesScreen(),
                '/exitScreen': (context) => const ExitScreen(),
                '/menuScreen': (context) => const MenuScreen(),
                '/startScreen': (context) => StartGame(
                      generationGame: secondGenerator,
                    ),
              },
              theme: ThemeData(
                useMaterial3: true,
                colorScheme:
                    ColorScheme.fromSwatch(backgroundColor: Colors.white)
                        .copyWith(
                  primary: Colors.black,
                ),
                textTheme: TextTheme(
                  titleLarge: GoogleFonts.galindo(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.035,
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
                  titleMedium: GoogleFonts.galindo(
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
                  titleSmall: GoogleFonts.galindo(
                      color: Colors.white,
                      fontSize: 22,
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
                  bodySmall: GoogleFonts.homenaje(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.021,
                      shadows: [
                        const Shadow(
                            // bottomLeft
                            offset: Offset(-1, -1),
                            color: Colors.black),
                        const Shadow(
                            // bottomRight
                            offset: Offset(1, -1),
                            color: Colors.black),
                        const Shadow(
                            // topRight
                            offset: Offset(1, 1),
                            color: Colors.black),
                        const Shadow(
                            // topLeft
                            offset: Offset(-1, 1),
                            color: Colors.black),
                      ]),
                ),
              ),
            ),
          );
        });
  }
}
