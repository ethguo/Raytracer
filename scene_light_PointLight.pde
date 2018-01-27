/**
 * Represents a light source that radiates light outward in all directions from a single point. Its intensity falls off with distance.
 * In real life, most artificial sources of light, such as lightbulbs, candles, can be considered point lights.
 * Note that the intensity of a point light will usually have to be orders of magnitude higher than that of a similar
 * directional light to achieve comparable levels of illumination, because the intensity falls off quadratically with distance.
 */
class PointLight extends Light {
  public Vector3 position;
  public float intensity;

  /**
   * Constructs a PointLight.
   * @param position  the center point (origin) of the light.
   * @param colour    the colour of the light (passed on to {@link Light(color)}).
   * @param intensity the intensity of the light at the light's origin.
   */
  PointLight(Vector3 position, color colour, float intensity) {
    super(colour);
    this.position = position;
    this.intensity = intensity;
  }

  /**
   * Constructs a PointLight object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public PointLight(JSONObject j) {
    super(j);
    this.position = new Vector3(j.getJSONObject("position"));
    this.intensity = j.getFloat("intensity");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("position", this.position.toJSONObject());
    j.setFloat("intensity", this.intensity);
    return j;
  }

  Vector3 getDirection(Vector3 point) {
    return this.position.minus(point).normalize();
  }

  float getIntensity(Vector3 point) {
    float distance = this.position.minus(point).getMagnitudeSquared();
    return this.intensity / (4 * PI * distance);
  }

  float getDistance(Vector3 point) {
    return this.position.minus(point).getMagnitude();
  }

  // implements Tweakable
  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = super.getParameters();
    parameters.add(0, new Vector3Parameter(this, "position", "Position", this.position, -5, 5));
    parameters.add(1, new FloatParameter(this, "intensity", "Intensity", this.intensity, 0, 4000));
    return parameters;
  }
}