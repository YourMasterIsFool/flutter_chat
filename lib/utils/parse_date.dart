import 'package:intl/intl.dart';

getTime(DateTime date) {
  return DateFormat("hh:mm").format(date);
}

getDate(DateTime date) {
  return DateFormat("dd/MM/yyyy").format(date);
}

chatDate(int firebaseSeconds) {
  DateTime currentDate = DateTime.now();

  var dt = DateTime.fromMillisecondsSinceEpoch(firebaseSeconds * 1000);

  var time_now = getTime(currentDate);
  var chat_time = getTime(dt);

  var date_now = getDate(currentDate);
  var chat_date = getDate(dt);

  if (date_now == chat_date) {
    return chat_time;
  }

  return chat_date;
}
