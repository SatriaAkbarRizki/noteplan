import 'package:intl/intl.dart';

void main() {
  final date = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
  print(date);

}
