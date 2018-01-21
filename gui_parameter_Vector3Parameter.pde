public class Vector3Parameter extends Parameter {
  Vector3 value;
  String labelText;
  float minValue;
  float maxValue;
  boolean hasSliders = false;
  boolean isColor = false;

  private FloatParameter xParameter;
  private FloatParameter yParameter;
  private FloatParameter zParameter;
  private GLabel label;

  Vector3Parameter(Object obj, String updateMethodName, String labelText, Vector3 initialValue) {
    super(labelText, obj, updateMethodName, Vector3.class);
    this.value = initialValue;
    this.labelText = labelText;
    this.hasSliders = false;
    this.isColor = false;

    this.xParameter = new FloatParameter(this, "setX", "X", this.value.x);
    this.yParameter = new FloatParameter(this, "setY", "Y", this.value.y);
    this.zParameter = new FloatParameter(this, "setZ", "Z", this.value.z);
  }

  Vector3Parameter(Object obj, String updateMethodName, String labelText, Vector3 initialValue, float minValue, float maxValue) {
    this(obj, updateMethodName, labelText, initialValue);
    this.hasSliders = true;
    this.minValue = minValue;
    this.maxValue = maxValue;

    this.xParameter = new FloatParameter(this, "setX", "X", this.value.x, minValue, maxValue);
    this.yParameter = new FloatParameter(this, "setY", "Y", this.value.y, minValue, maxValue);
    this.zParameter = new FloatParameter(this, "setZ", "Z", this.value.z, minValue, maxValue);
  }

  Vector3Parameter(Object obj, String updateMethodName, String labelText, Vector3 initialValue, boolean isColor) {
    this(obj, updateMethodName, labelText, initialValue);
    this.isColor = isColor;

    this.xParameter = new FloatParameter(this, "setX", "R", this.value.x*255, 0, 255);
    this.yParameter = new FloatParameter(this, "setY", "G", this.value.y*255, 0, 255);
    this.zParameter = new FloatParameter(this, "setZ", "B", this.value.z*255, 0, 255);
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.createLabel(window, x, y);

    int yPadding = 0;
    yPadding += this.xParameter.createGUIControls(window, x+100, y, 20, 140);
    yPadding += this.yParameter.createGUIControls(window, x+100, y+yPadding, 20, 140);
    yPadding += this.zParameter.createGUIControls(window, x+100, y+yPadding, 20, 140);

    return yPadding;
  }

  public void setX(float x) {
    if (this.isColor)
      x /= 255.0;
    this.value.x = x;
    this.callUpdateMethod(this.value);
  }

  public void setY(float y) {
    if (this.isColor)
      y /= 255.0;
    this.value.y = y;
    this.callUpdateMethod(this.value);
  }

  public void setZ(float z) {
    if (this.isColor)
      z /= 255.0;
    this.value.z = z;
    this.callUpdateMethod(this.value);
  }
}