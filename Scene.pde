class Scene {
  float fov = 75;
  Vector3 origin = new Vector3(0, 0, 0);
  color skyColor = #8CBED6;
  float shadowBias = 1e-4;

  SceneObject[] sceneObjects = new SceneObject[] {
    new Sphere(new Vector3(0, -1, -4), 1, 0.9),
    new Sphere(new Vector3(1, 0, -7), 2, 0.8),
    new Sphere(new Vector3(-1, 1.5, -5), 0.33, 0.9),
    new Plane(new Vector3(0, -2, 0), new Vector3(0, 1, 0), 0.6)
  };

  Light[] lights = new Light[] {
    new DirectionalLight(new Vector3(0, -1, 0).normalized(), #CCCCCC, 1),
    new DirectionalLight(new Vector3(1, -1, -1).normalized(), #FFCC99, PI),
    new DirectionalLight(new Vector3(-1, -0.5, -0.5).normalized(), #3399FF, 1.5),
  };
}