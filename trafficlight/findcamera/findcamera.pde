// Use video library
import processing.video.*;

int cameraIndex = -1;

// Declare a capture object.
Capture cam;

void setup() {  
  size(320, 240);
 
  println("Waiting for list of cameras:");
  println();
  printArray(Capture.list());
  println();
  println("Select camera with 0 - 9");
}

void draw() {
  if (cameraIndex == -1) {
    // Wait for camera selection
  } else if (cameraIndex < 10) {
    // Initialize Capture object.
    cam = new Capture(this, 320, 240, Capture.list()[cameraIndex], 30);
    // Start the capturing process.
    cam.start();
    cameraIndex = 100;
  } else if (cameraIndex > 10) {
    // If camera is selected, simply stream image
    image(cam, 0, 0);
  }
}

// Collects new image from camera when available
void captureEvent(Capture video) {
  cam.read();
}

void keyPressed() {
  // User input for chosen camera that outputs line of code to select
  // correct camera for traffic line example
  if (key >= '0' && key <= '9') {
    cameraIndex = key - '0';
    println("Code for line 22:");
    String chosenCamera = "  cam = new Capture(this, 640, 480,\""+Capture.list()[cameraIndex]+"\", 30);";
    println(chosenCamera);
  }
}
