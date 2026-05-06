import 'package:bloc/bloc.dart';
import 'package:day_tick/features/splash/presentation/bloc/splash_event.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>(_onStartSplash);
  }

  Future<void> _onStartSplash(
    StartSplash event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name");
    final age = prefs.getInt("age");

    if (name != null && age != null) {
      emit(SplashGoHome());
    } else {
      emit(SplashGoLogin());
    }
  }
}
