
import processing.serial.*;
import provessing.net.*;

Serial[] ports;

int portNum = 13;
int motorNum = 1;


void setup() {
  ports[0] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  ports[1] = new Serial(this, "/dev/cu.usbmodemFD12731", 9600);
  ports[2] = new Serial(this, "/dev/cu.usbmodemFD12741", 9600);
  ports[3] = new Serial(this, "/dev/cu.usbserial-A6019TGN", 9600);
  ports[4] = new Serial(this, "/dev/cu.usbmodemFD12761", 9600);
  ports[5] = new Serial(this, "/dev/cu.usbmodemFD12751", 9600);
  ports[6] = new Serial(this, "/dev/cu.usbmodemFD1241", 9600);
  ports[7] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  ports[8] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  ports[9] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  ports[10] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  ports[11] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);
  ports[12] = new Serial(this, "/dev/cu.usbserial-A603G9JE", 9600);

void draw() {
  while (keyPressed == true) {
    println("key pressed: " + key); 
    for (int i = 0; i < portNum; i++ ) {
      if (key == hex(i)) {
         ports[i].write("U" + motorNum);
      }
    }
    if (key == 'n') {
      motorNum = 1;
     else if (key == 'm') {
       motorNum = 2;
     }
  }
}


