import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/utils/position.dart';

class Snake {
  // variables
  final List<Position> body;
  final List<Position> _temp;

  // constructors
  Snake(this.body) : _temp = [];

  // getters
  Position get head => body.first;
  Position get tail => body.last;
  int get length => body.length;

  // functions
  void eat(Position target) => _temp.add(target);

  bool isOn(Position target) => head == target;

  bool contains(Position target) => body.contains(target);

  bool eatsHimself() => body.getRange(1, body.length).contains(head);

  void updateSize() {
    if (_temp.isNotEmpty && _temp.first == tail) {
      body.add(_temp.removeAt(0));
    }
  }

  void updatePosition(Direction direction) {
    for (int i = length - 1; i > 0; i--) {
      body[i] = body[i - 1].copyWith();
    }
    switch (direction) {
      case Direction.right:
        head.xAxis++;
        break;
      case Direction.left:
        head.xAxis--;
        break;
      case Direction.up:
        head.yAxis--;
        break;
      case Direction.down:
        head.yAxis++;
        break;
      default:
        break;
    }
  }

  bool isOff(List<List> list) => (head.yAxis < 0 ||
      head.yAxis > list.length - 1 ||
      head.xAxis < 0 ||
      head.xAxis > list[0].length - 1);
}
