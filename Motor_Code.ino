#include <AccelStepper.h>
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
AccelStepper stepper1(HALFSTEP, motorPin1, motorPin3, motorPin2, motorPin4);
AccelStepper stepper2(HALFSTEP, motorPin21, motorPin23, motorPin22, motorPin24);

int maxSpeed = 1000;
int stepperSpeed = 300;
int acceleration = 200;

int count1 = 0;
int count2 = 0;

char * val;

void setup() {
  Serial.begin(9600);
  stepper1.setMaxSpeed(maxSpeed);
  stepper1.setAcceleration(acceleration);
  stepper1.setSpeed(stepperSpeed);

  stepper2.setMaxSpeed(maxSpeed);
  stepper2.setAcceleration(acceleration);
  stepper2.setSpeed(stepperSpeed);
  
  stepper1.moveTo(INCH);
  stepper2.moveTo(INCH);
}

void loop() {
  if (Serial.available()) {
    val = Serial.read();
  
    char * dist = strtok(val, ",");
  
  //if (stepper1.distanceToGo() == 0) {
    int moving = calcDist(float(dist[0]));
    stepper1.moveTo(moving*INCH);
    Serial.print("HI HI HI ");
    Serial.println(String(dist[0]));
  //}
  
  
  //if (stepper1.distanceToGo() == 0) {
    int moving2 = calcDist(float(dist[1]));
    stepper2.moveTo(moving2*INCH);
    Serial.print("MOPEY DOPEW ");
    Serial.println(String(dist[1]));
  //}
  }
  bool step1 = stepper1.run();
  bool step2 = stepper2.run();
}

int calcDist(float num) {
  float distance = ROTATE*num;
  return (int)distance;
}

