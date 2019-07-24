import 'package:flutter/material.dart';
import '../screens/conference_all.dart';
import '../screens/conference_schedule.dart';
import '../screens/conference_create.dart';

final routes = {
  '/schedule' : (BuildContext context) => ConferenceSchedule(),
  '/create' : (BuildContext context) => CreateConferencePage(),
  '/' : (BuildContext context) => ConferencesPage(),
};