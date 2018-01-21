public abstract class Parameter {
  String labelText;
  Object obj;
  Method updateMethod;

  GLabel label;

  Parameter(String labelText, Object obj, String updateMethodName, Class<?>... argTypes) {
    this.labelText = labelText;
  	this.obj = obj;
  	try {
    	this.updateMethod = obj.getClass().getMethod(updateMethodName, argTypes);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }

  }

  public void callUpdateMethod(Object... args) {
    try {
      this.updateMethod.invoke(this.obj, args);
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

  // Returns vertical size
  abstract int createGUIControls(GWindow window, int x, int y);
}