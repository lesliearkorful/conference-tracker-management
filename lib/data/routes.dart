import 'package:flutter/material.dart';
import '../screens/conference_all.dart';
import '../screens/conference_create.dart';

final routes = {
  '/create' : (BuildContext context) => CreateConferencePage(),
  '/' : (BuildContext context) => ConferencesPage(),
};