import 'package:flutter/material.dart';
import 'package:snake/screen/home/utils/brick_type.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_brick.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeGrid extends StatelessWidget {
  // variables
  final int sideSize;
  final Snake snake;
  final int target;

  // constructors
  const SnakeGrid(
    this.sideSize,
    this.snake,
    this.target, {
    Key? key,
  }) : super(key: key);

  // overrides
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: SnakeColors.primary,
          border: Border.all(
            color: SnakeColors.primary,
            width: 1,
          )),
      child: Column(children: rows()));

  // functions
  List<Row> rows() =>
      List.generate(sideSize, (posY) => Row(children: bricks(posY)));

  List<SnakeBrick> bricks(int posY) =>
      List.generate(sideSize, (posX) => brick(posX + (posY * sideSize)));

  SnakeBrick brick(int posX) {
    if (!snake.contains(posX)) {
      return posX == target
          ? const SnakeBrick(SnakeBrickType.target)
          : const SnakeBrick(SnakeBrickType.empty);
    } else if (snake.isDead) {
      return const SnakeBrick(SnakeBrickType.dead);
    } else {
      return snake.isHead(posX)
          ? const SnakeBrick(SnakeBrickType.head)
          : snake.digests(posX)
              ? const SnakeBrick(SnakeBrickType.eaten)
              : snake.isBody(posX)
                  ? const SnakeBrick(SnakeBrickType.body)
                  : const SnakeBrick(SnakeBrickType.tail);
    }
  }
}
