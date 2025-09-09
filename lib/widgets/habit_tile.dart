import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const HabitTile({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: selectedIndex == index ? Color(0xff0A5938) : Color(0xffd5d5d5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  "Read Book",
                  style: TextStyle(
                    color: index == selectedIndex ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
