/**
 * Represents a generic light source that can illuminate scene objects.
 */
abstract class Light extends JSONSerializable implements Tweakable {
  public Vector3 colour;

  /**
   * Constructs a Light.
   * @param colour the colour of the light (in RGB).
   */
  Light(color colour) {
    this.colour = new Color(colour).toVector3();
  }

  /**
   * Constructs a Light object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public Light(JSONObject j) {
    super(j);
    this.colour = new Color(j.getJSONObject("colour")).toVector3();
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("colour", new Color(this.colour).toJSONObject());
    return j;
  }

  // implements Tweakable
  String getName() {
    return this.getClass().getSimpleName();
  }

  // implements Tweakable
  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = new ArrayList<ParameterControl>();
    parameters.add(new Vector3Parameter(this, "colour", "Color", this.colour, true));
    return parameters;
  }

  /**
   * Get the direction vector to the light from a given point in space.
   * @param  point the point at which to find the direction.
   * @return       the direction vector from the point to the light.
   */
  abstract Vector3 getDirection(Vector3 point);

  /**
   * Get the intensity of the light at a given point in space.
   * @param  point the point at which to find the intensity.
   * @return       the intensity of the light at the point.
   */
  abstract float getIntensity(Vector3 point);

  /**
   * Get the distance between the light and the given point in space.
   * @param  point the point from which to find the distance.
   * @return       the distance between the light and the point.
   */
  abstract float getDistance(Vector3 point);
}