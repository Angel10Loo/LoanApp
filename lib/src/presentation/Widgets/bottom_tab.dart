import 'package:flutter/material.dart';
import 'package:loan_app/src/presentation/screens/customer_screen.dart';
import 'package:loan_app/src/utils/constans.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({Key? key}) : super(key: key);

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 10.5,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        selectedLabelStyle:
            const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        onTap: (value) => redirectToScreen(value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            label: 'Prestamos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_outlined),
            label: 'Clientes',
          ),
        ]);
  }

  void redirectToScreen(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddCustomerScreen(),
        ));
      } else if (index == 2) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddCustomerScreen(),
        ));
      } else if (index == 3) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddCustomerScreen(),
        ));
      } else if (index == 4) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddCustomerScreen(),
        ));
      }
    });
  }
}
