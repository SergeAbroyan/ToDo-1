import 'package:flutter/material.dart';

class TaskItemScreen extends StatefulWidget {
  const TaskItemScreen({Key? key}) : super(key: key);

  @override
  State<TaskItemScreen> createState() => _TaskItemScreenState();
}

class _TaskItemScreenState extends State<TaskItemScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

extension _TaskItemScreenStateAddition on _TaskItemScreenState {}
