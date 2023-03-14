import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/enum/task_status_enum.dart';

class TaskModel {
  factory TaskModel.fromDocumentSnapshot(Map<String, dynamic>? data) =>
      TaskModel(
        id: data?['id'],
        ownerId: data?['ownerId'],
        title: data?['title'],
        description: data?['description'],
        taskStatusType: TaskStatusEnum.values
            .firstWhere((element) => data?['taskStatusType'] == element.name),
      );

  TaskModel({
    this.id,
    this.ownerId,
    this.title,
    this.description,
    this.taskStatusType = TaskStatusEnum.active,
  });

  String? id;
  String? ownerId;
  String? title;
  String? description;
  TaskStatusEnum? taskStatusType;

  Map<dynamic, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ownerId': '${FirebaseAuth.instance.currentUser?.uid}',
      'title': title,
      'description': description,
      'taskStatusType': taskStatusType?.name,
    };
  }
}
