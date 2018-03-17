// A class for one branch in the system.

class Branch {
  // Each has a location, velocity, and timer 
  // We could implement this same idea with different data
  PVector start;
  PVector end; 
  PVector vel;
  float timer;
  float timerstart;
  
  // [Note] Very important to maintain this variable. 
  // This keeps track if we are currently animating. 
  // Remember (never) try to branch off this if it's 
  // currently animating. 
  boolean isAnimating = true; 
  
  // Check if this branch is a child. If it's, then only
  // split it further. 
  boolean isChild = true;

  Branch(PVector l, PVector v, float n) {
    start = l.get();
    end = l.get();
    vel = v.get();
    timerstart = n;
    timer = timerstart;
  }
  
  // Animate location.
  void animate() {
    timer--; 
    
    if (isAnimating) {
      end.add(vel);
    }
    
    if (timer < 0) {
      isAnimating = false;  
    }
  }
  
  // Draw a line starting from the start. 
  void render() {
    fill(0);
    //noStroke();
    stroke(2);
    line(start.x,start.y,end.x,end.y);
    //ellipseMode(CENTER);
    //ellipse(end.x,end.y,2,2);
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
    
    // Return a new Branch
    return new Branch(end,newvel,timerstart*0.66f);
  }
}
