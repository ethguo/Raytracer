class Vector2 extends JSONSerializable {
  public float x, y;

  Vector2() {
    this(0.0, 0.0);
  }
  
  Vector2(float x, float y) {
    this.x = x;
    this.y = y;
  }

  Vector2(JSONObject j) {
    this.x = j.getFloat("x");
    this.y = j.getFloat("y");
  }

  String toString() {
    return "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ")";
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("x", this.x);
    j.setFloat("y", this.y);
    return j;
  }

  // Vector2 plus(Vector2 other) {
  //   return new Vector2(this.x + other.x, this.y + other.y);
  // }

  // Vector2 minus(Vector2 other) {
  //   return new Vector2(this.x - other.x, this.y - other.y);
  // }
}