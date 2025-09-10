import 'package:flutter/material.dart';
import 'package:utracker/models/habit_model.dart';

class HabitTile extends StatelessWidget {
  final int index;
  final BuildContext context;
  final VoidCallback onTap;
  final Habit habit;

  const HabitTile({
    super.key,
    required this.index,
    required this.context,
    required this.onTap,
    required this.habit,
  });

  void _deleteHabit(){
    habit.delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: Colors.red, duration: Duration(seconds: 2),content: Text('Habbit Deleted')));
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = false;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffd5d5d5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(habit.title, style: TextStyle(color: Colors.black)),
            Row(
              spacing: 5,
              children: [
                InkWell(child: Icon(Icons.delete), onTap: (){
                  _deleteHabit();
                },) ,
                Icon(isCompleted ? Icons.check : Icons.circle_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
