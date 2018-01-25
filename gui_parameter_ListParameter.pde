public class ListParameter<T extends Tweakable> extends Parameter {
  ArrayList<T> items;
  ArrayList<ArrayList<Parameter>> itemParameters;
  int currentIndex;

  private GWindow window;
  private int x, y;

  private GDropList dropList;

  ListParameter(Object obj, String fieldName, String labelText, ArrayList<T> items) {
    super(labelText, obj, fieldName);
    this.items = items;
    this.labelText = labelText;

    this.currentIndex = 0;
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.window = window;
    this.x = x;
    this.y = y;
    this.createLabel(window, x, y);

    // Build list of item names for the dropdown list.
    String[] itemNames = new String[this.items.size()];
    for (int i = 0; i < itemNames.length; i++)
      itemNames[i] = this.items.get(i).getName();

    // Create dropdown list.
    this.dropList = new GDropList(window, x+labelWidth, y, tweakerWidth - labelWidth - x - 20, 100, 4);
    this.dropList.setItems(itemNames, 0);
    this.dropList.addEventHandler(this, "dropListChange");

    // Build and store list of each item's Parameters, and simultaneously create the GUI controls,
    // keeping track of the largest (tallest) group of GUI controls.
    this.itemParameters = new ArrayList<ArrayList<Parameter>>(this.items.size());
    int maxHeight = 0;
    for (T item : this.items) {
      ArrayList<Parameter> parameters = item.getParameters();

      this.itemParameters.add(parameters);

      // Create all the GUI controls for this item, but invisible.
      int yOffset = 20 + smallPadding;
      for (Parameter parameter : parameters) {
        yOffset += parameter.createGUIControls(window, x+largePadding, y+yOffset);
        yOffset += smallPadding;
        // Hide the controls for now.
        parameter.setVisible(false);
      }

      // If this is the tallest group of GUI controls yet, update the maxHeight.
      if (yOffset > maxHeight)
        maxHeight = yOffset;
    }

    // Unhide the first item's controls.
    this.setCurrentItemVisible(true);

    return maxHeight;
  }

  public void dropListChange(GDropList source, GEvent event) {
    this.setCurrentItemVisible(false);
    this.currentIndex = this.dropList.getSelectedIndex();
    this.setCurrentItemVisible(true);
  }

  void setCurrentItemVisible(boolean visible) {
    ArrayList<Parameter> parameters = this.itemParameters.get(this.currentIndex);
    for (Parameter parameter : parameters)
      parameter.setVisible(visible);
  }
}