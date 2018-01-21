public abstract class Parameter {
  Object obj;
  Method updateMethod;

  Parameter(Object obj, String updateMethodName, Class<?>... argTypes) {
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
  
  // Returns vertical size
  abstract int createGUIControls(GWindow window, int x, int y);
}