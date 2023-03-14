import 'package:equatable/equatable.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class ListenAllTasksEvent extends TasksEvent {}

class GetAllTasksEvent extends TasksEvent {}

class CreateTaskEvent extends TasksEvent {
  const CreateTaskEvent({required this.taskModel});

  final TaskModel taskModel;

  @override
  List<Object> get props => [taskModel];
}

class UpdateTaskEvent extends TasksEvent {}

class DeleteTaskEvent extends TasksEvent {}
