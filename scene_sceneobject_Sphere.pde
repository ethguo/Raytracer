/**
 * Represents a sphere.
 */
class Sphere extends SceneObject {
  public Vector3 center;
  public float radius;

  /**
   * Constructs a Sphere.
   * @param center  the center point of the sphere.
   * @param radius  the radius of the sphere.
   * @param albedo  the albedo of the surface (passed on to {@link SceneObject(color)}).
   */
  Sphere(Vector3 center, float radius, color albedo) {
    super(albedo);
    this.center = center;
    this.radius = radius;
  }

  /**
   * Constructs a Sphere object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public Sphere(JSONObject j) {
    super(j);
    this.center = new Vector3(j.getJSONObject("center"));
    this.radius = j.getFloat("radius");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("center", this.center.toJSONObject());
    j.setFloat("radius", this.radius);
    return j;
  }

  float rayIntersect(Ray ray) {
    Vector3 co = ray.origin.minus(this.center);

    // The t values for the intersection with the ray can be computed using a quadratic equation:
    float a = ray.direction.dotSelf(); // Should be 1, as long as ray.direction is normalized.
    float b = 2 * ray.direction.dot(co);
    float c = co.dotSelf() - radius*radius;

    // Solve the quadratic equation.
    // hits.x and hits.y aren't really x and y values, they just represent the smaller and larger roots.
    Vector2 hits = solveQuadratic(a, b, c);

    if (hits == null)
      // No real solutions - no ray hit.
      return 0;

    if (hits.y < 0)
      // Both points are behind the ray origin - no ray hit.
      return 0;

    if (hits.x < 0)
      // One of the points are behind the ray origin - the other is the ray hit point.
      return hits.y;
    
    // Otherwise, both points are in front of the ray - pick the first one (closer one).
    return hits.x;

  }

  Vector3 getNormal(Vector3 point) {
    Vector3 normal = point.minus(this.center);
    normal.normalize();
    return normal;
  }

  // implements Tweakable
  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = super.getParameters();
    parameters.add(new Vector3Parameter(this, "center", "Center", this.center, -5, 5));
    parameters.add(new FloatParameter(this, "radius", "Radius", this.radius, 0, 5));
    return parameters;
  }

  /**
   * Finds the real solutions to the quadratic equation ax² + bx + c = 0
   * @param  a the coefficient of x².
   * @param  b the coefficient of x.
   * @param  c the constant.
   * @return   null if no real solutions. Otherwise, a Vector2 with the first component being the smaller of the two roots and the second component being the larger.
   */
  private Vector2 solveQuadratic(float a, float b, float c) {
    float discriminant = b*b - 4*a*c;

    // Negative discriminant - no real solutions.
    if (discriminant < 0)
      return null;

    // Zero discriminant - double root.
    if (discriminant == 0) {
      float x = -b / (2*a);
      return new Vector2(x, x);
    }
  
    // Positive discriminant - two real roots.
    // More numerically stable method for computing the roots, to avoid loss of significance (floating point rounding).
    float q;
    if (b > 0)
      q = (-b - sqrt(discriminant)) / 2;
    else
      q = (-b + sqrt(discriminant)) / 2;

    float x1 = q / a;
    float x2 = c / q;

    // Ensures that the smaller root is the first component and the larger is the second.
    Vector2 solution;
    if (x1 < x2)
      solution = new Vector2(x1, x2);
    else
      solution = new Vector2(x2, x1);

    return solution;
  }
}