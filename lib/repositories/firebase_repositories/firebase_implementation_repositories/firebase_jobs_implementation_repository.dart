import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/enum/task_status_enum.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/repositories/firebase_repositories/firebase_abstract_repositories/firebase_jobs_abstract_repository.dart';
import 'package:uuid/uuid.dart';

class FirebaseTaskImplementationRepository
    implements FirebaseTaskAbstractRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<List<TaskModel>> listenMyTask(
      {required TaskStatusEnum taskStatusEnum}) async* {
    try {
      yield* _db
          .collection('Tasks')
          .where('Task.ownerId',
              isEqualTo: '${FirebaseAuth.instance.currentUser?.uid}')
          .where('Task.taskStatusType', isEqualTo: taskStatusEnum.name)
          .snapshots()
          .map((snapShot) => snapShot.docs
              .map((document) =>
                  TaskModel.fromDocumentSnapshot(document.data()['Task']))
              .toList());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<TaskModel> createTask({required TaskModel taskModel}) async {
    const uuid = Uuid();
    taskModel.id = uuid.v4();
    try {
      await _db
          .collection('Tasks')
          .doc(taskModel.id)
          .set({'Task': taskModel.toJson()});
      return taskModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<TaskModel> updateTask({required TaskModel taskModel}) async {
    try {
      await _db
          .collection('Tasks')
          .doc(taskModel.id)
          .update({'Task': taskModel.toJson()});
      return taskModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteTask({required String taskId}) async {
    try {
      await _db.collection('Tasks').doc(taskId).delete();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
