class Tree {
   ArrayList<Branch> branches; 
   
   float yOff = 0.0;
   
   // Initial number of target branches.  
   int targetBranches = 2;
   
   // Max/Min children off a branch. 
   int maxChildren = 4; 
   int minChildren = 1; 
   
   // Constructor
   Tree() {      
      // Array of branches for this tree. 
      branches = new ArrayList();
      color c = color(164, 255, 66);
      
      // A branch has a starting location, a starting "velocity", and a starting "timer" 
      Branch b = new Branch(new PVector(width, height),new PVector(-3.0, -2.0), 140, c, 25); // Use 200, 30 for Mac Mini.
      
      // Initial root branch. 
      b.isRoot = true;
      
      // Add to branches
      branches.add(b);

      // Subtract from target branches. 
      targetBranches--;
   }
   
   void draw() { 
      // Define the condition for enabling/disabling perlin noise.
      // This is done by setting isPerlinMode to true/false.
      if (targetBranches!=0 || areBranchesAnimating()) {
        yOff = 0.0;
        isPerlinMode = false;
      } else {
        isPerlinMode = true;
      }
      
      if (isPerlinMode) {
        yOff += -0.009;
        
        // Add perlin noise
        Branch branch = branches.get(0);
        applyPerlin(branch, 0.0);
      }
      
      // Have I reached my target branches? Split the branches
      // if I haven't already reached my target. This is the update
      // logic that keeps running. 
      if (targetBranches > 0) {
         split();
      } else {
         // Reset target branches.
         targetBranches = 0;  
      }
      
      // Draw logic. 
      if (isPerlinMode) {
        // We pass the root to this and iterate through all the children. 
        pushMatrix();
          Branch rootBranch = branches.get(0);
          translate(rootBranch.start.x, rootBranch.start.y);
          rotate(PI/2 + rootBranch.vel.heading());
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
   
   void applyPerlin(Branch b, float xOff) {   
     xOff += -0.002;
     // Go through children
     for (int i = 0; i < b.children.size(); i++) {
       
       Branch curChild = b.children.get(i);
       
       float currentHeading = curChild.vel.heading();
           
       float mag = curChild.vel.mag();
       float length = curChild.timer * mag;

       // Calculate noise.        
       float angle = map(length, 0, 400, 3, 1);
       angle = constrain(angle, 1, 3);
       float minAngle = radians(angle);
       float noiseOffset = map(noise(xOff + i, yOff + i), 0, 1, -minAngle/50, minAngle/50);
       noiseOffset = constrain(noiseOffset, -minAngle/50, minAngle/50);
       
       // New heading with noise.
       float noiseHeading = currentHeading + noiseOffset;
        
       // Calculate new velocity vector based on this updated angle.
       PVector newVel = new PVector(mag*cos(noiseHeading),mag*sin(noiseHeading)); 
       curChild.vel = newVel.copy();
        
       // Update xEnd and yEnd for this branch based on the current velocity. 
       // We will update the start position of the current branch from it's parent
       // in the recursive method. That's really crucial, else it'll branches will
       // keep breaking.
       curChild.xEnd = (curChild.start.x + length * cos(newVel.heading())) ; 
       curChild.yEnd = (curChild.start.y + length * sin(newVel.heading()));
      
       applyPerlin(curChild, xOff);
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
        
        // [NOTE] Very important. Since, we can't update the start position
        // in the for loop, we have to do it in this recursive loop, where there
        // is a clear relation between parent and child branches. 
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
          //if (targetBranches < 0) {
          //  // Reset n.
          //  n = n + targetBranches; 
          //  targetBranches = 0;
          //}
          
            // We are about to split this, so it's not a child anymore. 
            b.isChild = false;
            
            // Begin the split.
            for (int j=0; j < n; j++) {
              Branch newB = b.branch(random(-60, 60), b.branchColor);
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
