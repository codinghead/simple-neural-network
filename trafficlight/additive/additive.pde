/* 
 * Simple project that display RGB
 * additive color mixing
 *
 */

int r;
int g;
int b;
int mode;
int speed = 1;

void setup() {
  size(500, 500);
  background(0);
  
  r = 0;
  g = 0;
  b = 0;
  
  mode = 0;
}

void draw() {
    background(0);
    
    switch(mode) {
      case 0:
        r += speed;
        if (r >= 255) {
          r = 255;
          mode = 1;
        }
        break;
        
      case 1:
        r -= speed;
        if (r <= 0) {
          r = 0;
          mode = 10;
        }
        break;
  
      case 2:
        r += speed;
        g += speed;
        if (r >= 255) {
          r = 255;
          g = 255;
          mode = 3;
        }
        break;
        
      case 3:
        r -= speed;
        g -= speed;
        if (r <= 0) {
          r = 0;
          g = 0;
          mode = 4;
        }
        break;
        
      case 4:
        r += speed;
        b += speed;
        if (r >= 255) {
          r = 255;
          b = 255;
          mode = 5;
        }
        break;
        
      case 5:
        r -= speed;
        b -= speed;
        if (r <= 0) {
          r = 0;
          b = 0;
          mode = 6;
        }
        break;
      
      case 6:
        g += speed;
        b += speed;
        if (g >= 255) {
          g = 255;
          b = 255;
          mode = 7;
        }
        break;
        
      case 7:
        g -= speed;
        b -= speed;
        if (g <= 0) {
          g = 0;
          b = 0;
          mode = 8;
        }
        break;
      
      case 8:
        r += speed;
        g += speed;
        b += speed;
        if (r >= 255) {
          r = 255;
          g = 255;
          b = 255;
          mode = 9;
        }
        break;
        
      case 9:
        r -= speed;
        g -= speed;
        b -= speed;
        if (r <= 0) {
          r = 0;
          g = 0;
          b = 0;
          mode = 0;
        }
        break;
        
      case 10:
        g += speed;
        if (g >= 255) {
          g = 255;
          mode = 11;
        }
        break;
        
      case 11:
        g -= speed;
        if (g <= 0) {
          g = 0;
          mode = 12;
        }
        break;
        
      case 12:
        b += speed;
        if (b >= 255) {
          b = 255;
          mode = 13;
        }
        break;
        
      case 13:
        b -= speed;
        if (b <= 0) {
          b = 0;
          mode = 2;
        }
        break;
        
      default:
      
    }
    
    noFill();
    
    stroke(255);
    ellipse(250, 200, 250, 250);
    ellipse(150, 300, 250, 250);
    ellipse(350, 300, 250, 250);
    
    blendMode(ADD);
    noStroke();
    
    fill(r, 0, 0);
    ellipse(250, 200, 250, 250);
    fill(0, g, 0);
    ellipse(150, 300, 250, 250);
    fill(0, 0, b);
    ellipse(350, 300, 250, 250);
    
    fill (255);
    textSize(30);
    textAlign(RIGHT);
    
    text(r, 280, 65);
    text(g, 100, 450);
    text(b, 465, 450);
    
    textAlign(CENTER);
    text("R", 250, 30);
    text("G", 70, 485);
    text("B", 435, 485);
    
    delay(10);
    
    println(mode, r, g, b);
}
