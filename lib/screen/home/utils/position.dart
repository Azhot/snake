class Position {
  // variables
  int yAxis;
  int xAxis;

  // constructors
  Position(this.yAxis, this.xAxis);

  // functions
  void activateOn(List<List<bool?>> list) => list[yAxis][xAxis] = true;
  void activateOff(List<List<bool?>> list) => list[yAxis][xAxis] = false;

  // overrides
  @override
  String toString() => 'Pair[$yAxis, $xAxis]';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.yAxis == yAxis && other.xAxis == xAxis;
  }

  @override
  int get hashCode => yAxis.hashCode ^ xAxis.hashCode;

  // functions
  Position copyWith({
    int? yAxis,
    int? xAxis,
  }) {
    return Position(
      yAxis ?? this.yAxis,
      xAxis ?? this.xAxis,
    );
  }
}
