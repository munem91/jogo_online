part of 'game_bloc.dart';

@immutable
abstract class GameState {
  List<List<int>> get board;
  int? get draggedIndex;
  late final int score;

  List<Object?> get props => [];
}

class InitialGameState extends GameState {
  @override
  get board => [];

  @override
  get draggedIndex => null;

  // Инициализировать score значением 0
  @override
  final int score = 0;
}

class GameInProgressState extends GameState {
  @override
  final List<List<int>> board;
  final int level;
  @override
  final int score;

  @override
  final int? draggedIndex;

  GameInProgressState({
    required this.board,
    this.draggedIndex,
    this.score = 0,
    this.level = 0, // Добавлено поле для уровня
  });

  GameInProgressState copyWith({
    List<List<int>>? board,
    int? draggedIndex,
    int? score,
    int? level,
  }) {
    return GameInProgressState(
      board: board ?? this.board,
      draggedIndex: draggedIndex ?? this.draggedIndex,
      score: score ?? this.score,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [board, draggedIndex, score];
}
