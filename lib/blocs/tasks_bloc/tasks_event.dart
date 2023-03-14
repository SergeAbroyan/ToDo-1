import 'package:equatable/equatable.dart';
import 'package:to_do_app/enum/task_status_enum.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class ListenAllTasksEvent extends TasksEvent {
  const ListenAllTasksEvent({required this.taskStatusEnum});

  final TaskStatusEnum taskStatusEnum;

  @override
  List<Object> get props => [taskStatusEnum];
}

class GetAllTasksEvent extends TasksEvent {}

class CreateTaskEvent extends TasksEvent {
  const CreateTaskEvent({required this.taskModel});

  final TaskModel taskModel;

  @override
  List<Object> get props => [taskModel];
}

class UpdateTaskEvent extends TasksEvent {
  const UpdateTaskEvent(
      {required this.taskModel,
      required this.isChangeStatus,
      required this.alsoDelete});

  final TaskModel taskModel;
  final bool isChangeStatus;
  final bool alsoDelete;

  @override
  List<Object> get props => [taskModel, isChangeStatus, alsoDelete];
}

class DeleteTaskEvent extends TasksEvent {
  const DeleteTaskEvent({required this.taskId});

  final String taskId;

  @override
  List<Object> get props => [taskId];
}
