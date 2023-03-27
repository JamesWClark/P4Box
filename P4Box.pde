// Rect class definition
class Rect {
  float x, y, w, h;
  
  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // Check if this rectangle collides with another rectangle
  boolean collidesWith(Rect other) {
    return x + w > other.x && x < other.x + other.w && y + h > other.y && y < other.y + other.h;
  }
  
  // Resolve collision with another rectangle
  void resolveCollision(Rect other) {
    float dx = Math.min(x + w - other.x, other.x + other.w - x);
    float dy = Math.min(y + h - other.y, other.y + other.h - y);
    
    if (dx < dy) {
      // Resolve horizontal collision
      if (x + w / 2 < other.x + other.w / 2) {
        x -= dx;
      } else {
        x += dx;
      }
    } else {
      // Resolve vertical collision
      if (y + h / 2 < other.y + other.h / 2) {
        y -= dy;
      } else {
        y += dy;
      }
    }
  }
  
  // Draw the rectangle
  void draw() {
    rect(x, y, w, h);
  }
}

// Player controlled rectangle
Rect playerRect;

// ArrayList of other rectangles
ArrayList<Rect> rects = new ArrayList<Rect>();

void setup() {
  size(400, 400);
  
  // Create player rectangle
  playerRect = new Rect(width / 2 - 25, height / 2 - 25, 50, 50);
  
  // Create other rectangles
  for (int i = 0; i < 10; i++) {
    rects.add(new Rect(random(width), random(height), random(50, 100), random(50, 100)));
  }
}

// Flag to indicate if arrow keys are being pressed
boolean upPressed, downPressed, leftPressed, rightPressed;

void keyPressed() {
  if (keyCode == UP) {
    upPressed = true;
  } else if (keyCode == DOWN) {
    downPressed = true;
  } else if (keyCode == LEFT) {
    leftPressed = true;
  } else if (keyCode == RIGHT) {
    rightPressed = true;
  }
}

void keyReleased() {
  if (keyCode == UP) {
    upPressed = false;
  } else if (keyCode == DOWN) {
    downPressed = false;
  } else if (keyCode == LEFT) {
    leftPressed = false;
  } else if (keyCode == RIGHT) {
    rightPressed = false;
  }
}

void draw() {
  background(255);

  // Move player rectangle continuously while arrow keys are held down
  if (upPressed) {
    playerRect.y -= 5;
  } else if (downPressed) {
    playerRect.y += 5;
  }
  if (leftPressed) {
    playerRect.x -= 5;
  } else if (rightPressed) {
    playerRect.x += 5;
  }

  // Check for collisions and resolve them
  for (Rect r : rects) {
    if (playerRect.collidesWith(r)) {
      playerRect.resolveCollision(r);
    }
    r.draw();
  }
  
  // Draw player rectangle
  playerRect.draw();
}
