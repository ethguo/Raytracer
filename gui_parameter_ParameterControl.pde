public abstract class ParameterControl {
  String labelText;
  Object obj;
  Field updateField;

  GLabel label;

  ParameterControl(String labelText, Object obj, String fieldName) {
    this.labelText = labelText;
  	this.obj = obj;
  	try {
    	this.updateField = obj.getClass().getField(fieldName);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }

  }

  public void updateValue(Object value) {
    try {
      this.updateField.set(this.obj, value);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }
    tweaker.update();
  }
  
  void createLabel(GWindow window, int x, int y) {
    createLabel(window, x, y, 100);
  }

  void createLabel(GWindow window, int x, int y, int labelWidth) {
    this.label = new GLabel(window, x, y, labelWidth, 20);
    this.label.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
    this.label.setText(this.labelText);
    this.label.setOpaque(false);
  }

  void setVisible(boolean visible) {
    this.label.setVisible(visible);
  }

  // Returns vertical size
  abstract int createGUIControls(GWindow window, int x, int y);
}