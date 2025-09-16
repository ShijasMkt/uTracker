bool isToday(DateTime? selectedDay) {
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day);
      if (today == selectedDay) {
        return true;
      } else {
        return false;
      }
    }