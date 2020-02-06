import 'package:intl/intl.dart';

class DateConverterService {
  static String getDateAsString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
