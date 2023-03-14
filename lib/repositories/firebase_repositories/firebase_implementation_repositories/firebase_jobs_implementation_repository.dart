import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/repositories/firebase_repositories/firebase_abstract_repositories/firebase_jobs_abstract_repository.dart';

class FirebaseTaskImplementationRepository
    implements FirebaseTaskAbstractRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<List<TaskModel>> listenMyTask() async* {
    yield* _db
        .collection('Tasks')
        .where('Task.ownerId',
            isEqualTo: '${FirebaseAuth.instance.currentUser?.uid}')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) =>
                TaskModel.fromDocumentSnapshot(document.data()['Task']))
            .toList());
  }

  @override
  Future<TaskModel> createTask({required TaskModel taskModel}) async {
    try {
      await _db.collection('Tasks').add({'Task': taskModel.toJson()});
      return taskModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteTask({required TaskModel taskModel}) async {
    try {
      await _db.collection('Tasks').doc().delete();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<TaskModel> updateTask({required TaskModel taskModel}) async {
    try {
      await _db.collection('Tasks').doc().update({'Task': taskModel.toJson()});
      return taskModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
