public class FloatParameter extends Parameter {
  float value;
  String labelText;
  float minValue;
  float maxValue;
  boolean hasSlider;
  boolean propagatingChange = false;

  private GTextField textField;
  private GSlider slider;
  private GLabel label;

  FloatParameter(Object obj, String methodName, String labelText, float initialValue) {
    super(obj, methodName, float.class);
    this.value = initialValue;
    this.labelText = labelText;
    this.hasSlider = false;
  }

  FloatParameter(Object obj, String methodName, String labelText, float initialValue, float minValue, float maxValue) {
    super(obj, methodName, float.class);
    this.value = initialValue;
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.hasSlider = true;
  }

  // Returns vertical size
  int createGUIControls(GWindow window, int x, int y) {
    return this.createGUIControls(window, x + 100, y, x);
  }

  int createGUIControls(GWindow window, int x, int y, int xLabel) {
    if (this.labelText != null) {
      this.label = new GLabel(window, xLabel, y, x - xLabel, 20);
      this.label.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
      this.label.setText(this.labelText);
      this.label.setOpaque(false);
    }

    this.textField = new GTextField(window, x, y, x, 20, G4P.SCROLLBARS_NONE);
    this.textField.setText(Float.toString(this.value));
    this.textField.setOpaque(true);
    this.textField.addEventHandler(this, "fieldChange");

    if (this.hasSlider) {
      this.slider = new GSlider(window, x, y+20, x, 20, 10.0);
      this.slider.setLimits(value, minValue, maxValue);
      this.slider.setNumberFormat(G4P.DECIMAL, 2);
      this.slider.setOpaque(false);
      this.slider.addEventHandler(this, "sliderChange");
      return 60;
    }
    
    return 40;
  }

  public void fieldChange(GTextField source, GEvent event) {
    if (event == GEvent.ENTERED || event == GEvent.LOST_FOCUS) {
      this.value = float(this.textField.getText());
      if (this.hasSlider) {
        // It is necessary to set a "propagatingChange" flag because for some reason,
        // event handlers on GSliders are triggered even when the value is set manually using setValue.
        this.propagatingChange = true;
        this.slider.setValue(this.value);
      }
      this.update(this.value);
    }
  }

  public void sliderChange(GSlider source, GEvent event) {
    // If the "propagatingChange" flag is set, we don't need to anything
    if (!this.propagatingChange && event == GEvent.VALUE_STEADY) {
      this.value = this.slider.getValueF();
      this.textField.setText(str(this.value));
      this.update(this.value);
    }
    this.propagatingChange = false;
  }
}