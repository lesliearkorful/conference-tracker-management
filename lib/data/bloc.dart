import 'package:rxdart/rxdart.dart';
import './global.dart';

class Bloc {

  List _blocList = globalConferenceList;

  //BehaviorSubject captures latest item and emits.
  BehaviorSubject<List> _conferenceTalks = BehaviorSubject();

  //Observable allows to send a notification to listening widgets
  Observable<List> get talksObservable => _conferenceTalks.stream;

  initialize() => _conferenceTalks.add(_blocList);


  deleteTalk(Talk talk) {
    _blocList.removeWhere((item) => item == talk);
  }


  newTalk(Talk talk) {
    _blocList.add(talk);
  }


  editTalk(Talk originalTalk, Talk newTalk) {
    int _index = _blocList.indexWhere((item) => item == originalTalk);
    _blocList[_index] = newTalk;

  }

  //dispose closes the stream
  dispose() {
    _conferenceTalks.close();
  }
}
