import 'package:day_tick/features/home/data/model/routine_task_model.dart';
import 'package:hive/hive.dart';

class HiveTaskService {
  static final Box<RoutineTaskModel> _box = Hive.box<RoutineTaskModel>(
    'routineBox',
  );

  static List<RoutineTaskModel> getTasks() {
    return _box.values.toList();
  }

  static Future<void> addTask(RoutineTaskModel task) async {
    await _box.add(task);
  }

  static Future<void> deleteTask(int index) async {
    await _box.deleteAt(index);
  }

  static Future<void> updateAllTasks(List<RoutineTaskModel> tasks) async {
    await _box.clear();
    await _box.addAll(tasks);
  }

  static bool get isEmpty => _box.isEmpty;
}
