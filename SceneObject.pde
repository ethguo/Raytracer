abstract class SceneObject {
  float albedo;

  abstract JSONObject toJSONObject();
  
  abstract float rayIntersect(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}