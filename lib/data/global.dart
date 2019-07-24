class Talk {
  Talk({
    this.minutes,
    this.name,
    this.assigned,
  });
  
  final int minutes;
  final String name;
  bool assigned;
}

class ScheduleItem {
  ScheduleItem({
    this.minutes,
    this.name,
    this.session,
    this.track,
    this.type,
  });
  
  final int minutes;
  final String name; 
  final Session session;
  final int track;
  final ScheduleItemType type;
}

enum ScheduleItemType {
  talk,
  lunch,
  track,
  networking,
}

//initial data dump
final List globalConferenceList = [
  Talk(name: 'Writing Fast Tests Against Enterprise Rails', minutes: 60),
  Talk(name: 'Overdoing it in Python', minutes: 45),
  Talk(name: 'Lua for the Masses', minutes: 30),
  Talk(name: 'Ruby Errors from Mismatched Gem Versions', minutes: 45),
  Talk(name: 'Common Ruby Errors', minutes: 45),
  Talk(name: 'Rails for Python Developers', minutes: 5),
  Talk(name: 'Communicating Over Distance', minutes: 60),
  Talk(name: 'Accounting-Driven Development', minutes: 45),
  Talk(name: 'Woah', minutes: 30),
  Talk(name: 'Sit Down and Write', minutes: 30),
  Talk(name: 'Pair Programming vs Noise', minutes: 45),
  Talk(name: 'Rails Magic', minutes: 60),
  Talk(name: 'Ruby on Rails: Why We Should Move On', minutes: 60),
  Talk(name: 'Clojure Ate Scala (on my project)', minutes: 45),
  Talk(name: 'Programming in the Boondocks of Seattle', minutes: 30),
  Talk(name: 'Ruby vs. Clojure for Back-End Development', minutes: 30),
  Talk(name: 'Ruby on Rails Legacy App Maintenance', minutes: 60),
  Talk(name: 'A World Without HackerNews', minutes: 30),
  Talk(name: 'User Interface CSS in Rails', minutes: 30),
];

enum Session {
  morning,
  afternoon
}

enum TalkValidateError {
  none,
  noIntegerAllowed,
  emptyText
}

//This map helps to get the info/reason for the talkValidateError
Map talkValidatorText = {
  TalkValidateError.emptyText : 'This cannot be empty.',
  TalkValidateError.noIntegerAllowed  : 'Titles should not contain numbers.',
  TalkValidateError.none  : null,

};