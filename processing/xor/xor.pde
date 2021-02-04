Neural network;
PFont textFont;

PrintWriter errorOutput;

float[] errorGraph = new float[20000];
int errorGraphCount = 0;

int learnXor = 0;

void setup() {
  size(640, 480);
  
  errorOutput = createWriter("xor-error.csv"); 
  
  textFont = loadFont("Calibri-48.vlw");
  //frameRate(30);
  
  network = new Neural(2,4,1);
  
  network.setLearningRate(0.45);
  
  println(network.getNoOfInputNodes(), " ", network.getNoOfHiddenNodes(), " ", network.getNoOfOutputNodes());
  
  network.setBiasInputToHidden(0.25);
  network.setBiasHiddenToOutput(0.3);
  
  network.displayOutputNodes();
  
  println(network.getTotalNetworkError());
  
  network.turnLearningOn();
  
  for (int loop = 0; loop < 20000; ++loop) {
    errorGraph[loop] = 0.0;
  }
}

void draw() {
  background(180);
  
  if (network.getLearningStatus()) {
    // If we are learning and have achieved < 40000 cycles...
    if (network.getEpoch() > 30000) {
      network.turnLearningOff();
      // Close file
      errorOutput.flush(); // Writes the remaining data to the file
      errorOutput.close();
      frameRate(0.5);
    }
    
    // Set up XOR inputs
    if (learnXor == 0) {
      network.setInputNode(0, 0.01);
      network.setInputNode(1, 0.01);
      network.setOutputNodeDesired(0, 0.01);
    } else if (learnXor == 1) {
      network.setInputNode(0, 0.01);
      network.setInputNode(1, 0.99);
      network.setOutputNodeDesired(0, 0.99);
    } else if (learnXor == 2) {
      network.setInputNode(0, 0.99);
      network.setInputNode(1, 0.01);
      network.setOutputNodeDesired(0, 0.99);
    } else { // learnXor == 3
      network.setInputNode(0, 0.99);
      network.setInputNode(1, 0.99);
      network.setOutputNodeDesired(0, 0.01);
    }
    
    network.calculateOutput();
    
    //print(network.getEpoch());
    //print(" : ");
    //print(learnXor);
    //print(" : ");
    //println(network.getTotalNetworkError());
    
    if ((network.getEpoch() % 50) == 0) {
      print(network.getEpoch());
      print(",");
      println(network.getTotalNetworkError());
      
      // Write to file
      errorOutput.print(network.getEpoch());
      errorOutput.print(",");
      errorOutput.println(network.getTotalNetworkError());
      errorOutput.flush();
    }
    // Output current error
    {
      float strError;
      
      textAlign(LEFT, CENTER);
      strError = network.getTotalNetworkError() * 100.0;
      textSize(24);
      text("Error: " + nf(strError,2,4) + "%", 40, 460);
      
      strokeWeight(10);
      stroke(0);
      textAlign(CENTER, CENTER);
    }
    
    // Increment to next input combination (00, 01, 10, 11)
    ++learnXor;
    
    if (learnXor > 3) {
      learnXor = 0;
    }
  } else {
    // Switch between differnt XOR input patterns
    
    // Set up XOR inputs
    if (learnXor == 0) {
      network.setInputNode(0, 0.01);
      network.setInputNode(1, 0.01);
    } else if (learnXor == 1) {
      network.setInputNode(0, 0.01);
      network.setInputNode(1, 0.99);
    } else if (learnXor == 2) {
      network.setInputNode(0, 0.99);
      network.setInputNode(1, 0.01);
    } else { // learnXor == 3
      network.setInputNode(0, 0.99);
      network.setInputNode(1, 0.99);
    }
    
    network.calculateOutput();
    print(learnXor);
    print(" : ");
    println(network.getOutputNode(0));
    
    // Increment to next input combination (00, 01, 10, 11)
    ++learnXor;
    if (learnXor > 3) {
      learnXor = 0;
    }
  }

  // Heading
  textFont(textFont);
  if (network.getLearningStatus()) {
    String strEpoch = str(network.getEpoch());
    textAlign(CENTER, CENTER);
    textSize(48);
    text("Learning - XOR", width/2, 40);
    textSize(24);
    text("Epoch: "+strEpoch, width/2, 80);
  } else {
    text("Testing - XOR", width/2, 40);
  }
  
  strokeWeight(10);
  
  //ItoH
  {
    float value = 0.0;
    
    value = 3.0 * network.getInputToHiddenWeight(0, 0);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 240, 320, 160);
    
    value = 3.0 * network.getInputToHiddenWeight(0, 1);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 240, 320, 240);
    
    value = 3.0 * network.getInputToHiddenWeight(0, 2);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 240, 320, 320);
    
    value = 3.0 * network.getInputToHiddenWeight(0, 3);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 240, 320, 400);
    
    
    
    value = 3.0 * network.getInputToHiddenWeight(1, 0);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 320, 320, 160);
    
    value = 3.0 * network.getInputToHiddenWeight(1, 1);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 320, 320, 240);
    
    value = 3.0 * network.getInputToHiddenWeight(1, 2);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 320, 320, 320);
    
    value = 3.0 * network.getInputToHiddenWeight(1, 3);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(160, 320, 320, 400);
  }
  
  //HtoO
  {
    float value = 0.0;
    
    value = 3.0 * network.getHiddenToOutputWeight(0, 0);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(320, 160, 480, 280);
    
    value = 3.0 * network.getHiddenToOutputWeight(1, 0);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(320, 240, 480, 280);
    
     value = 3.0 * network.getHiddenToOutputWeight(2, 0);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(320, 320, 480, 280);
    
     value = 3.0 * network.getHiddenToOutputWeight(3, 0);
    if (value < 0) {
      stroke(204, 102, 0);
    } else {
      stroke(0);
    }
    value = abs(value);
    strokeWeight(value);
    line(320, 400, 480, 280);
  }
  
  // Input
  strokeWeight(10);
  stroke(0);
  ellipse(160, 240, 55, 55);
  ellipse(160, 320, 55, 55);
  
  // Hidden
  strokeWeight(10);
  stroke(0);
  ellipse(320, 160, 55, 55);
  ellipse(320, 240, 55, 55);
  ellipse(320, 320, 55, 55);
  ellipse(320, 400, 55, 55);
  
  // Output
  ellipse(480, 280, 55, 55);
  
  textSize(48);

  // Input Node Text
  if (network.getInputNode(0) > 0.9) {
    text("1", 100, 240);
  } else {
    text("0", 100, 240);
  }
  if (network.getInputNode(1) > 0.9) {
    text("1", 100, 320);
  } else {
    text("0", 100, 320);
  }
  
  // Output Node Text
  if (network.getOutputNode(0) > 0.9) {
    text("1", 550, 280);
  } else {
    text("0", 550, 280);
  }
}

void keyPressed() {
  errorOutput.flush(); // Writes the remaining data to the file
  errorOutput.close(); // Finishes the file
  exit(); // Stops the program
}