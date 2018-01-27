abstract class SceneObject extends JSONSerializable implements Tweakable {
  public String name;
  public Vector3 albedo;

  SceneObject(color albedo) {
    this.albedo = new Vector3(albedo);
  }

  public SceneObject(JSONObject j) {
    super(j);
    this.albedo = new Color(j.getJSONObject("albedo")).toVector3();
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("albedo", new Color(this.albedo).toJSONObject());
    return j;
  }

  String getName() {
    return this.getClass().getSimpleName();
  }

  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = new ArrayList<ParameterControl>();
    parameters.add(new Vector3Parameter(this, "albedo", "Albedo", this.albedo, true));
    return parameters;
  }

  abstract float rayIntersect(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}