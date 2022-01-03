import 'package:flutter/material.dart';
import 'package:snake/screen/home/widgets/snake_brick.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeGrid extends StatelessWidget {
  // variables
  final List<List<bool?>> _grid;

  // constructors
  const SnakeGrid(this._grid, {Key? key}) : super(key: key);

  // overrides
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: SnakeColors.primary,
            border: Border.all(
              color: SnakeColors.primary,
              width: 1,
            )),
        child: Column(
          children: makeSnakeRows(_grid),
        ),
      );

  static List<Row> makeSnakeRows(List<List<bool?>> grid) => List.generate(
      grid.length,
      (index) => Row(children: SnakeBrick.makeSnakeBricks(grid[index])));
}
