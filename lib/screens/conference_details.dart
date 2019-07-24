import 'package:flutter/material.dart';
import '../data/global.dart';
import '../data/bloc.dart';

class ConferenceDetailsPage extends StatefulWidget {
  ConferenceDetailsPage({this.data});
  final Talk data;

  @override
  //Pass down the data to the State of the widget.
  _ConferenceDetailsPageState createState() => _ConferenceDetailsPageState(data);
}

class _ConferenceDetailsPageState extends State<ConferenceDetailsPage> {
  _ConferenceDetailsPageState(this.talk);
  final Talk talk;

  Bloc bloc = Bloc();

  //declare a validation variable and set it to empty,
  //because textfields are empty when screen is built.
  //This variable holds errors to prevent data submission.
  //If set to none, submission can occur.
  TalkValidateError validator = TalkValidateError.none;

  //Text controllers are for editable text fields
  TextEditingController titleController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  int talkDuration = 0;
  String talkTitle;

  @override
  void initState() {
    super.initState();
    //set initial text for the textfields with the passed Talk data
    titleController.text = talkTitle = talk.name;
    talkDuration = talk.minutes;

    //the text controller can only handle strings.
    //the duration needs to be converted to a string before being set
    durationController.text = talk.minutes.toString();
  }

  @override
  void dispose() {
    super.dispose();
    //Dispose the text controllers when the widget is unmounted
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
              //call the function in the Bloc for deletion
              bloc.deleteTalk(talk);
              //Go to previous page after the Talk has been deleted.
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[

          //textfield for talk name.no integers allowed
          Container(
            margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: TextField(
              controller: titleController,
              //Setting the maxLines to null allows the text field automatically grow
              //This makes it accommodate additional lines as they are entered.
              maxLines: null,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Talk Title',
                border: UnderlineInputBorder(),
                //Display error text based on the value  of the corresponding key in the talkValidatorText map
                errorText: talkValidatorText[validator],
              ),
              //The onChanged function is called on every keystroke
              onChanged: (value) {
                setState(() {
                  //check if the value contains a number before storing it.
                  //If there's an error, update the validate to reflect it.
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
              //TextInputType.number ensures only integers are typed.
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Talk Duration (in minutes)',
                border: UnderlineInputBorder(),
              ),
              //The onChanged function is called on every keystroke
              onChanged: (duration) {
                setState(() {
                  //convert duration to integer and store.
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
                  //Pass the original Talk and the new Talk to theBloc function
                  bloc.editTalk(talk, Talk(name: talkTitle, minutes: talkDuration));
                  //Go back to previous page after the previous function is done
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