import 'package:flutter/material.dart';

class ShowAlertInfo {
  static Future<bool?> showConfirmationDialog(
      BuildContext context, String content, String title, Widget icon) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Clicking outside the dialog will not dismiss it
      builder: (BuildContext context) {
        return AlertDialog(
          icon: icon,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8.0,
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
