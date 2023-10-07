import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_app/src/domain/entities/income.dart';
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

class _MainScreenState extends State<MainScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Income _income =
      Income(createdDate: Timestamp.fromDate(DateTime.now()), income: 0);
  @override
  void initState() {
    super.initState();
    fetchIncome();
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
                                "Ganancias ${Helper.formatNumberWithCommas(loanIncome.toString())}",
                                style: TextStyle(fontSize: rp.dp(2.8)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.monetization_on,
                                  size: rp.dp(3.01)),
                            )
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
                                "Ganancias",
                                style: TextStyle(fontSize: rp.dp(2.8)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.monetization_on,
                                  size: rp.dp(3.01)),
                            )
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
                  height: rp.hp(10),
                  width: rp.wp(28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    children: <Widget>[
                      Text('Prestamos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ),
                Container(
                  height: rp.hp(10),
                  width: rp.wp(28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    children: <Widget>[
                      Text('Inventario',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ),
                Container(
                  height: rp.hp(10),
                  width: rp.wp(28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Column(
                    children: <Widget>[
                      Text('Clientes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
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
