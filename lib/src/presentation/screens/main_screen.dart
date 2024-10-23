import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_app/src/domain/entities/customer.dart';
import 'package:loan_app/src/domain/entities/income.dart';
import 'package:loan_app/src/domain/entities/loan.dart';
import 'package:loan_app/src/domain/services/firebase_service.dart';
import 'package:loan_app/src/presentation/Widgets/app_bar.dart';
import 'package:loan_app/src/presentation/Widgets/bottom_tab.dart';
import 'package:loan_app/src/presentation/Widgets/chart_widget.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:loan_app/src/utils/helper.dart';
import 'package:loan_app/src/utils/responsive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int loanIncome = 0;
double invesmentCapital = 0;
int customerCount = 0;

class _MainScreenState extends State<MainScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Income _income =
      Income(createdDate: Timestamp.fromDate(DateTime.now()), income: 0);
  List<Loan> _loans = [];
  @override
  void initState() {
    super.initState();
    invesmentCapital = 0;
    fetchIncome();
    fetchLoanInvestmentCapital();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    List<Customer>? customers = await _firebaseService.getCustomers();
    customerCount = customers.length;
  }

  Future<void> fetchLoanInvestmentCapital() async {
    QuerySnapshot<Map<String, dynamic>>? document =
        await _firebaseService.getLoans();

    _loans = document!.docs
        .map((doc) => Loan.fromSnapshot(doc))
        .toList()
        .cast<Loan>();

    for (Loan element in _loans) {
      invesmentCapital += element.amount;
    }
  }

  Future<void> fetchIncome() async {
    _income = await _firebaseService.getIncome();
    setState(() {
      loanIncome = _income.income.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    var rp = Responsive(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bodyColor,
        appBar: appbarWidget(rp: rp),
        body: SingleChildScrollView(
          child: SizedBox(
            // Constrain the width of the child
            width: rp.width,
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: rp.hp(10),
                    child: SizedBox(
                      height: 400,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Ganancias ",
                                style: TextStyle(
                                    fontSize: rp.dp(2.8),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.monetization_on,
                                    size: rp.dp(3.01),
                                    color: Colors.green,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                      Helper.formatNumberWithCommas(
                                          loanIncome.toString()),
                                      style: TextStyle(fontSize: rp.dp(2.8))),
                                ),
                              ],
                            ),
                          ]),
                    )),
                SizedBox(height: rp.hp(2)),
                const SizedBox(
                    width: double.infinity,
                    height: 200.0,
                    child: ChartWidget()),
                SizedBox(
                    height: rp.hp(10),
                    child: SizedBox(
                      height: 400,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Ganancias ",
                                style: TextStyle(
                                    fontSize: rp.dp(2.8),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.monetization_on,
                                    size: rp.dp(3.01),
                                    color: Colors.green,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                      Helper.formatNumberWithCommas(
                                          loanIncome.toString()),
                                      style: TextStyle(fontSize: rp.dp(2.8))),
                                ),
                              ],
                            ),
                          ]),
                    )),
                const SizedBox(
                    width: double.infinity,
                    height: 200.0,
                    child: ChartWidget()),

                //
                // .
                //siz.. add more child widgets as needed
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomTabs(),
      ),
    );
  }
}

class appbarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(200.0);

  const appbarWidget({
    Key? key,
    required this.rp,
  }) : super(key: key);

  final Responsive rp;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(children: <Widget>[
          const AppBarWidget(),
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: rp.hp(0.06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: rp.hp(7),
                  width: rp.wp(28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Prestamos',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      Text(Helper.formatNumberWithCommas(
                          invesmentCapital.toString()))
                    ],
                  ),
                ),
                Container(
                  height: rp.hp(7),
                  width: rp.wp(28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Inventario',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: rp.hp(7),
                  width: rp.wp(28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Clientes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      Text(customerCount.toString())
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ],
    );
  }
}
