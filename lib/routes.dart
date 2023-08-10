// routes.dart
import 'package:flutter/material.dart';
import 'views/home_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const PhotoNoteHomePage(title: 'PhotoNote'),
  // Add other routes as needed, e.g., '/details': (context) => DetailsPage(),
};
