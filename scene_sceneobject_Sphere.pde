class Sphere extends SceneObject {
  public Vector3 center;
  public float radius;

  private Vector3Parameter centerParameter;
  private FloatParameter radiusParameter;

  Sphere(Vector3 center, float radius, float albedo) {
    super(albedo);
    this.center = center;
    this.radius = radius;

    this.createParameters();
  }

  public Sphere(JSONObject j) {
    super(j);
    this.center = new Vector3(j.getJSONObject("center"));
    this.radius = j.getFloat("radius");

    this.createParameters();
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("center", this.center.toJSONObject());
    j.setFloat("radius", this.radius);
    return j;
  }

  float rayIntersect(Ray ray) {
    Vector3 co = ray.origin.minus(this.center);

    float a = ray.direction.dotSelf();
    float b = 2 * ray.direction.dot(co);
    float c = co.dotSelf() - radius*radius;

    Vector2 hits = solveQuadratic(a, b, c);
    if (hits == null)
      return 0;

    // hits.x and hits.y aren't really x and y values, they simply represent the first and second root
    if (hits.y < 0) // Both rays are behind the camera
      return 0;
    float t;
    if (hits.x < 0)
      t = hits.y;
    else
      t = hits.x;

    return t;
  }

  Vector3 getNormal(Vector3 point) {
    Vector3 normal = point.minus(this.center);
    normal.normalize();
    return normal;
  }

  // gui_Tweakable methods

  void createParameters() {
    if (this.centerParameter != null)
      this.setVisible(true);
    else {
      this.centerParameter = new Vector3Parameter(this, "center", "Center", this.center, -5, 5);
      this.radiusParameter = new FloatParameter(this, "radius", "Radius", this.radius, 0, 5);
    }
  }

  int createGUIControls(GWindow window, int x, int y) {
    int yPadding = 0;
    yPadding += this.centerParameter.createGUIControls(window, x, y);
    yPadding += this.radiusParameter.createGUIControls(window, x, y+yPadding);
    return yPadding;
  }

  void setVisible(boolean visible) {
    this.centerParameter.setVisible(visible);
    this.radiusParameter.setVisible(visible);
  }
}