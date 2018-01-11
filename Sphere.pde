class Sphere {
  Vector3 center;
  float radius;
  float radiusSquared;

  Sphere(Vector3 center, float radius) {
    this.center = center;
    this.radius = radius;
    this.radiusSquared = radius * radius;
  }

  float rayHit(Ray ray) {
    Vector3 co = ray.origin.minus(this.center);

    float a = ray.direction.dotSelf();
    float b = 2 * ray.direction.dotProduct(co);
    float c = co.dotSelf() - radiusSquared;

    Vector2 hits = solveQuadratic(a, b, c);
    if (hits == null)
      return 0;

    // hits.x and hits.y aren't really x and y values, they simply represent the first and second root
    if (hits.y < 0) // Both rays are behind the camera
      return 0;
    float t;
    if (hits.x < 0)
      t = hits.y;
    else
      t = hits.x;

    printt(t);
    return t;
  }
}