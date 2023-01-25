class UploadFileScreenResponseModel {
  List<OneFileModel>? filesList;

  UploadFileScreenResponseModel({this.filesList});

  factory UploadFileScreenResponseModel.fromJson(List json) =>
      UploadFileScreenResponseModel(
        filesList: List<OneFileModel>.from(
            json.map((data) => OneFileModel.fromJson(data))),
      );
}

class OneFileModel {
  String? id;
  String? fileName;
  String? userId;
  String? status;
  String? error;
  String? createdUserId;
  String? updatedUserId;
  String? createdAt;
  String? updatedAt;

  OneFileModel(
      {this.id,
      this.fileName,
      this.userId,
      this.status,
      this.error,
      this.createdUserId,
      this.updatedUserId,
      this.createdAt,
      this.updatedAt});
  factory OneFileModel.fromJson(Map<String, dynamic> json) => OneFileModel(
        id: json['id'],
        fileName: json['filename'],
        userId: json['user_id'],
        status: json['status'],
        error: json['error'],
        createdUserId: json['created_user_id'],
        updatedUserId: json['updated_user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}
