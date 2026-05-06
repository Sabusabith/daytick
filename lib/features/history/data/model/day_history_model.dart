import 'package:hive/hive.dart';
import 'package:day_tick/features/home/data/model/routine_task_model.dart';

part 'day_history_model.g.dart';

@HiveType(typeId: 1)
class DayHistoryModel extends HiveObject {
  @HiveField(0)
  final String dateLabel;

  @HiveField(1)
  final List<RoutineTaskModel> tasks;

  @HiveField(2)
  final int progressPercent;

  @HiveField(3)
  final bool perfectDay;

  DayHistoryModel({
    required this.dateLabel,
    required this.tasks,
    required this.progressPercent,
    required this.perfectDay,
  });
}
