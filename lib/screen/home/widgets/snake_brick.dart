import 'package:flutter/material.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeBrick extends StatelessWidget {
  // variables
  final Color color;

  // constructors
  const SnakeBrick._on({Key? key})
      : color = Colors.green,
        super(key: key);
  const SnakeBrick._off({Key? key})
      : color = SnakeColors.primaryDark,
        super(key: key);
  const SnakeBrick._end({Key? key})
      : color = Colors.red,
        super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: color,
            margin: const EdgeInsets.all(1),
          ),
        ),
      );

  static List<SnakeBrick> makeSnakeBricks(List<bool?> row) => List.generate(
      row.length,
      (index) => row[index] == null
          ? const SnakeBrick._off()
          : row[index] == true
              ? const SnakeBrick._on()
              : const SnakeBrick._end());
}
