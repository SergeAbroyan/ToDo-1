import 'package:flutter/material.dart';
import 'package:to_do_app/screens/task_item_view_edit_screen.dart';
import 'package:to_do_app/screens/task_list_screen.dart';

class RouteGeneratorClass {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/taskListScreen') {
      return MaterialPageRoute(builder: (context) => const TaskListScreen());
    }

    if (settings.name == '/taskItemScreen') {
      return MaterialPageRoute(builder: (context) => const TaskItemScreen());
    }

    return null;
  }
}
