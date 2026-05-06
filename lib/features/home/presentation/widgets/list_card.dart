import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/home/data/model/routine_task_model.dart';
import 'package:flutter/material.dart';

class RoutineTaskCard extends StatelessWidget {
  final RoutineTaskModel task;
  final VoidCallback onTap;
  final VoidCallback? onLongDelete;

  const RoutineTaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onLongDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: task.isUserAdded ? onLongDelete : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xff151d30).withOpacity(.95),
              const Color(0xff0d1426).withOpacity(.92),
            ],
          ),
          border: Border.all(
            color: task.isActive
                ? kprimerycolor.withOpacity(.7)
                : Colors.white.withOpacity(.05),
            width: task.isActive ? 1.2 : .8,
          ),
          boxShadow: [
            BoxShadow(
              color: task.isActive
                  ? kprimerycolor.withOpacity(.25)
                  : Colors.black.withOpacity(.35),
              blurRadius: task.isActive ? 18 : 10,
              spreadRadius: task.isActive ? 1 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.time,
                    style: TextStyle(
                      color: task.isActive
                          ? kprimerycolor
                          : Colors.white.withOpacity(.35),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.title,
                    style: TextStyle(
                      color: task.isDone
                          ? Colors.white.withOpacity(.7)
                          : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: task.isDone
                      ? kprimerycolor.withOpacity(.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isDone
                        ? kprimerycolor
                        : Colors.white.withOpacity(.25),
                    width: 1.5,
                  ),
                  boxShadow: task.isDone
                      ? [
                          BoxShadow(
                            color: kprimerycolor.withOpacity(.35),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: task.isDone
                    ? const Icon(Icons.check, size: 18, color: kprimerycolor)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
