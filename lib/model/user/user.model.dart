class UserModel {
  String? userMail;
  String? userName;
  String? userID;
  String? userImage;

  UserModel({
    required this.userMail,
    required this.userName,
    required this.userID,
    required this.userImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userMail: map['userMail'] ?? '',
      userName: map['userName'] ?? '',
      userID: map['userID'] ?? '',
      userImage: map['userImage'] ?? '',
    );
  }
}
