class Vector3 extends PVector {
  
  Vector3(int x, int y, int z) {
    super(x, y, z);
  }

  Vector3(float x, float y, float z) {
    super(x, y, z);
  }

  String toString() {
    return "(" + nf(this.x) + ", " + nf(this.y) + ", " + nf(this.z) + ")";
  }

  // void normalize() {
  //   super.normalize();
  // }

  // Vector3 plus(Vector3 other) {
  //   return new Vector3(this.x + other.x, this.y + other.y, this.z + other.z);
  // }

  // Vector3 minus(Vector3 other) {
  //   return new Vector3(this.x - other.x, this.y - other.y, this.z - other.z);
  // }
}
