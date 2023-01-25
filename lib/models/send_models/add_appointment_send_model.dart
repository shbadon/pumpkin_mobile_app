class AddAppointmentSendModel {
  AddAppointmentSendModel({
      this.startDatetime, 
      this.endDatetime, 
      this.note, 
      this.alertId, 
      this.leadId,});

  AddAppointmentSendModel.fromJson(dynamic json) {
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    note = json['note'];
    alertId = json['alert_id'];
    leadId = json['lead_id'];
  }
  String? startDatetime;
  String? endDatetime;
  String? note;
  String? alertId;
  String? leadId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start_datetime'] = startDatetime;
    map['end_datetime'] = endDatetime;
    map['note'] = note;
    map['alert_id'] = alertId;
    map['lead_id'] = leadId;
    return map;
  }

}