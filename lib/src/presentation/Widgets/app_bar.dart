import 'package:flutter/material.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:loan_app/src/utils/responsive.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rp = Responsive(context);
    return Container(
      height: rp.hp(20),
      decoration: const BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(11.2),
              bottomRight: Radius.circular(11.2))),
      child: Stack(children: [
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Icon(Icons.menu, color: Colors.white, size: 32),
                Text("Inicio",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
                Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 32)
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
