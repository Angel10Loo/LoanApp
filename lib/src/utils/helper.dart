class Helper {
  static bool validateCedula(String cedula) {
    // Expresión regular para validar la cédula dominicana (10 dígitos numéricos).
    RegExp regex = RegExp(r'^\d{10}$');

    if (!regex.hasMatch(cedula)) {
      return false;
    }
    // Regla específica para verificar el dígito verificador.
    int lastDigit = int.parse(cedula[9]);
    int sum = 0;

    for (int i = 0; i < 9; i++) {
      int digit = int.parse(cedula[i]);
      if (i % 2 == 0) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
    }

    int remainder = sum % 10;
    int calculatedCheckDigit = (remainder == 0) ? 0 : (10 - remainder);

    return lastDigit == calculatedCheckDigit;
  }

  static String formatNumberWithCommas(String number) {
    String formattedNumber = number;
    final RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');

    return formattedNumber.replaceAllMapped(regExp, (Match match) => ',');
  }

  static bool isValidInput(String input) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(input);
  }

  static String removeSpecialCharacters(String input) {
    RegExp specialCharRegex = RegExp(r'[^\w\s]');
    return input.replaceAll(specialCharRegex, '');
  }

  static String removeTrailingZeros(double value) {
    String stringValue = value.toString();
    if (stringValue.contains('.')) {
      // Remove trailing zeros after the decimal point
      stringValue = stringValue.replaceAll(RegExp(r"0*$"), "");
      // Remove the decimal point if no decimal part remains
      if (stringValue.endsWith('.')) {
        stringValue = stringValue.substring(0, stringValue.length - 1);
        stringValue = stringValue.substring(0, stringValue.length - 1);
      }
    }
    return stringValue;
  }

  static String removeTrailingZerosToUseLoan(double value) {
    String stringValue = value.toString();
    if (stringValue.contains('.')) {
      // Remove trailing zeros after the decimal point
      stringValue = stringValue.replaceAll(RegExp(r"0*$"), "");
      // Remove the decimal point if no decimal part remains
      if (stringValue.endsWith('.')) {
        stringValue = stringValue.substring(0, stringValue.length - 1);
      }
    }
    return stringValue;
  }

  static DateTime parseDate(String dateString) {
    // Split the string into date and time parts
    List<String> dateAndTime = dateString.split(' ');

    // Split the date part into day, month, and year
    List<String> dateParts = dateAndTime[0].split('-');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Split the time part into hour and minute
    List<String> timeParts = dateAndTime[1].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Create a DateTime object
    DateTime dateTime = DateTime(year, month, day, hour, minute);
    return dateTime;
  }

  static bool isDateInCurrentMonth(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}
