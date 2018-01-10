class Vector2 extends PVector {

  Vector2(int x, int y) {
    super(x, y);
  }

  Vector2(float x, float y) {
    super(x, y);
  }

  String toString() {
    return "(" + nf(this.x) + ", " + nf(this.y) + ")";
  }

  Vector2 plus(Vector2 other) {
    return new Vector2(this.x + other.x, this.y + other.y);
  }

  Vector2 minus(Vector2 other) {
    return new Vector2(this.x - other.x, this.y - other.y);
  }
}