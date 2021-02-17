#include <Wire.h>
#include "Adafruit_TCS34725.h"
#include "Neural.h"

// Use pin 10 to control white LED
#define ledpin 10

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
   **  TEACH THE BRAIN !!!
   **
   **********************************/
  network.turnLearningOn();
  Serial.println("Neural network is learning...");
  
  for (int loop = 0; loop < 30000; ++loop) {
    
    teachRed(142, 59, 63);
    teachAmber(115, 79, 62);
    teachGreen(58, 102, 91);
    
    //teachOther(163, 160, 121);
    //teachOther(76, 72, 35);
    //teachOther(175, 167, 138);
    //teachOther(152, 167, 161);

    if (!(loop % 1000)) {
      Serial.print(".");
    }
  }
  Serial.println();
  network.turnLearningOff();
  /***********************************
   **
   **  END OF TEACHING !!!
   **
   **********************************/
   
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
  network.calculateOutput();

  // Now output traffic light color detected
  if (network.getOutputNode(0) > 0.90) {
    Serial.println("Red");
  }
  if (network.getOutputNode(1) > 0.90) {
    Serial.println("Amber");
  }
  if (network.getOutputNode(2) > 0.90) {
    Serial.println("Green");
  }
  if (network.getOutputNode(3) > 0.90) {
    Serial.println("Other");
  }
}

void teachRed(int r, int g, int b) {
  float newR, newG, newB;
  
  randomise(&r, &g, &b);
  
  newR = (r / 255.0);
  newG = (g / 255.0);
  newB = (b / 255.0);
  
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

  randomise(&r, &g, &b);
  
  newR = (r / 255.0);
  newG = (g / 255.0);
  newB = (b / 255.0);
  
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

  randomise(&r, &g, &b);
  
  newR = (r / 255.0);
  newG = (g / 255.0);
  newB = (b / 255.0);
  
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

  randomise(&r, &g, &b);
  
  newR = (r / 255.0);
  newG = (g / 255.0);
  newB = (b / 255.0);
  
  network.setInputNode(0, newR);
  network.setInputNode(1, newG);
  network.setInputNode(2, newB);
  
  network.setOutputNodeDesired(0, 0.01);
  network.setOutputNodeDesired(1, 0.01);
  network.setOutputNodeDesired(2, 0.01);
  network.setOutputNodeDesired(3, 0.99);

  network.calculateOutput();
}

void randomise(int *r, int *g, int *b) {
  *r += random(-4, 5);
  *g += random(-4, 5);
  *b += random(-4, 5);
  
  if (*r > 255) {
    *r = 255;
  }
  if (*r < 0 ) {
    *r = 0;
  }
  if (*g > 255) {
    *g = 255;
  }
  if (*g < 0 ) {
    *g = 0;
  }
  if (*b > 255) {
    *b = 255;
  }
  if (*b < 0 ) {
    *b = 0;
  }
}
