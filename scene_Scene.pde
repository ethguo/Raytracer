class Scene extends JSONSerializable {
  /** The camera field of view (in degrees). */
  public float fov;
  /** The shadow bias (see footnote on page 3 of design document). */
  public float shadowBias;
  /** The point at which all primary rays originate. */
  public Vector3 cameraOrigin;
  /** The color that a pixel is set to if the primary ray did not hit anything. */
  public Vector3 skyColor;
  /** A list of all the SceneObjects in the scene. */
  public ArrayList<SceneObject> sceneObjects;
  /** A list of all the Lights in the scene. */
  public ArrayList<Light> lights;

  /**
   * Default constructor, will return a hard-coded demo scene.
   */
  Scene() {
    this.fov = 75;
    this.shadowBias = 1e-4;
    this.cameraOrigin = new Vector3(0, 2, 0);
    this.skyColor = new Vector3(#8CBED6);

    this.sceneObjects = new ArrayList<SceneObject>();
    this.sceneObjects.add(new Sphere(new Vector3(0, 1, -4), 1, #E6E6E6));
    this.sceneObjects.add(new Sphere(new Vector3(1, 2, -7), 2, #E6E6E6));
    this.sceneObjects.add(new Sphere(new Vector3(-1, 3.5, -4.5), 0.33, #FF8099));
    this.sceneObjects.add(new Plane(new Vector3(0, 0, 0), new Vector3(0, 1, 0), #999999));

    this.lights = new ArrayList<Light>();
    this.lights.add(new DirectionalLight(new Vector3(0, -1, 0), #FFFFFF, 0.25));
    this.lights.add(new PointLight(new Vector3(-4, 5, 0), #FFCC99, 2000));
    this.lights.add(new PointLight(new Vector3(4, 2, -2), #3399FF, 500));
  }

  /**
   * Construct a Scene object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public Scene(JSONObject j) {
    super(j);
    this.fov = j.getFloat("fov");
    this.shadowBias = j.getFloat("shadowBias");
    this.cameraOrigin = new Vector3(j.getJSONObject("cameraOrigin"));
    this.skyColor = new Color(j.getJSONObject("skyColor")).toVector3();
    this.sceneObjects = fromJSONArray(j.getJSONArray("sceneObjects"));
    this.lights = fromJSONArray(j.getJSONArray("lights"));
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("fov", this.fov);
    j.setFloat("shadowBias", this.shadowBias);
    j.setJSONObject("cameraOrigin", this.cameraOrigin.toJSONObject());
    j.setJSONObject("skyColor", new Color(this.skyColor).toJSONObject());
    j.setJSONArray("sceneObjects", toJSONArray(this.sceneObjects));
    j.setJSONArray("lights", toJSONArray(this.lights));
    return j;
  }

  /**
   * Deep copies this object. This is accomplished by serializing it to JSON then deserializing it again.
   * @return a deep copy of this Scene object.
   */
  Scene copy() {
    return new Scene(this.toJSONObject());
  }
}