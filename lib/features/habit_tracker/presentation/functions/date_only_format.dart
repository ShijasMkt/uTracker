import 'package:intl/intl.dart';

String dateOnlyFormatter(DateTime date){
  return DateFormat('yyyy-MM-dd').format(date);
}