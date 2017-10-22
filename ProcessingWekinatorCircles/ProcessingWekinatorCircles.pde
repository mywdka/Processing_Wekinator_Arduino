//WdKA - Interaction Station//
//2017////////////////////////

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
final int typefaceSize = 13;

//Printing some info in the console if true
final boolean verbose = false;

//Set to false to disable easing (smoothing) effect in the animations
final boolean usingEasing = true;

//Amount of easing
final float easing = 0.05;



void setup() {
  size(700, 380);
  frameRate(60);
  smooth();

  //Receiving data
  parser = new WekinatorParser(number_wekinator_outputs,oscPort,usingEasing,easing,verbose);
  
  //Font
  typeface = createFont(typefaceName, typefaceSize);
  textFont(typeface);
  textAlign(CENTER, CENTER);
  
}


void draw() {
  background(235);
  
  current_values = parser.calculateValues();

  drawCircles();
 
}

void drawCircles(){
  
  float marginX = width / (number_wekinator_outputs*7);
  float sepCircleX = marginX/2;  
  float scaleFactor = (width /number_wekinator_outputs)- ((2*marginX)/number_wekinator_outputs)-(((number_wekinator_outputs-1)*sepCircleX)/number_wekinator_outputs);
  float initialX = marginX+(scaleFactor/2);
  float circle_y = height/2;
  float sepY = height/3;
  
  //For each one of the Wekinator Outputs draw a circle  
   for (int i = 0; i < number_wekinator_outputs; i++) {     
     
     float circle_width =  current_values[min(i,2)]*scaleFactor;
     float circle_x = initialX+(i*scaleFactor)+(i*sepCircleX);
     
     //circle
     stroke(255*int(i==1),255*int(i==2),255*int(i==0),120);
     fill(255*int(i==1),255*int(i==2),255*int(i==0),60);
     ellipse(circle_x,circle_y,circle_width,circle_width);     
     
     //text
     fill(20,int(255*current_values[min(i,2)]));
     text(name_wekinator_outputs[min(i,2)], circle_x, circle_y );
      
   }  
  
 }
 