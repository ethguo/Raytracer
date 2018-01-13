class Plane extends SceneObject {
  Vector3 point;
  Vector3 normal;

  Plane(Vector3 point, Vector3 normal, float albedo) {
    this.point = point;
    this.normal = normal;
    this.albedo = albedo;
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
}