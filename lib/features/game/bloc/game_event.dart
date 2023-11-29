part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class InitializeGame extends GameEvent {}

class SwapTiles extends GameEvent {
  final int firstIndex;
  final int secondIndex;

  SwapTiles({required this.firstIndex, required this.secondIndex});
}