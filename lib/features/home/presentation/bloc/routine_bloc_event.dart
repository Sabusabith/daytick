abstract class RoutineEvent {}

class ToggleTaskCheckBox extends RoutineEvent {
  final int index;
  ToggleTaskCheckBox(this.index);
}


class AddNewTask extends RoutineEvent {
  final String title;
  final String time;

  AddNewTask({required this.title, required this.time});
}
class DeleteTask extends RoutineEvent {
  final int index;
  DeleteTask(this.index);
}



