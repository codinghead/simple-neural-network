/*
 * Use to collect RGB colors sensed by camera
 *
 * Use "findcamera" project to determine correct code
 * for line 57
 */

import processing.video.*;

Capture cam;
PFont font;

boolean pause = false;

int r;
int g;
int b;

void setup() {
  size(1280, 480);
  // Replace the following line with the result from 'findcamera.pde'
  cam = new Capture(this, 640, 480, "Logitech Webcam 500", 30);
  
  println("Starting capture");
  
  // Start capturing the images from the camera
  cam.start();
  
  font = loadFont("ArialMT-48.vlw");
  textFont(font);
}

void draw() {
  background(0);
  
  if (cam.available() == true && pause == false) {
    cam.read();
    cam.loadPixels();
  }
  
  // Ouput image
  set(0, 0, cam);
  
  // Overlay testing points
  rectMode(CENTER);
  noFill();
  strokeWeight(5);
  
  // Centre
  stroke(250, 10, 10);
  rect(640/2, 480/2, 20, 20);
  
  // Centre left/right
  stroke(200, 200, 200);
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
  
  // Display RGB color weights as squares
  fill(r, 0, 0);
  rect(640+(50), 100, 40, 40);
  fill(0, g, 0);
  rect(640+(50), 160, 40, 40);
  fill(0, 0, b);
  rect(640+(50), 220, 40, 40);
    
  fill(200, 200, 200);
  text("Color seen", 640+(100), 60);
  text("R = " + r, 640+(100), 120);
  text("G = " + g, 640+(100), 180);
  text("B = " + b, 640+(100), 240);
  text("'p' - pause // 's' - start", 640+(100), 440);
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
