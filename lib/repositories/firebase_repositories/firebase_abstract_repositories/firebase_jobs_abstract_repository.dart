import 'package:to_do_app/enum/task_status_enum.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class FirebaseTaskAbstractRepository {
  Stream<List<TaskModel>> listenMyTask(
      {required TaskStatusEnum taskStatusEnum});

  Future<TaskModel> createTask({required TaskModel taskModel});

  Future<TaskModel> updateTask({required TaskModel taskModel});

  Future<bool> deleteTask({required String taskId});
}
