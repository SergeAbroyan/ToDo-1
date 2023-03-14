import 'package:to_do_app/models/task_model.dart';

abstract class FirebaseTaskAbstractRepository {
  Future<TaskModel> createTask({required TaskModel taskModel});

  Future<TaskModel> updateTask({required TaskModel taskModel});

  Future<bool> deleteTask({required TaskModel taskModel});

  Stream<List<TaskModel>> listenMyTask();
}
