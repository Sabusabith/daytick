import 'package:day_tick/core/service/app_date_service.dart';
import 'package:day_tick/core/service/db_service.dart';
import 'package:day_tick/core/service/history_service.dart';
import 'package:day_tick/features/history/data/model/day_history_model.dart';
import 'package:day_tick/features/home/data/model/routine_task_model.dart';
import 'package:intl/intl.dart';

class DayRolloverService {
  static Future<void> processNewDayIfNeeded() async {
    final String todayKey = DateFormat("dd-MM-yyyy").format(DateTime.now());

    if (AppDateService.lastOpenedDate == "") {
      await AppDateService.saveToday(todayKey);
      return;
    }

    if (AppDateService.lastOpenedDate != todayKey) {
      final oldTasks = HiveTaskService.getTasks();

      if (oldTasks.isNotEmpty) {
        final completed = oldTasks.where((e) => e.isDone).length;
        final percent = ((completed / oldTasks.length) * 100).toInt();

        await HiveHistoryService.addHistory(
          DayHistoryModel(
            dateLabel: AppDateService.lastOpenedDate,
            tasks: oldTasks.map((e) => e.copyWith()).toList(),
            progressPercent: percent,
            perfectDay: percent == 100,
          ),
        );
      }

      final resetTasks = oldTasks.map((e) {
        return e.copyWith(isDone: false, isActive: false);
      }).toList();

      await HiveTaskService.updateAllTasks(resetTasks);

      await AppDateService.saveToday(todayKey);
    }
  }
}
