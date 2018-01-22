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
    this.itemParameters = new ArrayList<ArrayList<Parameter>>(items.size());
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.window = window;
    this.x = x;
    this.y = y;
    this.createLabel(window, x, y);

    String[] itemNames = new String[items.size()];
    for (int i = 0; i < itemNames.length; i++) {
      itemNames[i] = items.get(i).getName();
    }

    this.dropList = new GDropList(window, x+labelWidth, y, tweakerWidth - labelWidth - x - 20, 100, 4);
    this.dropList.setItems(itemNames, 0);
    this.dropList.addEventHandler(this, "dropListChange");

    // Loop through all items
    int maxPadding = 0;
    for (T item : this.items) {
      ArrayList<Parameter> parameters = item.getParameters();
      itemParameters.add(parameters);

      int yPadding = 20 + smallPadding;
      for (Parameter parameter : parameters) {
        yPadding += parameter.createGUIControls(window, x+largePadding, y+yPadding);
        yPadding += smallPadding;
        parameter.setVisible(false);
      }

      if (yPadding > maxPadding)
        maxPadding = yPadding;
    }

    this.setItemVisible(true);

    return maxPadding;
  }

  public void dropListChange(GDropList source, GEvent event) {
    this.setItemVisible(false);
    this.currentIndex = this.dropList.getSelectedIndex();
    this.setItemVisible(true);
  }

  void setItemVisible(boolean visible) {
    ArrayList<Parameter> parameters = this.itemParameters.get(this.currentIndex);
    for (Parameter parameter : parameters)
      parameter.setVisible(visible);
  }
}