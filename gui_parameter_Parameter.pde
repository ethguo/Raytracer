public abstract class Parameter {
  Tweaker tweaker;
  Object obj;
  Method updateMethod;

  Parameter(Object obj, String methodName, Class<?>... argTypes) {
  	this.obj = obj;
  	try {
    	this.updateMethod = obj.getClass().getMethod(methodName, argTypes);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }

  }

  public void update(Object... args) {
    try {
      this.updateMethod.invoke(this.obj, args);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }
    this.tweaker.update();
  }
  
  // Returns vertical size
  abstract int createGUIControls(GWindow window, int x, int y);
}