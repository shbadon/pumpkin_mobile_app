class EnumResponseModel {
  EnumResponseModel({
      this.description = '',
      this.code = '',
      this.order = 0});

  EnumResponseModel.fromJson(dynamic json) {
    description = json['description'];
    code = json['code'];
    order = json['order'] == null ? 0 : num.parse(json['order'].toString());
  }
  String? description;
  String? code;
  num? order;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['code'] = code;
    map['order'] = order;
    return map;
  }

}