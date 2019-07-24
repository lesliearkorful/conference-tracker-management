import 'package:flutter/material.dart';
import '../data/global.dart';
import '../data/bloc.dart';
import '../screens/conference_details.dart';
import '../screens/conference_schedule.dart';


class ConferencesPage extends StatefulWidget {
  @override
  _ConferencesPageState createState() => _ConferencesPageState();
}

class _ConferencesPageState extends State<ConferencesPage> {
  Bloc bloc = Bloc();
  //This variable will hold the data for Generated Schedule screen
  List generatedScheduleData;

  @override
  void initState() {
    super.initState();
    //call the initialize function inside the Bloc when widget is mounted
    bloc.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    //close the stream when the widget is unmounted
    bloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Conference Tracker'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/create'),
          )
        ],
      ),
      //StreamBuilder Creates a wigdet that builds itself based on the latest snapshot of interaction with the specified [stream] and whose build strategy is given by [builder].
      body: StreamBuilder(
        stream: bloc.talksObservable,
        builder: (BuildContext context, AsyncSnapshot<List>talks) {

          generatedScheduleData = talks.data;

          return ((talks.data != null) && (talks.data.length > 0)) ? ListView.builder(
            padding: EdgeInsets.only(bottom: 80),
            itemCount: talks.data.length,
            itemBuilder: (BuildContext context, index) {

              Talk talk = talks.data[index];
              String minutesForm = talk.minutes == 1 ? '${talk.minutes} minute' : talk.minutes ==5 ? 'lightning' : '${talk.minutes} minutes';

              return ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 14, 0),
                title: Text('${talk.name}', textScaleFactor: 1.0,),
                subtitle: Text('$minutesForm',textScaleFactor: 1.0),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ConferenceDetailsPage(data: talk)
                  )
                ),
              );
            },
          ) : Center(
            child: Text('Nothing to show yet.', textScaleFactor: 1.4),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        icon: Icon(Icons.schedule),
        label: Text('Generate', textScaleFactor: 1.0),
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(
            builder: (BuildContext context) => ConferenceSchedule(list: generatedScheduleData)
          )
        ),
      ),
    );
  }
}