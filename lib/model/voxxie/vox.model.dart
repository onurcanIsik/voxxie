class VoxModel {
  String? voxName;
  String? voxGen;
  String? voxAge;
  String? voxColor;
  String? voxLoc;
  String? voxInfo;
  String? voxImage;
  String? date;
  String? voxID;
  String? userID;
  String? ownerMail;

  VoxModel({
    required this.voxName,
    required this.voxGen,
    required this.voxAge,
    required this.voxColor,
    required this.voxLoc,
    required this.voxInfo,
    required this.voxImage,
    required this.date,
    this.voxID,
    this.userID,
    this.ownerMail,
  });

  factory VoxModel.fromMap(Map<String, dynamic> map) {
    return VoxModel(
      voxName: map['voxName'] ?? '',
      voxGen: map['voxGen'] ?? '',
      voxAge: map['voxAge'] ?? '',
      voxColor: map['voxColor'] ?? '',
      voxLoc: map['voxLoc'] ?? '',
      voxInfo: map['voxInfo'] ?? '',
      voxImage: map['voxImage'] ?? '',
      date: map['voxDate'] ?? '',
      voxID: map['voxID'] ?? '',
      userID: map['userID'] ?? '',
      ownerMail: map['ownerMail'] ?? '',
    );
  }
}
