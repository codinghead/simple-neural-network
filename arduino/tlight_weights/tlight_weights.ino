#include <Wire.h>
#include "Adafruit_TCS34725.h"
#include "Neural.h"

// Use pin 10 to control white LED
#define ledpin 10
#define testpin 9

// Use Adafruit TCS34725 library
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

// Use Neural class
Neural network(3,6,4);

void setup() {
  Serial.begin(9600);
  Serial.println("Traffic Light with MLP Neural Network");

  // Turn off LED
  pinMode(ledpin, OUTPUT);
  digitalWrite(ledpin, LOW);
  pinMode(testpin, OUTPUT);
  digitalWrite(testpin, LOW);
  
  // Seed the random number generator
  randomSeed(analogRead(0));
  
  if (tcs.begin()) {
    Serial.println("RGB sensor found.");
  } else {
    Serial.println("No TCS34725 found ... check your connections");
    Serial.println("and then press reset button.");
    while (1); // halt!
  }

  Serial.println("Configuring neural network...");

  //network = new Neural(3,6,4);
  network.setLearningRate(0.5);
  Serial.print("Inputs = ");
  Serial.print(network.getNoOfInputNodes());
  Serial.print(" Hidden = ");
  Serial.print(network.getNoOfHiddenNodes());
  Serial.print(" Outputs = ");
  Serial.println(network.getNoOfOutputNodes());
  network.setBiasInputToHidden(0.35);
  network.setBiasHiddenToOutput(0.60);
  
  /***********************************
   **
   **  PROGRAM THE BRAIN !!!
   **
   **********************************/
  importWeights();
   
  Serial.println("Neural network is ready");

  digitalWrite(ledpin, HIGH);  // turn on LED
}

void loop() {
  float r, g, b;
  
  delay(60);  // takes 50ms to read

  tcs.getRGB(&r, &g, &b);

  // Apply RGB color to MLP and calculate outputs
  network.setInputNode(0, r / 255.0);
  network.setInputNode(1, g / 255.0);
  network.setInputNode(2, b / 255.0);
  
  digitalWrite(testpin, HIGH);
  network.calculateOutput();
  digitalWrite(testpin, LOW);
  
  // Now output traffic light color detected
  if (network.getOutputNode(0) > 0.98) {
    Serial.println("Red");
  }
  if (network.getOutputNode(1) > 0.98) {
    Serial.println("Amber");
  }
  if (network.getOutputNode(2) > 0.98) {
    Serial.println("Green");
  }
  if (network.getOutputNode(3) > 0.98) {
    Serial.println("Other");
  }
}

void importWeights() {
  // For Input Node 0: 
  network.setInputToHiddenWeight( 0 , 0 , 0.9894259 );
  network.setInputToHiddenWeight( 0 , 1 , -0.75018144 );
  network.setInputToHiddenWeight( 0 , 2 , 48.61366 );
  network.setInputToHiddenWeight( 0 , 3 , -3.345678 );
  network.setInputToHiddenWeight( 0 , 4 , 9.416907 );
  network.setInputToHiddenWeight( 0 , 5 , -23.454737 );

  // For Input Node 1: 
  network.setInputToHiddenWeight( 1 , 0 , 2.1327987 );
  network.setInputToHiddenWeight( 1 , 1 , 5.392093 );
  network.setInputToHiddenWeight( 1 , 2 , -36.850338 );
  network.setInputToHiddenWeight( 1 , 3 , 12.039759 );
  network.setInputToHiddenWeight( 1 , 4 , -18.738537 );
  network.setInputToHiddenWeight( 1 , 5 , 15.558427 );

  // For Input Node 2: 
  network.setInputToHiddenWeight( 2 , 0 , 1.3367374 );
  network.setInputToHiddenWeight( 2 , 1 , -0.74704653 );
  network.setInputToHiddenWeight( 2 , 2 , -1.242378 );
  network.setInputToHiddenWeight( 2 , 3 , -5.9497995 );
  network.setInputToHiddenWeight( 2 , 4 , -1.0344149 );
  network.setInputToHiddenWeight( 2 , 5 , 15.218534 );

  //For Hidden Node 0: 
  network.setHiddenToOutputWeight( 0 , 0 , -2.0546117 );
  network.setHiddenToOutputWeight( 0 , 1 , -1.203141 );
  network.setHiddenToOutputWeight( 0 , 2 , -2.7587035 );
  network.setHiddenToOutputWeight( 0 , 3 , -9.748996 );

  //For Hidden Node 1: 
  network.setHiddenToOutputWeight( 1 , 0 , -3.9066978 );
  network.setHiddenToOutputWeight( 1 , 1 , 1.2856442 );
  network.setHiddenToOutputWeight( 1 , 2 , -0.48529842 );
  network.setHiddenToOutputWeight( 1 , 3 , -10.828738 );

  //For Hidden Node 2: 
  network.setHiddenToOutputWeight( 2 , 0 , 2.6418133 );
  network.setHiddenToOutputWeight( 2 , 1 , 4.8058596 );
  network.setHiddenToOutputWeight( 2 , 2 , -25.040785 );
  network.setHiddenToOutputWeight( 2 , 3 , 21.380386 );

  //For Hidden Node 3: 
  network.setHiddenToOutputWeight( 3 , 0 , -7.608626 );
  network.setHiddenToOutputWeight( 3 , 1 , 6.0782804 );
  network.setHiddenToOutputWeight( 3 , 2 , 4.0631976 );
  network.setHiddenToOutputWeight( 3 , 3 , -12.329156 );

  //For Hidden Node 4: 
  network.setHiddenToOutputWeight( 4 , 0 , 11.230279 );
  network.setHiddenToOutputWeight( 4 , 1 , -15.336227 );
  network.setHiddenToOutputWeight( 4 , 2 , -11.472162 );
  network.setHiddenToOutputWeight( 4 , 3 , -7.3535438 );

  //For Hidden Node 5: 
  network.setHiddenToOutputWeight( 5 , 0 , -14.677024 );
  network.setHiddenToOutputWeight( 5 , 1 , -16.876846 );
  network.setHiddenToOutputWeight( 5 , 2 , 7.690963 );
  network.setHiddenToOutputWeight( 5 , 3 , 20.697523 );

}
