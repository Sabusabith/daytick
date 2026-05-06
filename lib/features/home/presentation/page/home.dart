import 'dart:io';

import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_bloc.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_event.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_state.dart';
import 'package:day_tick/features/home/presentation/page/history_screen.dart';
import 'package:day_tick/features/home/presentation/widgets/greetings.dart';
import 'package:day_tick/features/home/presentation/widgets/list_card.dart';
import 'package:day_tick/features/home/presentation/widgets/task_add_dialogue.dart';
import 'package:day_tick/features/profile/presentation/page/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String todayDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: GestureDetector(
          onTap: () {
            showAddTaskDialog(context);
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff0f1a12),
              border: Border.all(
                color: kgreencolor.withOpacity(.7),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: kgreencolor.withOpacity(.45),
                  blurRadius: 22,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(.35),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: kgreencolor, size: 30),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
          shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
        toolbarHeight: 60,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade800, // underline color
            height: 1,
          ),
        ),
        backgroundColor: kappbarcolour,
        leadingWidth: 160,
     leading: Padding(
       padding: const EdgeInsets.only(left: 8),
       child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: FutureBuilder(
              future: UserPrefs.getUser(),
              builder: (context, snapshot) {
                final name = snapshot.data?["name"] ?? "";
                final imagePath = snapshot.data?["image"];
       
                return Row(
                  children: [
                    const SizedBox(width: 12),
       
                    /// PROFILE IMAGE
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white10,
                      backgroundImage: (imagePath != null && imagePath != "")
                          ? FileImage(File(imagePath))
                          : null,
                      child: (imagePath == null || imagePath == "")
                          ? const Icon(Icons.person, size: 18, color: Colors.blue)
                          : null,
                    ),
       
                    const SizedBox(width: 10),
       
                    /// NAME
                    Flexible(
                      child: Text(
                        name.isNotEmpty ? "Hi, $name" : "Hi, User",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kprimerycolor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
     ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryScreen()),
              );
            },
            child: Icon(Icons.calendar_month, color: Colors.grey.shade400),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: kBackgroundGradient),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        greeting(),
                        style: GoogleFonts.catamaran(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    //Date Section
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        todayDate,
                        style: GoogleFonts.catamaran(
                          color: const Color.fromARGB(255, 212, 208, 208),
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: BlocBuilder<RoutineBloc, RoutineState>(
                    builder: (context, state) {
                      final Color progressColor = state.progressPercent == 100
                          ? const Color.fromARGB(255, 127, 214, 6)
                          : kprimerycolor;
                      return Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: state.progressValue,
                            strokeWidth: 5,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation(progressColor),
                          ),
                          Center(
                            child: Text(
                              "${state.progressPercent}%",
                              style: GoogleFonts.publicSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: Container(
                width: size.width,
                child: BlocBuilder<RoutineBloc, RoutineState>(
                  builder: (context, state) {
                        if (state.tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              color: Colors.white.withOpacity(.3),
                              size: 60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No Tasks",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.6),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Add your first task to get started",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.3),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];

                        return RoutineTaskCard(
                          task: task,
                          onTap: () {
                            context.read<RoutineBloc>().add(
                              ToggleTaskCheckBox(index),
                            );
                          },
                   onLongDelete: () {
                            if (task.isUserAdded) {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "DeleteTask",
                                barrierColor: Colors.black87,
                                transitionDuration: const Duration(
                                  milliseconds: 250,
                                ),
                                pageBuilder: (context, a1, a2) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(22),
                                          decoration: BoxDecoration(
                                            color: ktilecolor,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            border: Border.all(
                                              color: Colors.red.withOpacity(
                                                .35,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(
                                                  .08,
                                                ),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.redAccent,
                                                size: 40,
                                              ),

                                              const SizedBox(height: 12),

                                              const Text(
                                                "Delete Task?",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              const SizedBox(height: 10),

                                              Text(
                                                "Do you want to remove '${task.title}' ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(.7),
                                                  fontSize: 14,
                                                ),
                                              ),

                                              const SizedBox(height: 24),

                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          ),
                                                      onPressed: () {
                                                        context
                                                            .read<RoutineBloc>()
                                                            .add(
                                                              DeleteTask(index),
                                                            );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
