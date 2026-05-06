import 'package:day_tick/core/service/db_service.dart';
import 'package:day_tick/features/home/data/model/routine_task_model.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_event.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc() : super(RoutineState([])) {
    _loadInitialTasks();

    on<ToggleTaskCheckBox>((event, emit) async {
      final updated = state.tasks.asMap().entries.map((entry) {
        int i = entry.key;
        RoutineTaskModel task = entry.value;

        if (i == event.index) {
          return task.copyWith(isDone: !task.isDone, isActive: true);
        } else {
          return task.copyWith(isActive: false);
        }
      }).toList();

      await HiveTaskService.updateAllTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<AddNewTask>((event, emit) async {
      final updated = List<RoutineTaskModel>.from(state.tasks);

      updated.add(
        RoutineTaskModel(
          time: event.time,
          title: event.title,
          isDone: false,
          isActive: false,
          isUserAdded: true,
        ),
      );

      await HiveTaskService.updateAllTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<DeleteTask>((event, emit) async {
      final updated = List<RoutineTaskModel>.from(state.tasks);

      updated.removeAt(event.index);

      await HiveTaskService.updateAllTasks(updated);
      emit(state.copyWith(tasks: updated));
    });
  }

 void _loadInitialTasks() async {
    if (HiveTaskService.isEmpty) {
      // await HiveTaskService.addTask(
      //   RoutineTaskModel(
      //     time: "5:00 AM",
      //     title: "Fajr Prayer",
      //     isUserAdded: false,
      //   ),
      // );

      // await HiveTaskService.addTask(
      //   RoutineTaskModel(
      //     time: "6:30 AM",
      //     title: "Morning Exercise / Yoga",
      //     isUserAdded: false,
      //   ),
      // );

      // await HiveTaskService.addTask(
      //   RoutineTaskModel(
      //     time: "8:00 AM",
      //     title: "Breakfast & Prep",
      //     isUserAdded: false,
      //   ),
      // );
    }

    emit(state.copyWith(tasks: HiveTaskService.getTasks()));
  }
}
