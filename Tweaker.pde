public class Tweaker {
  private PApplet applet;
  private Map<String, Parameter> parameters;

  private GWindow tweakerWindow;
  private GTimer updateTimer;

  Tweaker(PApplet applet) {
    this.applet = applet;
    this.parameters = new LinkedHashMap<String, Parameter>();
  }

  void draw() {
    G4P.messagesEnabled(false);
    G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
    G4P.setCursor(ARROW);

    this.tweakerWindow = GWindow.getWindow(this.applet, "Tweaker", displayWidth/2+152, displayHeight/2-300, 300, 600, JAVA2D);
    this.tweakerWindow.noLoop();
    this.tweakerWindow.setActionOnClose(G4P.EXIT_APP);
    this.tweakerWindow.addDrawHandler(this, "tweakerWindowDraw");

    this.updateTimer = new GTimer(this.applet, this, "updateTimerTrigger", 500, 500);

    int y = 20;
    for(Map.Entry<String, Parameter> entry : this.parameters.entrySet()) {
      String name = entry.getKey();
      Parameter parameter = entry.getValue();
      y = parameter.createGUIControls(this.tweakerWindow, y);
    }

    this.tweakerWindow.loop();
  }

  void update() {
    this.updateTimer.start(1);
  }

  void addParameter(String name, Parameter parameter) {
    parameter.tweaker = this;
    this.parameters.put(name, parameter);
  }

  synchronized public void tweakerWindowDraw(PApplet appc, GWinData data) {
    appc.background(230);
  }

  public void updateTimerTrigger(GTimer source) {
    redraw();
  }
}