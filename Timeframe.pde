///
// class Timeframe
// This class holds the total timeframe of data collected
// It allows you to select windows of time from within this data
///
class Timeframe {
   int totalHour;  // the total number of hours currently in the window
   int windowHour; // the number of hours we want in the window
   int start;      // the start of the current window
   int end;        // the end of the current window
   int ropeNum;    // the number of ropes in the graph
   int segLength;  // the number of hours that each rope represents
   // the data set ( an avg happiness/ hour )
   // this data set is very detailed, could be more specific 
   float[] data;     
   float[] data1;   // data for location 1
   float[] data2;   // data for location 2
   float[] data3;   // data for location 3
  
  ///
  // Constructor: takes in rope number, total hours for data, 
  //              and the array of data
  //              Also calculates the first segLength by dividing 
  //              total hours by rope number
  ///
  public Timeframe(int p_rope, int p_hour, float[] p_data, float[] p_data1, float[] p_data2, float[] p_data3) {
    totalHour = p_hour;
    ropeNum = p_rope;
    segLength = totalHour/ropeNum;
    data = new float[totalHour];
    this.data = p_data;
    
    data1 = new float[totalHour];
    this.data1 = p_data1;
    
    data2 = new float[totalHour];
    this.data2 = p_data2;
    
    data3 = new float[totalHour];
    this.data3 = p_data3;
  }
  
  ///
  // changeWindow
  // Purpose: the purpose of this function is to 
  //          change the window in time that is displayed
  // @peram: p_start: the starting hour in the total time
  // @param: p_end: the ending hour in the total time ( will 
  //                include end hour in display )
  // @return: an array of data the size of the number of ropes
  //           each element in the array is the avg happiness
  //           data that tells the length of one rope
  ///
  public float[] changeWindow(int p_start, int p_end, int locArray) {
    start = p_start;
    end = p_end;
    windowHour = end - start;
    //println("start: " + start + " end: " + end);
    if (windowHour < ropeNum) {
      return null;
    }
    
    // create the array to hold the data sending out 
    // (must have a slot for each rope)
    float[] window = new float[ropeNum];
    
    // get the section of data that we want
    float[] newData = {};
    if (locArray == 0) {
      newData = subset(data, start, windowHour);
    } else if (locArray == 1) {
      newData = subset(data1, start, windowHour);
    } else if (locArray == 2) {
      newData = subset(data2, start, windowHour);
    } else if (locArray == 3) {
      newData = subset(data3, start, windowHour);
    }
    for (int i = 0; i < newData.length; i++) {
      //println("newData: " + i + " " +  newData[i]);
    }
    // calculate the number of hours that each rope represents (segLength)
    segLength = windowHour/ropeNum; 
    //println("seglength: " + segLength);
    int count = 0;
    float temp = 0;
    
    // Loop through the new segment of data by segLength 
    for (int i = 0; i < ropeNum; i ++) {
      // loop through each hour in the subset 
      for (int j = 0; j < segLength; j++) {
        // add that hour to the last
        temp = temp + newData[i*segLength +j]; 
      }
      // divide the total added hours by segLength to get avg happiness
      // for that segment. Then put it in the window array
      window[count] = temp/segLength;
      //println("window: " + count + "and val " + window[count]);
      temp = 0;
      // increase our location in the window array
      count = count + 1;
    }
    // return the window array with data for each rope
    return window;
  }
}
