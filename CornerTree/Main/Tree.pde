class Tree {
   ArrayList<Branch> branches; 
   float yOff = 0.1;
   boolean isNoise = false;
   
   // Initial number of target branches.  
   int targetBranches = 10;
   
   // 
   int maxChildren = 4; 
   int minChildren = 1; 
   
   // Constructor
   Tree() {
      print("Tree constructor: " + "\n");
      // Select a random height and startX position for this tree.
      //int treeHeight = (int) random(40, 75); 
      // For a field.
      //int startX = (int) random (3, width - 3);
      
      // Array of branches for this tree. 
      branches = new ArrayList();
      color c = color(255,255,255);
      
      // A branch has a starting location, a starting "velocity", and a starting "timer" 
      Branch b = new Branch(new PVector(width, height),new PVector(-2.0, -2.0), 100, c); // Use 150 for Mac Mini.
      
      // Initial root branch. 
      b.isRoot = true;
      
      // Add to branches
      branches.add(b);
      
      targetBranches--;
   }
   
   void draw() {
      //if (isNoise) {
      //   yOff += 0.05;
      //}
      
      // [Update Logic] 
      // Have I reached my target branches? Split the branches
      // if I haven't already reached my target. This is the update
      // logic that keeps running. 
      if (targetBranches != 0) {
         split();
      } 
      
      // Animate and draw branches. 
      for (int i = 0; i < branches.size(); i++) {
        // Get the branch, update and draw it. 
        Branch b =  branches.get(i);
        // Always render, every branch.
        b.render();
      }
      
      // [Perlin disabled currently. Come back and fix it.  Constrain the lengths and 
      // check flailer example from openFrameworks to see the 
      // applysPerlin();
   }

   void split() {
      // Go through the tree and check if there is a non-animating branch that we 
      // can split. If we can, then create a random number of branches at random
      // angles from there.
      // We only want split
      for (int i = 0; i < branches.size(); i++) {
         Branch b = branches.get(i);
            
         // Branch shouldn't be animating. 
         // Max children this branch can have are 3. 
         if (!b.isAnimating && b.numChildren < maxChildren) {   
          // Calculate the max rand value based on the current 
          // number of children. 
          int maxRandVal = maxChildren - b.numChildren;
          int n = (int) random(minChildren, maxRandVal); 
          // Calculate the new target branches. 
          targetBranches = targetBranches - n;
   
          // We don't want to create more than target branches. So we reset 
          // n if target branches are negative. And set targetBranches to 0.
          if (targetBranches < 0) {
            n = n + targetBranches; 
            targetBranches = 0;
          }
          
            // We are about to split this, so it's not a child anymore. 
            b.isChild = false;
            
            // Begin the split.
            for (int j=0; j < n; j++) {
              color c = color(255, 255, 255);
              Branch newB = b.branch(random(-45, 45), c);
              branches.add(newB);
            }
            
            // Increment the number of children this branch has. 
            b.numChildren = b.numChildren + n;
         }
      }
      
      print("Number of branches : " + branches.size() + "\n");
   }
   
   void clear() {
      branches.clear(); 
   }
   
   void setNewTargetBranches(int num) {
     targetBranches = num;
   }
   
   // Maybe this should be in branch.
   // Apply perline noise to branch angles.
   void applyPerlin() { 
      // Track non-animating count
      int nonAnimating = 0;
      for (int i=0; i < branches.size(); i++) {
        Branch b = branches.get(i);
        if (!b.isAnimating) {
          nonAnimating++;
        }
      }
      
      // Is something animating? No, apply perlin.
      if (nonAnimating == branches.size()) {
        isNoise = true;
        // We can apply perlin noise. 
        for (int i=0; i < branches.size(); i++) {
          if (!branches.get(i).isRoot) {
            Branch b = branches.get(i);
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
}