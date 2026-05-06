import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_bloc.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

void showAddTaskDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  DateTime selectedTime = DateTime.now();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "TaskDialog",
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, a1, a2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 30,
            ),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ktilecolor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kgreencolor.withOpacity(.35)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Add New Task",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// TASK FIELD
                        TextField(
                          cursorColor: Colors.grey.shade200,
                          controller: titleController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter task title",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(.1),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kprimerycolor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select Time",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.7),
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// TIME PICKER
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: const Color(0xff11192e),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(.05),
                            ),
                          ),
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                              brightness: Brightness.dark,
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: false,
                              initialDateTime: selectedTime,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  selectedTime = newTime;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Selected: ${DateFormat('h:mm a').format(selectedTime)}",
                          style: TextStyle(
                            color: kgreencolor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kgreencolor,
                                ),
                                onPressed: () {
                                  if (titleController.text.trim().isNotEmpty) {
                                    context.read<RoutineBloc>().add(
                                      AddNewTask(
                                        title: titleController.text.trim(),
                                        time: DateFormat(
                                          'h:mm a',
                                        ).format(selectedTime),
                                      ),
                                    );

                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "Add",
                                  style: TextStyle(color: Colors.black),
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
            ),
          );
        },
      );
    },
  );
}
