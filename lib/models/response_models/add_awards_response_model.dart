class AddAwardsResponseModel {
  String? message;
  Award? showData;
  AddAwardsResponseModel({this.message, this.showData});
  factory AddAwardsResponseModel.fromJson(Map<String, dynamic> json) =>
      AddAwardsResponseModel(
        message: json['message'],
        showData: Award.fromJson(json['showData']),
      );
}

class Award {
  int? id;
  String? name;
  String? year;
  String? description;

  Award({this.id, this.name, this.year, this.description});

  factory Award.fromJson(Map<String, dynamic> json) => Award(
        id: json['id'],
        name: json['name'],
        year: json["year"],
        description: json["description"],
      );
}
