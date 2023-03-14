import 'package:equatable/equatable.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class InitialState extends TasksState {}

class FailureState extends TasksState {
  const FailureState(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

class GetAllTasksState extends TasksState {}

class DeleteTaskState extends TasksState {}

class UpdateTaskState extends TasksState {
  const UpdateTaskState({this.isChangeStatus = false});

  final bool isChangeStatus;

  @override
  List<Object> get props => [isChangeStatus];
}

class CreateTaskState extends TasksState {}
