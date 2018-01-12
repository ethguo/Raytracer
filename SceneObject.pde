abstract class SceneObject {
  float albedo;

  abstract float rayIntersect(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}