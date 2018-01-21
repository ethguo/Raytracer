class JSONSerializable {
  JSONSerializable() {}

  public JSONSerializable(JSONObject j) {
    String className = this.getClass().getSimpleName();
    String jsonType = j.getString("type");
    if (!jsonType.equals(className)) throw new JSONTypeMismatchException("Invalid type for conversion in JSON object: expected " + className + ", got " + jsonType);
  }

  JSONObject toJSONObject() {
    JSONObject j = new JSONObject();
    // Adds the "type" key in the JSONObject to specify the class that should be deserialized into.
    String className = this.getClass().getSimpleName();
    j.setString("type", className);
    return j;
  }
}


class JSONTypeMismatchException extends RuntimeException {
  JSONTypeMismatchException(String message) {
    super(message);
  }
}