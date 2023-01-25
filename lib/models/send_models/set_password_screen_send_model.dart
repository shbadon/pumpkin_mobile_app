class SetPasswordScreenSendModel {
  String email;
  String newPassword;
  String confirmPassword;
  String userType;

  SetPasswordScreenSendModel(
      {required this.email,
      required this.newPassword,
      required this.confirmPassword,
      this.userType = 'agent'});

  Map<String, dynamic> toJson() => {
        "email": email,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
        "user_type": userType,
      };
}
