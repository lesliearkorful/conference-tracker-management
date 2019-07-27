import 'package:flutter/material.dart';
import '../data/global.dart';


class TrackHeader extends StatelessWidget {
  TrackHeader({this.trackNumber});
  final int trackNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('TrackHeader'),
      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
      color: Colors.black.withOpacity(0.05),
      child: Text('Track $trackNumber',
        textScaleFactor: 1.4,
        style: TextStyle(
          color: Colors.blue[700]
        )
      )
    );
  }
}

Widget scheduleItemWidget(ScheduleItem talk, List listRange) {

  DateTime startTime = (talk.session == Session.morning) ? 
                        DateTime.utc(2019, 7, 25, 9, 0) : DateTime.utc(2019, 7, 25, 12, 0);

  int cummulatedMinutes = 0;
  listRange.forEach((item) => cummulatedMinutes += item.minutes);

  DateTime scheduleTime = startTime.add(Duration(minutes: cummulatedMinutes));

  DateTime formattedTime = scheduleTime;
  
  if(talk.type == ScheduleItemType.networking) {
    if(cummulatedMinutes <= 180) {
      formattedTime = DateTime.utc(2019, 7, 25, 16, 0);

    } else if((cummulatedMinutes >= 180)) {
      formattedTime = DateTime.utc(2019, 7, 25, 17, 0);
    }
  } else {
    formattedTime = scheduleTime;
  }
                            
  
  String minutesForm = talk.minutes == 1 ?
                        '${talk.minutes} minute' : talk.minutes == 5 ?
                        'lightning' : '${talk.minutes} minutes';

  return ListTile(
    key: Key('${talk.name}'),
    contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
    title: Text('${talk.name}', 
      textScaleFactor: 0.9,
      style: TextStyle(
        color: talk.type == ScheduleItemType.lunch ? 
              Colors.black : (Colors.blue[600])
        )
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