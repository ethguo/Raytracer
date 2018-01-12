class Vector3 extends PVector {
  boolean isNormalized;
  
  Vector3() {
    super(0.0, 0.0, 0.0);
  }
  
  // Vector3(int x, int y, int z) {
  //   super(x, y, z);
  // }

  Vector3(float x, float y, float z) {
    super(x, y, z);
  }

  Vector3(color colour) {
    super(0.0, 0.0, 0.0);
    this.x = (colour >> 16 & 0xFF) / 255.0;
    this.y = (colour >> 8 & 0xFF) / 255.0;
    this.z = (colour & 0xFF) / 255.0;
  }

  String toString() {
    String s = "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ", " + nfs(this.z, 1, 6) + ")";
    if (this.isNormalized)
      s += "^";
    return s;
  }

  color toColor() {
    return color(this.x*255, this.y*255, this.z*255);
  }

  Vector3 normalize() {
    this.isNormalized = true;
    return (Vector3) super.normalize();
  }

  Vector3 normalized() {
    this.normalize();
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