abstract class SceneObject {
  abstract float rayHit(Ray ray);
  abstract Vector3 getNormal(Vector3 point);
}