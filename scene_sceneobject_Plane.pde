class Plane extends SceneObject {
  public Vector3 point;
  public Vector3 normal;

  Plane(Vector3 point, Vector3 normal, color albedo) {
    super(albedo);
    this.point = point;
    this.normal = normal.normalize();
  }

  public Plane(JSONObject j) {
    super(j);
    this.point = new Vector3(j.getJSONObject("point"));
    this.normal = new Vector3(j.getJSONObject("normal")).normalize();
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

  ArrayList<Parameter> getParameters() {
    ArrayList<Parameter> parameters = super.getParameters();
    parameters.add(new Vector3Parameter(this, "point", "Point", this.point, -5, 5));
    parameters.add(new Vector3Parameter(this, "normal", "Normal", this.normal, -1, 1));
    return parameters;
  }
}