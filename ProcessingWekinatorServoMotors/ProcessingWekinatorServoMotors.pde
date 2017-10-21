//WdKA - Interaction Station//
//2017////////////////////////

import processing.serial.*;
import oscP5.*;

//Specify the number of Wekinator outputs 
final int number_wekinator_outputs = 3; 

//OSC port used by Wekinator
final int oscPort = 12000;

final boolean verbose = false;
final boolean usingEasing = true;
final float easing = 0.05;

WekinatorParser parser;

// Create object from Serial class
Serial myPort;  

float current_outputs[];
float prev_outputs[];

void setup() {
  size(500, 500);
  parser = new WekinatorParser(usingEasing,easing,oscPort,verbose);
  frameRate(60);
  
  // Open whatever port is the one you're using.
   String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  println(portName);
  
}

void draw() {
  background(225);
  
  current_outputs = parser.calculateValues();

  sendValuesToArduino();

//  prev_outputs =  current_outputs;
}


void sendValuesToArduino(){
 int servoAngleRange = 180;
 String strSent = "";
 
 for(int i = 0; i < number_wekinator_outputs; i++){
   strSent += str(int(current_outputs[i]*servoAngleRange));
   
   if(i != (number_wekinator_outputs-1) ){
      strSent += ",";
   }
 }
 strSent += "\r";
 
 myPort.write(strSent);
 println(strSent);
}


/*
//WdKA - Interaction Station//
//2017////////////////////////

#include <Servo.h> 
 
//we define the number of servo motors that we will used
const int numServos = 3;

//The first servo motor is connected to this pin.
//Connect the rest of the servo motors to the next pins
const int initialServoPin = 5;

Servo myServos[numServos];  
int inputValues[numServos];
int servoValues[numServos];


static char inputBuffer[80];

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
    inputValues[i] = 0;
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