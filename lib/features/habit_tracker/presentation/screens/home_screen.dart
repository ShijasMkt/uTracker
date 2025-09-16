import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utracker/core/constrants/app_colors.dart';
import 'package:utracker/features/habit_tracker/data/models/habit_status_model.dart';
import 'package:utracker/features/habit_tracker/data/models/user_model.dart';
import 'package:utracker/features/habit_tracker/presentation/functions/date_only_format.dart';
import 'package:utracker/features/habit_tracker/presentation/screens/add_habit.dart';
import 'package:utracker/features/habit_tracker/presentation/screens/onboarding_screen.dart';
import 'package:utracker/features/habit_tracker/presentation/screens/settings.dart';
import 'package:utracker/features/habit_tracker/presentation/functions/streak_calculator.dart';
import 'package:utracker/features/habit_tracker/presentation/widgets/date_display.dart';
import 'package:utracker/features/habit_tracker/presentation/widgets/habit_tile.dart';
import 'package:utracker/features/habit_tracker/data/models/habit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/core/auth/auth_provider.dart';
import 'package:utracker/features/habit_tracker/presentation/functions/is_today.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Box settingsBox;
  late Box userBox;
  late Box<Habit> habitBox;
  late Box<HabitStatus> habitStatusBox;
  int selectedIndex = -1;
  DateTime? selectedDate;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settingsBox');
    userBox = Hive.box<User>('Users');
    habitBox = Hive.box<Habit>('Habits');
    habitStatusBox = Hive.box<HabitStatus>('HabitStatus');
    today = DateTime(today.year, today.month, today.day);
    selectedDate = DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = settingsBox.get('currentUser');
    final user = userBox.get(currentUser);

    return Scaffold(
      appBar: _myAppBar(context),
      drawer: _myDrawer(user, context),
      floatingActionButton: _myFloatingActionButton(context),
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
                  DateDisplay(
                    today: today,
                    selectedDate: selectedDate,
                    onDateSelected: (newDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: habitStatusBox.listenable(),
                  builder: (context, Box<HabitStatus> statusBox, _) {
                    return ValueListenableBuilder(
                      valueListenable: habitBox.listenable(),
                      builder: (context, Box<Habit> box, _) {
                        final currentUser = settingsBox.get('currentUser');

                        final userHabits = box.values
                            .where((habit) => habit.userId == currentUser)
                            .toList();
                        if (userHabits.isEmpty) {
                          return Center(child: Text("No habits added"));
                        }

                        return ListView.builder(
                          itemCount: userHabits.length,
                          itemBuilder: (context, index) {
                            final habit = userHabits[index];
                            String formattedDate = dateOnlyFormatter(
                              selectedDate!,
                            );
                            final statusKey = '${habit.key}-$formattedDate';
                            final status = habitStatusBox.get(statusKey);
                            final isCompleted = status?.isCompleted ?? false;
                            int streak = isToday(selectedDate)
                                ? calculateStreak(habit, statusBox)
                                : 0;
                            return HabitTile(
                              date: selectedDate,
                              context: context,
                              isCompleted: isCompleted,
                              habit: habit,
                              streak: streak,
                              isToday: isToday(selectedDate),
                            );
                          },
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

  //AppBar
  AppBar _myAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  //Drawer of app
  Drawer _myDrawer(User user, BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.mainGreenColor),
            child: Text(
              "Hi, ${user.uName}",
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Settings()),
              );
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
    );
  }

  //floatingActionBtn
  FloatingActionButton _myFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddHabit()));
      },
      child: Icon(Icons.add),
    );
  }
}
