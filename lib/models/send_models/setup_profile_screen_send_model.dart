class SetupProfileScreenSendModel {
  String firstName;
  String lastName;
  String dateOfBirth;
  String gender;
  String profileMessage;
  String email;

  SetupProfileScreenSendModel(
      {required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.profileMessage,
      required this.email});

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "dob": dateOfBirth,
        "gender": gender,
        "profile_msg": profileMessage,
        "email": email
      };
}
