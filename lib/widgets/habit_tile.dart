import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utracker/models/habit_model.dart';
import 'package:intl/intl.dart';
import 'package:utracker/models/habit_status_model.dart';


class HabitTile extends StatefulWidget {
  final DateTime? date;
  final BuildContext context;
  final bool isCompleted;
  final Habit habit;


  const HabitTile({
    super.key,
    required this.date,
    required this.context,
    required this.isCompleted,
    required this.habit,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  final habitStatusBox = Hive.box<HabitStatus>('HabitStatus');

  void _deleteHabit() {
    widget.habit.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(seconds: 2), content: Text('Habbit Deleted')),
    );
    Navigator.of(context).pop();
  }

  void toggleStatus(Habit habit) {

    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.date!);
    final statusKey = '${habit.key}-$formattedDate';

    HabitStatus? status= habitStatusBox.get(statusKey);

    if(status!=null){
      status.isCompleted =!status.isCompleted;
      status.save();
    }else{
      final newStatus=HabitStatus(habitId: habit.key.toString(), date: formattedDate,isCompleted: true);
      habitStatusBox.put(statusKey, newStatus);
    }   

  }

  void _showHabitInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: Text(widget.habit.title),
          content: Text(
            widget.habit.desc.isNotEmpty
                ? widget.habit.desc
                : "No Description given",
          ),
          actions: [
            IconButton(
              onPressed: () {
                _deleteHabit();
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
            ),
          ],
        );
      },
    );
  }

  // void _deleteHabit(){
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isCompleted? Colors.orangeAccent: Color(0xffd5d5d5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: InkWell(
        onTap: (){
          toggleStatus(widget.habit);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.habit.title, style: TextStyle(color: Colors.black)),
            Row(children: [
              InkWell(
              onTap: () {
                _showHabitInfo();
              },
              child: Icon(Icons.info),
            ),
            Checkbox(
              value: widget.isCompleted,
              onChanged: (_) {
                toggleStatus(widget.habit);
              },
            ),
            ],)
            
          ],
        ),
      ),
    );
  }
}
