/**
 * Represents a one-sided infinite plane. The plane is only visible from the side that the normal vector points toward.
 */
class Plane extends SceneObject {
  public Vector3 origin;
  public Vector3 normal;

  /**
   * Constructs a Plane.
   * @param origin  a point on the plane.
   * @param normal  the normal vector of the plane.
   * @param albedo  the albedo of the surface (passed on to {@link SceneObject(color)}).
   */
  Plane(Vector3 origin, Vector3 normal, color albedo) {
    super(albedo);
    this.origin = origin;
    this.normal = normal.normalize();
  }

  /**
   * Constructs a Plane object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public Plane(JSONObject j) {
    super(j);
    this.origin = new Vector3(j.getJSONObject("origin"));
    this.normal = new Vector3(j.getJSONObject("normal")).normalize();
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("origin", this.origin.toJSONObject());
    j.setJSONObject("normal", this.normal.toJSONObject());
    return j;
  }

  float rayIntersect(Ray ray) {
    float cosTheta = -this.normal.dot(ray.direction);

    // If viewing from the wrong side of the plane, return zero, representing no ray intersection.
    if (cosTheta < 1e-6)
      return 0;

    // Computes the distance between the ray origin the hit point.
    Vector3 co = ray.origin.minus(this.origin);
    float t = co.dot(this.normal) / cosTheta;
    return t;
  }

  Vector3 getNormal(Vector3 origin) {
    return this.normal;
  }

  // implements Tweakable
  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = super.getParameters();
    parameters.add(new Vector3Parameter(this, "origin", "Origin", this.origin, -5, 5));
    parameters.add(new Vector3Parameter(this, "normal", "Normal", this.normal, -1, 1));
    return parameters;
  }
}