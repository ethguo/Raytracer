<T extends JSONSerializable> ArrayList<T> fromJSONArray(JSONArray jsonArray) {
  int length = jsonArray.size();
  ArrayList<T> list = new ArrayList<T>(length);
  for (int i = 0; i < length; i++) {
    JSONObject jsonObj = jsonArray.getJSONObject(i);
    String type = jsonObj.getString("type");

    try {
      // printArray(Class.forName("Raytracer$" + type).getConstructors());
      Constructor constructor = Class.forName("Raytracer$" + type).getConstructor(Raytracer.class, JSONObject.class);
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

<T extends JSONSerializable> JSONArray toJSONArray(ArrayList<T> array) {
  JSONArray jsonArray = new JSONArray();
  for (T obj : array)
    jsonArray.append(obj.toJSONObject());
  return jsonArray;
}