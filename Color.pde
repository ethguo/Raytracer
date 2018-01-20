/**
 * This class is mainly intended to represent a color parameter for the purposes of JSON serialization. Internally, colors are usually represented as Vector3 objects.
 */
class Color extends JSONSerializable {
  int red, green, blue;

  Color(Vector3 v) {
    this.red = (int) (v.x * 255);
    this.green = (int) (v.y * 255);
    this.blue = (int) (v.z * 255);
  }

  Color(color colour) {
    this.red = colour >> 16 & 0xFF;
    this.green = colour >> 8 & 0xFF;
    this.blue = colour & 0xFF;
  }

  public Color(JSONObject j) {
    super(j);
    this.red = j.getInt("red");
    this.green = j.getInt("green");
    this.blue = j.getInt("blue");
  }

  String toString() {
    String s = "(" + this.red + ", " + this.green + ", " + this.blue + ")";
    return s;
  }

  Vector3 toVector3() {
    float x = this.red / 255.0;
    float y = this.green / 255.0;
    float z = this.blue / 255.0;
    return new Vector3(x, y, z);
  }

  color toColorPrimitive() {
    return color(this.red, this.green, this.blue);
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setInt("red", this.red);
    j.setInt("green", this.green);
    j.setInt("blue", this.blue);
    return j;
  }
}