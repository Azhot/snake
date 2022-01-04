import 'package:flutter/material.dart';
import 'package:snake/screen/home/utils/brick_type.dart';
import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_brick.dart';
import 'package:snake/screen/home/widgets/snake_grid_controller.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeGrid extends StatefulWidget {
  // variables
  final int _sides;
  final Snake _snake;
  final SnakeGridController _gridController;

  // constructors
  const SnakeGrid(this._sides, this._snake, this._gridController, {Key? key})
      : super(key: key);

  // overrides
  @override
  State<SnakeGrid> createState() => _SnakeGridState();
}

// state class
class _SnakeGridState extends State<SnakeGrid> {
  // variables
  late final List<SnakeBrickType> _grid;

  // static functions
  static List<SnakeBrickType> makeEmptyGrid(int sides) =>
      List.generate(sides * sides, (index) => SnakeBrickType.empty);

  // overrides
  @override
  void initState() {
    super.initState();
    _grid = makeEmptyGrid(widget._sides);
    widget._gridController.showSnake = showSnake;
    widget._gridController.moveSnake = moveSnake;
    widget._gridController.showTarget = showTarget;
    widget._gridController.reset = reset;
    showSnake();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: SnakeColors.primary,
            border: Border.all(
              color: SnakeColors.primary,
              width: 1,
            )),
        child: Column(children: makeSnakeRows()),
      );

  // functions
  List<Row> makeSnakeRows() => [
        for (int i = 0; i < widget._sides; i++)
          Row(
            children: SnakeBrick.makeSnakeBricks(
                _grid.getRange(i * widget._sides, ((i + 1) * widget._sides))),
          )
      ];

  void showSnake() => setState(() {
        _grid[widget._snake.head] = SnakeBrickType.head;
        if (widget._snake.length <= 1) return;
        _grid[widget._snake.tail] = SnakeBrickType.tail;
        if (widget._snake.length <= 2) return;
        for (int i = 1; i < widget._snake.length - 2; i++) {
          _grid[widget._snake.indexes[i]] = SnakeBrickType.body;
        }
      });

  void moveSnake(Direction direction) => setState(() {
        _grid[widget._snake.tail] = SnakeBrickType.empty;
        try {
          widget._snake.updatePosition(direction);
        } catch (e) {
          throw Exception('End of game');
        }
        showSnake();
      });

  void showTarget(int index) => setState(() {
        _grid[index] = SnakeBrickType.target;
      });

  void reset() => setState(() {
        for (int i = 0; i < _grid.length - 1; i++) {
          _grid[i] = SnakeBrickType.empty;
        }
      });
}
