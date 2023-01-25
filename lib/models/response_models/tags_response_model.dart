class TagsResponseModel {
  List<OneTag>? tags;

  TagsResponseModel({this.tags});
  factory TagsResponseModel.fromJson(Map<String, dynamic> json) =>
      TagsResponseModel(
        tags: List<OneTag>.from(
            json['data'].map((data) => OneTag.fromJson(data))),
      );
}

class OneTag {
  int? id;
  String? name;
  bool isSelected;

  OneTag({this.id, this.name, this.isSelected = false});

  factory OneTag.fromJson(Map<String, dynamic> json) => OneTag(
        id: json["id"],
        name: json["name"],
      );
}
