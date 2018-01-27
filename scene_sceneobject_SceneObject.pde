/**
 * Represents any solid object or surface that can be hit by a ray.
 */
abstract class SceneObject extends JSONSerializable implements Tweakable {
  /** The name of this object, as displayed in the dropdown list. */
  public String name;
  /** The amount of light reflect by this object, in each component of RGB. */
  public Vector3 albedo;

  /**
   * Constructs a SceneObject.
   * @param albedo the amount of light reflected by this object (of each color in RGB).
   */
  SceneObject(color albedo) {
    this.albedo = new Vector3(albedo);
  }

  /**
   * Constructs a SceneObject SceneObjectct from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public SceneObject(JSONObject j) {
    super(j);
    this.albedo = new Color(j.getJSONObject("albedo")).toVector3();
    this.name = j.getString("name");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("albedo", new Color(this.albedo).toJSONObject());
    if (this.name != null)
      j.setString("name", this.name);
    return j;
  }

  // implements Tweakable
  String getName() {
    String typeName = "(" + this.getClass().getSimpleName() + ")";
    if (this.name != null)
      return this.name + " " + typeName;
    else
      return typeName;
  }

  // implements Tweakable
  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = new ArrayList<ParameterControl>();
    parameters.add(new Vector3Parameter(this, "albedo", "Albedo", this.albedo, true));
    return parameters;
  }

  /**
   * Determines if and where the given ray intersects this object.
   * Will return a value <= 0 if ray does not intersect this object.
   * @param  ray the ray to be tested for intersection.
   * @return     the value of t at which the ray hits this object.
   */
  abstract float rayIntersect(Ray ray);

  /**
   * Get the normal vector to the surface at the given point.
   * @param  point the point in 3D space at which to get the normal vector.
   * @return       the normal vector to the surface at the point.
   */
  abstract Vector3 getNormal(Vector3 point);
}