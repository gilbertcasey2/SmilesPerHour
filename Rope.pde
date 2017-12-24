///
// class Rope
// this class represents one single rope holding a ball
// it stores its own length
///

class Rope {
 
 float lengthy; // where the rope hangs down to (includes space above top of rope)
 float oldLength; // the old height of the rope
 float value;   // the happiness of the rope ( a value from 1 - 5 )

 
 ///
 // This sets up the rope
 // @peram: the starting length of the rope (probably to start at cieling
  public Rope(int p_length) {
   oldLength = 0;
   lengthy = p_length;
   println("lengthy: " + lengthy);
  } 
  
  ///
  // @peram: value  a 1 - 5 number that represents the average
  //         level of happiness to calculate rope length
  // @peram: topH is the height of the top of the graph
  // @peram: bottomH is the height of the bottom of the graph
  // Purpose: This function converts the happiness value into
  //          a the length that the rope should be
  // @return: nothing
  ///
  public void calcLength(float p_value, int topH, int bottomH) {
    value = p_value;
    float distance = bottomH - topH;   // so the total height that the ropes can take up
    float increment = distance/4;      // the height of each of the levels
    // each value multipies by increment to get rope length of total length
    // then you subtract that length from the top height to get the height that
    // the rope hangs down to
    oldLength = lengthy;
    lengthy = (int)bottomH - (value * increment);  // so length 
    if (lengthy - oldLength != 0 ) {
      println("lengthy: " + lengthy + " old lenght: " + oldLength + " and difference: " + (lengthy - oldLength));
    }
  }
  
  ///
  // @returns an int that is the distance the rope needs to move
  // @ EDIT: This now returns the length that the rope needs to be
  ///
  public float getDist() {
    
    if (lengthy - oldLength != 0 ) {
      //println("lengthy: " + lengthy + " old lenght: " + oldLength + " and difference: " + (lengthy - oldLength));
    }
     //return (lengthy - oldLength);
     return lengthy;
  }
  
  public float oldDist() {
   return oldLength; 
  }
  ///
  // @returns an int that is the direction the rope needs to move
  // 0 is up
  // 1 is down
  ///
  public int getDir() {
    if(lengthy >= oldLength) {
      return 0;
    } else {
      return 1;
    }
  }
  
  
}
