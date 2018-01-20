abstract class SceneObject extends JSONSerializable {
  public float albedo;

  SceneObject(float albedo) {
    this.albedo = albedo;
  }

  SceneObject(JSONObject j) {
    super(j);
    this.albedo = j.getFloat("albedo");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("albedo", this.albedo);
    return j;
  }
  
  abstract float rayIntersect(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}