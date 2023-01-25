class HeaderModel {
  String? authorization;

  HeaderModel({
    required this.authorization,
  });

  factory HeaderModel.fromJson(Map<String, dynamic> json) => HeaderModel(
        authorization: json["Authorization"],
      );

  Map<String, dynamic> toJson() => {
        "Authorization": authorization,
      };
  Map<String, String> toHeader() => {
        "Authorization": authorization ?? " ",
        "Content-Type": "application/json"
      };

  Map<String, String> toHeaderFileUpload() => {
        "Authorization": authorization ?? " ",
        // "Content-Type": "multipart/form-data",
        //"Content-Type": "multipart-formdata"
      };
}
