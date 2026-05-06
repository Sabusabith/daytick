import 'package:day_tick/features/history/data/model/day_history_model.dart';
import 'package:hive/hive.dart';

class HiveHistoryService {
  static final Box<DayHistoryModel> _historyBox = Hive.box<DayHistoryModel>(
    'historyBox',
  );

  static List<DayHistoryModel> getHistory() {
    final data = _historyBox.values.toList();
    data.sort((a, b) => b.dateLabel.compareTo(a.dateLabel));
    return data;
  }

  static Future<void> addHistory(DayHistoryModel model) async {
    await _historyBox.add(model);
  }

  static bool get isEmpty => _historyBox.isEmpty;
}
