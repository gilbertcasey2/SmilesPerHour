///
// Author: Casey E Gilbert
// Name: SmilesPerHourModel.pde
// Created: 02/2017
// Edited: 04/21/2017
//
// Purpose: This program controls all the movement of the motors
//          that moves the balls up and down on the strings. 
//          The program has an array of hours, and each hour holds
//          the average happiness recorded in that hour. 
//
//          The timeframe class takes in two numbers, the index of 
//          the starting hour and the index of the finishing hour 
//          that the user wants to view on the graph. It then splits
//          the hours among the ropes and calculates the average 
//          happiness for all the hours that each rope holds. 
//
//          The main class holds an array of ropes. Each rope can 
//          calculate how long it should be if it knows how happy 
//          it is. Each rope calculates its length and returns the 
//          data.
//
//          The main program sends the length of the ropes to the
//          appropriate arduino that is controlling those ropes in 
//          real life.
///

// Set up the serial stuff
import processing.serial.*;
import processing.net.*;

//Serial port;
int[] outLength;

int hoursTracked; // TOTAL NUMBER OF HOURS TRACKED

// CLIENT STUFF
Client me;
String dataIn; // the data coming in
String IPaddr;

// read in from file;
BufferedReader reader;
BufferedReader reader2;
BufferedReader reader3;

String line;
String line2;
String line3;


Serial[] ports;
// the number of ports we have (each is connected to 1 arduino)
// each arduino is connected to 2 motors
// so ultimately the number should be 13 ports
int portNum = 1; 

// Here is an array of data for each hour tracked
float[] data;  // data now has a spot for each hour
float[] data1; // data for location 1
float[] data2; // data for location 2
float[] data3; // data for location 3

// which location is the user currently viewing? 
// (signifies which data array to use)
int currLocation = 0;     

Rope[] ropes;  // an array holding the ropes
int ropeNum;   // the number of ropes total
Timeframe timeWindow; // The total window
float[] currWindow; // the current window being shown
int top; // height of top of graph;
int bottom; // height of bottom of graph
int lowest;
int highest;
int start; // the start of the window we want to see ( in hours ) 
int end;   // the end of the window we want to see ( in hours )

// for drawing the time window
int startLine;
int endLine;

float[] oldDist; // Keeps track of the old distance 

// handle calibration events
boolean goUp;
boolean goDown;
boolean reset;
char port;

// is the sketch started?
boolean startProgram;

void setup() {
  //size(500,500);
  ports = new Serial[portNum];
  // set up the drawing thing
  startLine = 55;
  endLine = 445;
  
  me = new Client(this, IPaddr, 2000);
  
  // Read in data from a file for location 1
  reader = createReader("location0.txt");
  reader2 = createReader("location1.txt");
  reader3 = createReader("location2.txt");

  ArrayList<Float> l = new ArrayList<Float>();
  try {
    line = reader.readLine();
    l.add(float(line));
  } catch (IOException e) {
    println("Empty file1.");
  }

  while(line != null) {
    try {
      line = reader.readLine();
    } catch (IOException e) {
      println("IO Exception");
      line = null;
    }
    if (line != null) {
     String pieces = line;
     l.add(float(pieces));
    }
  }
  ArrayList<Float> l2 = new ArrayList<Float>();
  try {
    line2 = reader2.readLine();
    l2.add(float(line2));
  } catch (IOException e) {
    println("Empty file2.");
  }

  while(line2 != null) {
    try {
      line2 = reader2.readLine();
    } catch (IOException e) {
      println("IO Exception");
      line2 = null;
    }
    if (line2 != null) {
     String pieces2 = line2;
     l2.add(float(pieces2));
    }
  }
  ArrayList<Float> l3 = new ArrayList<Float>();
  try {
    line3 = reader3.readLine();
    l3.add(float(line3));
  } catch (IOException e) {
    println("Empty file3.");
  }

  while(line3 != null) {
    try {
      line3 = reader3.readLine();
    } catch (IOException e) {
      println("IO Exception");
      line3 = null;
    }
    if (line3 != null) {
     String pieces3 = line3;
     l3.add(float(pieces3));
    }
  }
  hoursTracked = 705;
  data3 = new float[hoursTracked];
  data2 = new float[hoursTracked];
  data1 = new float[hoursTracked];
  data = new float[hoursTracked];
  println("The data: " );
  for (int i = 0; i < hoursTracked; i++) {
     data1[i] = l.get(i);
     data2[i] = l2.get(i);
     data3[i] = l3.get(i);
     data[i] = ((data1[i] + data2[i] + data3[i])/3);
     println(data3[i]); 
  }
  
  // TESTING PURPOSES ONLY
  // Generate data 
  int amount = hoursTracked/5;
  int count = 0;
  
  for (int j = 0; j < 5; j++ ) {
    for ( int i = 0; i  < amount; i ++) {
      data[count] = j;
      println("data[count]: " + data[count]);
      count++;
    }
  }

  // We start by viewing the array with all location data
  currLocation = 0; 
  
  top = 0; // top of the graph starts at 2 inches 
  bottom = 60; // the bottom the the graph is 54 inches from the top
  lowest = 60; // the lowest point the graph can go
  //highest = 6; // the highest value is 6 inches from top 
  
  // Serial stuff
  //println(Serial.list());
  //port = new Serial(this, Serial.list()[1], 9600);
  // Here is a port for each arduino
  ports[0] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  //ports[0] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  //ports[1] = new Serial(this, "/dev/cu.usbmodemFD12731", 9600);
  //ports[2] = new Serial(this, "/dev/cu.usbmodemFD12741", 9600);
  //ports[3] = new Serial(this, "/dev/cu.usbserial-A6019TGN", 9600);
  //ports[4] = new Serial(this, "/dev/cu.usbmodemFD12761", 9600);
  //ports[5] = new Serial(this, "/dev/cu.usbmodemFD12751", 9600);
  //ports[6] = new Serial(this, "/dev/cu.usbmodemFD1241", 9600);

  
  megaStart = 6;
  startProgram = false; // haven't started yet 
  // handle calibration events
  goUp = false;
  goDown = false;
  reset = false;
  port = 'n';
  
  // The total number of ropes
  ropeNum = 25;

  // make rope array and generate ropes
  ropes = new Rope[ropeNum];
  for (int i = 0; i < ropeNum; i++) {
    // start the ropes from the ceiling 
   ropes[i] = new Rope(top); 
  }
  // build the time window
  timeWindow = new Timeframe(ropeNum, hoursTracked, data, data1, data2, data3);
  
  oldDist = new float[portNum];
  for (int i = 0; i < portNum; i++) {
    oldDist[i] = 0;
  }
  
}

void draw() {
   background(255,255,255);
   
   if (!startProgram) {
     delay(100);
     return;
   }

  // calculate the window 
  // when we hook it with dan's then he'll be giving us the start and end values
  calcWind();
  //drawControl();
  float dist = 0;
  
  String send = "";
  int count = 0;
  
  // The first loops through each port
  for (int i = 0; i < portNum; i++) {
    // get distance of first rope
    dist = ropes[count].getDist();  
    count++;
    send = send + dist + ",";
    dist = ropes[count].getDist();
    count++;
    send = send + dist + ",";
    if (dist != oldDist[i]) {
      println("New dist: " + dist + " and old dist: " + oldDist);
      ports[i].write(send);
      println("Sending to port " + (i + 1) + ": "  + send);
    }
    send = "";
    
    if (ports[i].available() > 0) {
      readInfo(i);
    }
    oldDist[i] = dist;
  }
    
  // now change the window and update the rope lengths
  newWindow(currLocation);
  delay(1000);
}

synchronized void readInfo( int i ) {
      String val = "";
      val = ports[i].readStringUntil('\n');
      println("val of " + i + ": " + val);
}

///
// printRopes: a function to loop through ropes and print them
///
void printRopes() {
  for (int i = 0; i < ropeNum; i ++) {
    println("Rope " + i + ": value: " + ropes[i].value + 
      ", length: " + ropes[i].lengthy);
  }
}

///
// newWindow: a function to generate the new window and store it,
//            and then apply those values to the ropes
// @peram: the start and end hours of the window
// @return: none
///
void newWindow(int locArray) {
  // get the rope data for the new window
  currWindow = new float[ropes.length];
  currWindow = timeWindow.changeWindow(start,end,locArray);
  if (currWindow == null) {
      println("LESS HOURS THAN ROPES");
      return;
  }
  // put that data into the ropes
  for (int i = 0; i < ropeNum; i++) {
    ropes[i].calcLength(currWindow[i],top, bottom);
  }
}

/**
* This function takes in a mouse reading to know what the window should be
*/
void mouseDragged() {
  if (mouseX >= startLine - 40 && mouseX < startLine + 40 && mouseY > 300 && mouseY < 400) {
    startLine = mouseX;
  }
  if (mouseX >= endLine - 40 && mouseX < endLine + 40 && mouseY > 300 && mouseY < 400) {
    endLine = mouseX;
  }
  
}
/**
*
* Keypressed: use this to handle calibrating the motors
*   
*  Step 1) If the motor needs to go up, press 'u' or 'U'. 
*          You should see 'goUp' or 'goDown' written to the console.
*  Step 2) Figure out which arduino number is controlling the
*          motor. Press the number of that arduino. You should
*          see 'Port: ' and whatever port you chose on the console.
*  Step 3) Figure out what number motor on that arduino it is.
*          ( If it is a regular arduino, its either motor 1 or 2 )
*          (if it is a mega, more options) Press that number. You
*          should see "sending to port: X the message: XX" written
*          to the console.
*  Step 4) Repeat steps 1-3 until the motor is where you want to zero it.
*  Step 5) Press 'R' or 'r' for reset. you should see 'reset' written
*          to the console.
*  Step 6) Press the arduino number. You should see "Port: " + number 
*          written to the console.
*  Step 7) Press the motor number of the arduino. You should see
*          "sending to port: X the message: RX" to the console.
*
*          The ball is now zeroed on the location it is at. 
*
*  Other functions:
*      's' = start (to use after calibrating)
*      'z' = zero (brings all motors to position zero; can use to calibrate)
*
*/
void keyPressed() {
 if (key == 'z' || key == 'Z') {
   println("zeroing");
   reset = false;
   goDown = false;
   goUp = false; 
   port = 'n';
   for (int i = 0; i < portNum; i++) {
     ports[i].write("Z");
   }
 }
 if (key == 's' || key == 'S') {
   startProgram = true;
 }
 if (key =='u' || key == 'U') {
   goUp = true;
   println("goUp");
 } 
 if (key =='d' || key == 'D') {
   goDown = true;
   println("goDown");
 } 
 if (key =='r' || key == 'R') {
   reset = true;
   println("reset");
 }
 if (key >= '0' && key <= '9')  {
     if (port != 'n') {
       if (goDown) {
        println("sending to port: " + port + " the message: D" + key);
        ports[Integer.parseInt(str(port))].write("D" + key);
        goDown = false;
        port = 'n';
       } else if (goUp) {
        println("sending to port: " + port  + " the message: U" + key);
        ports[Integer.parseInt(str(port))].write("U" + key);
        goUp = false;
        if (ports[Integer.parseInt(str(port))].available() > 0) {
          readInfo(Integer.parseInt(str(port)));
        }
        port = 'n';
       } else if (reset) {
        println("sending to port: " + port + " the message: R" + key);
        ports[Integer.parseInt(str(port))].write("R" + key);
        reset = false;
        if (ports[Integer.parseInt(str(port))].available() > 0) {
          readInfo(Integer.parseInt(str(port)));
        }
        port = 'n';
       }
     }
     else if (goDown || goUp || reset) {
       port = key;
       println("Port: " + port);
     }
   }
   if (key == 'c' || key == 'C') {
      reset = false;
      goDown = false;
      goUp = false; 
      port = 'n';
      println("Cleared values.");
   }
   
}

/**
* Calculate the window the start and end hours
* This would just be sent to me by dan
*/
void calcWind() {
  start = ((startLine-55)*hoursTracked)/400;
  end = ((endLine-45)*hoursTracked)/400;
  
  if (me.available() > 0) {
    dataIn = me.readString();
    if (dataIn != "null") {
      String[] list = split(dataIn, ',');
    }
    currLocation = Integer.parseInt(list[0]);
    start = Integer.parseInt(list[1]);
    end = Integer.parseInt(list[2]);
  }

/**
* A simple function to draw the controls
*/
void drawControl() {
  stroke(0,0,0);
  strokeWeight(2);
  line(50,300,50,400);
  line(450,300,450,400);
  line(50,350,450,350);
  strokeWeight(3);
  stroke(100,100,100);
  line(startLine, 310, startLine,  390);
  line(endLine, 310, endLine, 390);
  noStroke();
  fill(0,0,0,50);
  rect(startLine, 320, endLine-startLine, 60);
}
