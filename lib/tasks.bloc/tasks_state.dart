import 'package:equatable/equatable.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class InitialState extends TasksState {}

class GetAllTasksState extends TasksState {}

class DeleteTaskState extends TasksState {}

class UpdateTaskState extends TasksState {}

class CreateTaskState extends TasksState {}
