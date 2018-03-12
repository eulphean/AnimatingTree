// Recursive branching "structure" without an explicitly recursive function
// Instead we have an ArrayList to hold onto N number of elements
// For every element in the ArrayList, we add 2 more elements, etc. (this is the recursion)

// An arraylist that will keep track of all current branches
ArrayList<Tree> grassField;

void setup() {
  //size(200,200);
  fullScreen();
  background(0);
  smooth();  
  grassField = new ArrayList();
}

void draw() {
  // Try erasing the background to see how it works
  background(0);
  
  if (grassField != null) {
    for (int i = 0; i < grassField.size(); i++) {
      Tree grass = grassField.get(i);
      grass.draw();
    }
  }
}

void keyPressed() {
   // Reset. 
   if (key == 'r') {
     grassField.clear();
   }
   
   // Split.
   if (key == 's') {
     // Split a random grass into subgrass. 
     int randIdx = (int) random(0, grassField.size());
     Tree grass = grassField.get(randIdx);
     grass.split();
   }
   
   if (key == 'g') {
     // Create a new grass.  
     Tree grass = new Tree();
     grassField.add(grass);
   }
}