import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_app/src/domain/entities/amortization.dart';
import 'package:loan_app/src/domain/services/firebase_service.dart';
import 'package:loan_app/src/presentation/Widgets/alertInfo.dart';
import 'package:loan_app/src/presentation/Widgets/appbar_widget.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:loan_app/src/utils/helper.dart';
import 'package:loan_app/src/utils/responsive.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Amortization> _amortizations = [];
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final rp = Responsive(context);
    final String id = args!["id"];
    final String customerName = args["customerName"];
    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: bodyColor,
          appBar: const AppBarCustomWidget(
              title: "Pagos de Prestamos", isCentered: true),
          body: Column(children: <Widget>[
            const SizedBox(height: 20.1),
            Stack(
              children: [
                Container(
                  height: rp.hp(6.9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: mainColor,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
                Positioned(
                    top: 8,
                    left: 28,
                    child: Column(
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 20.1),
            getAmortizationBaseOnLoanId(id, rp)
          ]),
        ));
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>?>
      getAmortizationBaseOnLoanId(String id, Responsive rp) {
    return FutureBuilder(
      future: _firebaseService.getAmortizationBaseOnLoanId(id),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.data.docs.length > 0) {
            _amortizations = snapshot.data.docs
                .map((doc) => Amortization.fromSnapshot(doc))
                .toList()
                .cast<Amortization>();
            return _listViewAmortizations(_amortizations);
          } else {
            return Container(
              margin: EdgeInsets.only(top: rp.dp(20)),
              child: const Center(
                  child: Text(
                "No tenemos prestamos registrado 😔",
                style: TextStyle(fontSize: 17),
              )),
            );
          }
        }
      },
    );
  }

  Expanded _listViewAmortizations(List<Amortization> amortizations) {
    amortizations.sort((a, b) => a.period.compareTo(b.period));
    int minNumber = findSmallestNumber(amortizations);
    return Expanded(
      child: ListView.builder(
        itemCount: amortizations.length,
        itemBuilder: (context, index) {
          Amortization amortization = amortizations[index];
          return Card(
            elevation: 2,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          child: Text("${amortization.period}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ),
                      ),
                      amortization.isPayment
                          ? const Text("Pagado",
                              style: TextStyle(
                                  color: successColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400))
                          : const Text("")
                    ],
                  ),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Interés : ${Helper.formatNumberWithCommas(Helper.removeTrailingZerosToUseLoan(amortization.interest.toDouble()))}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 17),
                        ),
                        Text(
                          "Capital : ${Helper.formatNumberWithCommas(Helper.removeTrailingZerosToUseLoan(amortization.principal.toDouble()))}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 17),
                        ),
                        Text(
                          "Cuota : ${Helper.formatNumberWithCommas(Helper.removeTrailingZerosToUseLoan(amortization.quote.toDouble()))}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 17),
                        ),
                        Text(
                          "Balance Pendiente : ${Helper.formatNumberWithCommas(amortization.remainingBalance.toString())}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 17),
                        ),
                        Text(
                          "Fecha De Pago : ${DateFormat("dd-MM-yyyy").format(amortization.paymentDate!)} ",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 17),
                        )
                      ]),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: handlePaymentAndPrint(
                      amortization.amortizationId!,
                      amortization.isPayment,
                      minNumber,
                      amortization.period,
                      amortization.interest.toDouble()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TextButton handlePaymentAndPrint(String amortizationId, bool isPayment,
      int minNumber, int currentNumber, double income) {
    final FirebaseService _firebaseService = FirebaseService();
    return isPayment
        ? TextButton(
            style: TextButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 10.3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13))),
            onPressed: () {
              // Handle button press
            },
            child: const Row(
              children: [Icon(Icons.print)],
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                elevation: 10.3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13))),
            onPressed: minNumber == currentNumber
                ? () async {
                    bool? accept = await ShowAlertInfo.showConfirmationDialog(
                        context,
                        "Estas seguro que deseas realizar este pago ?",
                        "Advertencia",
                        Icon(Icons.warning, color: Colors.yellow.shade700));
                    if (accept!) {
                      await _firebaseService
                          .updateAmortizationIsPayment(
                              amortizationId, isPayment = true)
                          .then((value) => {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_showSnackBar(context)),
                              })
                          .whenComplete(
                        () {
                          _firebaseService.updateIncome(income);
                        },
                      );

                      setState(() {});
                    }
                  }
                : null,
            child: const Row(
              children: [Icon(Icons.money_off_rounded), Text("Pagar")],
            ),
          );
  }

  int findSmallestNumber(List<Amortization> data) {
    if (data.isEmpty) {
      throw ArgumentError('The list is empty.');
    }
    int minNumber = 0;
    try {
      Amortization item = data.firstWhere((element) => !element.isPayment);
      minNumber = item.period;
      for (int i = 1;
          i < data.where((element) => !element.isPayment).length;
          i++) {
        if (!data[i].isPayment && data[i].period < minNumber) {
          minNumber = data[i].period;
        }
      }
    } catch (e) {
      print(e);
    }

    return minNumber;
  }

  SnackBar _showSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      backgroundColor: successColor,
      content: const Text(
        'El pago se registro de manera exitosa**',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
        textColor: Colors.white,
      ),
    );
  }
}
