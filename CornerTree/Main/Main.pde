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

// Compute max and minimum sensor val
// Map this difference to the number of branches. 
int maxSensorVal = -9999; 
int minSensorVal = 9999;
long delayBeforeUpdate = -1;

// OSC handler for processing.
OscP5 oscHandler;

// Random seeds.
int randomSeed = 5; 
int noiseSeed = 0;

int maxTreeSize = 20000; 

boolean isPerlinMode = false;

void setup() {
  frameRate(25);
  
  randomSeed(randomSeed);
  noiseSeed(noiseSeed);
  
  // Initialize animation engine.
  Ani.init(this);
  
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
  
  // Hide cursor when drawing.
  noCursor();
  

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
   
   if (key == 'p') {
      isPerlinMode = !isPerlinMode;
   }
}

void oscEvent(OscMessage theOscMessage) {
  int captureButtonState = theOscMessage.get(0).intValue(); 
  
  // Only care about the values when it's high. 
  if (captureButtonState == 1) {
    int sensorVal = theOscMessage.get(1).intValue();
    if (sensorVal > maxSensorVal) {
       maxSensorVal = sensorVal; 
    }
    
    if (sensorVal < minSensorVal) {
       minSensorVal = sensorVal; 
    }
  }
  
  // When are we ready to update the tree? 
  if (captureButtonState == 0 && maxSensorVal != -9999 && minSensorVal != 9999) {
    if (delayBeforeUpdate == -1) {
      // Store the current second.
      delayBeforeUpdate = millis();
    }

    // That means user has left the button and we are ready to map the difference 
    // to the number of branches. 
    int diff = maxSensorVal - minSensorVal;
    
    int newBranchesToGrow = 0; 
    
    // Check current number of branches, then change the map values for newBranchesToGrow
    // Range is 500, 1200, and beyond. If that's the size of the current number of branches, 
    // then grow new branches accordingly. 
    if (tree.getNumBranches() < 500) {
        // Send this data to the tree after a delay or however. 
        newBranchesToGrow = (int) map(diff, 0, 50, 0, 500);
        newBranchesToGrow = constrain(newBranchesToGrow, 0, 500);
    } else if (tree.getNumBranches() < 1200) {
        newBranchesToGrow = (int) map(diff, 0, 50, 200, 500);
        newBranchesToGrow = constrain(newBranchesToGrow, 200, 500);
    } else {
        newBranchesToGrow = (int) map(diff, 0, 50, 800, 1500); 
        newBranchesToGrow = constrain(newBranchesToGrow, 800, 500);
    }
    
    print("Differences, newBranchesToGrow: " + diff + ", " + newBranchesToGrow + "\n");
    
    if (newBranchesToGrow < 75) {
         // Reset and return.
         delayBeforeUpdate = -1;
        
        // Reset maxSensorVal and minSensorVal.
        maxSensorVal = -9999;
        minSensorVal = 9999;
       return; 
    }
    
    long currentSecond = millis();
    
    //print ("Delay, CurrentSecond: " + delayBeforeUpdate + ", " + currentSecond + "\n");
    
    // We will wait for 1 second before updating the tree.
    if (currentSecond - delayBeforeUpdate > 1000) {
        print("MinSensorVal, MaxSensorVal, Diff, NewBranchesToGrow : " + minSensorVal + ", " + maxSensorVal + ", " + diff + ", " + newBranchesToGrow + "\n");
        
        tree.setNewTargetBranches(newBranchesToGrow);
        
        delayBeforeUpdate = -1;
        
        // Reset maxSensorVal and minSensorVal.
        maxSensorVal = -9999;
        minSensorVal = 9999;
    }
  }
}

void createGrass() {
  if (grassField != null) {
    for (int i = 0; i < grassField.size(); i++) {
      Tree grass = grassField.get(i);
      grass.draw();
    }
  }
}