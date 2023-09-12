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
}
