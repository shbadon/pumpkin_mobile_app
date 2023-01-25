import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pumpkin/models/response_models/activities_ledger_response_model.dart';
import 'package:pumpkin/models/response_models/appointments_response_model.dart';
import 'package:pumpkin/models/response_models/enum_response_model.dart';
import 'package:pumpkin/models/response_models/lead_model.dart';
import 'package:pumpkin/models/response_models/notes_response_model.dart';
import 'package:pumpkin/models/send_models/Add_note_send_model.dart';
import 'package:pumpkin/models/send_models/add_appointment_send_model.dart';
import 'package:pumpkin/services/core_service.dart';
import 'package:pumpkin/utils/api_urls.dart';
import 'package:pumpkin/utils/screen_routes.dart';

class LeadProfileScreenController extends GetxController {
  RxBool isLoading = false.obs;
  var leadModel = LeadModel().obs;
  var notes = <NoteModel>[].obs;
  var appointments = <AppointmentModel>[].obs;
  RxString leadID = "".obs;
  TextEditingController headlineTextEditingController = TextEditingController();
  TextEditingController noteTextEditingController = TextEditingController();
  late FilePickerResult? filePickerResult;
  Rx<File> file = File("").obs;
  RxList<OneActivitiesLedger> activitiesList = <OneActivitiesLedger>[].obs;
  Rx<ActivityLedgerResponseModel> activityLedgerResponseModel =
      ActivityLedgerResponseModel().obs;

  getLeadDetails() async {
    try {
      isLoading.value = true;

      var responseBody = await CoreService()
          .getWithAuth(url: baseUrl + getLeadUrl + leadID.value);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        var result = LeadModel.fromJson(responseBody);
        leadModel.value = result;
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  Future<void> createNote() async {
    try {
      isLoading.value = true;

      var body = AddNoteSendModel(
        heading: headlineTextEditingController.text,
        note: noteTextEditingController.text,
      );

      var responseBody = await CoreService().postWithAuth(
          url: baseUrl + addNoteUrl + leadID.value, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        clearFields();
        isLoading.value = false;
        getNotes();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  getNotes() async {
    notes.clear();
    try {
      var responseBody = await CoreService()
          .getWithAuth(url: baseUrl + getAllNoteUrl + leadID.value);
      if (responseBody != null) {
        var results = NotesResponseModel.fromJson(responseBody);
        notes.value = results.data!;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      isLoading.value = true;

      var responseBody = await CoreService()
          .deleteWithAuth(url: baseUrl + addNoteUrl + noteId);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        getNotes();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  clearFields() {
    noteTextEditingController.clear();
    headlineTextEditingController.clear();
  }

  Future<void> updateNote(String noteId) async {
    try {
      isLoading.value = true;

      var body = AddNoteSendModel(
        heading: headlineTextEditingController.text,
        note: noteTextEditingController.text,
      );

      var responseBody = await CoreService()
          .putWithAuth(url: baseUrl + addNoteUrl + noteId, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        clearFields();
        isLoading.value = false;
        getNotes();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  // Future getImage() async {
  //   final pickedFile = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 30,
  //   );
  //   if (pickedFile != null) {
  //     debugPrint(pickedFile.path);
  //     images.value = File(pickedFile.path);
  //     uploadProfilePicture(leadID.value);
  //   } else {
  //     debugPrint('No image selected.');
  //   }
  // }

  Future getFile() async {
    filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      debugPrint(filePickerResult!.paths.toString());
      file.value = File(filePickerResult!.paths[0]!);
      uploadFile(leadID.value);
    } else {
      debugPrint('File not selected.');
    }
  }

  uploadFile(String leadID) async {
    isLoading.value = true;
    try {
      var responseBody = await CoreService().postFileWithAuth(
          upload: file.value.readAsBytesSync(),
          filename: file.value.path.split("/").last,
          url: baseUrl + uploadNoteFileUrl + leadID,
          key: 'file');
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        debugPrint(responseBody.toString());
        isLoading.value = false;
        getNotes();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  //appointment management
  TextEditingController dateTextEditingController = TextEditingController();
  TextEditingController startTimeTextEditingController =
      TextEditingController();
  TextEditingController endTimeTextEditingController = TextEditingController();
  var selectedAlert = EnumResponseModel();

  Future<void> addAppointment() async {
    try {
      isLoading.value = true;

      var body = AddAppointmentSendModel(
        startDatetime: dateTextEditingController.text +
            " " +
            startTimeTextEditingController.text,
        endDatetime: dateTextEditingController.text +
            " " +
            endTimeTextEditingController.text,
        note: noteTextEditingController.text,
        alertId: selectedAlert.code,
        leadId: leadID.value,
      );

      var responseBody = await CoreService().postWithAuth(
          url: baseUrl + addAppointmentUrl + leadID.value, body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        clearFields();
        isLoading.value = false;
        getAppointment();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  getAppointment() async {
    appointments.clear();
    try {
      var responseBody = await CoreService()
          .getWithAuth(url: baseUrl + getAllAppointmentUrl + leadID.value);
      if (responseBody != null) {
        var results = AppointmentsResponseModel.fromJson(responseBody);
        appointments.value = results.data!;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateAppointment(String appointmentID) async {
    try {
      isLoading.value = true;

      var body = AddAppointmentSendModel(
        startDatetime: dateTextEditingController.text +
            " " +
            startTimeTextEditingController.text,
        endDatetime: dateTextEditingController.text +
            " " +
            endTimeTextEditingController.text,
        note: noteTextEditingController.text,
        alertId: selectedAlert.code,
        leadId: leadID.value,
      );

      var responseBody = await CoreService().putWithAuth(
          url: baseUrl + addAppointmentUrl + appointmentID,
          body: body.toJson());
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        clearFields();
        isLoading.value = false;
        getAppointment();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  Future<void> deleteAppointment(String appointmentID) async {
    try {
      isLoading.value = true;

      var responseBody = await CoreService()
          .deleteWithAuth(url: baseUrl + addAppointmentUrl + appointmentID);
      if (responseBody == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        getAppointment();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  deleteLead() async {
    try {
      var responseBody = await CoreService()
          .deleteWithAuth(url: baseUrl + deleteLeadUrl + leadID.value);
      if (responseBody == null) {
      } else {
        Get.back();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getActivities() async {
    try {
      var responseBody = await CoreService()
          .getWithAuth(url: baseUrl + getActivitiesLedgerUrl);
      if (responseBody == null) {
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getActivities();
          }
        });
      } else {
        activityLedgerResponseModel.value =
            ActivityLedgerResponseModel.fromJson(responseBody);
        activitiesList.value =
            activityLedgerResponseModel.value.activitiesList ?? [];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // This API is called when the user taps on any of the tiles in the contact section eg: Call, Message, Facebook etc. We need to report it to backend and add it in activities
  addContactActivities(Map<String, dynamic> body) async {
    try {
      var responseBody = await CoreService().postWithAuth(
          url: baseUrl + addContactLeadActivityUrl + leadID.value, body: body);
      if (responseBody == null) {
        // Do nothing
      } else if (responseBody == 401) {
        CoreService()
            .getAccessToken(url: baseUrl + getAccessTokenUrl)
            .then((value) {
          if (value == null) {
            Get.offAllNamed(loginScreen);
          } else {
            getActivities();
          }
        });
      } else {
        // Do nothing
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
