class Vector3 extends JSONSerializable {
  public float x, y, z;
  boolean isNormalized;
  
  Vector3() {
    this(0.0, 0.0, 0.0);
  }
  
  Vector3(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vector3(color colour) {
    this.x = (colour >> 16 & 0xFF) / 255.0;
    this.y = (colour >> 8 & 0xFF) / 255.0;
    this.z = (colour & 0xFF) / 255.0;
  }

  public Vector3(JSONObject j) {
    super(j);
    this.x = j.getFloat("x");
    this.y = j.getFloat("y");
    this.z = j.getFloat("z");
  }

  String toString() {
    String s = "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ", " + nfs(this.z, 1, 6) + ")";
    if (this.isNormalized)
      s += "^";
    return s;
  }

  color toColorPrimitive() {
    return color(this.x*255, this.y*255, this.z*255);
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("x", this.x);
    j.setFloat("y", this.y);
    j.setFloat("z", this.z);
    return j;
  }

  float getMagnitude() {
    return sqrt(x*x + y*y + z*z);
  }

  float getMagnitudeSquared() {
    return x*x + y*y + z*z;
  }

  Vector3 normalize() {
    float magnitude = this.getMagnitude();
    if (magnitude == 0)
      magnitude = 1;
    this.x /= magnitude;
    this.y /= magnitude;
    this.z /= magnitude;
    this.isNormalized = true;
    return this;
  }

  Vector3 plus(Vector3 other) {
    return new Vector3(this.x + other.x, this.y + other.y, this.z + other.z);
  }

  Vector3 minus(Vector3 other) {
    return new Vector3(this.x - other.x, this.y - other.y, this.z - other.z);
  }

  Vector3 times(float scalar) {
    return new Vector3(scalar*this.x, scalar*this.y, scalar*this.z);
  }

  float dot(Vector3 other) {
    return this.x*other.x + this.y*other.y + this.z*other.z;
  }

  float dotSelf() {
    if (this.isNormalized)
      return 1;
    else
      return this.dot(this);
  }
}