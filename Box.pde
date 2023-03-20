class Box {
  PVector pos; // position
  PVector vel; // velocity
  float w, h;
  
  Box(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    this.w = w;
    this.h = h;
  }
  

  
  void render() {
    rect(pos.x, pos.y, w, h);
  }
}
