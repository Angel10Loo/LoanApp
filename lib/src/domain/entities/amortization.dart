import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Amortization {
  String? loanId;
  String? amortizationId;
  int period;
  int quote;
  int interest;
  int principal;
  int remainingBalance;
  DateTime? paymentDate;
  bool isPayment;

  Amortization({
    required this.isPayment,
    this.amortizationId,
    this.loanId,
    this.paymentDate,
    required this.period,
    required this.quote,
    required this.interest,
    required this.principal,
    required this.remainingBalance,
  });

  static fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Amortization(
      amortizationId: snapshot.id,
      isPayment: data['isPayment'],
      paymentDate: (data['paymentDate'] as Timestamp).toDate(),
      loanId: data['loanId'],
      period: data['period'],
      quote: data['quote'],
      interest: data['interest'],
      principal: data['principal'],
      remainingBalance: data['remainingBalance'],
    );
  }
}
