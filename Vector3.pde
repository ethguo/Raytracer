class Vector3 extends PVector {
  boolean isNormalized;
  
  Vector3(int x, int y, int z) {
    super(x, y, z);
  }

  Vector3(float x, float y, float z) {
    super(x, y, z);
  }

  String toString() {
    String s = "(" + nfs(this.x, 1, 6) + ", " + nfs(this.y, 1, 6) + ", " + nfs(this.z, 1, 6) + ")";
    if (this.isNormalized)
      s += "^";
    return s;
  }

  PVector normalize() {
    this.isNormalized = true;
    return super.normalize();
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

  float dotProduct(Vector3 other) {
    return this.x*other.x + this.y*other.y + this.z*other.z;
  }

  float dotSelf() {
    if (this.isNormalized)
      return 1;
    else
      return this.dotProduct(this);
  }
}