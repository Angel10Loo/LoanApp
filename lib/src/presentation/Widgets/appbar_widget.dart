import 'package:flutter/material.dart';
import 'package:loan_app/src/utils/constans.dart';

class AppBarCustomWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(56.0);
  const AppBarCustomWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      elevation: 8.0,
      backgroundColor: mainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
      ),
    );
  }
}
