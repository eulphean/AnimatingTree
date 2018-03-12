// A class for one branch in the system.

class Branch {
  // Each has a location, velocity, and timer 
  // We could implement this same idea with different data
  PVector loc;
  PVector vel;
  float timer;
  float timerstart;
  
  // Check if this branch is a child. If it's, then only
  // split it further. 
  boolean isChild;

  Branch(PVector l, PVector v, float n) {
    loc = l.get();
    vel = v.get();
    timerstart = n;
    timer = timerstart;
  }
  
  // Move location
  void update() {
    loc.add(vel);
    timer--; 
  }
  
  // Draw a dot at location
  void render() {
    fill(0);
    noStroke();
    ellipseMode(CENTER);
    ellipse(loc.x,loc.y,2,2);
  }
  
  boolean hasAnimationStopped() {
    return timer < 0;
  }
  
  // Did the timer run out?
  boolean timeToBranch() {
    timer--;
    if (timer < 0) {
      return true;
    } else {
      return false;
    }
  }

  // Create a new branch at the current location, but change direction by a given angle
  Branch branch(float angle) {
    // What is my current heading
    float theta = vel.heading2D();
    // What is my current speed
    float mag = vel.mag();
    // Turn me
    theta += radians(angle);
    // Look, polar coordinates to cartesian!!
    PVector newvel = new PVector(mag*cos(theta),mag*sin(theta));
    
    isChild = true; 
    // Return a new Branch
    return new Branch(loc,newvel,timerstart*0.66f);
  }
  
}