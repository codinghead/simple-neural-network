#include <Wire.h>
#include "Adafruit_TCS34725.h"

// Use pin 10 to control white LED
#define ledpin 10

// Use Adafruit TCS34725 library
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

void setup() {
  Serial.begin(9600);
  Serial.println("TCS34725 Test!");

  // Turn off LED
  pinMode(ledpin, OUTPUT);
  digitalWrite(ledpin, LOW);
  
  if (tcs.begin()) {
    Serial.println("Sensor found - testing starts.");
  } else {
    Serial.println("No TCS34725 found ... check your connections");
    Serial.println("and then press reset button.");
    while (1); // halt!
  }

  digitalWrite(ledpin, HIGH);  // turn on LED
}

void loop() {
  float red, green, blue;
    
  delay(60);  // takes 50ms to read

  tcs.getRGB(&red, &green, &blue);
  
  Serial.print("R:\t"); Serial.print(int(red)); 
  Serial.print("\tG:\t"); Serial.print(int(green)); 
  Serial.println("\tB:\t"); Serial.print(int(blue));
}
