// Recursive branching "structure" without an explicitly recursive function
// Instead we have an ArrayList to hold onto N number of elements
// For every element in the ArrayList, we add 2 more elements, etc. (this is the recursion)

// An arraylist that will keep track of all current branches
import oscP5.*;
import netP5.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

ArrayList<Tree> grassField;

Tree tree;

boolean reset = false;

int maxTreeSize = 4000;

// OSC handler for processing.
OscP5 oscHandler;

void setup() {
  // Initialize animation engine.
  Ani.init(this);
  
  //size(200,200);
  fullScreen();
  background(0);
  smooth();  
  
  // Setup OSC to receive at port 12346.
  oscHandler = new OscP5(this, 12346);
  
  // Create a tree. 
  tree = new Tree();
}

void draw() {
  // Update logic. 
  background(0);
  
  // Tree height has increased to the max or somebody hit reset. 
  if (tree.getNumBranches() > maxTreeSize || reset) {
     background(0);
     reset = false;
     tree.clear();
     tree = new Tree();
  }
  
  // Draw the tree. 
  tree.draw();
}

void keyPressed() {
   // Reset. 
   if (key == 'r') {
     // grassField.clear();
     reset = true;
   }
   
   if (key == '1') {
      tree.setNewTargetBranches(100);
   }
   
   if (key == '2') {
      tree.setNewTargetBranches(200); 
   }
   
   if (key == '3') {
      tree.setNewTargetBranches(300); 
   }
   
   if (key == '4') {
      tree.setNewTargetBranches(400); 
   }
   
   if (key == '5') {
      tree.setNewTargetBranches(500); 
   }
   
   if (key == '6') {
      tree.setNewTargetBranches(600); 
   }
   
   if (key == '7') {
      tree.setNewTargetBranches(700); 
   }
   
   if (key == '8') {
      tree.setNewTargetBranches(800); 
   }
   
   if (key == '9') {
      tree.setNewTargetBranches(900); 
   }
   
   if (key == '0') {
      tree.setNewTargetBranches(1000); 
   }
   
   if (key == 'g') {
     // Create a new grass.  
     Tree grass = new Tree();
     grassField.add(grass);
   }
   
   // Update Easing Idx using Left and Right arrows. 
   if (key == LEFT) {
     
   }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //println(theOscMessage.get(0).intValue()); // Capture button state. 
  //println(theOscMessage.get(1).intValue()); // Sensor val.
}

void createGrass() {
  if (grassField != null) {
    for (int i = 0; i < grassField.size(); i++) {
      Tree grass = grassField.get(i);
      grass.draw();
    }
  }
}