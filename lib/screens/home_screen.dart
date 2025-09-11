import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:utracker/models/habit_status_model.dart';
import 'package:utracker/models/user_model.dart';
import 'package:utracker/screens/add_habit.dart';
import 'package:utracker/screens/onboarding_screen.dart';
import 'package:utracker/screens/settings.dart';
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
  late Box settingsBox;
  late Box userBox;
  late Box<Habit> habitBox;
  late Box<HabitStatus> habitStatusBox;

  int selectedIndex = -1;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settingsBox');
    userBox = Hive.box<User>('Users');
    habitBox = Hive.box<Habit>('Habits');
    habitStatusBox = Hive.box<HabitStatus>('HabitStatus');
    DateTime today = DateTime.now();
    selectedDate = DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = settingsBox.get('currentUser');
    final user = userBox.get(currentUser);
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
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Settings()));
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
                        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
                        final statusKey= '${habit.key}-$formattedDate';
                        final status=habitStatusBox.get(statusKey);
                        final isCompleted= status?.isCompleted?? false;
                        return HabitTile(
                          date:selectedDate,
                          context: context,
                          isCompleted:isCompleted,
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
