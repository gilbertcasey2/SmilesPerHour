///
// Name: press
// This class represents one press of a button
// It holds the date/time and level of happiness
// just a helper
///

class press {
   
 // data fields
  int level;
  int month;
  int day;
  int hour; 
  
  public press(int p_level, int p_month, int p_day, int p_hour) {
   this.level = p_level;
   this.month = p_month;
   this.day = p_day; 
   adjust(p_hour);
  }                                                                  
  
  private void adjust(int houry) {
   if (houry >= 4) {
      hour = houry - 4;
   } else {
     hour = houry + 20;
     day = day - 1;  
   }
   //print("houry: " + houry);
   //println(" and hour: " + hour);
  }
  
  void printPress() {
    println("Press from " + month + "/" + day +  " at " + hour + " o clock was a " + level + "."); 
  }
  
}
