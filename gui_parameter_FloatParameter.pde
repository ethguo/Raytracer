public class FloatParameter extends ParameterControl {
  float value;
  float minValue;
  float maxValue;
  boolean hasSlider = false;
  float valueScaling = 1;

  private boolean propagatingChange = false;

  private GTextField textField;
  private GSlider slider;

  FloatParameter(Object obj, String fieldName, String labelText, float initialValue) {
    super(labelText, obj, fieldName);
    this.value = initialValue;
  }

  FloatParameter(Object obj, String fieldName, String labelText, float initialValue, float minValue, float maxValue) {
    this(obj, fieldName, labelText, initialValue);
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.hasSlider = true;
  }

  FloatParameter(Object obj, String fieldName, String labelText, float initialValue, float minValue, float maxValue, float valueScaling) {
    this(obj, fieldName, labelText, initialValue, minValue, maxValue);
    this.valueScaling = valueScaling;
  }

  int createGUIControls(GWindow window, int x, int y) {
    return this.createGUIControls(window, x, y, labelWidth);
  }

  int createGUIControls(GWindow window, int x, int y, int labelWidth) {
    this.createLabel(window, x, y, labelWidth);

    int fieldWidth = tweakerWidth - labelWidth - x - largePadding;
    if (this.hasSlider)
      fieldWidth -= sliderWidth;

    this.textField = new GTextField(window, x+labelWidth, y, fieldWidth, 20, G4P.SCROLLBARS_NONE);
    this.textField.setText(Float.toString(this.value));
    this.textField.setOpaque(true);
    this.textField.addEventHandler(this, "fieldChange");

    if (this.hasSlider) {
      this.slider = new GSlider(window, tweakerWidth-sliderWidth-largePadding, y, sliderWidth, 20, 10);
      this.slider.setLimits(value, minValue, maxValue);
      this.slider.setNumberFormat(G4P.DECIMAL, 2);
      this.slider.setOpaque(false);
      this.slider.addEventHandler(this, "sliderChange");
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
      if (Float.isNaN(this.value)) {
        // If the user typed an invalid input, set the background to red.
        this.textField.setLocalColor(7, #FF9999);
      }
      else {
        this.textField.setLocalColor(7, #FFFFFF);
        if (this.hasSlider) {
          // It is necessary to set a "propagatingChange" flag because for some reason,
          // event handlers on GSliders are triggered even when the value is set manually using setValue.
          this.propagatingChange = true;
          this.slider.setValue(this.value);
        }
        this.updateValue(this.value * valueScaling);
      }
    }
  }

  public void sliderChange(GSlider source, GEvent event) {
    // If the "propagatingChange" flag is set, we don't need to anything
    if (!this.propagatingChange && event == GEvent.VALUE_STEADY) {
      this.value = this.slider.getValueF();
      this.textField.setText(str(this.value));
      this.updateValue(this.value * valueScaling);
    }
    this.propagatingChange = false;
  }
}