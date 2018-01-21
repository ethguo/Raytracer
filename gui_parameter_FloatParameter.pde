public class FloatParameter extends Parameter {
  float value;
  float minValue;
  float maxValue;
  boolean hasSlider = false;

  private boolean propagatingChange = false;

  private GTextField textField;
  private GSlider slider;

  FloatParameter(Object obj, String fieldName, String labelText, float initialValue) {
    super(labelText, obj, fieldName);
    this.value = initialValue;
    this.labelText = labelText;
  }

  FloatParameter(Object obj, String fieldName, String labelText, float initialValue, float minValue, float maxValue) {
    this(obj, fieldName, labelText, initialValue);
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.hasSlider = true;
  }

  int createGUIControls(GWindow window, int x, int y) {
    return this.createGUIControls(window, x, y, 100, 160);
  }

  int createGUIControls(GWindow window, int x, int y, int labelWidth, int fieldWidth) {
    this.createLabel(window, x, y, labelWidth);

    this.textField = new GTextField(window, x+labelWidth, y, fieldWidth, 20, G4P.SCROLLBARS_NONE);
    this.textField.setText(Float.toString(this.value));
    this.textField.setOpaque(true);
    this.textField.addEventHandler(this, "fieldChange");

    if (this.hasSlider) {
      this.slider = new GSlider(window, x+labelWidth, y+20, fieldWidth, 20, 10.0);
      this.slider.setLimits(value, minValue, maxValue);
      this.slider.setNumberFormat(G4P.DECIMAL, 2);
      this.slider.setOpaque(false);
      this.slider.addEventHandler(this, "sliderChange");
      return 40;
    }
    
    return 20;
  }

  void setVisible(boolean visible) {
    super.setVisible(visible);
    this.textField.setVisible(visible);
    if (this.hasSlider)
      this.slider.setVisible(visible);
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
      this.updateValue(this.value);
    }
  }

  public void sliderChange(GSlider source, GEvent event) {
    // If the "propagatingChange" flag is set, we don't need to anything
    if (!this.propagatingChange && event == GEvent.VALUE_STEADY) {
      this.value = this.slider.getValueF();
      this.textField.setText(str(this.value));
      this.updateValue(this.value);
    }
    this.propagatingChange = false;
  }
}