abstract class Light extends JSONSerializable implements Tweakable {
  public Vector3 colour;

  Light(color colour) {
    this.colour = new Color(colour).toVector3();
  }

  public Light(JSONObject j) {
    super(j);
    this.colour = new Color(j.getJSONObject("colour")).toVector3();
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("colour", new Color(this.colour).toJSONObject());
    return j;
  }

  String getName() {
    return this.getClass().getSimpleName();
  }

  abstract Vector3 getIncidentDirection(Vector3 point);
  abstract float getIntensity(Vector3 point);
  abstract float getDistance(Vector3 point);
}