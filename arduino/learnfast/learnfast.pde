/*
 * This teaches the traffic light colors to the MLP, then
 * outputs the weights for use on an Arduino.
 */
boolean pause = false;

boolean learningMode = false;
boolean learnRed = false;
boolean learnAmber = false;
boolean learnGreen = false;
boolean learnOther = false;

int r;
int g;
int b;

Neural network;

void setup() {  
  println("Configuring neural network...");
  
  network = new Neural(3,6,4);
  network.setLearningRate(0.5);
  println("Inputs =", network.getNoOfInputNodes(), " Hidden = ", network.getNoOfHiddenNodes(), " Outputs = ", network.getNoOfOutputNodes());
  network.setBiasInputToHidden(0.35);
  network.setBiasHiddenToOutput(0.60);
  
  /***********************************
   **
   **  TEACH THE BRAIN !!!
   **
   **********************************/
  network.turnLearningOn();
  println("Neural network is learning...");
  
  for (int loop = 0; loop < 90000; ++loop) {

    // Enter your RGB values here
    teachRed(220, 56, 8);
    teachAmber(216, 130, 11);
    teachGreen(123, 150, 128);
    
    //teachOther(163, 160, 121);
    teachOther(76, 72, 35);
    teachOther(175, 167, 138);
    teachOther(152, 167, 161);
    
  }

  network.turnLearningOff();
  /***********************************
   **
   **  END OF TEACHING !!!
   **
   **********************************/
  
  println("Input-to-hidden node weights");
  network.displayInputToHiddenWeightsCurrent();
  println();
  println("Hidden-to-output node weights");
  network.displayHiddenToOutputWeightsCurrent();
  println();
  
  println("Arduino sketch code:");
  println();
  
  for (int x = 0; x < network.getNoOfInputNodes(); ++x) {
    println("  // For Input Node " + x + ": ");
    for (int y = 0; y < network.getNoOfHiddenNodes(); ++y) {
      println("  network.setInputToHiddenWeight(", x,",", y,",", network.inputToHiddenWeights[x][y],");");
      //print(inputToHiddenWeights[x][y], " ");
    }
    println();
  }
  
  for (int x = 0; x < network.getNoOfHiddenNodes(); ++x) {
    println("  //For Hidden Node " + x + ": ");
    for (int y = 0; y < network.getNoOfOutputNodes(); ++y) {
      println("  network.setHiddenToOutputWeight(", x,",", y,",", network.hiddenToOutputWeights[x][y],");");
      //print(hiddenToOutputWeights[x][y], " ");
    }
    println();
  }
    
  println("Neural network is ready");
}

void draw() {
  // No code required here
}

void teachRed(int r, int g, int b) {
  float newR, newG, newB;

  newR = (randomise(r) / 255.0);
  newG = (randomise(g) / 255.0);
  newB = (randomise(b) / 255.0);
  
  //println("Red:", newR, newG, newB);
  
  network.setInputNode(0, newR);
  network.setInputNode(1, newG);
  network.setInputNode(2, newB);
  
  network.setOutputNodeDesired(0, 0.99);
  network.setOutputNodeDesired(1, 0.01);
  network.setOutputNodeDesired(2, 0.01);
  network.setOutputNodeDesired(3, 0.01);
  
  network.calculateOutput();
}

void teachAmber(int r, int g, int b) {
  float newR, newG, newB;

  newR = (randomise(r) / 255.0);
  newG = (randomise(g) / 255.0);
  newB = (randomise(b) / 255.0);
  
  //println("Amber:", newR, newG, newB);
  
  network.setInputNode(0, newR);
  network.setInputNode(1, newG);
  network.setInputNode(2, newB);
  
  network.setOutputNodeDesired(0, 0.01);
  network.setOutputNodeDesired(1, 0.99);
  network.setOutputNodeDesired(2, 0.01);
  network.setOutputNodeDesired(3, 0.01);
  
  network.calculateOutput();
}

void teachGreen(int r, int g, int b) {
  float newR, newG, newB;
  
  newR = (randomise(r) / 255.0);
  newG = (randomise(g) / 255.0);
  newB = (randomise(b) / 255.0);
  
  network.setInputNode(0, newR);
  network.setInputNode(1, newG);
  network.setInputNode(2, newB);
  
  network.setOutputNodeDesired(0, 0.01);
  network.setOutputNodeDesired(1, 0.01);
  network.setOutputNodeDesired(2, 0.99);
  network.setOutputNodeDesired(3, 0.01);

  network.calculateOutput();
}

void teachOther(int r, int g, int b) {
  float newR, newG, newB;
  
  newR = (randomise(r) / 255.0);
  newG = (randomise(g) / 255.0);
  newB = (randomise(b) / 255.0);
  
  network.setInputNode(0, newR);
  network.setInputNode(1, newG);
  network.setInputNode(2, newB);
  
  network.setOutputNodeDesired(0, 0.01);
  network.setOutputNodeDesired(1, 0.01);
  network.setOutputNodeDesired(2, 0.01);
  network.setOutputNodeDesired(3, 0.99);

  network.calculateOutput();
}

int randomise(int value) {
  value += random(-4, 5);
  
  if (value > 255) {
    value = 255;
  }
  if (value < 0 ) {
    value = 0;
  }

  return value;
}
