import 'package:day_tick/core/service/history_service.dart';
import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/history/data/model/day_history_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with WidgetsBindingObserver {
  List<DayHistoryModel> historyList = [];
  int selectedIndex = 0;

  void loadHistory() {
    final data = HiveHistoryService.getHistory();

    if (!mounted) return;

    setState(() {
      historyList = data;

      if (historyList.isEmpty) {
        selectedIndex = 0;
      } else if (selectedIndex >= historyList.length) {
        selectedIndex = 0;
      }
    });
  }

  DateTime parseDate(String value) {
    return DateFormat("dd-MM-yyyy").parse(value);
  }
Future<void> pickHistoryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: parseDate(historyList[selectedIndex].dateLabel),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kprimerycolor,
              onPrimary: Colors.black,
              surface: const Color(0xff151d30),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final pickedString = DateFormat("dd-MM-yyyy").format(picked);

    final index = historyList.indexWhere((e) => e.dateLabel == pickedString);

    if (index != -1) {
      setState(() {
        selectedIndex = index;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No history found for selected date")),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadHistory();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadHistory();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (historyList.isEmpty) {
      return Scaffold(
        backgroundColor: kbgcolor,
        body:  Center(
          child: Text("No History Yet", style: GoogleFonts.publicSans(color: Colors.white)),
        ),
      );
    }

    final DayHistoryModel selectedDay = historyList[selectedIndex];
    final completedTasks = selectedDay.tasks.where((e) => e.isDone).toList();

    return Scaffold(
      backgroundColor: kbgcolor,
      body: Container(
        decoration: BoxDecoration(gradient: kBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "History",
                      style: GoogleFonts.catamaran(
                        color: kprimerycolor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: pickHistoryDate,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(.1),
                          ),
                          color: Colors.white.withOpacity(.03),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// DATE SELECTOR
              SizedBox(
                height: 82,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: historyList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final date = parseDate(historyList[index].dateLabel);
                    final bool isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? kprimerycolor
                                : Colors.white.withOpacity(.08),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: kprimerycolor.withOpacity(.2),
                                    blurRadius: 14,
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat("E").format(date).toUpperCase(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(.4),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat("dd").format(date),
                              style: TextStyle(
                                color: isSelected
                                    ? kprimerycolor
                                    : Colors.white70,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// SUMMARY CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xff1b243a), Color(0xff11192e)],
                  ),
                  border: Border.all(color: kgreencolor.withOpacity(.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Summary",
                            style: GoogleFonts.catamaran(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            selectedDay.perfectDay
                                ? "${selectedDay.progressPercent}% Complete — Perfect Day!"
                                : "${selectedDay.progressPercent}% Completed",
                            style: TextStyle(color: kgreencolor, fontSize: 18),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "${completedTasks.length} TASKS COMPLETED",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.45),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: selectedDay.progressPercent / 100,
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation(kgreencolor),
                            backgroundColor: Colors.white12,
                          ),
                          Center(
                            child: Text(
                              "${selectedDay.progressPercent}%",
                              style: const TextStyle(color: kgreencolor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "COMPLETED TASKS",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.45),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: completedTasks.length,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ktilecolor,
                        border: Border.all(
                          color: Colors.white.withOpacity(.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: kprimerycolor.withOpacity(.12),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: kprimerycolor,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  task.time,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kgreencolor.withOpacity(.15),
                              boxShadow: [
                                BoxShadow(
                                  color: kgreencolor.withOpacity(.4),
                                  blurRadius: 14,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: kgreencolor,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
