public class Tweaker {
  ArrayList<Parameter> parameters;

  private PApplet applet;
  private GWindow tweakerWindow;
  private GTimer updateTimer;

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

  synchronized public void tweakerWindowDraw(PApplet appc, GWinData data) {
    appc.background(230);
  }

  public void updateTimerTrigger(GTimer source) {
    redraw();
  }
}