class Plane extends SceneObject {
  Vector3 point;
  Vector3 normal;

  Plane(Vector3 point, Vector3 normal, float albedo) {
    this.point = point;
    this.normal = normal;
    this.albedo = albedo;
  }

  float rayIntersect(Ray ray) {
    float theta = this.normal.dot(ray.direction);
    if (theta < 1e-6)
      return 0;

    Vector3 po = this.point.minus(ray.origin);
    float t = po.dot(this.normal) / theta;
    return t;
  }

  Vector3 getNormal(Vector3 point) {
    return this.normal;
  }
}