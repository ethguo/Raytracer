/**
 * Represents a 3D Vector. Can be used to represent a point in 3D space, a direction (as a unit vector), or an RGB color.
 */
class Vector3 extends JSONSerializable {
  public float x, y, z;

  private boolean isNormalized;
  
  /** Constructs a 3D zero vector. */
  Vector3() {
    this(0.0, 0.0, 0.0);
  }

  /** Constructs a 3D vector from x, y, and z components. */
  Vector3(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /** Converts a Processing <code>color</code> primitive to a Vector3. */
  Vector3(color colour) {
    // From https://processing.org/reference/rightshift.html,
    // Processing color primitives can be treated as ints with 8-bit color components.
    this.x = (colour >> 16 & 0xFF) / 255.0;
    this.y = (colour >> 8 & 0xFF) / 255.0;
    this.z = (colour & 0xFF) / 255.0;
  }

  /**
   * Constructs a Vector3 object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public Vector3(JSONObject j) {
    super(j);
    this.x = j.getFloat("x");
    this.y = j.getFloat("y");
    this.z = j.getFloat("z");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("x", this.x);
    j.setFloat("y", this.y);
    j.setFloat("z", this.z);
    return j;
  }

  /** Generates a human-friendly String representation of this vector for debugging purposes. */
  String toString() {
    String s = "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ", " + nfs(this.z, 1, 6) + ")";
    if (this.isNormalized)
      s += "^";
    return s;
  }

  /** Converts this Vector to a Processing <code>color</code> primitive. */
  color toColorPrimitive() {
    return color(this.x*255, this.y*255, this.z*255);
  }

  /** Returns the magnitude of this vector. */
  float getMagnitude() {
    return sqrt(x*x + y*y + z*z);
  }

  /** Returns the square of the magnitude of this vector. This is more efficient than getMagnitude() if only the squared magnitude is needed. */
  float getMagnitudeSquared() {
    return x*x + y*y + z*z;
  }

  /**
   * Normalizes this vector. Returns itself so that it can be chained with other operators.
   * @return <var>this</var>.
   */
  Vector3 normalize() {
    if (!this.isNormalized) {
      float magnitude = this.getMagnitude();

      // If it's a zero vector, prevent dividing by zero.
      if (magnitude != 0) {
        this.x /= magnitude;
        this.y /= magnitude;
        this.z /= magnitude;
        this.isNormalized = true;
      }
    }
    return this;
  }

  /** Returns a new vector representing the sum of this vector and the other vector. */
  Vector3 plus(Vector3 other) {
    return new Vector3(this.x + other.x, this.y + other.y, this.z + other.z);
  }

  /** Returns a new vector representing the other vector subtracted from this vector. */
  Vector3 minus(Vector3 other) {
    return new Vector3(this.x - other.x, this.y - other.y, this.z - other.z);
  }

  /** Returns a new vector representing this vector multiplied by a scalar. */
  Vector3 times(float scalar) {
    return new Vector3(scalar*this.x, scalar*this.y, scalar*this.z);
  }

  /**
   * Returns a new vector with the componentwise product of this vector with the other vector, also known as the Hadamard product.
   * We use it when multiplying a light's color by an object's albedo to compute how much of each color (in RGB) is reflected.
   */
  Vector3 hadamardTimes(Vector3 other) {
    return new Vector3(this.x*other.x, this.y*other.y, this.z*other.z);
  }

  /** Returns the dot product of this vector with the other vector. */
  float dot(Vector3 other) {
    return this.x*other.x + this.y*other.y + this.z*other.z;
  }

  /** Returns the dot product of this vector with itself. Slightly faster when dealing with normalized (unit) vectors. */
  float dotSelf() {
    if (this.isNormalized)
      return 1;
    else
      return this.dot(this);
  }
}