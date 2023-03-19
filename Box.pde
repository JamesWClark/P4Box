class Box {
  PVector pos;
  float w, h;
  
  Box(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
  }
  

  
  void render() {
    rect(pos.x, pos.y, w, h);
  }
}
