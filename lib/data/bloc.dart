import 'package:rxdart/rxdart.dart';
import './global.dart';

class Bloc {
  //The Bloc class streams the Talk data to the StreamBuilder in All Conferences
  //It also holds the functions for manipulating the data contained inside it

  //A globalConferenceList is defined inside ./global.dart
  //It is the initial data dump for mocking purposes
  //The internal _blocList will initially hold the globalConferenceList
  List _blocList = globalConferenceList;

  //BehaviorSubject is a special StreamController
  //that captures the latest item that has been added to the controller
  //and emits that as the first item to any new listener.
  BehaviorSubject<List> _conferenceTalks = BehaviorSubject();

  //Observable allows to send a notification to listening widgets
  //The getter talksObservable is a stream
  Observable<List> get talksObservable => _conferenceTalks.stream;

  //the Initialize function sends the original data dump to the stream
  initialize() => _conferenceTalks.add(_blocList);

  //deleteTalk removes the specified Talk from the _blocList
  //The edited _blocList is then sent to the stream
  deleteTalk(Talk talk) {
    _blocList.removeWhere((item) => item == talk);
    //_conferenceTalks.add(_blocList);
  }

  //newTalk appends the new Talk to the _blocList
  //The new list is sent to the stream
  newTalk(Talk talk) {
    _blocList.add(talk);
    //_conferenceTalks.add(_blocList);
  }

  //editTalk receives the original Talk and the new Talk
  //The index of the original Talk is located in the _blocList
  //The Talk at the found index is replaced with the newTalk
  editTalk(Talk originalTalk, Talk newTalk) {
    int _index = _blocList.indexWhere((item) => item == originalTalk);
    _blocList[_index] = newTalk;

  }

  //dispose closes the stream
  dispose() {
    _conferenceTalks.close();
  }
}
