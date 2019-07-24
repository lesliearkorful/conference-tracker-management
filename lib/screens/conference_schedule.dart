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
    List commonDurations = [];
    List assigned = [];
    List generated = [];
    List lightning = [];

    temp.forEach((item) {
      if(commonDurations.contains(item.minutes) == false) {
        commonDurations.add(item.minutes);
      }
    });
    
    generated.add(ScheduleItem(track: track, type: ScheduleItemType.track));

    for (var i = 0; i <= (temp.length + 1); i++) {
      print('iteration: $i');

      for(int index = i; index < temp.length; index++) {

        var item = temp[index];
        print('currently assigned: ${assigned.length}');

        if(assigned.contains(item)) {
          print('ALREADY ASSIGNED : ${item.name}');
          break;

        } else {

          if(item.minutes == 5) {
            assigned.add(item);
            lightning.add(item);
            break;
          }


          if(item.minutes <= morningMinutes) {

            if((morningMinutes%item.minutes == 0) ||
              
              (commonDurations.contains(item.minutes-morningMinutes)) ) {

                print('morning  : $morningMinutes');

                morningMinutes -= item.minutes;

                final assignedTalk = ScheduleItem(
                                      minutes: item.minutes,
                                      name: item.name,
                                      session: Session.morning,
                                      track: track,
                                      type: ScheduleItemType.talk
                );

                assigned.add(item);
                generated.add(assignedTalk);

                print('ADDED  : ${item.name}');
                print('${item.minutes} deducted. $morningMinutes left');

            } else {
                print('SKIPPED  : ${item.name}. $morningMinutes left');
                continue;
              }


          } else if((item.minutes <= afternoonMinutes)) {

            final lunch = ScheduleItem(
                            minutes: 60,
                            name: 'Lunch',
                            session: Session.afternoon,
                            track: track,
                            type: ScheduleItemType.lunch
            );
            
            if((afternoonMinutes%item.minutes == 0) ||
              (commonDurations.contains(item.minutes % afternoonMinutes))) {

              print('afternoon  : $afternoonMinutes');

              if((afternoonMinutes == 240) &&
                (generated.contains(lunch) == false)) {
                  print('\nBEGIN LUNCH  : ${item.name}');
                  print('afternoon minutes  : $afternoonMinutes: lunch presence: ${generated.contains(lunch)}');
                  generated.add(lunch);
              }

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

              print('ADDED  : ${item.name}');
              print('${item.minutes} deducted. $afternoonMinutes left');

              print('LUNCH CHECK  : $afternoonMinutes: lunch presence: ${generated.contains(lunch)}');

            } else {
              print('SKIPPED  : ${item.name}. $afternoonMinutes left');
              continue;
            }          
          } else {
            generated.add(ScheduleItem(
                            minutes: 0,
                            name: 'Networking Event',
                            session: Session.afternoon,
                            track: track,
                            type:  ScheduleItemType.networking
                          )
            );
                            
            //increase track count when all sessions are occupied
            track++;
            print('\nNEW TRACK ADDED');
            //reset sessions for new track
            morningMinutes = 180;
            afternoonMinutes = 240;
            //adds a new track header
            generated.add(ScheduleItem(track: track, type: ScheduleItemType.track));
          }
        }
      }
    }

    //append lightning items to generated list
    lightning.forEach((item) {

      final lightningItem = ScheduleItem(
                              minutes: item.minutes,
                              name: item.name,
                              session: Session.afternoon,
                              track: track,
                              type: ScheduleItemType.talk
                            );

      generated.add(lightningItem);
      print('ADDED: ${lightningItem.name}');
    });

    //append last networking item for last track to generated list
    final lastNetworkingItem = ScheduleItem(
                                minutes: 0,
                                name: 'Networking Event',
                                session: Session.afternoon,
                                track: track,
                                type:  ScheduleItemType.networking
    );

    if(generated.contains(lastNetworkingItem) == false) {
      generated.add(lastNetworkingItem);
    }

    //update the schedule view with the generated schedule
    setState(() => scheduleView = generated);

    generated.forEach((item) => print('${item.minutes} mins : ${item.name}. track: ${item.track}. type:${item.type}'));

    assigned.forEach((item) => print('ASSIGNED: ${item.name}'));

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
          final int sessionSwitch = scheduleView.indexWhere(
                                      (item) => (item.session == scheduleItem.session &&
                                      item.track == scheduleItem.track)
                                    );

          //the range is for calculating the accumulated minutes from start time
          final List sessionRange = scheduleView.getRange(sessionSwitch,
                                                          scheduleView.indexWhere(
                                                            (item) => item == scheduleItem)
                                                          ).toList();

          //return Track header or a schedule item
          return scheduleItem.type == ScheduleItemType.track ?

            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              color: Colors.black.withOpacity(0.05),
              child: Text('Track ${scheduleItem.track}',
                textScaleFactor: 1.4,
                style: TextStyle(
                  color: Colors.blue[700])
                ),
            ) : scheduleItemWidget(scheduleItem, sessionRange);
        }).toList(),
      )
    );
  }
}