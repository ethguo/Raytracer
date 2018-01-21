public class Vector3Parameter extends Parameter {
  Vector3 value;
  String labelText;

  private FloatParameter xParameter;
  private FloatParameter yParameter;
  private FloatParameter zParameter;
  private GLabel label;

  Vector3Parameter(Object obj, String updateMethodName, String labelText, Vector3 initialValue) {
    super(obj, updateMethodName, Vector3.class);
    this.value = initialValue;
    this.labelText = labelText;
  }

  Vector3Parameter(Object obj, String updateMethodName, String labelText, Vector3 initialValue) {

  }

  int createGUIControls(GWindow window, int x, int y) {
    this.label = new GLabel(window, x, y, 100, 20);
    this.label.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
    this.label.setText(this.labelText);
    this.label.setOpaque(false);

    this.xParameter = new FloatParameter(this, "setX", "X", this.value.x);
    this.yParameter = new FloatParameter(this, "setY", "Y", this.value.y);
    this.zParameter = new FloatParameter(this, "setZ", "Z", this.value.z);

    this.xParameter.createGUIControls(window, x+100, y, 20, 120);
    this.yParameter.createGUIControls(window, x+100, y+20, 20, 120);
    this.zParameter.createGUIControls(window, x+100, y+40, 20, 120);

    return 120;
  }

  public void setX(float x) {
    println("x: " + x);
    this.value.x = x;
    this.callUpdateMethod(this.value);
  }

  public void setY(float y) {
    println("y: " + y);
    this.value.y = y;
    this.callUpdateMethod(this.value);
  }

  public void setZ(float z) {
    println("z: " + z);
    this.value.z = z;
    this.callUpdateMethod(this.value);
  }
}