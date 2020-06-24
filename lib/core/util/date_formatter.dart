class DateFormatter {
  static String formatToYYYYMMDD(DateTime dateTime){
    return "${dateTime.year}-${_monthPadded(dateTime.month)}-${dateTime.day}";
  }

  static String _monthPadded(int month){
    if(month < 10){
      return "0$month";
    }else{
      return month.toString();
    }
  }

}