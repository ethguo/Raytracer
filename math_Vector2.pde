/**
 * Represents a 2D Vector. Currently only used to contain the 2 solutions of a quadratic equation, but could be used to implement object textures and UV coordinates.
 */
class Vector2 extends JSONSerializable {
  public float x, y;

  /** Construct a 2D zero vector. */
  Vector2() {
    this(0.0, 0.0);
  }

  /** Constructs a 2D vector from x and y components. */
  Vector2(float x, float y) {
    this.x = x;
    this.y = y;
  }

  /**
   * Constructs a Vector2 object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public Vector2(JSONObject j) {
    super(j);
    this.x = j.getFloat("x");
    this.y = j.getFloat("y");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("x", this.x);
    j.setFloat("y", this.y);
    return j;
  }

  /** Generates a human-friendly String representation of this vector for debugging purposes. */
  String toString() {
    return "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ")";
  }

  /** Returns a new vector representing the sum of this vector and the other vector. */
  // Vector2 plus(Vector2 other) {
  //   return new Vector2(this.x + other.x, this.y + other.y);
  // }

  /** Returns a new vector representing the other vector subtracted from this vector. */
  // Vector2 minus(Vector2 other) {
  //   return new Vector2(this.x - other.x, this.y - other.y);
  // }
}