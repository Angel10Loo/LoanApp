import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  String? incomeId;
  Timestamp createdDate;
  double income;

  Income({
    this.incomeId,
    required this.createdDate,
    required this.income,
  });

  static fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Income(
      incomeId: snapshot.id,
      income: data['income'],
      createdDate: data['createdDate'],
    );
  }
}
