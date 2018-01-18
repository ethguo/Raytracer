class Scene {
  float fov;
  Vector3 origin;
  color skyColor;
  float shadowBias;
  SceneObject[] sceneObjects;
  Light[] lights;

  Scene() {
    this.fov = 75;
    this.origin = new Vector3(0, 0, 0);
    this.skyColor = #8CBED6;
    this.shadowBias = 1e-4;

    this.sceneObjects = new SceneObject[] {
      new Sphere(new Vector3(0, -1, -4), 1, 0.9),
      new Sphere(new Vector3(1, 0, -7), 2, 0.8),
      new Sphere(new Vector3(-1, 1.5, -5), 0.33, 0.9),
      new Plane(new Vector3(0, -2, 0), new Vector3(0, 1, 0), 0.6)
    };

    this.lights = new Light[] {
      new DirectionalLight(new Vector3(0, -1, 0).normalized(), #CCCCCC, 1),
      new DirectionalLight(new Vector3(1, -1, -1).normalized(), #FFCC99, PI),
      new DirectionalLight(new Vector3(-1, -0.5, -0.5).normalized(), #3399FF, 1.5),
    };
  }

  Scene(JSONObject json) {
    
  }
}