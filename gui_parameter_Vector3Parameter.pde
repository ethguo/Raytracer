public class Vector3Parameter extends ParameterControl {
  Vector3 vector;
  String labelText;
  float minValue;
  float maxValue;
  boolean hasSliders = false;
  boolean isColor = false;

  private FloatParameter xParameter;
  private FloatParameter yParameter;
  private FloatParameter zParameter;
  private GLabel label;

  Vector3Parameter(Object obj, String fieldName, String labelText, Vector3 initialValue) {
    super(labelText, obj, fieldName);
    this.vector = initialValue;
    this.hasSliders = false;
    this.isColor = false;

    this.xParameter = new FloatParameter(this.vector, "x", "X", this.vector.x);
    this.yParameter = new FloatParameter(this.vector, "y", "Y", this.vector.y);
    this.zParameter = new FloatParameter(this.vector, "z", "Z", this.vector.z);
  }

  Vector3Parameter(Object obj, String fieldName, String labelText, Vector3 initialValue, float minValue, float maxValue) {
    this(obj, fieldName, labelText, initialValue);
    this.hasSliders = true;
    this.minValue = minValue;
    this.maxValue = maxValue;

    this.xParameter = new FloatParameter(this.vector, "x", "X", this.vector.x, minValue, maxValue);
    this.yParameter = new FloatParameter(this.vector, "y", "Y", this.vector.y, minValue, maxValue);
    this.zParameter = new FloatParameter(this.vector, "z", "Z", this.vector.z, minValue, maxValue);
  }

  Vector3Parameter(Object obj, String fieldName, String labelText, Vector3 initialValue, boolean isColor) {
    this(obj, fieldName, labelText, initialValue);
    this.isColor = isColor;

    this.xParameter = new FloatParameter(this.vector, "x", "R", this.vector.x*255, 0, 255, 1.0/255);
    this.yParameter = new FloatParameter(this.vector, "y", "G", this.vector.y*255, 0, 255, 1.0/255);
    this.zParameter = new FloatParameter(this.vector, "z", "B", this.vector.z*255, 0, 255, 1.0/255);
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.createLabel(window, x, y);

    int yPadding = 0;
    yPadding += this.xParameter.createGUIControls(window, x+labelWidth, y, 20);
    yPadding += this.yParameter.createGUIControls(window, x+labelWidth, y+yPadding, 20);
    yPadding += this.zParameter.createGUIControls(window, x+labelWidth, y+yPadding, 20);

    return yPadding;
  }

  void setVisible(boolean visible) {
    super.setVisible(visible);
    this.xParameter.setVisible(visible);
    this.yParameter.setVisible(visible);
    this.zParameter.setVisible(visible);
  }
}