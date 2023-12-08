import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:jogo_online/features/game/game_app.dart';
import 'features/export.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  GetIt.I.registerLazySingleton<AbstractDioRepository>(
      () => DioRepository(dio: Dio()));
  runApp(const MyApp());
}


