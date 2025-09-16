import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utracker/core/constrants/app_colors.dart';
import 'package:utracker/features/habit_tracker/presentation/functions/is_today.dart';

class DateDisplay extends StatefulWidget {
  final DateTime today;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  const DateDisplay({
    super.key,
    required this.today,
    required this.selectedDate,
    required this.onDateSelected
  });

  @override
  State<DateDisplay> createState() => _DateDisplayState();
}

class _DateDisplayState extends State<DateDisplay> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate=widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    bool isSelectedDay(DateTime? day) {
      return _selectedDate!=null && day == _selectedDate;
    }

    return Expanded(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            DateTime day = widget.today.subtract(Duration(days: index));
            day = DateTime(day.year, day.month, day.day);
            String dayName = DateFormat('EEEE').format(day);
            return Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelectedDay(day)
                    ? AppColors.mainGreenColor
                    : AppColors.mainGreyColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                  widget.onDateSelected(day);
                },
                child: Column(
                  children: [
                    Text(
                      isToday(day) ? 'Today' : dayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelectedDay(day)
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${day.day}",
                      style: TextStyle(
                        color: isSelectedDay(day)
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
    );
  }
}
