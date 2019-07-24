import 'package:flutter/material.dart';
import '../widgets/generated_schedule_widgets.dart';
import '../data/global.dart';

class ConferenceSchedule extends StatefulWidget {
  ConferenceSchedule({this.list});
  final list;
  @override
  _ConferenceScheduleState createState() => _ConferenceScheduleState(list);
}

class _ConferenceScheduleState extends State<ConferenceSchedule> {
  _ConferenceScheduleState(this.conferenceTalks);
  final List conferenceTalks;

  List scheduleView = [];


  @override
  void initState() {
    super.initState();
    generate();
  }

  void generate() {
    int morningMinutes = 180;
    int afternoonMinutes = 240;
    int track = 1;
    List temp = conferenceTalks;
    List assigned = [];
    List generated = [];
    
    generated.add(ScheduleItem(track: track, type: ScheduleItemType.track));

    for (var i = 0; i < temp.length; i++) {
      
      for(int index = i; index < temp.length; index++) {

        var item = temp[index];
        print('currently assigned: ${assigned.length}');

        if(assigned.contains(item)) {
          break;

        } else {

          if(item.minutes == 5) {
            continue;
          }

          if(item.minutes <= morningMinutes) {

            if((morningMinutes%item.minutes == 0)) {
              morningMinutes -= item.minutes;

              final assignedTalk = ScheduleItem(
                                    minutes: item.minutes,
                                    name: item.name,
                                    session: Session.morning,
                                    track: track,
                                    type: ScheduleItemType.talk,
                                  );
              assigned.add(item);
              generated.add(assignedTalk);
              print('${item.minutes} deducted. remaining morning minutes: $morningMinutes');
            } else {
              continue;
            }

          } else if((item.minutes <= afternoonMinutes)) {

            if(afternoonMinutes == 240) {
              generated.add(ScheduleItem(minutes: 60, name: 'Lunch', session: Session.afternoon, track: track, type: ScheduleItemType.talk));
            }

            if(afternoonMinutes%item.minutes == 0) {
              afternoonMinutes -= item.minutes;

              final assignedTalk = ScheduleItem(
                                    minutes: item.minutes,
                                    name: item.name,
                                    session: Session.afternoon,
                                    track: track,
                                    type: ScheduleItemType.talk
                                  );
              generated.add(assignedTalk);
              assigned.add(item);
              print('${item.minutes} deducted. remaining afternoon minutes: $afternoonMinutes');

            } else {
              //print('skipping afternoon');
              continue;
            }          
          } else {
              generated.add(ScheduleItem(minutes: 60, name: 'Networking Event', session: Session.afternoon, track: track,type:  ScheduleItemType.talk));
              //increase track count when all sessions are occupied
              track++;
              //reset sessions for new track
              morningMinutes = 180;
              afternoonMinutes = 240;
              //adds a new track header
              generated.add(ScheduleItem(track: track, type: ScheduleItemType.track));
            }
        }
        
      }
    }

    //update the schedule view with the generated schedule
    setState(() => scheduleView = generated);
    //generated.forEach((item) => print('${item.minutes} mins : ${item.name}. track: ${item.track}. type:${item.type}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Generated Schedule'),
        centerTitle: true,
      ),
      body: ListView(
        children: scheduleView.map<Widget>((scheduleItem) {
          
          //get the first index where this item session and track are equal
          final int sessionSwitch = scheduleView.indexWhere((item) => (item.session == scheduleItem.session && item.track == scheduleItem.track));

          //return Track header or a schedule item
          return scheduleItem.type == ScheduleItemType.track ?
            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              color: Colors.black.withOpacity(0.05),
              child: Text('Track ${scheduleItem.track}', textScaleFactor: 1.4, style: TextStyle(color: Colors.blue[700]),),
            ) : scheduleItemWidget(scheduleItem, scheduleView.getRange(sessionSwitch, scheduleView.indexWhere((item) => item == scheduleItem)).toList());

        }).toList(),
      )
    );
  }
}