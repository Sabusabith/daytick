import 'package:hive/hive.dart';

part 'routine_task_model.g.dart';

@HiveType(typeId: 0)
class RoutineTaskModel extends HiveObject {
  @HiveField(0)
  final String time;

  @HiveField(1)
  final String title;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  bool isUserAdded;

  RoutineTaskModel({
    required this.time,
    required this.title,
    this.isDone = false,
    this.isActive = false,
    this.isUserAdded = false,
  });

  RoutineTaskModel copyWith({
    String? time,
    String? title,
    bool? isDone,
    bool? isActive,
    bool? isUserAdded,
  }) {
    return RoutineTaskModel(
      time: time ?? this.time,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      isActive: isActive ?? this.isActive,
      isUserAdded: isUserAdded ?? this.isUserAdded,
    );
  }
}
