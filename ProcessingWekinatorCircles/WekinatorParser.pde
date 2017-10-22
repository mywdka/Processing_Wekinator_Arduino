import oscP5.*;

//It receives the Wekinator outputs through OSC
class WekinatorParser {


  OscP5 oscP5;
  
  float target_outputs[];
  float current_outputs[];  
  boolean usingEasing = true;
  boolean verbose = false;
  float easing = 0.0;
  int number_wekinator_outputs = 0 ;
  int oscPort = 0;

  WekinatorParser(int number_wekinator_outputs,int oscPort,boolean usingEasing,float easing,boolean verbose){
    this.number_wekinator_outputs = number_wekinator_outputs;
    this.oscPort = oscPort;
    this.usingEasing = usingEasing;
    this.easing = easing;
    this.verbose = verbose;
  
    target_outputs = new float[number_wekinator_outputs];
    current_outputs = new float[number_wekinator_outputs];
  
    for(int i = 0; i < number_wekinator_outputs;i++){
        target_outputs[i] = 0.0;          
    }  
    oscP5 = new OscP5(this,oscPort);  
  }
  
  //It returns the values received from Wekinator. If usingEasing is true, there is some smoothing effect
  float[] calculateValues() {
    
    for (int i = 0; i < number_wekinator_outputs; i++) {
      if(usingEasing){
        current_outputs[i] += (target_outputs[i] - current_outputs[i]) * easing;
      }else{
        current_outputs[i] = target_outputs[i];
      }
  }  
  
    return current_outputs;
  
  }

  void oscEvent(OscMessage theOscMessage) {
    
    if(verbose){
      theOscMessage.print();  
      println(" typetag: "+theOscMessage.typetag());
      println(" addrPattern: "+theOscMessage.addrPattern());
      println(" address: "+theOscMessage.address());
    }
    
    if (theOscMessage.addrPattern().equals("/wek/outputs")) {
      Object[] objects = theOscMessage.arguments();
          if(verbose){
           println(objects.length);
          }
      for (int i = 0; i < objects.length; i++) {
        target_outputs[i] = min(max(theOscMessage.get(i).floatValue(), 0.0), 1.0);
      }
    }
  }


}