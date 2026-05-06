import 'dart:io';

import 'package:day_tick/core/service/history_service.dart';
import 'package:day_tick/core/utils/app_colours.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_bloc.dart';
import 'package:day_tick/features/home/presentation/bloc/routine_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String keyName = "name";
  static const String keyAge = "age";
  static const String keyImage = "image";

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString(keyName) ?? "",
      "age": prefs.getInt(keyAge) ?? 0,
      "image": prefs.getString(keyImage),
    };
  }

  static Future<void> saveImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyImage, path);
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker picker = ImagePicker();

  String? imagePath;

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });

      await UserPrefs.saveImage(picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = HiveHistoryService.getHistory();

    final doneTasks = history.fold(
      0,
      (sum, d) => sum + d.tasks.where((e) => e.isDone).length,
    );

    return Scaffold(
      backgroundColor: kbgcolor,
      body: Container(
        decoration: const BoxDecoration(gradient: kBackgroundGradient),
        child: FutureBuilder(
          future: UserPrefs.getUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: kgreencolor),
              );
            }

            final user = snapshot.data!;
            final name = user["name"].toString();
            final age = user["age"].toString();

            final savedImage = imagePath ?? user["image"];

            return BlocBuilder<RoutineBloc, RoutineState>(
              builder: (context, state) {
                final activeTasks = state.tasks.length;
                final todayDone = state.tasks.where((e) => e.isDone).length;

                final todayProgress = activeTasks == 0
                    ? 0.0
                    : todayDone / activeTasks;

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            GestureDetector(onTap: () {
                              Navigator.pop(context);
                            },
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.grey.shade200,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Profile",
                              style: GoogleFonts.catamaran(
                                color: kprimerycolor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// PROFILE CARD
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ktilecolor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              /// ✅ CLICKABLE AVATAR
                              GestureDetector(
                                onTap: pickImage,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: kgreencolor,
                                  backgroundImage:
                                      (savedImage != null &&
                                          savedImage.toString().isNotEmpty)
                                      ? FileImage(File(savedImage))
                                      : null,
                                  child:
                                      (savedImage == null ||
                                          savedImage.toString().isEmpty)
                                      ? Text(
                                          name.isNotEmpty
                                              ? name[0].toUpperCase()
                                              : "?",
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                "Age: $age",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.6),
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Tap avatar to update",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.3),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// TODAY PROGRESS
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: ktilecolor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today Progress",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: todayProgress,
                                backgroundColor: Colors.white12,
                                valueColor: const AlwaysStoppedAnimation(
                                  kgreencolor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(todayProgress * 100).toInt()}% completed today",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// STATS
                        Row(
                          children: [
                            Expanded(
                              child: _box("Active Tasks", "$activeTasks"),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: _box("Done Tasks", "$doneTasks")),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _box(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ktilecolor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: kgreencolor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(.6))),
        ],
      ),
    );
  }
}
