/// File that gather several tools use in some files
import 'dart:math' show pow;


/// Format a DateTime into 'dd/MM/yyyy at HH:mm'
String formatDate(DateTime dateTime) {
  // Get the following fields
  final String day = dateTime.day.toString().padLeft(2, '0');
  final String month = dateTime.month.toString().padLeft(2, '0');
  final String year = dateTime.year.toString().padLeft(4, '0');
  final String hours = dateTime.hour.toString().padLeft(2, '0');
  final String minutes = dateTime.minute.toString().padLeft(2, '0');

  // Return the formatted string
  return '$day/$month/$year at $hours:$minutes';
}

/// Round a double to N decimals
double roundDoubleToDecimals(double number, { int decimals = 2 }) {
  final multiplication = pow(10, decimals);

  return (number * multiplication).round() / multiplication;
}