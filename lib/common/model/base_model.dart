abstract class BaseModel {
  ///Create a function for working with api, database smoothly
  Map<String, dynamic> toJson();

  ///inherit  add fromJson func if need
  ///factory BaseModel.fromJson(Map<String, dynamic> json);
}
