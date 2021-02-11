/*
 * This code trains a neural network to implement the XOR function.
 * It visualises the network. The weights between the node are shown
 * in colour (black +ve; brown -ve) and thickness (thin low value;
 * thick high value).
 */
Neural network;
PFont textFont;

PrintWriter errorOutput;

int learnXor = 0;
float averageError = 100.0;
float[] averageErrorArray;
int averageErrorPointer = 0;

void setup() {
  size(640, 480);
  
  // Output total network error occaisionally to a CSV file.
  errorOutput = createWriter("xor-error.csv"); 
  
  textFont = loadFont("Calibri-48.vlw");
  
  // We'll use two inputs, four hidden nodes, and one output node.
  network = new Neural(2,4,1);
  
  // Set learning rate here
  network.setLearningRate(0.5);
  
  println(network.getNoOfInputNodes(), " ", network.getNoOfHiddenNodes(), " ", network.getNoOfOutputNodes());
  
  // Set network biasing here
  network.setBiasInputToHidden(0.25);
  network.setBiasHiddenToOutput(0.3);
  
  network.displayOutputNodes();
  
  println(network.getTotalNetworkError());
  
  network.turnLearningOn();
  
  // Set up average error array
  averageErrorArray = new float [4];
  for (int x = 0; x < 4; ++x) {
    averageErrorArray[x] = 100.0;
  }
}

void draw() {
  background(180);
  
  if (network.getLearningStatus()) {
    // Replace line 57 with line 55 to stop learning after a certain number of epochs
    // if (network.getEpoch() > 12000) {
    // If we are learning and have achieved better than 0.05% error...
    if (averageError < 0.0005) {
      network.turnLearningOff();
      // Close file
      errorOutput.flush(); // Writes the remaining data to the file
      errorOutput.close();
      frameRate(0.5);
    }
    
    // Set up XOR inputs and expected output
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
    
    // Calculate the output for the inputs given
    network.calculateOutput();
    
    // Calculate average error
    averageErrorArray[averageErrorPointer] = network.getTotalNetworkError();
    averageError = (averageErrorArray[0] + averageErrorArray[1] + averageErrorArray[1] + averageErrorArray[3]) / 4.0;
    ++averageErrorPointer;
    if (averageErrorPointer >= 4) {
       averageErrorPointer = 0; 
    }
    
    if ((network.getEpoch() % 50) == 0){
      print(network.getEpoch());
      print(",");
      print(network.getTotalNetworkError());
      print(",");
      println(averageError);
      
      // Write to file
      errorOutput.print(network.getEpoch());
      errorOutput.print(",");
      errorOutput.print(network.getTotalNetworkError());
      errorOutput.print(",");
      errorOutput.println(averageError);
      errorOutput.flush();
    }
    
    // Output current error to main output
    {
      float strError;
      
      textAlign(LEFT, CENTER);
      strError = averageError * 100.0;
      textSize(24);
      text("Total Network Error: " + nf(strError,2,4) + "%", 40, 460);
      
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
    // Switch between differnt AND input patterns to show result of learning
    
    // Set up AND inputs
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

  // What follows outputs the rest of the display including heading,
  // depiction of nodes, and the weights as lines.
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
