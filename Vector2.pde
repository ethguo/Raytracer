class Vector2 extends PVector {

  Vector2() {
    super(0.0, 0.0);
  }
  
  Vector2(float x, float y) {
    super(x, y);
  }

  String toString() {
    return "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ")";
  }

  // Vector2 plus(Vector2 other) {
  //   return new Vector2(this.x + other.x, this.y + other.y);
  // }

  // Vector2 minus(Vector2 other) {
  //   return new Vector2(this.x - other.x, this.y - other.y);
  // }
}