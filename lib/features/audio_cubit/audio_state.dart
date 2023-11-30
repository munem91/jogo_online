part of 'audio_cubit.dart';

@immutable
abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object?> get props => [];
}

class Button1AudioEnabled extends AudioState {}

class Button2AudioEnabled extends AudioState {}

class BothButtonsAudioEnabled extends AudioState {}

class AudioDisabled extends AudioState {}
