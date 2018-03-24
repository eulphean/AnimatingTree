class Tree {
   ArrayList<Branch> branches; 
   float yOff = 0.1;
   
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
      Branch b = new Branch(new PVector(width/2, height),new PVector(0, -2.0), 120, c, 9.0); // Use 200, 30 for Mac Mini.
      
      // Initial root branch. 
      b.isRoot = true;
      
      // Add to branches
      branches.add(b);
      
      // Subtract from target branches. 
      targetBranches--;
   }
   
   void draw() { 
      // Add noise to the angles. 
      applyPerlin();
      
      // Have I reached my target branches? Split the branches
      // if I haven't already reached my target. This is the update
      // logic that keeps running. 
      if (targetBranches != 0) {
         split();
      }
      
      if (isPerlinMode) {
        // We pass the root to this and iterate through all the children. 
        pushMatrix();
          Branch rootBranch = branches.get(0);
          translate(rootBranch.start.x, rootBranch.start.y);
          recursiveDraw(rootBranch);
        popMatrix();
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
   
   void recursiveDraw(Branch b) {
     b.render();
   
     // Draw all the children. 
     for (int i = 0; i < b.children.size(); i++) {
      pushMatrix();   
        float length = b.timer * b.vel.mag();
        
        translate(0, -length);
        
        Branch curChildBranch = b.children.get(i);
        float prevHeading = b.vel.heading();
        
        // [NOTE] Very important. 
        // Update curChildBranch's start position to previous position's end. 
        curChildBranch.start.x = b.xEnd;
        curChildBranch.start.y = b.yEnd;
       
        // New heading is actually a sum of previous + currentHeading. 
        // Check Branch() where we add previous heading to randomly generate angle
        // to calculate the new direction. Similarly, here we need to do that. 
        rotate(curChildBranch.vel.heading() - prevHeading); 
        
        recursiveDraw(curChildBranch);
      popMatrix();
     }
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
      
      print("Target branches : " + targetBranches + "\n");
      print("Number of branches : " + branches.size() + "\n");
   }
   
   // Return the number of branches. 
   int getNumBranches() {
      return branches.size(); 
   }
   
   // Apply noise to each branch of the tree. 
   void applyPerlin() { 
      // Track non-animating count
     if (targetBranches!=0 || areBranchesAnimating()) {
       isPerlinMode = false;
       return;
     }
      
      // Else go through each branch and add some noise to 
      // each branch. 
      for (int i=1; i < branches.size(); i++) {
          Branch curBranch = branches.get(i);
          Branch prevBranch = branches.get(i-1);
          
          float currentHeading = curBranch.vel.heading();
         
          float noiseOffset = random(-0.01, 0.01);
          // New heading woth noise.
          float noiseHeading = currentHeading + noiseOffset;
          
          // Calculate new velocity vector based on this updated angle.
          float mag = curBranch.vel.mag();
          PVector newVel = new PVector(mag*cos(noiseHeading),mag*sin(noiseHeading)); 
          curBranch.vel = newVel.copy();
          
          // Update xEnd and yEnd for this branch based on the current velocity. 
          // We will update the start position of the current branch from it's parent
          // in the recursive method. That's really crucial, else it'll branches will
          // keep breaking.
          float length = curBranch.timer * mag;
          curBranch.xEnd = (curBranch.start.x + length * cos(newVel.heading())) ; 
          curBranch.yEnd = (curBranch.start.y + length * sin(newVel.heading()));
      }
      
      isPerlinMode = true; 
    }
    
   // Secondary helpers.    
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
}