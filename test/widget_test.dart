import 'package:intl/intl.dart';

void main() {
  final time = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
  print(time);

  final date = DateFormat("d/M/y").format(DateTime.now());
  print(date);
}
