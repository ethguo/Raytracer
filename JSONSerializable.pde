class JSONSerializable {
  JSONSerializable() {}

  JSONSerializable(JSONObject j) {
    String className = this.getClass().getSimpleName();
    println(className);
    String jsonType = j.getString("type");
    if (jsonType != className) throw new JSONTypeMismatchException("Invalid type for conversion in JSON object: expected " + className + ", got " + jsonType);

    Field[] fields = this.getClass().getFields();
    printArray(fields);
  }

  JSONObject toJSONObject() {
    JSONObject j = new JSONObject();

    // Adds the "type" key in the JSONObject to specify the class that should be deserialized into.
    String className = this.getClass().getSimpleName();
    j.setString("type", className);

    // Gets all public fields of this class.
    Field[] fields = this.getClass().getFields();
    for (Field field : fields) {
      try {
        String fieldName = field.getName();
        String fieldType = field.getType().getSimpleName();
        // From the Javadocs, 'The simple name of an array is the simple name of the component type with "[]" appended.'
        // Handle array types as a JSONArray.
        if (fieldType.endsWith("[]")) {
          JSONArray jsonArray = new JSONArray();
          Object[] objects = (Object[]) field.get(this);
          // String fieldItemType = fieldType.substring(0, fieldType.length()-2);
          switch (fieldType) {
            case "boolean[]":
              for (boolean obj : (Boolean[]) objects) jsonArray.append(obj);
              break;
            case "float[]":
              for (float obj : (Float[]) objects) jsonArray.append(obj);
              break;
            case "int[]":
              for (int obj : (Integer[]) objects) jsonArray.append(obj);
              break;
            case "String[]":
              for (String obj : (String[]) objects) jsonArray.append(obj);
              break;
            default:
              if (objects instanceof JSONSerializable[]) {
                for (JSONSerializable obj : (JSONSerializable[]) objects) jsonArray.append(obj.toJSONObject());
              }
          }
          j.setJSONArray(fieldName, jsonArray);
        }
        else {
          switch (fieldType) {
            // Handle primitive types
            case "boolean":
              j.setBoolean(fieldName, field.getBoolean(this));
              break;
            case "float":
              j.setFloat(fieldName, field.getFloat(this));
              break;
            case "int":
              j.setInt(fieldName, field.getInt(this));
              break;
            case "String":
              j.setString(fieldName, (String) field.get(this));
              break;
            default:
              // If not a primitive type, try handling it as a JSONSerializable.
              Object obj = field.get(this);
              if (obj instanceof JSONSerializable) {
                j.setJSONObject(fieldName, ((JSONSerializable) obj).toJSONObject());
              }
          }
        }
      }
      catch (IllegalAccessException e) {
        System.err.println("IllegalAccessException: " + e.getMessage());
      }
    }

    return j;
  }
}


class JSONTypeMismatchException extends RuntimeException {
  JSONTypeMismatchException(String message) {
    super(message);
  }
}