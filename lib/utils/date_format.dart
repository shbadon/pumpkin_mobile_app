import 'package:intl/intl.dart';

String formatDateToDDMMYYYY(String date) {
  DateTime dateToConvert = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(dateToConvert);
  return formatted;
}

String formatDateToMMMMYYYY(String date) {
  DateTime dateToConvert = DateTime.parse(date);
  final DateFormat formatter = DateFormat('MMMMyyyy');
  final String formatted = formatter.format(dateToConvert);
  return formatted;
}


String formatDateTimeToDDMMYYYYHHMM(String date) {
  DateTime dateToConvert = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd MMM hh:mm a');
  final String formatted = formatter.format(dateToConvert);
  return formatted;
}

String formatTimeToHHMM(String date) {
  DateTime dateToConvert = DateTime.parse(date);
  final DateFormat formatter = DateFormat('hh:mm');
  final String formatted = formatter.format(dateToConvert);
  return formatted;
}


String formatDate(String date, String format) {
  DateTime dateToConvert = DateTime.parse(date);
  final DateFormat formatter = DateFormat(format);
  final String formatted = formatter.format(dateToConvert);
  return formatted;
}

String dateFormat1 = "dd-MM-yyyy";
String dateFormat2 = "yyyy-MM-dd";

String formatDateToDDEEEE(String date) {
  DateTime dateToConvert = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd. EEEE');
  final String formatted = formatter.format(dateToConvert);
  return formatted;
}
