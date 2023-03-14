import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/enum/task_status_enum.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  factory TaskModel.fromDocumentSnapshot(Map<String, dynamic>? data) =>
      TaskModel(
          id: data?['id'],
          ownerId: data?['ownerId'],
          title: data?['title'],
          description: data?['description'],
          taskStatusType: TaskStatusEnum.values
              .firstWhere((element) => data?['taskStatusType'] == element.name),
          isDeleteWhenCompleted: data?['isDeleteWhenCompleted']);

  TaskModel(
      {this.id,
      this.ownerId,
      this.title,
      this.description,
      this.taskStatusType = TaskStatusEnum.active,
      this.isDeleteWhenCompleted = false});

  final String? id;
  final String? ownerId;
  final String? title;
  final String? description;
  final TaskStatusEnum? taskStatusType;
  final bool? isDeleteWhenCompleted;

  Map<dynamic, dynamic> toJson() {
    const uuid = Uuid();

    return <String, dynamic>{
      'id': uuid.v4(),
      'ownerId': '${FirebaseAuth.instance.currentUser?.uid}',
      'title': title,
      'description': description,
      'taskStatusType': taskStatusType?.name,
      'isDeleteWhenCompleted': isDeleteWhenCompleted,
    };
  }
}
