import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan_app/src/domain/enums/term_type.dart';

class Loan {
  String? loanId;
  int period;
  String customerName;
  double interest;
  double amount;
  String createdDate;
  TermType? termType;
  String? termTypevalue;
  int? dailyQuote;

  Loan(
      {this.loanId,
      this.termType,
      this.termTypevalue,
      required this.customerName,
      required this.createdDate,
      required this.period,
      required this.interest,
      required this.amount,
      this.dailyQuote});

  static fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Loan(
      loanId: snapshot.id,
      termTypevalue: data['termTypevalue'],
      period: data['period'],
      customerName: data['customerName'],
      interest: data['interest'],
      amount: data['amount'],
      createdDate: data['createdDate'],
      dailyQuote: data['dailyQoute'] ?? 0,
    );
  }
}
