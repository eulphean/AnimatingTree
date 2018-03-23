// A class for one branch in the system.
class Branch {
  // Each has a location, velocity, and timer 
  // We could implement this same idea with different data
  PVector start;
  
  // Maintain these as seperate variables for Animation.
  float xEnd; 
  float yEnd; 
  
  //PVector end; 
  PVector vel;
  float timer;
  float timerstart;
  float branchColor;
  
  float strokeWidth;

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
  
  // Keep track of both X and Y animation to be completed. 
  boolean isXAnimated = false;
  boolean isYAnimated = false;
  
  // Branch animation. 
  Ani branchXAni;
  Ani branchYAni;
  
  // Easing coefficients.
  Easing[] easings = { 
    Ani.LINEAR, Ani.QUAD_IN, Ani.QUAD_OUT, Ani.QUAD_IN_OUT, Ani.CUBIC_IN, Ani.CUBIC_IN_OUT, Ani.CUBIC_OUT, Ani.QUART_IN, Ani.QUART_OUT, Ani.QUART_IN_OUT, Ani.QUINT_IN, Ani.QUINT_OUT, Ani.QUINT_IN_OUT, Ani.SINE_IN, Ani.SINE_OUT, Ani.SINE_IN_OUT, Ani.CIRC_IN, Ani.CIRC_OUT, Ani.CIRC_IN_OUT, Ani.EXPO_IN, Ani.EXPO_OUT, Ani.EXPO_IN_OUT, Ani.BACK_IN, Ani.BACK_OUT, Ani.BACK_IN_OUT, Ani.BOUNCE_IN, Ani.BOUNCE_OUT, Ani.BOUNCE_IN_OUT, Ani.ELASTIC_IN, Ani.ELASTIC_OUT, Ani.ELASTIC_IN_OUT
  };
  String[] easingsVariableNames = {
    "Ani.LINEAR", "Ani.QUAD_IN", "Ani.QUAD_OUT", "Ani.QUAD_IN_OUT", "Ani.CUBIC_IN", "Ani.CUBIC_IN_OUT", "Ani.CUBIC_OUT", "Ani.QUART_IN", "Ani.QUART_OUT", "Ani.QUART_IN_OUT", "Ani.QUINT_IN", "Ani.QUINT_OUT", "Ani.QUINT_IN_OUT", "Ani.SINE_IN", "Ani.SINE_OUT", "Ani.SINE_IN_OUT", "Ani.CIRC_IN", "Ani.CIRC_OUT", "Ani.CIRC_IN_OUT", "Ani.EXPO_IN", "Ani.EXPO_OUT", "Ani.EXPO_IN_OUT", "Ani.BACK_IN", "Ani.BACK_OUT", "Ani.BACK_IN_OUT", "Ani.BOUNCE_IN", "Ani.BOUNCE_OUT", "Ani.BOUNCE_IN_OUT", "Ani.ELASTIC_IN", "Ani.ELASTIC_OUT", "Ani.ELASTIC_IN_OUT"
  };
  
  // Public easing index.
  Easing currentEasing = Ani.QUINT_OUT;

  Branch(PVector l, PVector v, float n, color c, float sw) {
    start = l.get();
    vel = v.get();
    timerstart = n;
    timer = timerstart;
    branchColor = c;
    strokeWidth = sw;
    
    // Current end vector
    xEnd = start.x; 
    yEnd = start.y;
    
    // Setup and kick off animation.
    setupBranchAnimation();
  }
  
  void setupBranchAnimation() {
    // Calculate the targetX, targetY where we are heading.
    float length = timer * vel.mag();
    float targetX = (start.x + length * cos(vel.heading2D())) ; 
    float targetY = (start.y + length * sin(vel.heading2D()));
    
    // Define X, Y animation for the branches., 
    branchXAni = new Ani(this, 2.5, "xEnd", targetX, currentEasing, "onEnd:xDoneAnimating");
    branchYAni = new Ani(this, 2.5, "yEnd", targetY, currentEasing, "onEnd:yDoneAnimating");
    
    // Begin animation.
    branchXAni.start();
    branchYAni.start();
  }
  
  // Callback when x is reached. 
  void xDoneAnimating() {
    isXAnimated = true; 
  }
  
  // Callback when y is reached. 
  void yDoneAnimating() {
    isYAnimated = true;
  }
  
  // Draw a line starting from the start. 
  void render() {
    // Update isAnimating flag to keep track of the animation.
    isAnimating = !(isXAnimated && isYAnimated); 
     
    // Calculate end vector.
    PVector end = new PVector(xEnd, yEnd);
   
    strokeWeight(strokeWidth);
    // Apply the branch color.
    stroke(color(255, 255, 255));
    strokeCap(PROJECT);
    
    line(start.x,start.y, end.x, end.y);
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
   
    // Calculate latest end vector based on xEnd and yEnd values.
    PVector end = new PVector(xEnd, yEnd);
    
    // Return a new Branch
    return new Branch(end,newvel,timerstart*0.66f, branchColor, strokeWidth*0.45);
  }
}