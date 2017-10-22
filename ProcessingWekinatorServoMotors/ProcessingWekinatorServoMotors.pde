//WdKA - Interaction Station//
//2017////////////////////////

import processing.serial.*;
import oscP5.*;

//Specify the number of Wekinator outputs 
final int number_wekinator_outputs = 3; 

//Current values in a [0.0 - 1.0] range
float current_values[];

//Class that parses the data received from Wekinator
WekinatorParser parser;

//OSC port used by Wekinator
final int oscPort = 12000;

//Printing some info in the console if true
final boolean verbose = false;

//Set to false to disable easing (smoothing) effect in the animations
final boolean usingEasing = true;

//Amount of easing
final float easing = 0.05;

//Serial port for communicating with Arduino
Serial myPort;  


void setup() {
  size(500, 500);
  frameRate(60);

  parser = new WekinatorParser(usingEasing,easing,oscPort,verbose);
  
  printArray(Serial.list());
  // Change the index (0 in the example) to match your 
   String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);

   println(portName+" selected");
 
}

void draw() {
  background(225);
  
  current_values = parser.calculateValues();

  //Sending values to Arduno
  sendValuesToArduino();

}


void sendValuesToArduino(){
 int servoAngleRange = 180;
 String strSent = "";
 
 for(int i = 0; i < number_wekinator_outputs; i++){
   strSent += str(int(current_values[i]*servoAngleRange));
   
   if(i != (number_wekinator_outputs-1) ){
      strSent += ",";
   }
 }
 strSent += "\r";
 
 myPort.write(strSent);
 if(verbose){
   println(strSent);
  }
}

/*
//Arduino code

//WdKA - Interaction Station//
//2017////////////////////////

#include <Servo.h> 
 
//we define the number of servo motors that we will used
const int numServos = 3;

//The first servo motor is connected to this pin.
//Connect the rest of the servo motors to the next pins (Digital Pins 6 & 7)
const int initialServoPin = 5; 

Servo myServos[numServos];  
int servoValues[numServos];

void setup() 
{ 
  //Initialize Serial comunication
  Serial.begin(9600);

  //For each one of the servo motros
  for(int i = 0;i < numServos;++i){
    //attaches the pin to the servo object
    myServos[i].attach(i+initialServoPin); 
    //Initialize the servo motors to the position 0
    myServos[i].write(0); 
    servoValues[i] = 0;    
  }
  
} 

void loop() { 

  
  // if there's any serial available, read it:
  while (Serial.available() > 0) {

    for(int i = 0;i < numServos;++i){
      //attaches the pin to the servo object 
      servoValues[i] = Serial.parseInt();

      //contrain the values between 0 and 180 for the servo motors
      servoValues[i] = constrain(servoValues[i], 0, 180);      
    }

    // end of the line
    if (Serial.read() == '\r') {
       //we move the servos
       for(int i = 0;i < numServos;++i){
         myServos[i].write(servoValues[i]); 
       }
       
    }else{
      return;
    }
  }

}

*/