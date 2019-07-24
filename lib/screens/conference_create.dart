import 'package:flutter/material.dart';
import '../data/global.dart';
import '../data/bloc.dart';

class CreateConferencePage extends StatefulWidget {
  @override
  _CreateConferencePageState createState() => _CreateConferencePageState();
}

class _CreateConferencePageState extends State<CreateConferencePage> {
  Bloc bloc = Bloc();
  TalkValidateError validator;
  int talkDuration = 0;
  String talkTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Add a New Talk'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[

          //textfield for talk name: no integers allowed
          Container(
            margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: TextField(
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              child: Text('Add New Talk', textScaleFactor: 1.0),
              textColor: Colors.white,
              onPressed: () {
                if(validator == TalkValidateError.none) {

                  bloc.newTalk(Talk(name: talkTitle, minutes: talkDuration ));
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