class NotesResponseModel {
  NotesResponseModel({
      this.data,});

  NotesResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NoteModel.fromJson(v));
      });
    }
  }
  List<NoteModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class NoteModel {
  NoteModel({
      this.id, 
      this.heading, 
      this.note, 
      this.file, 
      this.fileFormat, 
      this.fileSize, 
      this.leadId, 
      this.createdUserId, 
      this.updatedUserId, 
      this.createdAt, 
      this.updatedAt, 
      this.status,});

  NoteModel.fromJson(dynamic json) {
    id = json['id'];
    heading = json['heading'];
    note = json['note'];
    file = json['file'];
    fileFormat = json['file_format'];
    fileSize = json['file_size'];
    leadId = json['lead_id'];
    createdUserId = json['created_user_id'];
    updatedUserId = json['updated_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }
  String? id;
  String? heading;
  String? note;
  dynamic file;
  dynamic fileFormat;
  dynamic fileSize;
  String? leadId;
  String? createdUserId;
  dynamic updatedUserId;
  String? createdAt;
  dynamic updatedAt;
  dynamic status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['heading'] = heading;
    map['note'] = note;
    map['file'] = file;
    map['file_format'] = fileFormat;
    map['file_size'] = fileSize;
    map['lead_id'] = leadId;
    map['created_user_id'] = createdUserId;
    map['updated_user_id'] = updatedUserId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    return map;
  }

}