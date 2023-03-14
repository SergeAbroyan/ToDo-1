import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/repositories/firebase_repositories/firebase_abstract_repositories/firebase_jobs_abstract_repository.dart';
import 'package:to_do_app/tasks.bloc/tasks_event.dart';
import 'package:to_do_app/tasks.bloc/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(this._firebaseTaskAbstractRepository) : super(InitialState()) {
    on<ListenAllTasksEvent>(_onListenAllTasksEvent);
    on<GetAllTasksEvent>(_onGetAllTasksEvent);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  final FirebaseTaskAbstractRepository _firebaseTaskAbstractRepository;

  List<TaskModel>? _taskList;
  List<TaskModel>? get taskList => _taskList;

  Future<void> _onListenAllTasksEvent(
      ListenAllTasksEvent event, Emitter emit) async {
    emit(InitialState());
    try {
      _firebaseTaskAbstractRepository.listenMyTask().listen((event) {
        _taskList = event;
        add(GetAllTasksEvent());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _onGetAllTasksEvent(GetAllTasksEvent event, Emitter emit) async {
    emit(InitialState());
    emit(GetAllTasksState());
  }

  Future<void> _onCreateTaskEvent(CreateTaskEvent event, Emitter emit) async {
    emit(InitialState());

    await _firebaseTaskAbstractRepository.createTask(
        taskModel: event.taskModel);

    emit(CreateTaskState());
  }

  Future<void> _onUpdateTaskEvent(UpdateTaskEvent event, Emitter emit) async {}
  Future<void> _onDeleteTaskEvent(DeleteTaskEvent event, Emitter emit) async {}
}
