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
  ScrollController scrollController = ScrollController();
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

    for (int i = 0; i <= (temp.length + 1); i++) {

      for(int index = i; index < temp.length; index++) {

        Talk item = temp[index];

        if(assigned.contains(item)) {
          continue;

        } else {

          if(item.minutes == 5) {
            assigned.add(item);
            lightning.add(item);
            break;
          }


          if(item.minutes <= morningMinutes) {

            if((morningMinutes%item.minutes == 0) ||
              (commonDurations.contains(item.minutes - morningMinutes))) {

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
                
            } else {
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
              (commonDurations.contains(item.minutes % afternoonMinutes)) ) {

              if((afternoonMinutes == 240) &&
                (generated.contains(lunch) == false)) {
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

            } else {
              continue;
            }          
          } else {
            
            if((afternoonMinutes != 0 ) && (afternoonMinutes <= 240)) {
              continue;
            }

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
            //reset sessions for new track
            morningMinutes = 180;
            afternoonMinutes = 240;
            //adds a new track header
            generated.add(ScheduleItem(track: track, type: ScheduleItemType.track));
            //continue;
          }
        }
      }
    }

    

    //append lightning items to generated list
    Session lightningSession;

    if((afternoonMinutes == 0)) {

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
      
      track++;
      lightningSession = Session.morning;

      final trackHeader = ScheduleItem(track: track, type: ScheduleItemType.track);

      if(generated.contains(trackHeader) == false) {
        generated.add(trackHeader);
      }

    } else if(morningMinutes == 0) {
      lightningSession = Session.afternoon;

    } else {
      lightningSession = Session.morning;
    }


    lightning.forEach((item) {

      final lightningItem = ScheduleItem(
                              minutes: item.minutes,
                              name: item.name,
                              session: lightningSession,
                              track: track,
                              type: ScheduleItemType.talk
      );

      generated.add(lightningItem);

    });
      
    
    //update the schedule view with the generated schedule
    setState(() => scheduleView = generated);
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
        controller: scrollController,
        scrollDirection: Axis.vertical,
        children: scheduleView.map<Widget>((scheduleItem) {
          
          //get the first index where this item session and track are equal
          final int sessionSwitch = scheduleView.indexWhere(
                                      (item) => (item.session == scheduleItem.session &&
                                      item.track == scheduleItem.track)
          );

          final int currentItem = scheduleView.indexWhere((item) => item == scheduleItem);

          //the range is for calculating the accumulated minutes
          //from the first index to the current index
          final List sessionRange = scheduleView.getRange(sessionSwitch, currentItem).toList();

          return (scheduleItem.type == ScheduleItemType.track) ?
            TrackHeader(trackNumber: scheduleItem.track) : 
            scheduleItemWidget(scheduleItem, sessionRange);

        }).toList(),
      )
    );
  }
}