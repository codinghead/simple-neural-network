/*
 * This code demonstrates the example by Matt Mazur:
 * https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/
 * Code by Stuart Cording
 * aka codinghead@gmail.com
 */
 
Neural network;

void setup() {
  // This neural network uses two inputs, two hidden nodes, and two output nodes.
  network = new Neural(2,2,2);
  
  // Set learning rate here
  network.setLearningRate(0.5);
  
  // Set Neural class to be 'verbose' so we can see what it is doing
  network.turnVerboseOn();
  
  println("Matt Mazur Neural Network Backpropagation Example");
  println("-------------------------------------------------");
  println();
  println("Structure is:");
  println("Input nodes: ", network.getNoOfInputNodes(), "; Hidden nodes: ", network.getNoOfHiddenNodes(), 
            "; Output nodes: ", network.getNoOfOutputNodes());
  
  // Set network biasing here
  // b1 = 0.35
  network.setBiasInputToHidden(0.35);
  // b2 = 0.60
  network.setBiasHiddenToOutput(0.6);
  
  // The Neural class constructor gives the weights random value.
  // Here we use the values from Matt Mazur's example.
  // We start with the input-to-hidden weights:
  // w1 = 0.15 (i1 to h1)
  network.setInputToHiddenWeight(0, 0, 0.15);
  // w3 = 0.25 (i1 to h2)
  network.setInputToHiddenWeight(0, 1, 0.25);
  // w2 = 0.20 (i2 to h1)
  network.setInputToHiddenWeight(1, 0, 0.2);
  // w4 = 0.30 (i2 to h2)
  network.setInputToHiddenWeight(1, 1, 0.30);
  
  // Next we configure the hidden-to-output weights:
  // w5 = 0.40 (h1 to o1)
  network.setHiddenToOutputWeight(0, 0, 0.4);
  // w7 = 0.50 (h1 to o2)
  network.setHiddenToOutputWeight(0, 1, 0.5);
  // w6 = 0.45 (h2 to o1)
  network.setHiddenToOutputWeight(1, 0, 0.45);
  // w8 = 0.55 (h2 to o2)
  network.setHiddenToOutputWeight(1, 1, 0.55);
  
  // Configure the inputs
  // i1 = 0.05
  network.setInputNode(0, 0.05);
  // i2 = 0.10
  network.setInputNode(1, 0.1);
  
  // Now declare the values we like to achieve at the outputs for this
  // input combination
  // o1 should be 0.01
  network.setOutputNodeDesired(0, 0.01);
  // o2 should be 0.99
  network.setOutputNodeDesired(1, 0.99);
  
  // We now perform a forwardpass using the configured inputs, weights
  // and bias value. Verbose is on, so you will see the working
  println();
  println("Calculating values for o1 and o2...");
  println();
  network.calculateOutput();
  println();
  
  // Let's summarise the current state
  println("...forwardpass complete. Results:");
  println("For i1 = ", network.getInputNode(0), " and i2 = ", network.getInputNode(1));
  println("o1 = ", network.getOutputNode(0), " (but we want: ", network.getOutputNodeDesired(0), ")");
  println("o2 = ", network.getOutputNode(1), " (but we want: ", network.getOutputNodeDesired(1), ")");
  println();
  println("Total network error is: ", network.getTotalNetworkError(), "(", network.getTotalNetworkError()*100.0,"%)");
  println();
  
  // Now we'll perform a learning cycle using backpropagation
  // This enables a backpropagation cycle everytime the calculateOuput() method is called
  network.turnLearningOn();
  
  println("Learning is ON");
  println("Calculating outputs again and performing backpropagation...");
  println();
  network.calculateOutput();
  
  // We'll turn learning off again...
  network.turnLearningOff();
  // ...and run another forwardpass without verbose on:
  network.turnVerboseOff();
  network.calculateOutput();
  
  println("...backpropagation complete. Results:");
  println("For i1 = ", network.getInputNode(0), " and i2 = ", network.getInputNode(1));
  println("o1 = ", network.getOutputNode(0), " (but we want: ", network.getOutputNodeDesired(0), ")");
  println("o2 = ", network.getOutputNode(1), " (but we want: ", network.getOutputNodeDesired(1), ")");
  println();
  println("Total network error is: ", network.getTotalNetworkError(), "(", network.getTotalNetworkError()*100.0,"%)");
  println();
}

void draw() {
}
