import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  late final SharedPreferences _prefs;
  bool isButton1SoundEnabled = true;
  bool isButton2SoundEnabled = true;

  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();

  AudioCubit() : super(AudioDisabled()) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    // Всегда устанавливаем значения в false при новом запуске
    isButton1SoundEnabled = false;
    isButton2SoundEnabled = false;

    _prefs.setBool('isButton1SoundEnabled', isButton1SoundEnabled);
    _prefs.setBool('isButton2SoundEnabled', isButton2SoundEnabled);

    _emitState();
  }

  void toggleButton1Sound() {
    isButton1SoundEnabled = !isButton1SoundEnabled;
    _prefs.setBool('isButton1SoundEnabled', isButton1SoundEnabled);
    _emitState();
  }

  void toggleButton2Sound() {
    isButton2SoundEnabled = !isButton2SoundEnabled;
    _prefs.setBool('isButton2SoundEnabled', isButton2SoundEnabled);
    _emitState();
  }

  void _emitState() {
    if (isButton1SoundEnabled && isButton2SoundEnabled) {
      emit(BothButtonsAudioEnabled());
    } else if (isButton1SoundEnabled) {
      emit(Button1AudioEnabled());
    } else if (isButton2SoundEnabled) {
      emit(Button2AudioEnabled());
    } else {
      emit(AudioDisabled());
    }
  }

  Future<void> playSound1(String soundPath) async {
    if (isButton1SoundEnabled) {
      await _player1.play(AssetSource(soundPath));
    }
    // Добавьте любые другие условия при необходимости
  }

  Future<void> playSound2(String soundPath) async {
    if (isButton2SoundEnabled) {
      await _player2.play(AssetSource(soundPath));
      loop();
    }
    // Добавьте любые другие условия при необходимости
  }

  void loop() {
    _player2.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> stopSound2() async {
    await _player2.stop();
  }
}
