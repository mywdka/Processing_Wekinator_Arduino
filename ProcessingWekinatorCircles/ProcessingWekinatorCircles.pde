//WdKA - Interaction Station//
//2017////////////////////////

import processing.serial.*;
import oscP5.*;

//Specify the number of Wekinator outputs 
final int number_wekinator_outputs = 3; 

//Specify the names of the of the Wekinator outputs 
String[] name_wekinator_outputs = {"neutral","smile","surprise"};

//Current values in a [0.0 - 1.0] range
float current_values[];

//Class that parses the data received from Wekinator
WekinatorParser parser;

//OSC port used by Wekinator
final int oscPort = 12000;

//Typeface used to display the stats
PFont typeface;

//Typeface loaded (needs to be in the data folder)
final String typefaceName = "SourceCodePro-Regular.ttf";

//Size of the typefaces
final int typefaceSize = 12;

//Set to try to print the data
final boolean verbose = false;

//Set to false to disable easing (smoothing) effect in the animations
final boolean usingEasing = true;

//Amount of easing
final float easing = 0.05;



void setup() {
  size(500, 500);
  parser = new WekinatorParser(usingEasing,easing,oscPort,verbose);
  frameRate(60);
  smooth();
  noFill();
  
  // Create the font
  typeface = createFont(typefaceName, typefaceSize);
  textFont(typeface);
  textAlign(LEFT, TOP);
  
}


void draw() {
  background(225);
  
  current_values = parser.calculateValues();

  drawCircles();
 
}

void drawCircles(){
  
  boolean circleUp =false;
  float scaleFactor = 2*width/3-(3*width/10);
  float initialX = width*0.2;
  float sepX = width*0.3;
  float sepY = height*0.3;
   noFill();
    
   for (int i = 0; i < number_wekinator_outputs; i++) {
     
     circleUp = !circleUp;
     
     stroke(255*int(i==0),255*int(i==1),255*int(i==2));

     float y = height/3;
     if(circleUp){
       y+=sepY;
     }
     float circle_width =  current_outputs[i]*scaleFactor;
     ellipse(initialX+(i*sepX),y,circle_width,circle_width);
      
   }  
  
 }
 