import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:utracker/screens/add_habit.dart';
import 'package:utracker/screens/onboarding_screen.dart';
import 'package:utracker/widgets/habit_tile.dart';
import 'package:utracker/models/habit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final userBox = Hive.box('userBox');
  final settingsBox = Hive.box('settingsBox');
  int selectedIndex = -1;
  DateTime? selectedDate;
  final habitBox = Hive.box<Habit>('Habits');

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    selectedDate = DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddHabit()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xff0A5938)),
              child: Text(
                "Hi, ${userBox.get('name')}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: () {
                settingsBox.put('isLoggedIn', false);
                ref.read(authProvider.notifier).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OnboardingScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Habits", style: TextTheme.of(context).titleLarge),
                  SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          DateTime day = today.subtract(Duration(days: index));
                          day = DateTime(day.year, day.month, day.day);
                          String dayName = DateFormat('EEEE').format(day);
                          return Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: day == selectedDate
                                  ? Color(0xff0A5938)
                                  : Color(0xffd5d5d5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedDate = day;
                                });
                                log("$day");
                                log("$today");
                              },
                              child: Column(
                                children: [
                                  Text(
                                    day == today ? 'Today' : dayName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: day == selectedDate
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${day.day}",
                                    style: TextStyle(
                                      color: day == selectedDate
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: habitBox.listenable(),
                  builder: (context, Box<Habit> box, _) {
                    if (box.values.isEmpty) {
                      return Center(child: Text("No habits added"));
                    }
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final habit = box.getAt(index);
                        if (habit == null) {
                          return SizedBox();
                        }
                        return HabitTile(
                          index: index,
                          context:context,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          habit: habit,
                        );
                      },
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
