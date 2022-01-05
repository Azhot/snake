import 'package:snake/screen/home/utils/direction.dart';

class Snake {
  // variables
  final List<int> indexes;
  final List<int> _temp = [];
  final int _gridSides;

  // constructors
  Snake(this._gridSides) : indexes = [centerSnake(_gridSides)];

  // getters
  int get head => indexes.first;
  int get tail => indexes.last;
  int get length => indexes.length;

  // static functions
  static int centerSnake(int gridSides) =>
      ((gridSides + 1 - gridSides % 2) * gridSides / 2 - 1).ceil();

  // functions
  void eat(int target) => _temp.add(target);

  bool isOn(int target) => head == target;

  bool contains(int target) => indexes.contains(target);

  bool eatsHimself() => indexes.getRange(1, indexes.length).contains(head);

  void updatePosition(Direction direction) {
    updateSize();
    for (int i = length - 1; i > 0; i--) {
      indexes[i] = indexes[i - 1];
    }
    switch (direction) {
      case Direction.right:
        {
          if ((head + 1) % _gridSides == 0) throw Exception('Collision!');
          indexes[0]++;
        }
        break;
      case Direction.left:
        {
          if ((head) % _gridSides == 0) throw Exception('Collision!');
          indexes[0]--;
        }
        break;
      case Direction.up:
        indexes[0] = indexes.first - _gridSides;
        break;
      case Direction.down:
        indexes[0] = indexes.first + _gridSides;
        break;
      default:
        break;
    }
  }

  void updateSize() {
    if (_temp.isNotEmpty && _temp.first == tail) {
      indexes.add(_temp.removeAt(0));
    }
  }

  void reset() {
    indexes.clear();
    _temp.clear();
    indexes.add(centerSnake(_gridSides));
  }
}
