class Tree {
   ArrayList<Branch> branches; 
   float yOff = 0.1;
   boolean isNoise = false;
   
   // Initial number of target branches.  
   int targetBranches = 5;
   
   // Max/Min children off a branch. 
   int maxChildren = 4; 
   int minChildren = 1; 
   
   // Constructor
   Tree() {      
      // Array of branches for this tree. 
      branches = new ArrayList();
      color c = color(255,255,255);
      
      // A branch has a starting location, a starting "velocity", and a starting "timer" 
      Branch b = new Branch(new PVector(width/2, height),new PVector(0, -2.0), 100, c, 9.0); // Use 200, 30 for Mac Mini.
      
      // Initial root branch. 
      b.isRoot = true;
      
      // Add to branches
      branches.add(b);
      
      // Subtract from target branches. 
      targetBranches--;
   }
   
   void draw() {
       noCursor();
      
      // [Update Logic] 
      //applyPerlin();
      
      // Have I reached my target branches? Split the branches
      // if I haven't already reached my target. This is the update
      // logic that keeps running. 
      if (targetBranches != 0) {
         split();
      } 
      
      
      if (applyPerlin) {
        // We pass the root to this and iterate through all the children. 
        drawBranch(branches.get(0));
      } else {
        // Animate and draw branches. 
        for (int i = 0; i < branches.size(); i++) {
          // Get the branch, update and draw it. 
          Branch b =  branches.get(i);
          // Always render, every branch.
          b.render();
        }
      }
   }
   

   void drawBranch(Branch b) {
      translate(b.start.x, b.start.y);
      recursiveDraw(b);
   }
   
   
   void recursiveDraw(Branch b) {
     b.render();
      
     if (showGrid) {
      drawGrid(80, 80, 10);
     }
      
     // Draw all the children. 
     for (int i = 0; i < b.children.size(); i++) {
      pushMatrix();   
        float length = b.timer * b.vel.mag();
        translate(0, -length);
        Branch curChildBranch = b.children.get(i);
        rotate(curChildBranch.vel.heading2D() + PI/2);
        recursiveDraw(curChildBranch);
      popMatrix();
     }
   }
  
  void drawGrid(float gWidth, float gHeight, float size)
  {
    pushStyle();
    noFill();
    stroke(color(255, 60));
    
    for (int x = 0; x < gWidth; x += size)
    {
        line(x, 0, x, gHeight);
    }
  
    for (int y = 0; y < gHeight; y += size)
    {
        line(0, y, gWidth, y);
    }
  
    rect(0, 0, gWidth, gHeight);
  
    stroke(color(0, 255, 0));
    line(0, 0, gWidth / 2, 0);
  
    stroke(color(255, 0, 0));
    line(0, 0, 0, gHeight / 2);
  
    popStyle();
  }

   void split() {
      
      // Make sure all the branches have animated before splitting. 
      if (areBranchesAnimating()) {
         return; 
      }
      
      // Go through the tree and check if there is a non-animating branch that we 
      // can split. If we can, then create a random number of branches at random
      // angles from there.
      for (int i = 0; i < branches.size(); i++) {
         Branch b = branches.get(i);
         
         float nextChildLength = b.timerstart * 0.66 * b.vel.mag();
         
         // Branch shouldn't be animating. 
         // Max children this branch can have are 3. 
         if (!b.isAnimating && b.numChildren < maxChildren && nextChildLength > 25) {  
           
           //print("Next child's length " + nextChildLength + "\n");
           
          // Calculate the max rand value based on the current 
          // number of children. 
          int maxRandVal = maxChildren - b.numChildren;
          
          int n = (int) random(minChildren, maxRandVal); 
          
          // Calculate the new target branches. 
          targetBranches = targetBranches - n;
   
          // We don't want to create more than target branches. So we reset 
          // n if target branches are negative. And set targetBranches to 0.
          if (targetBranches < 0) {
            // Reset n.
            n = n + targetBranches; 
            targetBranches = 0;
          }
          
            // We are about to split this, so it's not a child anymore. 
            b.isChild = false;
            
            // Begin the split.
            for (int j=0; j < n; j++) {
              color c = color(255, 255, 255);
              Branch newB = b.branch(random(-60, 60), c);
              branches.add(newB);
              b.children.add(newB);
            }
            
            // Increment the number of children this branch has. 
            b.numChildren = b.numChildren + n;
         }
      }
      
      //print("Number of branches : " + branches.size() + "\n");
   }
   
   boolean areBranchesAnimating() {
     for (int i = 0; i < branches.size(); i++) {
       Branch b = branches.get(i);
       if (b.isAnimating) {
         return true; 
       }
     }
     
     return false;
   }
   
   void clear() {
      branches.clear(); 
   }
   
   void setNewTargetBranches(int num) {
     targetBranches = num;
   }
   
   // Return the number of branches. 
   int getNumBranches() {
      return branches.size(); 
   }
   
   // Maybe this should be in branch.
   // Apply perline noise to branch angles.
   //void applyPerlin() { 
   //   // Track non-animating count
   //   int nonAnimating = 0;
   //   for (int i=0; i < branches.size(); i++) {
   //     Branch b = branches.get(i);
   //     if (!b.isAnimating) {
   //       nonAnimating++;
   //     }
   //   }
      
   //   // Is something animating? No, apply perlin.
   //   if (nonAnimating == branches.size()) {
   //     isNoise = true;
   //     // We can apply perlin noise. 
   //     for (int i=0; i < branches.size(); i++) {
   //       if (!branches.get(i).isRoot) {
   //         Branch b = branches.get(i);
   //         float oldTheta = b.vel.heading2D();
   //         float newTheta = map(noise(i, yOff+i), 0, 1, oldTheta - PI/4, oldTheta + PI/4);
   //         // Calculate length
   //         float mag = (PVector.sub(b.end, b.start)).mag();
   //         // calculate new end vertex 
   //         b.end.x = mag*cos(newTheta); b.end.y = mag*sin(newTheta);
   //       }
   //     }
   //   } else {
   //      isNoise = false; 
   //   }
   // }
}