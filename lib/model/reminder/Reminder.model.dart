class ReminderModel {
  String? date;
  String? drugName;
  String? petImage;
  String? petName;
  String? docID;
  String? userID;

  ReminderModel({
    required this.date,
    required this.drugName,
    required this.petImage,
    required this.petName,
    required this.docID,
    required this.userID,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      date: map['date'] ?? '',
      drugName: map['drugName'] ?? '',
      petImage: map['petImage'] ?? '',
      petName: map['petName'] ?? '',
      docID: map['docID'] ?? '',
      userID: map['userID'] ?? '',
    );
  }
}
