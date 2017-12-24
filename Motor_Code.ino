///
// Author: Casey E Gilbert
// Name: Motor_Code
// Purpose: This code is installed on all of the Arduinos that
// 	    control motors for the SmilesPErHour installation.
//	    The arduino running this code controlls two motors 
//          at a time. It recieves data from the processing code,
//          uses it to calculate how far it needs to move its
//          motor, and then turns the motor (which in turn lowers
//          the balls up and down).
/// 

// the library used to control the motor
#include <AccelStepper.h>

// define our macros
#define HALFSTEP 8
#define ROTATE 4096
#define INCH 435

// Motor pin definitions
#define motorPin1  3     // IN1 on the ULN2003 driver 1
#define motorPin2  4     // IN2 on the ULN2003 driver 1
#define motorPin3  5     // IN3 on the ULN2003 driver 1
#define motorPin4  6     // IN4 on the ULN2003 driver 1

#define motorPin21  8     // IN1 on the ULN2003 driver 2
#define motorPin22  9     // IN2 on the ULN2003 driver 2
#define motorPin23  10     // IN3 on the ULN2003 driver 2
#define motorPin24  11     // IN4 on the ULN2003 driver 2

// Initialize with pin sequence IN1-IN3-IN2-IN4 for using the AccelStepper with 28BYJ-48
AccelStepper stepper1(HALFSTEP, motorPin1, motorPin3, motorPin2, motorPin4);  // the first motor
AccelStepper stepper2(HALFSTEP, motorPin21, motorPin23, motorPin22, motorPin24); // the second motor

int maxSpeed = 1000;
int stepperSpeed = 300;
int acceleration = 200;

int count1 = 0;
int count2 = 0;

char * val;

void setup() {
  // Set up the motors
  Serial.begin(9600);
  stepper1.setMaxSpeed(maxSpeed);
  stepper1.setAcceleration(acceleration);
  stepper1.setSpeed(stepperSpeed);

  stepper2.setMaxSpeed(maxSpeed);
  stepper2.setAcceleration(acceleration);
  stepper2.setSpeed(stepperSpeed);
  
  // zero out where all out motors are starting
  stepper1.moveTo(INCH);
  stepper2.moveTo(INCH);
}

void loop() {

  // if we're getting data from the processing code,
  // read in the data
  if (Serial.available()) {
    val = Serial.read();
    // parse the values at the commas, store in array
    char * dist = strtok(val, ",");
  
  //if (stepper1.distanceToGo() == 0) {
    // calculate how far to move
    int moving = calcDist(float(dist[0]));
    move that many inches (since moving is in inches)
    stepper1.moveTo(moving*INCH);
    // testing purposes
    Serial.print("HI HI HI ");
    Serial.println(String(dist[0]));
  //}
  
  // Do the same process as above for the second motor
  //if (stepper1.distanceToGo() == 0) {
    int moving2 = calcDist(float(dist[1]));
    stepper2.moveTo(moving2*INCH);
    Serial.print("MOPEY DOPEW ");
    Serial.println(String(dist[1]));
  //}
  }
  // run the motors
  bool step1 = stepper1.run();
  bool step2 = stepper2.run();
}
 // function to convert number coming into processing
 // into a number we want to use
int calcDist(float num) {
  float distance = ROTATE*num;
  return (int)distance;
}

