import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:to_do_app/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:to_do_app/blocs/tasks_bloc/tasks_event.dart';
import 'package:to_do_app/blocs/tasks_bloc/tasks_state.dart';
import 'package:to_do_app/components/alert_widget.dart';
import 'package:to_do_app/components/centered_button_widget.dart';
import 'package:to_do_app/components/dropdown_status_button.dart';
import 'package:to_do_app/components/info_widget.dart';
import 'package:to_do_app/components/text_filed_widget.dart';
import 'package:to_do_app/components/typedef_functions.dart';
import 'package:to_do_app/constants/app_colors.dart';
import 'package:to_do_app/constants/app_styles.dart';
import 'package:to_do_app/enum/task_status_enum.dart';
import 'package:to_do_app/mixins/device_metrics.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/repositories/firebase_repositories/firebase_implementation_repositories/firebase_jobs_implementation_repository.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with DeviceMetricsStateful {
  late final TasksBloc _tasksBloc;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskStatusEnum _taskFilterStatus = TaskStatusEnum.active;

  @override
  void initState() {
    _tasksBloc = TasksBloc(FirebaseTaskImplementationRepository())
      ..add(const ListenAllTasksEvent(taskStatusEnum: TaskStatusEnum.active));
    super.initState();
  }

  @override
  void dispose() {
    _tasksBloc.close();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksBloc>(
        create: (context) => _tasksBloc,
        child: BlocConsumer<TasksBloc, TasksState>(
            listener: _listener,
            builder: (context, state) => Scaffold(
                appBar: appBar(),
                floatingActionButton: FloatingActionButton(onTapAdd: _onTapAdd),
                body: SafeArea(
                    child: TaskListView(
                  taskList: _tasksBloc.taskList,
                  onTapDelete: _onTapDelete,
                  onTapEdit: (index) =>
                      _onTapEditTask(_tasksBloc.taskList?[index]),
                  onTapCompleted: (index) =>
                      _changeTaskStatusCompleted(_tasksBloc.taskList?[index]),
                )))));
  }

  AppBar appBar() {
    return AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Task List'),
      StatusWorkingPopup(
          statusWorkingType: _taskFilterStatus,
          statusWorkingTypeCallback: _filterWithStatus)
    ]));
  }
}

class TaskListView extends StatelessWidget with DeviceMetricsStateless {
  const TaskListView(
      {required this.taskList,
      required this.onTapDelete,
      required this.onTapEdit,
      required this.onTapCompleted,
      Key? key})
      : super(key: key);

  final List<TaskModel>? taskList;
  final StringCallback onTapDelete;
  final IndexCallback onTapEdit;
  final IndexCallback onTapCompleted;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: taskList?.length,
        itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.whiteSmoke),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoWidget(
                            title: 'Title', info: taskList?[index].title ?? ''),
                        InfoWidget(
                            title: 'Description',
                            info: taskList?[index].description ?? ''),
                        DoneButtons(
                          onTapCompleted: () => onTapCompleted(index),
                          taskStatusType: taskList?[index].taskStatusType,
                        )
                      ]),
                  EditDeleteButtons(
                    onTapDelete: () => onTapDelete(taskList?[index].id ?? ''),
                    onTapEdit: () => onTapEdit(index),
                  )
                ])));
  }
}

class EditDeleteButtons extends StatelessWidget {
  const EditDeleteButtons(
      {required this.onTapDelete, required this.onTapEdit, Key? key})
      : super(key: key);

  final VoidCallback onTapDelete;
  final VoidCallback onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(onPressed: onTapEdit, icon: const Icon(Icons.edit)),
      IconButton(onPressed: onTapDelete, icon: const Icon(Icons.delete))
    ]);
  }
}

class DoneButtons extends StatelessWidget {
  const DoneButtons(
      {required this.taskStatusType, required this.onTapCompleted, Key? key})
      : super(key: key);

  final TaskStatusEnum? taskStatusType;
  final VoidCallback onTapCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          const Text('Done?'),
          Checkbox(
              value: taskStatusType == TaskStatusEnum.completed,
              onChanged: (_) => onTapCompleted.call())
        ]));
  }
}

class StatusWorkingPopup extends StatelessWidget with DeviceMetricsStateless {
  StatusWorkingPopup(
      {required this.statusWorkingTypeCallback,
      required this.statusWorkingType,
      Key? key})
      : super(key: key);

  final TaskStatusEnumCallback statusWorkingTypeCallback;
  final TaskStatusEnum statusWorkingType;

  @override
  Widget build(BuildContext context) {
    final isWorkingNotifier = ValueNotifier<TaskStatusEnum>(statusWorkingType);

    return ValueListenableBuilder(
        valueListenable: isWorkingNotifier,
        builder: (context, TaskStatusEnum value, child) => DropdownStatusButton(
            backgroundColor: AppColors.solitudeColor,
            value: value.name.titleCase,
            padding: EdgeInsets.zero,
            columnWidth: width(context) / 2.5,
            items: TaskStatusEnum.values
                .where((valueType) => valueType != isWorkingNotifier.value)
                .map((TaskStatusEnum valueType) => DropdownMenuItem<String>(
                    onTap: () {
                      isWorkingNotifier.value = valueType;
                      statusWorkingTypeCallback(valueType);
                    },
                    value: valueType.name,
                    child: Text(valueType.name.titleCase,
                        style: getStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))))
                .toList()));
  }
}

class FloatingActionButton extends StatelessWidget {
  const FloatingActionButton({required this.onTapAdd, Key? key})
      : super(key: key);

  final VoidCallback onTapAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapAdd,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Icon(Icons.add, size: 40),
          Text('Add Task', style: getStyle())
        ]));
  }
}

extension _TaskListScreenStateAddition on _TaskListScreenState {
  void _listener(context, state) {
    if (state is CreateTaskState) {
      _taskFilterStatus = TaskStatusEnum.active;
      _onTapCancel();
    }
    if (state is UpdateTaskState && !state.isChangeStatus) {
      _onTapCancel();
    }
  }

  /// filter task by status
  void _filterWithStatus(TaskStatusEnum taskStatusEnum) {
    _taskFilterStatus = taskStatusEnum;
    _tasksBloc.add(ListenAllTasksEvent(taskStatusEnum: taskStatusEnum));
  }

  ///  tap cancel or closed dialog
  void _onTapCancel() {
    _textControllerClear();
    Navigator.pop(context);
  }

  /// show create or update task view
  void _showTaskDialog({TaskModel? task, bool isCreate = false}) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              scrollable: true,
              title: Text(isCreate ? 'New Task' : 'Update Task',
                  style: getStyle(fontSize: 20)),
              content: Column(children: [
                TextFiledWidget(hint: 'Title', controller: _titleController),
                TextFiledWidget(
                    hint: 'Description', controller: _descriptionController)
              ]),
              actions: [
                CenteredButtonWidget(
                    activeBackgroundColor: AppColors.altoColor,
                    activeBorderColor: AppColors.altoColor,
                    textColor: AppColors.blackColor,
                    onTap: _onTapCancel,
                    title: 'Cancel',
                    width: 100),
                CenteredButtonWidget(
                    onTap: () =>
                        isCreate ? _createTask() : _updateTaskInfo(task),
                    title: 'Save',
                    width: 100)
              ]));

  /// call delete task event
  void _onTapDelete(String taskId) =>
      _tasksBloc.add(DeleteTaskEvent(taskId: taskId));

  /// show change status dialog
  void _changeTaskStatusCompleted(TaskModel? task) {
    if (task?.taskStatusType == TaskStatusEnum.active) {
      AlertWidget().showMessage(
          context, 'Are you sure you want to add this task to the Done list?',
          onTapOk: () => _callUpdateTaskEvent(task, false),
          onTapAlsoDelete: () => _callUpdateTaskEvent(task, true));
    }
  }

  /// call change status event and delete or don't delete
  void _callUpdateTaskEvent(TaskModel? task, bool alsoDelete) {
    _tasksBloc.add(UpdateTaskEvent(
        taskModel: TaskModel(
            id: task?.id,
            taskStatusType: TaskStatusEnum.completed,
            title: task?.title,
            description: task?.description),
        isChangeStatus: true,
        alsoDelete: alsoDelete));
  }

  /// update only title and description
  void _updateTaskInfo(TaskModel? task) {
    _tasksBloc.add(UpdateTaskEvent(
        taskModel: TaskModel(
            id: task?.id,
            taskStatusType: task?.taskStatusType,
            title: _titleController.text,
            description: _descriptionController.text),
        isChangeStatus: false,
        alsoDelete: false));
  }

  /// call CreateTask Event
  void _createTask() {
    _tasksBloc.add(CreateTaskEvent(
        taskModel: TaskModel(
            title: _titleController.text,
            description: _descriptionController.text)));
  }

  ///   open task dialog and create task
  void _onTapAdd() {
    _textControllerClear();
    _showTaskDialog(isCreate: true);
  }

  /// open task dialog and edit task
  void _onTapEditTask(TaskModel? task) {
    _titleController.text = task?.title ?? '';
    _descriptionController.text = task?.description ?? '';
    _showTaskDialog(task: task);
  }

  ///  title and description clear
  void _textControllerClear() {
    _descriptionController.clear();
    _titleController.clear();
  }
}
