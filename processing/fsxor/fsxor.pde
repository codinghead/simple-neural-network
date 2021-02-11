/* Fast XOR NN to test learning rate impact
 * This does away with the visualization of 
 * the MLP during learning and operation.
 * The output error is saved during learning,
 * so try experimenting with learning rates.
 * Otherwise, just use as a basis for your
 * own code.
 */

Neural network;

PrintWriter errorOutput;

int learnXor = 0;
float averageError = 100.0;
float[] averageErrorArray;
int averageErrorPointer = 0;

void setup() {
  errorOutput = createWriter("xor-error.csv"); 
  
  network = new Neural(2,4,1);
  
  network.setLearningRate(0.5);
  
  println(network.getNoOfInputNodes(), " ", network.getNoOfHiddenNodes(), " ", network.getNoOfOutputNodes());
  
  network.setBiasInputToHidden(0.3);
  network.setBiasHiddenToOutput(0.6);
  
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
    // Replace line 51 with line 49 to stop learning after a certain number of epochs
    // if (network.getEpoch() > 12000) {
    // If we are learning and have achieved better than 0.05% error...
    if (averageError < 0.0005) {
      network.turnLearningOff();
      // Close file
      errorOutput.flush(); // Writes the remaining data to the file
      errorOutput.close();
    }
    
    // Set up XOR inputs and expected ouput
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
       
    // Calculate average error
    averageErrorArray[averageErrorPointer] = network.getTotalNetworkError();
    averageError = (averageErrorArray[0] + averageErrorArray[1] + averageErrorArray[1] + averageErrorArray[3]) / 4.0;
    ++averageErrorPointer;
    if (averageErrorPointer >= 4) {
       averageErrorPointer = 0; 
    }
    
    // Write network error every 50 epochs to CSV file.
    if ((network.getEpoch() % 50) == 0) {
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
    
    // Increment to next input combination (00, 01, 10, 11)
    ++learnXor;
    
    if (learnXor > 3) {
      learnXor = 0;
    }
  } else {
    // With learning completed, 
    // switch between different XOR input patterns
    // and display output.
    
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
}

void keyPressed() {
  errorOutput.flush(); // Writes the remaining data to the file
  errorOutput.close(); // Finishes the file
  exit(); // Stops the program
}
