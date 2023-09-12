import 'package:flutter/material.dart';
import 'package:loan_app/src/presentation/Widgets/app_bar.dart';
import 'package:loan_app/src/presentation/Widgets/bottom_tab.dart';
import 'package:loan_app/src/utils/responsive.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rp = Responsive(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                      width: rp.wp(25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: const <Widget>[
                          Text('Prestamos',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                        ],
                      ),
                    ),
                    Container(
                      height: rp.hp(10),
                      width: rp.wp(25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: const <Widget>[
                          Text('Inventario',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                        ],
                      ),
                    ),
                    Container(
                      height: rp.hp(10),
                      width: rp.wp(25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: const <Widget>[
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
        ),
        bottomNavigationBar: const BottomTabs(),
      ),
    );
  }
}
