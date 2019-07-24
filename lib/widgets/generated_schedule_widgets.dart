import 'package:flutter/material.dart';
import '../data/global.dart';


scheduleItemWidget(ScheduleItem talk, List listRange) {

  DateTime startTime = (talk.session == Session.morning) ? DateTime.utc(2019, 7, 25, 9, 0) : DateTime.utc(2019, 7, 25, 12, 0);

  int cummulatedMinutes = 0;
  listRange.forEach((item) => cummulatedMinutes += item.minutes);

  DateTime scheduleTime = startTime.add(Duration(minutes: cummulatedMinutes));
  DateTime formattedTime = (talk.type == ScheduleItemType.networking) ?  DateTime.utc(2019, 7, 25, 17, 0) : scheduleTime;
  
  String minutesForm = talk.minutes == 1 ? '${talk.minutes} minute' : talk.minutes == 5 ? 'lightning' : '${talk.minutes} minutes';

  return ListTile(
    contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
    title: Text('${talk.name}', 
      textScaleFactor: 0.9,
      style: TextStyle(color: Colors.blue[600])
    ),
    subtitle: Text('${talk.type == ScheduleItemType.networking ? '' : minutesForm}',textScaleFactor: 0.8),
    leading: Container(
      width: 90,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.topCenter,
      child: Text('${formattedTime.hour > 12 ? formattedTime.hour-12 : formattedTime.hour}:${formattedTime.minute < 10 ? '0${formattedTime.minute}' : formattedTime.minute} ${formattedTime.hour >= 12 ? 'PM' : 'AM'}',
      style: TextStyle(fontSize: 16)),
    ),
  );
}