import 'package:flutter/material.dart';
import 'package:to_do_app/route_generator_class.dart';
import 'package:to_do_app/screens/task_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _mainRoute(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) =>
            RouteGeneratorClass().onGenerateRoute(settings));
  }
}

extension _HomeScreenStateAddition on _HomeScreenState {
  Widget _mainRoute() {
    return const TaskListScreen();
  }
}
