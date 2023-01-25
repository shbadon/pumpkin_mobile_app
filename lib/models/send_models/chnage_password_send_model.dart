class ChangePasswordSendModel {
  String oldPassword;
  String newPassword;
  String confirmPassword;

  ChangePasswordSendModel(
      {required this.oldPassword,
      required this.newPassword,
      required this.confirmPassword});

  Map<String, dynamic> toJson() => {
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword
      };
}
