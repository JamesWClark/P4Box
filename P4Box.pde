// https://happycoding.io/tutorials/processing/collision-detection#collision-detection-with-moving-objects

ArrayList<Box> boxes;


long prev = 0; // ms elapsed time
float delta = 0; // delta in seconds


void setup() {
  size(300, 300, P2D);
  
  boxes = new ArrayList<>();
  boxes.add(new Box(10, 10, 30, 20));
  boxes.add(new Box(100, 100, 80, 50));
  prev = millis();
}

void draw() {
  background(64);
  stroke(255);
  
  
  DemoRectVsRect();
  prev = millis();
}

class RayBoxIntersectStats {
  boolean hit = false;
  boolean dynamic_box_hit = false; // used in dynamic box on box collision only
  PVector contact_point = new PVector(0,0);
  PVector contact_normal = new PVector(0,0);
  float t_hit_near = 0;
  float elapsed_time = 0;
}

// https://www.youtube.com/watch?v=8JJ-4JgR7Dg 16:40
RayBoxIntersectStats RayInBox(PVector P, PVector D, Box target) {
  // P origin
  // Q endpoint
  // D = Q - P, direction vector
  
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

// Determines if `a` is crashing into `b`
RayBoxIntersectStats DynamicBoxVsBox(Box a, Box b, float deltaTime) {
  // assume boxes will not start in collision
  if(a.vel.x == 0 && a.vel.y == 0)
    return new RayBoxIntersectStats(); // false

  Box expanded_target = new Box(b.pos.x - a.w/2, b.pos.y - a.h/2, b.w + a.w, b.h + a.h);
  
  PVector distance = new PVector(a.pos.x + a.vel.x, a.pos.y + a.vel.y).mult(deltaTime);
  PVector origin = new PVector(a.pos.x + a.w / 2, a.pos.y + a.h/2);
  RayBoxIntersectStats stats = RayInBox(origin, distance, expanded_target);
  
  if(stats.hit && stats.t_hit_near < 1) {
    stats.dynamic_box_hit = true; // true
  }
  
  return stats; // false
}

void DemoRayIntersector() {
  background(64);
  
  noCursor();
  stroke(255);

  Box b1;
  PVector ray_P, ray_Q;
  b1 = new Box(100, 100, 50, 30);
  
  ray_P = new PVector(20, 20);
  ray_Q = new PVector(mouseX, mouseY);
  line(ray_P.x, ray_P.y, ray_Q.x, ray_Q.y);
  
  RayBoxIntersectStats stats = RayInBox(ray_P, ray_Q.sub(ray_P), b1);

  if(stats.hit && stats.t_hit_near < 1) {
    fill(255,0,0); 
    b1.render();
    float cpx = stats.contact_point.x;
    float cpy = stats.contact_point.y;
    float cnx = stats.contact_normal.x;
    float cny = stats.contact_normal.y;
    fill(200,200,0);
    ellipse(cpx, cpy, 15, 15);
    stroke(255,255,0);
    line(cpx, cpy, cpx + cnx * 10, cpy + cny * 10);
  } else {
    fill(0,255,0);
    b1.render();
  }
}

void DemoRectVsRect() {
  // before setup:
  /*
    ArrayList<Box> boxes;
  */
  
  // in setup:
  /*
    boxes = new ArrayList<>();
    boxes.add(new Box(10, 10, 30, 20));
    boxes.add(new Box(100, 100, 80, 50));
  */
  
  Box player = boxes.get(0);
  if(mousePressed) {
    player.vel.add(new PVector(mouseX - player.pos.x, mouseY - player.pos.y).normalize().mult(100));
  }
  
  delta = (millis() - prev) * 0.001; // in seconds
  for(int i = 1; i < boxes.size(); i++) {
    boxes.get(i).render();
    RayBoxIntersectStats stats = DynamicBoxVsBox(boxes.get(0), boxes.get(i), delta);
    if(stats.dynamic_box_hit) {
      float dotx = stats.contact_normal.x * abs(player.vel.x) * (1 - stats.contact_normal.x);
      float doty = stats.contact_normal.y * abs(player.vel.y) * (1 - stats.contact_normal.y);
      player.vel = new PVector(dotx, doty);
      println("Collide");
    } else {
      println("Don't collide");
    }
  }
  player.pos.add(player.vel.mult(delta));
  player.render();
}
