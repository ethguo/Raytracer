/**
 * A dynamically generated GUI control that controls a Vector3 value.
 * This is built out of 3 FloatParameters, one for each component of the vector.
 */
public class Vector3Parameter extends ParameterControl {
  private Vector3 vector;
  private boolean isColor = false;

  private FloatParameter xParameter;
  private FloatParameter yParameter;
  private FloatParameter zParameter;
  private GLabel label;

  /**
   * Creates a Vector3Parameter with no sliders.
   * @param obj          the object that contains the field to be controlled.
   * @param fieldName    the name of the field on the object that this should control. Should be of type <code>Vector3</code>.
   * @param labelText    the text displayed beside the control.
   * @param initialValue the initial value of the control. The initial values of each FloatParameter will be set to the components of this vector.
   */
  Vector3Parameter(Object obj, String fieldName, String labelText, Vector3 initialValue) {
    super(labelText, obj, fieldName);
    this.vector = initialValue;
    this.isColor = false;

    this.xParameter = new FloatParameter(this.vector, "x", "X", this.vector.x);
    this.yParameter = new FloatParameter(this.vector, "y", "Y", this.vector.y);
    this.zParameter = new FloatParameter(this.vector, "z", "Z", this.vector.z);
  }

  /**
   * Creates a Vector3Parameter with sliders.
   * @param obj          the object that contains the field to be controlled.
   * @param fieldName    the name of the field on the object that this should control. Should be of type <code>Vector3</code>.
   * @param labelText    the text displayed beside the control.
   * @param initialValue the initial value of the control. The initial values of each FloatParameter will be set to the components of this vector.
   * @param minValue     the lower bound of each slider.
   * @param maxValue     the upper bound of each slider.
   */
  Vector3Parameter(Object obj, String fieldName, String labelText, Vector3 initialValue, float minValue, float maxValue) {
    this(obj, fieldName, labelText, initialValue);

    this.xParameter = new FloatParameter(this.vector, "x", "X", this.vector.x, minValue, maxValue);
    this.yParameter = new FloatParameter(this.vector, "y", "Y", this.vector.y, minValue, maxValue);
    this.zParameter = new FloatParameter(this.vector, "z", "Z", this.vector.z, minValue, maxValue);
  }

  /**
   * Creates a Vector3Parameter that controls an RGB color. The range of the slider will be set to 0-255, but the
   * value passed on will be in the range 0-1 to stay consistent with color vectors elsewhere in the program.
   * @param obj          the object that contains the field to be controlled.
   * @param fieldName    the name of the field on the object that this should control. Should be of type <code>Vector3</code>.
   * @param labelText    the text displayed beside the control.
   * @param initialValue the initial value of the control. The initial values of each FloatParameter will be set to the components of this vector.
   * @param isColor      set to <code>true</code> to indicate that this is a color vector.
   */
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