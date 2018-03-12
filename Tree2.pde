// Recursive Tree (w/ ArrayList)
// Daniel Shiffman <http://www.shiffman.net>
// Nature of Code, Chapter 8

// Recursive branching "structure" without an explicitly recursive function
// Instead we have an ArrayList to hold onto N number of elements
// For every element in the ArrayList, we add 2 more elements, etc. (this is the recursion)

// An arraylist that will keep track of all current branches
ArrayList<Branch> tree;

void setup() {
  //size(200,200);
  fullScreen();
  background(255);
  smooth();
  
  // Setup the arraylist and add one branch to it
  tree = new ArrayList();
  // A branch has a starting location, a starting "velocity", and a starting "timer" 
  Branch b = new Branch(new PVector(width,height),new PVector(-2.0,-2.0),100);
  // Add to arraylist
  tree.add(b);
}

void mousePressed() {
  print ("Old size" + tree.size() + "\n");
  for (int i = 0; i < tree.size(); i++) {
     Branch b = tree.get(i);
     // If this branch doesn't have other branches connected to it, then 
     // skip it. Only expand through children. 
     if (b.hasAnimationStopped() && !b.isChild) {
        // No more a child. So, we don't split it the next time. 
        b.isChild = false;
        
        // Random number of branches. 
        int n = (int) random(1, 4); 
        for (int j=0; j < n; j++) {
          tree.add(b.branch(random(-45, 45)));
        }
     }
  }
}

void draw() {
  // Try erasing the background to see how it works
  // background(255);
 
  // Animate and draw branches. 
  for (int i = 0; i < tree.size(); i++) {
    // Get the branch, update and draw it
    Branch b = tree.get(i);
    if (!b.hasAnimationStopped()) {
      b.update();
      b.render();
    }
  }
}