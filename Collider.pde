static class Collider {
  
  static boolean PointInBox(PVector vec, Box box) {
    return vec.x > box.pos.x && vec.y > box.pos.y && vec.x < box.pos.x + box.w && vec.y < box.pos.y + box.h; 
  }
  
  static boolean BoxInBox(Box b1, Box b2) {
    return (b1.pos.x < b2.pos.x + b2.w && b1.pos.x + b1.w > b2.pos.x &&
            b1.pos.y < b2.pos.y + b2.h && b1.pos.y + b1.h > b2.pos.y); 
  }
  

}
