// A class for one branch in the system.

class Branch {
  // Each has a location, velocity, and timer 
  // We could implement this same idea with different data
  PVector start;
  PVector end; 
  PVector vel;
  float timer;
  float timerstart;
  float branchColor;
  
  // [Note] Very important to maintain this variable. 
  // This keeps track if we are currently animating. 
  // Remember (never) try to branch off this if it's 
  // currently animating. 
  boolean isAnimating = true; 
  
  // Is it a child? 
  boolean isChild = true;
  
  // Is it the root?
  boolean isRoot = false;
  
  // New branch has 0 children.
  int numChildren = 0;

  Branch(PVector l, PVector v, float n, color c) {
    start = l.get();
    end = l.get();
    vel = v.get();
    timerstart = n;
    timer = timerstart;
    branchColor = c;
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
    
    // Keep animating if it's currently animating. 
    if (isAnimating)  {
       animate(); 
    }
    
    // Calculate the length of this branch. 
    float length = (PVector.sub(end, start)).mag();
    float sw = map(length, 0, 285, 1, 4);
    strokeWeight(sw);
    // Apply the branch color.
    stroke(color(255, 255, 255));
    line(start.x,start.y,end.x,end.y);
  }
  
    // Create a new branch at the current location, but change direction by a given angle
    Branch branch(float angle, color branchColor) {
      // What is my current heading
      float theta = vel.heading2D();
      // What is my current speed
      float mag = vel.mag();
      // Turn me
      theta += radians(angle);
      // Look, polar coordinates to cartesian!!
      PVector newvel = new PVector(mag*cos(theta),mag*sin(theta)); 
     
      // Return a new Branch
      return new Branch(end,newvel,timerstart*0.66f, branchColor);
    }
}