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
  
  //initiliazing the WekinatorParser
  parser = new WekinatorParser(usingEasing,easing,oscPort,verbose);
  frameRate(60);
  smooth();
  noFill();
  
  // Create and configure the font
  typeface = createFont(typefaceName, typefaceSize);
  textFont(typeface);
  textAlign(LEFT, TOP);
  
}

void draw() {
  //Clean and paint the canvas
  background(235);
  
  //Receives the values from Wekinator
  current_values = parser.calculateValues();

  //Draw stats
  drawStats();

}

void drawStats() {

  float interlineSeparation = typefaceSize+5;
  float paragraphSeparation = typefaceSize*3;
  float heightRects = 10.0;
//  float startingtHeightFactor = 0.15;
  float startingtHeightFactor = 0.075;
  float scaleFactor = 2*width/3+(width/10);
  float initialX = width*0.075;  

  fill(32);
  
  //For each one of the values received form Wekinator
  for (int i = 0; i < number_wekinator_outputs; i++) {
    //Display the text
    text(name_wekinator_outputs[i]+" "+round(current_values[i]*100.0)+"%", initialX, (startingtHeightFactor*height) +(paragraphSeparation*i));
    if ( current_values[i] > 0) {
      float temp_width =  current_values[i]*scaleFactor;
      //Draw the stats
      rect(initialX, (startingtHeightFactor*height)+((paragraphSeparation*i)+interlineSeparation), temp_width, heightRects);
    }
  }
}

 