class NumberParameter<T> extends Parameter {
  T value;
  T minValue;
  T maxValue;

  NumberParameter(T initialValue, T minValue, T maxValue) {
    this.value = initialValue;
    this.minValue = minValue;
    this.maxValue = maxValue;
  }

  T getValue() {

  }

  void createGUIControls(GWindow window, int y) {
    textField = new GTextField(window, 100, y, 100, 20, G4P.SCROLLBARS_NONE);
    textField.setText(this.value);
    textField.setOpaque(true);
    textField.addEventHandler(this, "field_fov_change");
  }
}