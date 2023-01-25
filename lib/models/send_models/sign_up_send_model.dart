class SignupSendModel {
  String fullName;
  String email;
  int agreedTerm;

  SignupSendModel({
    required this.fullName,
    required this.email,
    required this.agreedTerm,
  });

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "email": email,
        "agreed_term": agreedTerm,
      };
}
