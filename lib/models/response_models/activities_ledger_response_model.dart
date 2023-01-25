class ActivityLedgerResponseModel {
  List<OneActivitiesLedger>? activitiesList;
  ActivityLedgerResponseModel({this.activitiesList});

  factory ActivityLedgerResponseModel.fromJson(List json) {
    return ActivityLedgerResponseModel(
      activitiesList: List<OneActivitiesLedger>.from(
          json.map((data) => OneActivitiesLedger.fromJson(data))),
    );
  }
}

class OneActivitiesLedger {
  String? id;
  String? activityId;
  String? activityType;
  String? activityLabel;
  String? leadId;
  String? point;
  String? appointmentId;
  String? status;
  String? createdByUserId;
  String? updatedByUserId;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? startDateTime;
  String? endDateTime;
  String? appointmentObjectives;
  String? appointmentType;
  String? appointmentStatus;

  OneActivitiesLedger(
      {this.id,
      this.activityId,
      this.activityType,
      this.activityLabel,
      this.leadId,
      this.point,
      this.appointmentId,
      this.status,
      this.createdByUserId,
      this.updatedByUserId,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.startDateTime,
      this.endDateTime,
      this.appointmentObjectives,
      this.appointmentType,
      this.appointmentStatus});

  factory OneActivitiesLedger.fromJson(Map<String, dynamic> json) {
    return OneActivitiesLedger(
      id: json['id'],
      activityId: json['activity_id'],
      activityType: json['activity_type'],
      activityLabel: json['activity_label'],
      leadId: json['lead_id'],
      point: json['point'],
      appointmentId: json['appointment_id'],
      status: json['status'],
      createdByUserId: json['created_user_id'],
      updatedByUserId: json['updated_user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      startDateTime: json['start_datetime'],
      endDateTime: json['end_datetime'],
      appointmentObjectives: json['appointment_objectives'],
      appointmentType: json['appointment_type'],
      appointmentStatus: json['appointment_status'],
    );
  }
}
