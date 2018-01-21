class Plane extends SceneObject {
  public Vector3 point;
  public Vector3 normal;

  private Vector3Parameter pointParameter;
  private Vector3Parameter normalParameter;

  Plane(Vector3 point, Vector3 normal, float albedo) {
    super(albedo);
    this.point = point;
    this.normal = normal.normalize();

    this.createParameters();
  }

  public Plane(JSONObject j) {
    super(j);
    this.point = new Vector3(j.getJSONObject("point"));
    this.normal = new Vector3(j.getJSONObject("normal")).normalize();

    this.createParameters();
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("point", this.point.toJSONObject());
    j.setJSONObject("normal", this.normal.toJSONObject());
    return j;
  }

  float rayIntersect(Ray ray) {
    float cosTheta = -this.normal.dot(ray.direction);

    if (cosTheta < 1e-6)
      return 0;

    Vector3 po = ray.origin.minus(this.point);
    float t = po.dot(this.normal) / cosTheta;
    return t;
  }

  Vector3 getNormal(Vector3 point) {
    return this.normal;
  }

  // gui_Tweakable methods

  void createParameters() {
    if (this.pointParameter != null)
      this.setVisible(true);
    else {
      this.pointParameter = new Vector3Parameter(this, "point", "Point", this.point, -5, 5);
      this.normalParameter = new Vector3Parameter(this, "normal", "Normal", this.normal, -1, 1);
    }
  }

  int createGUIControls(GWindow window, int x, int y) {
    int yPadding = 0;
    yPadding += this.pointParameter.createGUIControls(window, x, y);
    yPadding += this.normalParameter.createGUIControls(window, x, y+yPadding);
    return yPadding;
  }

  void setVisible(boolean visible) {
    this.pointParameter.setVisible(visible);
    this.normalParameter.setVisible(visible);
  }
}