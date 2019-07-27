import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/conference_all.dart';
import '../lib/screens/conference_create.dart';

void main() {
  testWidgets('Conference Tracker Management', (WidgetTester tester) async {
    print('Begin test for Conference Tracker Management');

    //ALL CONFERENCES SCREEN
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/create' : (BuildContext context) => CreateConferencePage(),
        },
        home: ConferencesPage()
      )
    ).whenComplete(() => log(Log.screen, 'All Conferences'));

    
    await tester.pumpAndSettle().whenComplete(() {
      expect(find.byType(ListTile), findsWidgets);
      log(Log.exists, 'Conference talk list items');
    });
    
    
    expect(find.text('Conference Tracker'), findsOneWidget);
    log(Log.exists, 'Conference Tracker title');

    final generateSchedule = find.widgetWithIcon(FloatingActionButton, Icons.schedule);
    expect(generateSchedule, findsOneWidget);
    log(Log.exists, 'Generate button');

    //new conference button
    final addConference = find.widgetWithIcon(IconButton, Icons.add);
    expect(addConference, findsOneWidget);
    log(Log.exists, 'Add New Talk button');

    //NAVIGATION TO ADD TALK SCREEN
    await tester.tap(addConference).then((onValue) => log(Log.tap, 'Add New Talk button'));

    //rebuild the widget
    await tester.pumpAndSettle().then((onValue) => log(Log.navigation, 'Add New Talk screen'));





    //ADD NEW TALK SCREEN
    expect(find.text('Add a New Talk'), findsOneWidget);
    log(Log.exists, 'Add New talk title');

    await tester.enterText(find.byKey(Key('talkTitle')), 'Test Run').then((onValue) {
      print('DATA ENTRY FOR TALK TITLE: Test Run');
    });

    await tester.enterText(find.byKey(Key('talkDuration')), '60').then((onValue) {
      print('DATA ENTRY FOR TALK DURATION: 60');
    });

    await tester.tap(find.byType(RaisedButton)).then((onValue) {
      log(Log.tap, 'Save New talk');
      //Submitting also triggers a back navigation 
      log(Log.navigation, 'Previous Screen');
    });

    await tester.pumpAndSettle().whenComplete(() => log(Log.screen, 'All Conferences'));

    tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(1108);
    await tester.pump();

    Scrollable.ensureVisible(tester.element(find.text('Test Run')));
    await tester.pump();

    expect(find.text('Test Run'), findsOneWidget);
    log(Log.exists, 'Newly added "Test Run" is present');

    await tester.tap(find.widgetWithText(ListTile, 'Test Run'));
    log(Log.tap, 'View/Edit/Delete Test Run');
    await tester.pumpAndSettle().then((onValue) => log(Log.navigation, 'Edit Talk Screen'));





    //EDIT TALK SCREEN
    expect(find.text('Edit Talk'), findsOneWidget);
    log(Log.exists, 'Edit talk title');

    await tester.enterText(find.byKey(Key('talkTitle')), 'Test Run Update').then((onValue) {
      print('UPDATE ENTRY FOR TALK TITLE: Test Run Update');
    });

    await tester.enterText(find.byKey(Key('talkDuration')), '120').then((onValue) {
      print('UPDATE ENTRY FOR TALK DURATION: 120');
    });

    await tester.tap(find.byType(RaisedButton)).then((onValue) {
      log(Log.tap, 'Save changes');
      //Submitting also triggers a back navigation 
      log(Log.navigation, 'Previous Screen');
    });

    await tester.pumpAndSettle().whenComplete(() {
      expect(find.text('Conference Tracker'), findsOneWidget);
      log(Log.screen, 'All Conferences screen');
    });

    expect(find.text('Test Run Update'), findsOneWidget);
    log(Log.exists, 'Updated "Test Run Update" is present');





    //VIEW GENERATED SCHEDULE
    await tester.tap(generateSchedule).then((onValue) {
      log(Log.tap, 'Generate button');
    });

    await tester.pumpAndSettle().then((onValue) {
      log(Log.navigation, 'Generated Schedule screen');
    });

    expect(find.text('Generated Schedule'), findsOneWidget);
    log(Log.exists, 'Generated Schedule');

    expect(find.byType(ListTile), findsWidgets);
    log(Log.exists, 'Generated Schedule list items');

    expect(find.byKey(Key('TrackHeader')), findsWidgets);
    log(Log.exists, 'Track Headers exist');

    tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(1100);
    await tester.pump();

    expect(find.text('Test Run Update'), findsOneWidget);
    log(Log.exists, '"Test Run Update" is in generated schedule');
    
    await tester.tap(find.byType(BackButton)).then((onValue) {
      log(Log.navigation, 'Previous screen');
    });

    await tester.pumpAndSettle().then((onValue) {
      log(Log.screen, 'All Conferences');
    });

    //await tester.tap(find.byKey(Key('Overdoing it in Python')));

    


    print('\nEND OF TEST REACHED.');
  });  
}

log(Log type, String message) {
    print('${logMessage[type]} : $message');
}

enum Log {
  navigation,
  exists,
  screen,
  tap,
}

Map logMessage = {
  Log.navigation : '\nNAVIGATION TO',
  Log.screen: 'RENDERED SCREEN',
  Log.exists: 'FOUND WIDGET',
  Log.tap: 'TAPPED BUTTON'
};
