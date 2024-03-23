import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SudokuApp());
}

class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Game',
      home: SudokuGame(),
    );
  }
}

class SudokuGame extends StatefulWidget {
  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> board;
  late List<List<int>> solvedBoard;

  @override
  void initState() {
    super.initState();
    generateRandomBoard();
  }

  void generateRandomBoard() {
    final random = Random();
    board = List.generate(9, (i) => List.generate(9, (j) => 0));

    for (int i = 0; i < 17; i++) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      int num = random.nextInt(9) + 1;

      if (_isSafe(row, col, num)) {
        board[row][col] = num;
      }
    }

    // Copy the initial board for solving
    solvedBoard = List.generate(9, (i) => List.generate(9, (j) => board[i][j]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildRows(board),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generateRandomBoard();
                });
              },
              child: Text('Refresh'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  solveSudoku();
                });
              },
              child: Text('Solve'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRows(List<List<int>> board) {
    List<Widget> rows = [];
    for (int i = 0; i < 9; i++) {
      rows.add(_buildRow(board[i]));
    }
    return rows;
  }

  Widget _buildRow(List<int> row) {
    List<Widget> rowChildren = [];
    for (int j = 0; j < 9; j++) {
      rowChildren.add(_buildCell(row[j]));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowChildren,
    );
  }

  Widget _buildCell(int value) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
        ),
      ),
    );
  }

  bool _isSafe(int row, int col, int num) {
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num || board[x][col] == num) {
        return false;
      }
    }
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num) {
          return false;
        }
      }
    }
    return true;
  }

  bool solveSudoku() {
    return _solveSudokuUtil(solvedBoard);
  }

  bool _solveSudokuUtil(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isSafe(row, col, num)) {
              board[row][col] = num;
              if (_solveSudokuUtil(board)) {
                return true;
              } else {
                board[row][col] = 0;
              }
            }
          }
          return false;
        }
      }
    }
    return true;
  }
}
