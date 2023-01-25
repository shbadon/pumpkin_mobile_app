class AppointmentsResponseModel {
  AppointmentsResponseModel({
      this.data,});

  AppointmentsResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(AppointmentModel.fromJson(v));
      });
    }
  }
  List<AppointmentModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class AppointmentModel {
  AppointmentModel({
      this.id, 
      this.startDatetime, 
      this.endDatetime, 
      this.note, 
      this.alertId, 
      this.leadId, 
      this.appointmentType, 
      this.appointmentObjectives, 
      this.status, 
      this.createdUserId, 
      this.updatedUserId, 
      this.createdAt, 
      this.updatedAt,});

  AppointmentModel.fromJson(dynamic json) {
    id = json['id'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    note = json['note'];
    alertId = json['alert_id'];
    leadId = json['lead_id'];
    appointmentType = json['appointment_type'];
    appointmentObjectives = json['appointment_objectives'];
    status = json['status'];
    createdUserId = json['created_user_id'];
    updatedUserId = json['updated_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? startDatetime;
  String? endDatetime;
  String? note;
  String? alertId;
  String? leadId;
  dynamic appointmentType;
  dynamic appointmentObjectives;
  String? status;
  String? createdUserId;
  dynamic updatedUserId;
  String? createdAt;
  dynamic updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['start_datetime'] = startDatetime;
    map['end_datetime'] = endDatetime;
    map['note'] = note;
    map['alert_id'] = alertId;
    map['lead_id'] = leadId;
    map['appointment_type'] = appointmentType;
    map['appointment_objectives'] = appointmentObjectives;
    map['status'] = status;
    map['created_user_id'] = createdUserId;
    map['updated_user_id'] = updatedUserId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}