// Recursive branching "structure" without an explicitly recursive function
// Instead we have an ArrayList to hold onto N number of elements
// For every element in the ArrayList, we add 2 more elements, etc. (this is the recursion)

// An arraylist that will keep track of all current branches
ArrayList<Branch> tree;
float yOff = 0.1;
boolean isNoise = false;

void setup() {
  //size(200,200);
  fullScreen();
  background(255);
  smooth();
  
  // Create a new tree. 
  newTree();
}

void draw() {
  // Try erasing the background to see how it works
  background(255);
  
  if (isNoise) {
    yOff += 0.005;
  }
 
  // Animate and draw branches. 
  for (int i = 0; i < tree.size(); i++) {
    // Get the branch, update and draw it
    Branch b = tree.get(i);
    if (b.isAnimating) {
      b.animate();
    }
    
    // Always render, every branch.
    b.render();
  }
  
  // Check for perlin noise.
  // applyPerlin();
}

void keyPressed() {
   // Reset. 
   if (key == 'r') {
     newTree();
   }
   
   // Split.
   if (key == 's') {
     split();
   }
}

// Apply perline noise to branch angles.
void applyPerlin() { 
  
  // Track non-animating count
  int nonAnimating = 0;
  for (int i=0; i < tree.size(); i++) {
    Branch b = tree.get(i);
    if (!b.isAnimating) {
      nonAnimating++;
    }
  }
  
  // Is something animating? No, apply perlin.
  if (nonAnimating == tree.size()) {
    isNoise = true;
    // We can apply perlin noise. 
    for (int i=0; i < tree.size(); i++) {
      if (!tree.get(i).isRoot) {
        Branch b = tree.get(i);
        float oldTheta = b.vel.heading2D();
        float newTheta = map(noise(i, yOff+i), 0, 1, oldTheta - PI/4, oldTheta + PI/4);
        // Calculate length
        float mag = (PVector.sub(b.end, b.start)).mag();
        // calculate new end vertex 
        b.end.x = mag*cos(newTheta); b.end.y = mag*sin(newTheta);
      }
    }
  } else {
     isNoise = false; 
  }
}

void newTree() {
  // A branch has a starting location, a starting "velocity", and a starting "timer" 
  Branch b = new Branch(new PVector(width,height),new PVector(-2.0,-2.0),100);
  
  if (tree == null) {
    // Setup the arraylist an add one branch to it
    tree = new ArrayList();
    // I'm a root. 
    b.isRoot = true;
  } else {
    background(255);
    tree.clear(); 
  }
 
  // Add to arraylist
  tree.add(b);
}

void split() {
  // Go through the tree and check if there is a non-animating branch that we 
  // can split. If we can, then create a random number of branches at random
  // angles from there.
  for (int i = 0; i < tree.size(); i++) {
     Branch b = tree.get(i);
     // Branch shouldn't be animating.
     // Branch shouldn't be a child.
     if (!b.isAnimating && b.isChild) {
        // No more a child. So, we don't split it the next time. 
        b.isChild = false;
        
        // Random number of branches
        int n = (int) random(1, 5); 
        for (int j=0; j < n; j++) {
          Branch b1 = b.branch(random(-45, 45));
          //Branch b2 = b1.branch(random(-45, 45));
          //tree.add(b1);
          tree.add(b1);
        }
     }
  }
  
  print("New tree size : " + tree.size() + "\n");
}