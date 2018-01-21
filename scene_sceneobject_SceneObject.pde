abstract class SceneObject extends JSONSerializable implements NamedObject {
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

  abstract float rayIntersect(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}