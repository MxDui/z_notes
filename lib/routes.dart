import 'package:flutter/cupertino.dart';
import 'package:z_notes/views/notebook_page.dart';

import 'views/dashboard_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const DashboardPage(),
  '/notebook': (context) => const NotebookPage(
      title: 'Sample Notebook', description: 'Sample Description'),
};
