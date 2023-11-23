import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/test.dart';

// Events
abstract class GameEvent {}

class InitializeGame extends GameEvent {}

class SwapTiles extends GameEvent {
  final int firstIndex;
  final int secondIndex;

  SwapTiles({required this.firstIndex, required this.secondIndex});
}

// States
abstract class GameState {
  List<List<int>> get board;

  int? get draggedIndex;

  @override
  List<Object?> get props => [];
}

class InitialGameState extends GameState {
  @override
  get board => [];

  @override
  get draggedIndex => null;
}

class InitializeDrag extends GameEvent {
  final int draggedIndex;

  InitializeDrag({required this.draggedIndex});
}

class FinishDrag extends GameEvent {}

class GameInProgressState extends GameState {
  @override
  final List<List<int>> board;

  @override
  final int? draggedIndex;

  GameInProgressState({required this.board, this.draggedIndex});

  GameInProgressState copyWith({
    List<List<int>>? board,
    int? draggedIndex,
  }) {
    return GameInProgressState(
      board: board ?? this.board,
      draggedIndex: draggedIndex ?? this.draggedIndex,
    );
  }

  @override
  List<Object?> get props => [board, draggedIndex];
}

class GameBloc extends Bloc<GameEvent, GameState> {
  final int rows;
  final int columns;

  GameBloc({required this.rows, required this.columns})
      : super(InitialGameState()) {
    on<InitializeGame>(_mapInitializeGameToState);
    on<InitializeDrag>(_mapInitializeDragToState);
    on<FinishDrag>(_mapFinishDragToState);
    on<SwapTiles>(_mapSwapTilesToState);
  }

  Future<void> _mapInitializeGameToState(
      InitializeGame event, Emitter<GameState> emit) async {
    List<List<int>> initialBoard;

    do {
      initialBoard = List.generate(
          rows, (_) => List.generate(columns, (_) => Random().nextInt(7)));
    } while (_hasThreeOrMoreInARow(initialBoard) ||
        _hasThreeOrMoreInAColumn(initialBoard));

    // Проверить и уничтожить три и более элемента в ряду
    for (int r = 0; r < initialBoard.length; r++) {
      for (int c = 0; c < initialBoard[r].length - 2; c++) {
        if (initialBoard[r][c] == initialBoard[r][c + 1] &&
            initialBoard[r][c + 1] == initialBoard[r][c + 2]) {
          initialBoard[r][c] = -1; // Mark for crushing
          initialBoard[r][c + 1] = -1;
          initialBoard[r][c + 2] = -1;
        }
      }
    }

    // Проверить и уничтожить три и более элемента в столбце
    for (int c = 0; c < initialBoard[0].length; c++) {
      for (int r = 0; r < initialBoard.length - 2; r++) {
        if (initialBoard[r][c] == initialBoard[r + 1][c] &&
            initialBoard[r + 1][c] == initialBoard[r + 2][c]) {
          initialBoard[r][c] = -1; // Mark for crushing
          initialBoard[r + 1][c] = -1;
          initialBoard[r + 2][c] = -1;
        }
      }
    }

    // Уничтожить помеченные элементы
    _crushCandy(initialBoard);

    emit(GameInProgressState(board: initialBoard, draggedIndex: null));
  }

  bool _hasThreeOrMoreInARow(List<List<int>> board) {
    for (int r = 0; r < board.length; r++) {
      for (int c = 0; c < board[r].length - 2; c++) {
        if (board[r][c] == board[r][c + 1] &&
            board[r][c + 1] == board[r][c + 2]) {
          return true;
        }
      }
    }
    return false;
  }

  bool _hasThreeOrMoreInAColumn(List<List<int>> board) {
    for (int c = 0; c < board[0].length; c++) {
      for (int r = 0; r < board.length - 2; r++) {
        if (board[r][c] == board[r + 1][c] &&
            board[r + 1][c] == board[r + 2][c]) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _mapInitializeDragToState(
      InitializeDrag event, Emitter<GameState> emit) async {
    if (state is! GameInProgressState) {
      return;
    }
    emit((state as GameInProgressState)
        .copyWith(draggedIndex: event.draggedIndex));
  }

  Future<void> _mapFinishDragToState(
      FinishDrag event, Emitter<GameState> emit) async {
    if (state is! GameInProgressState) {
      return;
    }

    emit((state as GameInProgressState).copyWith(draggedIndex: null));
  }

  Future<void> _mapSwapTilesToState(
      SwapTiles event, Emitter<GameState> emit) async {
    List<List<int>> updatedBoard = List.from(state.board);

    int firstRow = event.firstIndex ~/ columns;
    int firstCol = event.firstIndex % columns;
    int secondRow = event.secondIndex ~/ columns;
    int secondCol = event.secondIndex % columns;

    if (_areImmediateNeighbors(firstRow, firstCol, secondRow, secondCol)) {
      int temp = updatedBoard[firstRow][firstCol];
      updatedBoard[firstRow][firstCol] = updatedBoard[secondRow][secondCol];
      updatedBoard[secondRow][secondCol] = temp;

      // Check and crush candies
      if (_hasThreeOrMoreInARow(updatedBoard) ||
          _hasThreeOrMoreInAColumn(updatedBoard)) {
        _crushCandy(updatedBoard);
        emit(GameInProgressState(board: updatedBoard, draggedIndex: null));
      } else {
        // Revert the swap if it doesn't create a match
        temp = updatedBoard[firstRow][firstCol];
        updatedBoard[firstRow][firstCol] = updatedBoard[secondRow][secondCol];
        updatedBoard[secondRow][secondCol] = temp;
      }
    }
  }

  void _crushCandy(List<List<int>> board) {
    bool hasCrush = true;

    while (hasCrush) {
      hasCrush = false;

      // Проверить строки
      for (int r = 0; r < board.length; r++) {
        for (int c = 0; c < board[r].length - 2; c++) {
          int consecutiveCount = 1;

          while (c + consecutiveCount < board[r].length &&
              (board[r][c] == board[r][c + consecutiveCount] ||
                  board[r][c + consecutiveCount] == -1)) {
            consecutiveCount++;
          }

          if (consecutiveCount >= 3) {
            // Пометить для разрушения
            for (int i = 0; i < consecutiveCount; i++) {
              board[r][c + i] = -1;
            }
            hasCrush = true;
          }
        }
      }

      // Проверить столбцы
      for (int c = 0; c < board[0].length; c++) {
        for (int r = 0; r < board.length - 2; r++) {
          int consecutiveCount = 1;

          while (r + consecutiveCount < board.length &&
              (board[r][c] == board[r + consecutiveCount][c] ||
                  board[r + consecutiveCount][c] == -1)) {
            consecutiveCount++;
          }

          if (consecutiveCount >= 3) {
            // Пометить для разрушения
            for (int i = 0; i < consecutiveCount; i++) {
              board[r + i][c] = -1;
            }
            hasCrush = true;
          }
        }
      }

      // Разрушить помеченные конфеты
      for (int c = 0; c < board[0].length; c++) {
        int emptyCount = 0;

        for (int r = board.length - 1; r >= 0; r--) {
          if (board[r][c] == -1) {
            emptyCount++;
          } else if (emptyCount > 0) {
            // Сдвинуть элементы выше
            board[r + emptyCount][c] = board[r][c];
            board[r][c] = -1;
          }
        }

        // Заменить новыми конфетами
        for (int i = 0; i < emptyCount; i++) {
          board[i][c] = Random().nextInt(5);
        }
      }
    }
  }

  bool _areImmediateNeighbors(int row1, int col1, int row2, int col2) {
    return (row1 == row2 && (col1 == col2 - 1 || col1 == col2 + 1)) ||
        (col1 == col2 && (row1 == row2 - 1 || row1 == row2 + 1));
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Match-3 Game'),
        ),
        body: BlocProvider(
          create: (context) =>
              GameBloc(rows: 7, columns: 6)..add(InitializeGame()),
          child: const GameScreen(),
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameInProgressState) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemCount: state.board.length * state.board[0].length,
            itemBuilder: (context, index) {
              int row = index ~/ state.board[0].length;
              int col = index % state.board[0].length;
              int color = state.board[row][col];

              return BlocBuilder<GameBloc, GameState>(
                builder: (context, state) => Draggable<int>(
                    key: ValueKey<int>(index), // Добавлен ключ
                    data: index,
                    childWhenDragging: CustomIcon(
                      iconName: getColorName(color),
                      wight: 64,
                      hight: 64,
                    ),
                    onDragStarted: () {
                      context
                          .read<GameBloc>()
                          .add(InitializeDrag(draggedIndex: index));
                    },
                    onDraggableCanceled: (velocity, offset) {
                      context.read<GameBloc>().add(FinishDrag());
                    },
                    onDragEnd: (details) {
                      context.read<GameBloc>().add(FinishDrag());
                    },
                    feedback: CustomIcon(
                      iconName: getColorName(color),
                      wight: 64,
                      hight: 64,
                    ),
                    child: DragTarget<int>(
                      key: ValueKey<int>(index), // Добавлен ключ
                      builder: (BuildContext context, List<int?> candidateData,
                          List<dynamic> rejectedData) {
                        final bool isNeighbour =
                            _isDraggedNeighbor(index, state);

                        return Container(
                          margin: EdgeInsets.all(isNeighbour ? 2.0 : 0.1),
                          padding: EdgeInsets.all(isNeighbour ? 2.0 : 0.1),
                          child: CustomIcon(
                            iconName: getColorName(color),
                            wight: isNeighbour ? 160 : 164,
                            hight: isNeighbour ? 160 : 164,
                          ),
                        );
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        context.read<GameBloc>().add(
                            SwapTiles(firstIndex: data, secondIndex: index));
                        context.read<GameBloc>().add(FinishDrag());
                      },
                    )),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bool _isDraggedNeighbor(int currentIndex, GameState state) {
    if (state.draggedIndex == null) {
      return false;
    }

    int draggedRow = state.draggedIndex! ~/ state.board[0].length;
    int draggedCol = state.draggedIndex! % state.board[0].length;

    int currentRow = currentIndex ~/ state.board[0].length;
    int currentCol = currentIndex % state.board[0].length;

    return (currentRow == draggedRow &&
            (currentCol == draggedCol - 1 || currentCol == draggedCol + 1) &&
            _hasMatchInRow(currentRow, state.board)) ||
        (currentCol == draggedCol &&
            (currentRow == draggedRow - 1 || currentRow == draggedRow + 1) &&
            _hasMatchInColumn(currentCol, state.board));
  }

  bool _hasMatchInRow(int row, List<List<int>> board) {
    for (int c = 0; c < board[row].length - 2; c++) {
      if (board[row][c] == board[row][c + 1] &&
          board[row][c + 1] == board[row][c + 2]) {
        return true;
      }
    }
    return false;
  }

  bool _hasMatchInColumn(int column, List<List<int>> board) {
    for (int r = 0; r < board.length - 2; r++) {
      if (board[r][column] == board[r + 1][column] &&
          board[r + 1][column] == board[r + 2][column]) {
        return true;
      }
    }
    return false;
  }

  String getColorName(int color) {
    switch (color) {
      case 0:
        return 'cherep';
      case 1:
        return 'compos';
      case 2:
        return 'bocka';
      case 3:
        return 'kruk';
      case 4:
        return 'rul';
      case 5:
        return 'trubka';
      case 6:
        return 'list';
      default:
        return 'default';
    }
  }
}
