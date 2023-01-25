class AddNoteSendModel {
  AddNoteSendModel({
      this.heading, 
      this.note,});

  AddNoteSendModel.fromJson(dynamic json) {
    heading = json['heading'];
    note = json['note'];
  }
  String? heading;
  String? note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['heading'] = heading;
    map['note'] = note;
    return map;
  }

}