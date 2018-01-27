/**
 * Base class for a dynamically generated GUI control.
 */
public abstract class ParameterControl {
  private String labelText;
  private Object obj;
  private Field updateField;

  private GLabel label;

  /**
   * Creates a ParameterControl.
   * @param labelText    the text displayed beside the control.
   * @param obj          the object that contains the field to be controlled.
   * @param fieldName    the name of the field on the object that this should control.
   */
  ParameterControl(String labelText, Object obj, String fieldName) {
    this.labelText = labelText;
  	this.obj = obj;
  	try {
      // Tries to find the Field specified by fieldName.
    	this.updateField = obj.getClass().getField(fieldName);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }

  }

  /** Sets the field on the object specified at creation to a new value. */
  public void updateValue(Object value) {
    try {
      this.updateField.set(this.obj, value);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }
    // (Delayed) re-render the scene.
    tweaker.update();
  }
  
  protected void createLabel(GWindow window, int x, int y) {
    createLabel(window, x, y, 100);
  }

  protected void createLabel(GWindow window, int x, int y, int labelWidth) {
    this.label = new GLabel(window, x, y, labelWidth, 20);
    this.label.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
    this.label.setText(this.labelText);
    this.label.setOpaque(false);
  }

  public void setVisible(boolean visible) {
    this.label.setVisible(visible);
  }

  /**
   * Creates and draws the G4P GUI elements on the window.
   * @param  window the window to draw the GUI elements on.
   * @param  x      the x position within the window for the left edge of the GUI elements.
   * @param  y      the y position within the window for the top edge of the GUI elements.
   * @return        the vertical height of the GUI elements drawn, in number of pixels.
   */
  abstract int createGUIControls(GWindow window, int x, int y);
}