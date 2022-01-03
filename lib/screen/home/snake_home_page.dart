import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/screen/home/snake_controller.dart';
import 'package:snake/screen/home/utils/position.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_grid.dart';
import 'package:snake/shared/snake_colors.dart';

import 'utils/direction.dart';

class SnakeHomePage extends StatefulWidget {
  // constructors
  const SnakeHomePage({Key? key}) : super(key: key);

  // overrides
  @override
  State<SnakeHomePage> createState() => _SnakeHomePageState();
}

// state class
class _SnakeHomePageState extends State<SnakeHomePage> {
  // variables
  late List<List<bool?>> _grid;
  late Snake _snake;
  late Direction _direction;
  Timer? _timer;
  late Random _random;
  late Position _target;

  // overrides
  @override
  void initState() {
    super.initState();
    _grid = List.generate(15, (index) => List.generate(15, (index) => null));
    _grid[7][7] = true;
    _direction = Direction.right;
    _snake = Snake([Position(7, 7)]);
    _random = Random();
    _target = createNewTarget();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: SnakeColors.primaryDark,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text('snake',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.green,
                    fontSize: 46,
                  )),
              SnakeGrid(_grid),
              SnakeController(
                start: start,
                goRight: goRight,
                goLeft: goLeft,
                goUp: goUp,
                goDown: goDown,
              ),
            ],
          ),
        ),
      );

  // functions
  Position createNewTarget() {
    Position position = Position(
      _random.nextInt(_grid.length),
      _random.nextInt(_grid.length),
    );
    return !_snake.contains(position) ? position : createNewTarget();
  }

  void goRight() {
    if (_direction != Direction.right && _direction != Direction.left) {
      _direction = Direction.right;
    }
  }

  void goLeft() {
    if (_direction != Direction.right && _direction != Direction.left) {
      _direction = Direction.left;
    }
  }

  void goUp() {
    if (_direction != Direction.up && _direction != Direction.down) {
      _direction = Direction.up;
    }
  }

  void goDown() {
    if (_direction != Direction.up && _direction != Direction.down) {
      _direction = Direction.down;
    }
  }

  void start() {
    if (_timer?.isActive == true) return;
    _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {
        _snake.updateSize();
        _snake.updatePosition(_direction);
        if (_snake.isOff(_grid)) return reset();
        iterateOverGrid();
      });
    });
  }

  void iterateOverGrid() {
    for (int yAxis = 0; yAxis < _grid.length; yAxis++) {
      for (int xAxis = 0; xAxis < _grid[yAxis].length; xAxis++) {
        _grid[yAxis][xAxis] =
            _snake.contains(Position(yAxis, xAxis)) ? true : null;
        _target.activateOn(_grid);
        if (_snake.isOn(_target)) {
          _snake.eat(_target);
          _target = createNewTarget();
        }
        if (_snake.eatsHimself()) return reset();
      }
    }
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      for (int yAxis = 0; yAxis < _grid.length; yAxis++) {
        for (int xAxis = 0; xAxis < _grid[yAxis].length; xAxis++) {
          _grid[yAxis][xAxis] =
              _snake.contains(Position(yAxis, xAxis)) ? false : null;
        }
      }
    });
    _snake = Snake([Position(7, 7)]);
    _direction = Direction.right;
    _target = createNewTarget();
  }
}
