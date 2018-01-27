/**
 * Base class for all classes which can be saved into a JSON file. Supports serializing this object into a JSONObject
 * and deserializing a JSONObject back into a real java.lang.Object with the same data.
 */
class JSONSerializable {
  JSONSerializable() {}

  /**
   * Constructs a JSONSerializable object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public JSONSerializable(JSONObject j) {
    // Check that the type declared in the "type" entry of the JSONObject matches the class we're trying to instantiate.
    String className = this.getClass().getSimpleName();
    String jsonType = j.getString("type");
    if (!jsonType.equals(className))
      throw new JSONTypeMismatchException("Invalid type for conversion in JSON object: expected " + className + ", got " + jsonType);
  }

  /**
   * Serializes this object into a JSONObject. Stores the name of this class into the "type" entry of the JSONObject.
   * Subclasses should override this method, call super.toJSONObject() to get a JSONObject, and then store all their necessary data into that.
   * @return the JSONObject containing this object's data.
   */
  JSONObject toJSONObject() {
    JSONObject j = new JSONObject();
    // Adds the "type" entry in the JSONObject to specify the class that should be deserialized into.
    String className = this.getClass().getSimpleName();
    j.setString("type", className);
    return j;
  }

  /**
   * Deserializes a JSONArray of JSONObjects into a ArrayList of the correct type.
   * @param  jsonArray the JSONArray to deserialize.
   * @return           An ArrayList of the deserialized array elements.
   */
  protected <T extends JSONSerializable> ArrayList<T> fromJSONArray(JSONArray jsonArray) {
    // Create an ArrayList to hold the deserialized objects.
    int length = jsonArray.size();
    ArrayList<T> list = new ArrayList<T>(length);

    for (int i = 0; i < length; i++) {
      // Get the JSONObject and its "type" entry.
      JSONObject jsonObj = jsonArray.getJSONObject(i);
      String type = jsonObj.getString("type");

      try {
        // Try to get the constructor for the specified class. We're specifically looking for a constructor that takes a JSONObject as the argument.
        Constructor constructor = Class.forName("Raytracer$" + type).getConstructor(Raytracer.class, JSONObject.class);
        // "Call" the constructor (instantiate the class with this jsonObj) and add it to the ArrayList.
        Object obj = constructor.newInstance(Raytracer.this, jsonObj);
        list.add((T) obj);
      }
      catch (ReflectiveOperationException e) {
        System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
        System.err.println("This probably means the scene JSON file is corrupted.");
      }
    }
    return list;
  }

  /**
   * Serializes an ArrayList into a JSONArray of serialized JSONObjects.
   * @param  array ArrayList to serialize.
   * @return       a JSONArray of serialized JSONObjects.
   */
  protected <T extends JSONSerializable> JSONArray toJSONArray(ArrayList<T> array) {
    // Create a JSONArray to hold the serialized JSONObjects.
    JSONArray jsonArray = new JSONArray();
    for (T obj : array)
      jsonArray.append(obj.toJSONObject()); // Serialize each object and append it to the output JSONArray.
    return jsonArray;
  }
}


/**
 * Thrown when the type indicated in the JSONObject's "type" key does not match the expected type.
 */
class JSONTypeMismatchException extends RuntimeException {
  JSONTypeMismatchException(String message) {
    super(message);
  }
}