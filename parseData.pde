///
// Author: Casey E Gilbert
// Name: parseData.pde
// Created: May 12, 2017
// Purpose: To parse the data collected from the happiness kiosks,
//	    and put it into documents that would be manageable for 
//	    the SmilesPerHour to use to send movement data to the 
//	    arduino's motors. 
//
// parseData()
// This is a program to parse data from an 
// individual location file
///

Table table;
int rowNum;
press[] presses;
int[] hapArray;

PrintWriter output; // the printwriter

ArrayList<Float> hours = new ArrayList<Float>();

void setup() {
  
    // create the table
    table = loadTable("location2.csv", "header"); // name of file
    rowNum = table.getRowCount();
    presses = new press[rowNum];
    
    // loop through and put the objects in an array
    for (TableRow row : table.rows()) {
       String date = row.getString("created_at");
       int id = row.getInt("entry_id")-15;
       int level = row.getInt("field1"); 
       // split the string into necessary fields
       int m = Integer.parseInt(date.substring(5,7));
       int d = Integer.parseInt(date.substring(8,10));
       int h = Integer.parseInt(date.substring(11,13));
       // make the object
       presses[id] = new press(level, m, d, h);
    }
    println("---------------- NEXT ------------------------");
    for (int i = 0; i < 550; i++) {
      println("Day: " + presses[i].day);
    }
    
    output = createWriter("location2-1.txt");
    

    // now loop through the object array and sort the 
    // objects into averages per hour
    // hours w/ no input are 6
    // store the final value in an Arraylist
    int prev = presses[0].hour; 
    int h = presses[0].hour;
    float l;
    int count = 0;
    float temp = 0;
    float tempCount = 0;
    for (int i = 0; i < rowNum; i++) {
      // make sure we didn't skip a day!
      if (i > 0) {
      if ((presses[i].day != presses[i-1].day) && (presses[i].hour == presses[i-1].hour)) {
        //output.println("Adding day! " + presses[i].day+ " and hour: " + presses[i].hour + " and the old day: " 
       // + presses[i-1].day + " and the hour " + presses[i-1].hour);
        for( int k = 0; k < 24; k++) {
          hours.add(6.0);
          //output.println("Index: " + i + " Hour " + h + ": " + hours.get(hours.size()-1));  
        }
      }
      }
     // h is equivalient to the hour of the press at that index
     h = presses[i].hour; 
     // l is the level of happiness for the press at that inddes
     l = presses[i].level;
     // if the hour at that press index is a new hour
     if (h != prev) {
       // see if the old hour was under 23
        if (prev < 23) {
          // if it is, then h is one more than the previous hour
          h = prev+1;
        }else {
          // otherwise, we loop around and become hour 0
           h = 0;
        }
        
        if (tempCount != 0) {
          hours.add(temp/tempCount);
          //output.println("Index: " + i + " Hour " + prev + ": " + hours.get(hours.size()-1)); 
        }
       
       // if the hour of that presses is 0
        if(presses[i].hour == 0) {
          // then we add 6s until hour is up to 23
          while(prev <  23) {
            hours.add(6.0);
            //output.println("Index: " + i + " Hour " + h + ": " + hours.get(hours.size()-1)); 
            h++;
            prev = h;
          }
        } else {
          //else we had 6s until he is up to the current press's h
            while(h < (presses[i].hour) ) {
               //println("prev update: " + prev + " and h: " + h);
               hours.add(6.0);
               //output.println("Index: " + i + " Hour " + h + ": " + hours.get(hours.size()-1)); 
               h++;
               prev = h;
            }
        }
       
        if (tempCount == 0) {
          hours.add(l);
          //output.println("Hour " + prev + ": " + hours.get(hours.size()-1)); 
        }    
        count++;
        temp = l;
        tempCount = 1;
       } else {
          temp = temp + l;
          tempCount = tempCount + 1;
        }
        prev = h;
    }
    for (int i = 0; i < hours.size(); i++) {
     //output.println("Hour " + i + ": " + hours.get(i)); 
    }
    
    // now loop through and replace the 6s with the
    // average of the hours on either side
    float low = 0;
    float high = 0;
    boolean empty = false;
    int count2 = 0;
    float avg = 0;
    for (int i = 0; i < hours.size(); i++) {
       if (hours.get(i) == 6.0) {
         if (empty == false) {
           empty = true;
           low = hours.get(i-1);
         }
         count2++;
       } 
      if(empty == true &&  hours.get(i) != 6.0) {
          high = hours.get(i);
          for (int j = i-(count2); j < i; j++) {
              avg = (low + high)/2;
              hours.set(j, avg);
          }
          empty = false;
          count2 = 0;
       }
    }
    // TESTING PURPOSES
    println("---------------- NOW AVERAGED ------------------");
    for (int i = 0; i < hours.size(); i++) {
    // output.println("Hour " + i + ": " + hours.get(i)); 
    }
    
    // now write to a text file
    
    for (int i = 0; i < hours.size(); i++) {
     //output.println(hours.get(i));
    }
    output.flush();
    output.close();
}
