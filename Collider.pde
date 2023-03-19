static class Collider {
  
  static class RayBoxIntersectStats {
    boolean hit = false;;
    PVector contact_point;
    PVector contact_normal;
    float t_hit_near;
  }
  
  static boolean PointInBox(PVector vec, Box box) {
    return vec.x > box.pos.x && vec.y > box.pos.y && vec.x < box.pos.x + box.w && vec.y < box.pos.y + box.h; 
  }
  
  static boolean BoxInBox(Box b1, Box b2) {
    return (b1.pos.x < b2.pos.x + b2.w && b1.pos.x + b1.w > b2.pos.x &&
            b1.pos.y < b2.pos.y + b2.h && b1.pos.y + b1.h > b2.pos.y); 
  }
  
  // https://www.youtube.com/watch?v=8JJ-4JgR7Dg
  static RayBoxIntersectStats RayInBox(PVector P, PVector Q, Box target) {
    // P origin
    // Q endpoint
    // D = Q - P, direction vector
    PVector D = Q.sub(P);
    
    // P(t) = P + D•t
    
    float Nx = (target.pos.x - P.x) / D.x; // near x
    float Ny = (target.pos.y - P.y) / D.y; // near y 
    float Fx = (target.pos.x + target.w - P.x) / D.x; // far x
    float Fy = (target.pos.y + target.h - P.y) / D.y; // far y
    
    // rules of intersection
    // Nx < Fy
    // Ny < Fx  
    
    // we also need to know *where* the intersection occurs
    
    if(Nx > Fx) {
      float swap = Nx;
      Nx = Fx;
      Fx = swap;
    }
    if(Ny > Fy) {
      float swap = Ny;
      Ny = Fy;
      Fy = swap;
    }
    
    if(Nx > Fy || Ny > Fx) return new RayBoxIntersectStats();

    // assumption: max(Nx, Ny) is distance along vector from origin to first collision point
    float t_hit_near = max(Nx, Ny);
    float t_hit_far  = min(Fx, Fy);
    
    if(t_hit_far < 0) return new RayBoxIntersectStats();
    
    RayBoxIntersectStats hit = new RayBoxIntersectStats();
    hit.contact_point = new PVector(P.x + t_hit_near * D.x, P.y + t_hit_near * D.y);
    
    if(Nx > Ny)
      if(D.x < 0)
        hit.contact_normal = new PVector(1, 0);
      else
        hit.contact_normal = new PVector(-1, 0);
    else if (Nx < Ny)
      if(D.y < 0)
        hit.contact_normal = new PVector(0, 1);
      else
        hit.contact_normal = new PVector(0, -1);
    
    hit.hit = true;
    hit.t_hit_near = t_hit_near;
    return hit;
    
    
  }
  
}
