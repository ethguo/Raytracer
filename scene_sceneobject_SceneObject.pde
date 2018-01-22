abstract class SceneObject extends JSONSerializable implements Tweakable {
  public String name;
  public float albedo;

  SceneObject(float albedo) {
    this.albedo = albedo;
  }

  public SceneObject(JSONObject j) {
    super(j);
    this.albedo = j.getFloat("albedo");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("albedo", this.albedo);
    return j;
  }

  String getName() {
    return this.getClass().getSimpleName();
  }

  ArrayList<Parameter> getParameters() {
    ArrayList<Parameter> parameters = new ArrayList<Parameter>();
    parameters.add(new FloatParameter(this, "albedo", "Albedo", this.albedo, 0, 1));
    return parameters;
  }

  abstract float rayIntersect(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}