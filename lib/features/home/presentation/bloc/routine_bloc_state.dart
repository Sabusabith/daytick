import 'package:day_tick/features/home/data/model/routine_task_model.dart';

class RoutineState {
  final List<RoutineTaskModel> tasks;

  RoutineState(this.tasks);

  RoutineState copyWith({List<RoutineTaskModel>? tasks}) {
    return RoutineState(tasks ?? this.tasks);
  }

  int get completedCount => tasks.where((e) => e.isDone).length;

  double get progressValue {
    if (tasks.isEmpty) return 0;
    return completedCount / tasks.length;
  }

  int get progressPercent => (progressValue * 100).toInt();



  int get totalTasks => tasks.length;

  int get doneTasks => tasks.where((e) => e.isDone).length;


}
