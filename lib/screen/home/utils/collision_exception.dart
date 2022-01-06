class CollisionException implements Exception {
  final dynamic message;

  CollisionException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "CollisionException";
    return "CollisionException: $message";
  }
}
