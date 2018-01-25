public class Tweaker {
  ArrayList<Parameter> parameters;

  private PApplet applet;
  private GWindow tweakerWindow;
  private GTimer updateTimer;
  private GButton saveButton;
  private GButton loadButton;

  Tweaker(PApplet applet) {
    this.applet = applet;
    this.parameters = new ArrayList<Parameter>();
  }

  void draw() {
    G4P.messagesEnabled(false);
    G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
    G4P.setCursor(ARROW);

    int xTweakerWindow = (displayWidth + renderWidth - tweakerWidth) / 2 + 2;
    int yTweakerWindow = (displayHeight - tweakerHeight) / 2;
    this.tweakerWindow = GWindow.getWindow(Raytracer.this, "Tweaker", xTweakerWindow, yTweakerWindow, tweakerWidth, tweakerHeight, JAVA2D);
    this.tweakerWindow.noLoop();
    this.tweakerWindow.setActionOnClose(G4P.EXIT_APP);
    this.tweakerWindow.addDrawHandler(this, "tweakerWindowDraw");

    this.updateTimer = new GTimer(Raytracer.this, this, "updateTimerTrigger", 100);

    this.saveButton = new GButton(this.tweakerWindow, (tweakerWidth-largePadding)/2-100, tweakerHeight-largePadding-20, 100, 20, "Save Scene");
    this.saveButton.addEventHandler(this, "saveButtonClicked");

    this.loadButton = new GButton(this.tweakerWindow, (tweakerWidth+largePadding)/2, tweakerHeight-largePadding-20, 100, 20, "Load Scene");
    this.loadButton.addEventHandler(this, "loadButtonClicked");

    int y = largePadding;
    for(Parameter parameter : this.parameters) {
      int yPadding = parameter.createGUIControls(this.tweakerWindow, largePadding, y);
      y += yPadding + largePadding;
    }

    this.tweakerWindow.loop();
  }

  void update() {
    this.updateTimer.stop();
    this.updateTimer.start(1);
  }

  void addParameter(Parameter parameter) {
    this.parameters.add(parameter);
  }

  void destroy() {
    this.tweakerWindow.setActionOnClose(G4P.CLOSE_WINDOW);
    this.tweakerWindow.close();
  }

  synchronized public void tweakerWindowDraw(PApplet appc, GWinData data) {
    appc.background(230);
  }

  public void updateTimerTrigger(GTimer source) {
    redraw();
  }

  public void saveButtonClicked(GButton source, GEvent event) {
    selectOutput("Select file", "saveScene", new File(dataPath("my-scene.json")));
  }

  public void loadButtonClicked(GButton source, GEvent event) {
    selectInput("Select file", "loadScene", new File(dataPath("my-scene.json")));
  }
}