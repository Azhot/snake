import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/screen/home/utils/brick_type.dart';
import 'package:snake/screen/home/utils/collision_exception.dart';
import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_brick.dart';
import 'package:snake/screen/home/widgets/snake_grid_controller.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeGrid extends StatefulWidget {
  // variables
  final int _sidesLength;
  final SnakeGridController _gridController;

  // constructors
  const SnakeGrid(
    this._sidesLength,
    this._gridController, {
    Key? key,
  }) : super(key: key);

  // overrides
  @override
  State<SnakeGrid> createState() => _SnakeGridState();
}

// state class
class _SnakeGridState extends State<SnakeGrid> {
  // variables
  late final List<SnakeBrickType> _grid;
  late final Snake _snake;
  late final Random _random;
  late int _target;

  // overrides
  @override
  void initState() {
    super.initState();
    _grid = List.filled(
        widget._sidesLength * widget._sidesLength, SnakeBrickType.empty);
    _snake = Snake(widget._sidesLength);
    _random = Random();
    _target = createNewTarget();
    widget._gridController.moveSnake = moveSnake;
    widget._gridController.reset = reset;
    displaySnake();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: SnakeColors.primary,
            border: Border.all(
              color: SnakeColors.primary,
              width: 1,
            )),
        child: Column(children: makeRows()),
      );

  // functions
  List<Row> makeRows() => [
        for (int i = 0; i < widget._sidesLength; i++)
          Row(
            children: SnakeBrick.makeSnakeBricks(_grid.getRange(
                i * widget._sidesLength, ((i + 1) * widget._sidesLength))),
          )
      ];

  void moveSnake(final Direction direction) => setState(() {
        _grid[_snake.tail] = SnakeBrickType.empty;
        try {
          _snake.moveSnake(direction);
        } on CollisionException {
          snakeDies();
          throw CollisionException();
        }
        displaySnake();
        if (_snake.isOn(_target)) {
          _snake.eats(_target);
          _target = createNewTarget();
        }
        displayTarget();
      });

  int createNewTarget() {
    int target = _random.nextInt(_grid.length);
    return !_snake.contains(target) ? target : createNewTarget();
  }

  void displayTarget() => _grid[_target] = SnakeBrickType.target;

  void displaySnake() {
    for (int i = 1; i < _snake.size - 1; i++) {
      _grid[_snake.positionAt(i)] = _snake.digests(_snake.positionAt(i))
          ? SnakeBrickType.eaten
          : SnakeBrickType.body;
    }
    _grid[_snake.head] = SnakeBrickType.head;
    if (_snake.size > 1) {
      _grid[_snake.tail] = SnakeBrickType.tail;
    }
  }

  void reset() => setState(() {
        for (int i = 0; i < _grid.length; i++) {
          _grid[i] = SnakeBrickType.empty;
        }
        _snake.reset();
        displaySnake();
      });

  void snakeDies() => setState(() {
        HapticFeedback.heavyImpact();
        for (int i = 0; i < _snake.size; i++) {
          _grid[_snake.positionAt(i)] = SnakeBrickType.dead;
        }
        _grid[_target] = SnakeBrickType.empty;
      });
}
