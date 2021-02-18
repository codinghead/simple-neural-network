/*
 * This teaches the traffic light colors to the MLP, then
 * tests if they are correctly classified.
 * 
 * Focus red box on color of interest.
 */

import processing.video.*;

Capture cam;
PFont font;

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
  size(1280, 480);
  
  cam = new Capture(this, 640, 480, "Logitech Webcam 500", 30);
  
  // Start capturing the images from the camera
  cam.start();
  
  font = loadFont("ArialMT-48.vlw");
  textFont(font);
  
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
   
  println("Neural network is ready");
}

void draw() {
  background(0);
  
  if (cam.available() == true && pause == false) {
    //println("Cam available");
    cam.read();
    cam.loadPixels();
  }

  // Output image
  set(0, 0, cam);
  
  // Display testing points
  rectMode(CENTER);
  noFill();
  strokeWeight(5);
  
  // Centre
  stroke(250, 10, 10);
  rect(640/2, 480/2, 20, 20);
  
  // Centre left/right
  stroke(204, 102, 0);
  rect((640/2) - 80, (480/2), 20, 5);
  rect((640/2) + 80, (480/2), 20, 5);
  
  // Centre above/below
  rect((640/2), (480/2) - 80, 5, 20);
  rect((640/2), (480/2) + 80, 5, 20);
  
  // Circle for centering sign
  translate((640/2), (480/2));
  dashedCircle(140, 6, 4);
  translate((-640/2), (-480/2));
    
  int averageR = 0;
  int averageG = 0;
  int averageB = 0;
  int loopCount = 0;
  
  // This averages the color of all pixels seen in the red square
  for (int i = ((480 / 2) - 5); i <= ((480 / 2) + 5); ++i) {
    for (int j = ((640 / 2) - 5); j <= ((640 / 2) + 5); ++j) {
      ++loopCount;
      
      int wantedPixel = (640 * i) + j - 1;
      
      int pixelcolour = cam.pixels[wantedPixel];
      averageR += (pixelcolour >> 16) & 0xff;
      averageG += (pixelcolour >> 8) & 0xff;
      averageB += pixelcolour & 0xff;
    }
  }
  
  r = averageR / loopCount;
  g = averageG / loopCount;
  b = averageB / loopCount;
  
  // Display pixel as a square
  rectMode(CENTER);
  fill(r, g, b);
  stroke(255, 255, 255);
  strokeWeight(1);
  rect(640+(50), 40, 40, 40);
  
  // Display RGB colours weights as squares
  fill(r, 0, 0);
  rect(640+(50), 100, 40, 40);
  fill(0, g, 0);
  rect(640+(50), 160, 40, 40);
  fill(0, 0, b);
  rect(640+(50), 220, 40, 40);
    
  fill(200, 200, 200);
  text("Colour seen", 640+(100), 60);
  text("R = " + r, 640+(100), 120);
  text("G = " + g, 640+(100), 180);
  text("B = " + b, 640+(100), 240);
  
  // Now try to detect colour seen
  network.setInputNode(0, (float) r / 255.0);
  network.setInputNode(1, (float) g / 255.0);
  network.setInputNode(2, (float) b / 255.0);
  
  network.calculateOutput();
  
//  println(network.getOutputNode(0), 
//          network.getOutputNode(1),
//          network.getOutputNode(2),
//          network.getOutputNode(3));
  
  
  // Display detected colours as circles
  // Red
  if (network.getOutputNode(0) > 0.90) {
    fill(200, 200, 200);
    text("Red", 640+(100), 320);
    
    fill(r, g, b);
  } else {
    fill(0, 0, 0);
  }
  ellipse(640+(50), 300, 40, 40);
  
  // Amber
  if (network.getOutputNode(1) > 0.90) {
    fill(200, 200, 200);
    text("Amber", 640+(100), 380);
    
    fill(r, g, b);
  } else {
    fill(0, 0, 0);
  }
  ellipse(640+(50), 360, 40, 40);
  
  // Green
  if (network.getOutputNode(2) > 0.90) {
    fill(200, 200, 200);
    text("Green", 640+(100), 440);
    
    fill(r, g, b);
  } else {
    fill(0, 0, 0);
  }
  ellipse(640+(50), 420, 40, 40);
  
  // Other
  if (network.getOutputNode(3) > 0.90) {
    fill(200, 200, 200);
    text("Other", 640+(400), 440);
    
    fill(r, g, b);
  } else {
    fill(0, 0, 0);
  }
  ellipse(640+(360), 420, 40, 40);

}

// Handle key presses
void keyPressed() {
  if (key == 'p' || key == 'P') {
    // Check we aren't currently paused
    if (pause == false) {
      pause = true;
    }
  }
  
  if (key == 's' || key == 'S') {
      // Check we are paused
      if (pause == true) {
        pause = false;
      }
  }
}

void dashedCircle(float radius, int dashWidth, int dashSpacing) {
    int steps = 200;
    int dashPeriod = dashWidth + dashSpacing;
    boolean lastDashed = false;
    for(int i = 0; i < steps; i++) {
      boolean curDashed = (i % dashPeriod) < dashWidth;
      if(curDashed && !lastDashed) {
        beginShape();
      }
      if(!curDashed && lastDashed) {
        endShape();
      }
      if(curDashed) {
        float theta = map(i, 0, steps, 0, TWO_PI);
        vertex(cos(theta) * radius, sin(theta) * radius);
      }
      lastDashed = curDashed;
    }
    if(lastDashed) {
      endShape();
    }
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
  value += random(-4, 4);

  if (value > 255) {
    value = 255;
  }
  if (value < 0 ) {
    value = 0;
  }
  return value;
}
