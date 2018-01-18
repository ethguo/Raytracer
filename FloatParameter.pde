public class FloatParameter extends Parameter {
  private float value;
  private float minValue;
  private float maxValue;

  private GTextField textField;
  private GSlider slider;

  FloatParameter(float initialValue, float minValue, float maxValue) {
    this.value = initialValue;
    this.minValue = minValue;
    this.maxValue = maxValue;
  }

  Object getValue() {
    return value;
  }

  int createGUIControls(GWindow window, int y) {
    textField = new GTextField(window, 100, y, 100, 20, G4P.SCROLLBARS_NONE);
    textField.setText(Float.toString(this.value));
    textField.setOpaque(true);
    textField.addEventHandler(this, "fieldChange");

    slider = new GSlider(window, 100, y+20, 100, 20, 10.0);
    slider.setLimits(value, minValue, maxValue);
    slider.setNumberFormat(G4P.DECIMAL, 2);
    slider.setOpaque(false);
    slider.addEventHandler(this, "sliderChange");
    
    return y + 40;
  }

  public void fieldChange(GTextField source, GEvent event) {
    this.value = float(source.getText());
    tweaker.update();
  }

  public void sliderChange(GSlider source, GEvent event) {
    this.value = source.getValueF();
    tweaker.update();
  }
}