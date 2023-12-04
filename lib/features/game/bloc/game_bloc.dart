import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

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

    emit(
      GameInProgressState(
          board: initialBoard, draggedIndex: null, score: 0, level: 0),
    );
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
    int updatedScore = state.score;

    int firstRow = event.firstIndex ~/ columns;
    int firstCol = event.firstIndex % columns;
    int secondRow = event.secondIndex ~/ columns;
    int secondCol = event.secondIndex % columns;

    if (_areImmediateNeighbors(firstRow, firstCol, secondRow, secondCol)) {
      int temp = updatedBoard[firstRow][firstCol];
      updatedBoard[firstRow][firstCol] = updatedBoard[secondRow][secondCol];
      updatedBoard[secondRow][secondCol] = temp;

      // Check and crush candies
      bool hasMatch = _hasThreeOrMoreInARow(updatedBoard) ||
          _hasThreeOrMoreInAColumn(updatedBoard);

      // Revert the swap if it doesn't create a match
      if (!hasMatch) {
        temp = updatedBoard[firstRow][firstCol];
        updatedBoard[firstRow][firstCol] = updatedBoard[secondRow][secondCol];
        updatedBoard[secondRow][secondCol] = temp;
      }

      // Continue checking and crushing candies until no more matches
      while (hasMatch) {
        // Here, you can also check for and crush candies if necessary
        if (hasMatch) {
          int matchCount = _getMatchCount(updatedBoard);
          updatedScore += (matchCount > 3) ? 70 : 50;
          _crushCandy(updatedBoard);
        }

        emit(GameInProgressState(
          board: updatedBoard,
          draggedIndex: null,
          score: updatedScore,
          level:
              (state as GameInProgressState).level, // Keep the level unchanged
        ));

        // Check for new matches after crushing candies
        hasMatch = _hasThreeOrMoreInARow(updatedBoard) ||
            _hasThreeOrMoreInAColumn(updatedBoard);
      }
      if (state is GameInProgressState) {
        int currentLevel = (state as GameInProgressState).level;

        if (updatedScore >= 1000 && currentLevel < 5) {
          currentLevel = 5; // Уровень 6 (индекс 5 в списке)
        } else if (updatedScore >= 800 && currentLevel < 4) {
          currentLevel = 4; // Уровень 5 (индекс 4 в списке)
        } else if (updatedScore >= 600 && currentLevel < 3) {
          currentLevel = 3; // Уровень 4 (индекс 3 в списке)
        } else if (updatedScore >= 400 && currentLevel < 2) {
          currentLevel = 2; // Уровень 3 (индекс 2 в списке)
        } else if (updatedScore >= 200 && currentLevel < 1) {
          currentLevel = 1; // Уровень 2 (индекс 1 в списке)
        }

        emit(GameInProgressState(
          board: updatedBoard,
          draggedIndex: null,
          score: updatedScore,
          level: currentLevel,
        ));
      } else {
        // No match after reverting the swap
        // Reset matchCount to 0
        emit(GameInProgressState(
          board: updatedBoard,
          draggedIndex: null,
          score: updatedScore,
        ));
      }
    }
  }
}

void printBoard(List<List<int>> board) {
  for (var row in board) {
    print(row);
  }
}

int _getMatchCount(List<List<int>> board) {
  int matchCount = 0;
  Set<List<int>> matchedCandies = <List<int>>{};

  // Проверка строк на совпадения
  for (int r = 0; r < board.length; r++) {
    for (int c = 0; c < board[r].length - 2; c++) {
      if (board[r][c] != -1 &&
          board[r][c] == board[r][c + 1] &&
          board[r][c + 1] == board[r][c + 2]) {
        List<int> matchedSet = [board[r][c], board[r][c + 1], board[r][c + 2]];
        if (!matchedCandies.contains(matchedSet)) {
          matchedCandies.add(matchedSet);
          int consecutiveCount = 3;
          while (c + consecutiveCount < board[r].length &&
              board[r][c] == board[r][c + consecutiveCount]) {
            consecutiveCount++;
          }
          matchCount += (consecutiveCount >= 4) ? consecutiveCount : 0;
          // Пометить для разрушения
          for (int i = 0; i < consecutiveCount; i++) {
            board[r][c + i] = -1;
          }
        }
      }
    }
  }

  // Проверка столбцов на совпадения
  for (int c = 0; c < board[0].length; c++) {
    for (int r = 0; r < board.length - 2; r++) {
      if (board[r][c] != -1 &&
          board[r][c] == board[r + 1][c] &&
          board[r + 1][c] == board[r + 2][c]) {
        List<int> matchedSet = [board[r][c], board[r + 1][c], board[r + 2][c]];
        if (!matchedCandies.contains(matchedSet)) {
          matchedCandies.add(matchedSet);
          int consecutiveCount = 3;
          while (r + consecutiveCount < board.length &&
              board[r][c] == board[r + consecutiveCount][c]) {
            consecutiveCount++;
          }
          matchCount += (consecutiveCount >= 4) ? consecutiveCount : 0;
          // Пометить для разрушения
          for (int i = 0; i < consecutiveCount; i++) {
            board[r + i][c] = -1;
          }
        }
      }
    }
  }

  return matchCount;
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
