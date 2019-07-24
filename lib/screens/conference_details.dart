import 'package:flutter/material.dart';
import '../data/global.dart';
import '../data/bloc.dart';

class ConferenceDetailsPage extends StatefulWidget {
  ConferenceDetailsPage({this.data});
  final Talk data;

  @override
  _ConferenceDetailsPageState createState() => _ConferenceDetailsPageState(data);
}

class _ConferenceDetailsPageState extends State<ConferenceDetailsPage> {
  _ConferenceDetailsPageState(this.talk);
  final Talk talk;

  Bloc bloc = Bloc();

  TalkValidateError validator = TalkValidateError.none;

  TextEditingController titleController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  int talkDuration = 0;
  String talkTitle;

  @override
  void initState() {
    super.initState();
    titleController.text = talkTitle = talk.name;
    talkDuration = talk.minutes;

    //the text controller can only handle strings.
    durationController.text = talk.minutes.toString();
  }

  @override
  void dispose() {
    super.dispose();
    //Dispose text controllers when widget is unmounted
    titleController.dispose();
    durationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Talk'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

              bloc.deleteTalk(talk);
              Navigator.pop(context);

            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[

          //textfield for talk name. no integers allowed
          Container(
            margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: TextField(
              controller: titleController,
              maxLines: null,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Talk Title',
                border: UnderlineInputBorder(),
                errorText: talkValidatorText[validator],
              ),
              onChanged: (value) {
                setState(() {
                  //check for errors
                  if(value.contains(new RegExp(r'[0-9]'))) {
                    validator = TalkValidateError.noIntegerAllowed;
                    talkTitle = value;
                  } else {
                    value.isEmpty ? validator = TalkValidateError.emptyText : validator = TalkValidateError.none;
                    talkTitle = value;
                  }
                });
                
              },
            )
          ),

          //textfield for talk duration. only integers allowed
          Container(
            margin: EdgeInsets.fromLTRB(40, 40, 40, 20),
            child: TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Talk Duration (in minutes)',
                border: UnderlineInputBorder(),
              ),
              onChanged: (duration) {
                setState(() {
                  talkDuration = int.parse(duration);
                });
              },
            )
          ),

          //submit button
          Container(
            margin: EdgeInsets.fromLTRB(40, 20, 40, 10),
            width: double.infinity,
            child: RaisedButton(
              elevation: 0,
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Text('Save changes', textScaleFactor: 1.0),
              textColor: Colors.white,
              onPressed: () {
                if(validator == TalkValidateError.none) {

                  bloc.editTalk(talk, Talk(name: talkTitle, minutes: talkDuration));
                  Navigator.pop(context);

                } else if(talkTitle == null) {
                  //Error for an empty title will not be shown if the textfield has not be tapped yet.
                  //Show an empty title error if user tries submitting an empty title.
                  setState(() {
                    validator = TalkValidateError.emptyText;
                  });
                }
              },
            )
          ),

        ],
      ),
    );
  }
}