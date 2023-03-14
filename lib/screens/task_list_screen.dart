import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:to_do_app/components/centered_button_widget.dart';
import 'package:to_do_app/components/dropdown_status_button.dart';
import 'package:to_do_app/components/text_filed_widget.dart';
import 'package:to_do_app/constants/app_colors.dart';
import 'package:to_do_app/constants/app_styles.dart';
import 'package:to_do_app/enum/task_status_enum.dart';
import 'package:to_do_app/mixins/device_metrics.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/repositories/firebase_repositories/firebase_implementation_repositories/firebase_jobs_implementation_repository.dart';
import 'package:to_do_app/screens/typedef_functions.dart';
import 'package:to_do_app/tasks.bloc/tasks_bloc.dart';
import 'package:to_do_app/tasks.bloc/tasks_event.dart';
import 'package:to_do_app/tasks.bloc/tasks_state.dart';

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
  final ValueNotifier<bool> _isDeletedNotifier = ValueNotifier(false);

  @override
  void initState() {
    _tasksBloc = TasksBloc(FirebaseTaskImplementationRepository())
      ..add(ListenAllTasksEvent());
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
                    child: TaskListView(taskList: _tasksBloc.taskList)))));
  }
}

class TaskListView extends StatelessWidget with DeviceMetricsStateless {
  const TaskListView({required this.taskList, Key? key}) : super(key: key);

  final List<TaskModel>? taskList;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: taskList?.length,
            itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Title   '),
                                    Container(
                                        width: width(context) / 3,
                                        child: Text(
                                            taskList?[index].title ?? '',
                                            overflow: TextOverflow.ellipsis))
                                  ]),
                              Row(children: [
                                Text('Description   '),
                                Container(
                                    width: width(context) / 3,
                                    child: Text(
                                        taskList?[index].description ?? '',
                                        overflow: TextOverflow.ellipsis))
                              ]),
                              Row(children: [
                                Text('Is Completed   '),
                                Checkbox(
                                    value: taskList?[index].taskStatusType ==
                                        TaskStatusEnum.completed,
                                    onChanged: (_) {})
                              ])
                            ]),
                        Row(children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.open_with)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete))
                        ])
                      ]),
                  const Divider()
                ]))));
  }
}

extension _TaskListScreenStateAddition on _TaskListScreenState {
  void _listener(context, state) {
    if (state is CreateTaskState) {
      _textControlerClear();
    }
  }

  void _onTapAdd() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              scrollable: true,
              title: Text('New Task', style: getStyle(fontSize: 20)),
              content: Column(children: [
                TextFiledWidget(hint: 'Title', controller: _titleController),
                TextFiledWidget(
                    hint: 'Description', controller: _descriptionController),
                Row(children: [
                  Text('Will be deleted after completing the task',
                      style: getStyle(fontSize: 10)),
                  ValueListenableBuilder(
                      valueListenable: _isDeletedNotifier,
                      builder: (context, bool value, child) => Switch(
                          value: value,
                          onChanged: (value) {
                            _isDeletedNotifier.value = value;
                          }))
                ])
              ]),
              actions: [
                CenteredButtonWidget(
                    onTap: _textControlerClear, title: 'Cancel', width: 100),
                CenteredButtonWidget(
                    onTap: () {
                      _tasksBloc.add(CreateTaskEvent(
                          taskModel: TaskModel(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              isDeleteWhenCompleted:
                                  _isDeletedNotifier.value)));
                    },
                    title: 'Save',
                    width: 100)
              ]));

  void _textControlerClear() {
    _descriptionController.clear();
    _titleController.clear();
    Navigator.pop(context);
  }

  PreferredSizeWidget appBar() {
    return AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Task List'),
      StatusWorkingPopup(
        statusWorkingType: TaskStatusEnum.all,
        statusWorkingTypeCallback: (TaskStatusEnum taskStatusEnum) {},
      ),
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
            columnWidth: 150,
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
