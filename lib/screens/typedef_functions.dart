import 'package:to_do_app/enum/task_status_enum.dart';

typedef StringCallback = Function(String value);
typedef DoubleDateTimeCallback = Function(DateTime? value1, DateTime? value2);
typedef DynamicCallback = Function(dynamic value);
typedef IndexCallback = Function(int index);
typedef BoolCallback = Function(bool value);
typedef DateTimeCallback = Function(DateTime? date);
typedef TaskStatusEnumCallback = Function(TaskStatusEnum taskStatusEnum);
