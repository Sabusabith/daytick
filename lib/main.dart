import 'package:day_tick/core/service/day_rollover_service.dart';
import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/history/data/model/day_history_model.dart';
import 'package:day_tick/features/home/data/model/routine_task_model.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_bloc.dart';
import 'package:day_tick/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:day_tick/features/splash/presentation/bloc/splash_event.dart';
import 'package:day_tick/features/splash/presentation/page/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(RoutineTaskModelAdapter());
  Hive.registerAdapter(DayHistoryModelAdapter());

  await Hive.openBox<RoutineTaskModel>('routineBox');
  await Hive.openBox<DayHistoryModel>('historyBox');
  await Hive.openBox('appBox');

  await DayRolloverService.processNewDayIfNeeded();

  runApp(const MayApp());
}

class MayApp extends StatelessWidget {
  const MayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc()..add(StartSplash())),
        BlocProvider(create: (_) => RoutineBloc()),
      ],
      child: MaterialApp( theme: ThemeData(
    scaffoldBackgroundColor: kbgcolor,
    canvasColor: kbgcolor,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  ),debugShowCheckedModeBanner: false, home: Splash()),
    );
  }
}
