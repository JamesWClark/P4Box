// https://happycoding.io/tutorials/processing/collision-detection#collision-detection-with-moving-objects

Box b1;
PVector ray_P, ray_Q;

void setup() {
  size(300, 300, P2D);
  
  b1 = new Box(100, 100, 50, 30);

}

void draw() {
  background(64);
  
  noCursor();
  stroke(255);
  

  
  
  ray_P = new PVector(20, 20);
  ray_Q = new PVector(mouseX, mouseY);
  line(ray_P.x, ray_P.y, ray_Q.x, ray_Q.y);
  
  Collider.RayBoxIntersectStats stats = Collider.RayInBox(ray_P, ray_Q, b1);

  if(stats.hit && stats.t_hit_near < 1) {
    fill(255,0,0);
  } else {
    fill(0,255,0);
  }
  
  b1.render();

}

void keyPressed() {
  //player.keyDown();
}

void keyReleased() {
  //player.keyUp();
}
