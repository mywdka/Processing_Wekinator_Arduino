
class WekinatorParser {


  OscP5 oscP5;
  
  float target_outputs[];
  float current_outputs[];  
  boolean usingEasing = true;
  boolean verbose = false;
  float easing = 0.0;
  int oscPort = 0;

  WekinatorParser(boolean usingEasing,float easing,int oscPort,boolean verbose){
    this.usingEasing = usingEasing;
    this.easing = easing;
    this.oscPort = oscPort;
    this.verbose = verbose;
  
    target_outputs = new float[number_wekinator_outputs];
    current_outputs = new float[number_wekinator_outputs];
  
    for(int i = 0; i < number_wekinator_outputs;i++){
        target_outputs[i] = 0.0;          
    }  
    oscP5 = new OscP5(this,oscPort);  
  }
  
  float[] calculateValues() {
    
    for (int i = 0; i < number_wekinator_outputs; i++) {
      current_outputs[i] += (target_outputs[i] - current_outputs[i]) * easing;
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