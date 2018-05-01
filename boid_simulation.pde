import peasy.*;
PImage img;
PeasyCam cam;
/*Boid object class
* Matt Wetmore
* Changelog
* ---------
* 12/14/09: Started work
* 12/16/09: Revised code to work with forces instead of heading. First steering algorithm implemented
* 12/18/09: Arrival steering behavior
* 12/20/09: Alignment added NEED TO FIX COHESION
* 1/6/10: Finished algorithms. Time to clean up the code!
*/

void setup()
{
  size(1000,700,P3D);
  frameRate(60);
  //Peasy Cam
  //cam = new PeasyCam(this, 100);
  //cam.setMinimumDistance(5);
  //cam.setMaximumDistance(500);  
  //create and fill the list of boids
  camera(500,350,1000,500,350,0,0,1,0);
  flock1 = new BoidList(initBoidNum,255);
  img = loadImage("sky.jpg");
  img.resize(1000,700);
  //background(img);
  background(0);
  //flock2 = new BoidList(100,255);
  //flock3 = new BoidList(100,128);
}


class Boid
{
  //fields
  PVector pos,vel,acc,ali,coh,sep; //pos, velocity, and acceleration in a vector datatype
  float neighborhoodRadius; //radius in which it looks for fellow boids
  float maxSpeed = 4; //maximum magnitude for the velocity vector
  float maxSteerForce = .06; //maximum magnitude of the steering vector
  float h; //hue
  //float sc=3; //scale factor for the render of the boid
  //float flap = 0;
  //float t=0;
  boolean avoidWalls = true;
  //float horizontal = 1000;
  //float vertical =700;
  float shade = random (255);
  PVector mom; //momentum of that particular boid
  float kineticEnergy; 
  ArrayList<Boid> friends;
  float mass = random(0.058,0.10); //Mass between 58 grams to 100 grams according to wikipedia
  
  //constructors
  Boid(PVector inPos)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector(random(-1,1),random(-1,1),random(1,-1));
    float multiplier = mass * frameRate;
    mom = PVector.mult(vel,multiplier);
    float multiplierHash = vel.magSq();
    kineticEnergy = 0.5 * mass * multiplierHash * (frameRate) * (frameRate);
    //vel = new PVector(0,0,0);
    acc = new PVector(0,0,0);
    neighborhoodRadius = 50;
    friends = new ArrayList<Boid>();
  }
  /*
  Boid(PVector inPos,PVector inVel,float r)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector();
    vel.set(inVel);
    acc = new PVector(0,0);
    neighborhoodRadius = r;
  }
  */
  
  void run(ArrayList bl)
  {
    //bl is arrayList of boids
    //t+=.1;
    //flap = 10*sin(t);
    //acc.add(steer(new PVector(mouseX,mouseY,300),true));
    //acc.add(new PVector(0,.05,0));
    if(avoidWalls)
    {
      acc.add(PVector.mult(avoid(new PVector(pos.x,350,pos.z),true),5));
      acc.add(PVector.mult(avoid(new PVector(pos.x,-350,pos.z),true),5));
      acc.add(PVector.mult(avoid(new PVector(500,pos.y,pos.z),true),5));
      acc.add(PVector.mult(avoid(new PVector(-500,pos.y,pos.z),true),5));
      acc.add(PVector.mult(avoid(new PVector(pos.x,pos.y,-200),true),5));
      acc.add(PVector.mult(avoid(new PVector(pos.x,pos.y,200),true),5));
    }
    else
    	checkBounds();
    flock(bl);
    move();
    render();
    getFriends(bl);
  }
  
  /////-----------behaviors---------------
  void flock(ArrayList bl)
  {
    ali = alignment(bl);
    coh = cohesion(bl);
    sep = seperation(bl);
    //Adding after taking their weights
    acc.add(PVector.mult(ali,2));
    acc.add(PVector.mult(coh,3));
    acc.add(PVector.mult(sep,2));
  }
  
  void move()
  {
    vel.add(acc); //add acceleration to velocity
    vel.limit(maxSpeed); //make sure the velocity vector magnitude does not exceed maxSpeed
    pos.add(vel); //add velocity to position
    acc.mult(0); //reset acceleration
    //System.out.println(vel.x +" "+ vel.y +" "+ vel.z);
    shade += getAverageColor() * 0.3;
    //shade += (random(2) - 1) ;
    //shade = (shade + 255) % 255; //max(0, min(255, shade));
  }

  void getFriends (ArrayList<Boid> bl) {
    ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (int i =0; i < bl.size(); i++) {
      Boid test = bl.get(i);
      if (test == this) continue;
      if (abs(test.pos.x - this.pos.x) < neighborhoodRadius && abs(test.pos.y - this.pos.y) < neighborhoodRadius && abs(test.pos.z - this.pos.z) < neighborhoodRadius) {
        nearby.add(test);
      }
    }
    friends = nearby;
  }

  float getAverageColor () {
    float total = 0;
    float count = 0;
    for(int i=0; i<friends.size(); i++){
      if (friends.get(i).shade - shade < -128) {
        total += friends.get(i).shade + 255 - shade;
      } else if (friends.get(i).shade - shade > 128) {
        total += friends.get(i).shade - 255 - shade;
      } else {
        total += friends.get(i).shade - shade; 
      }
      count++;
    }
    /*
    for (Boid other : friends) {
      if (other.shade - shade < -128) {
        total += other.shade + 255 - shade;
      } else if (other.shade - shade > 128) {
        total += other.shade - 255 - shade;
      } else {
        total += other.shade - shade; 
      }
      count++;
    }
    */
    if (count == 0) return 0;
    return total / (float) count;
  }
  
  void checkBounds()
  {
    if(pos.x>500) pos.x=-500;
    if(pos.x<-500) pos.x=500;
    if(pos.y>350) pos.y=-350;
    if(pos.y<-350) pos.y=350;
    if(pos.z>200) pos.z=-200;
    if(pos.z<-200) pos.z=200;
  }
  
  void render()
  {
    
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    //rotateY(atan2(-vel.z,vel.x));
    //rotateZ(asin(vel.y/vel.mag()));
    stroke(100);
    //noFill();
    //noStroke();
    fill(shade, 90, 200);
    
    box(10);
    /*Start drawing the bird*/

    popMatrix();
  }
  
  //steering. If arrival==true, the boid slows to meet the target. Credit to Craig Reynolds
  PVector steer(PVector target,boolean arrival)
  {
    PVector steer = new PVector(); //creates vector for steering
    if(!arrival)
    {
      steer.set(PVector.sub(target,pos)); //steering vector points towards target (switch target and pos for avoiding)
      steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    }
    else
    {
      PVector targetOffset = PVector.sub(target,pos);
      float distance=targetOffset.mag();
      float rampedSpeed = maxSpeed*(distance/100);
      float clippedSpeed = min(rampedSpeed,maxSpeed);
      PVector desiredVelocity = PVector.mult(targetOffset,(clippedSpeed/distance));
      steer.set(PVector.sub(desiredVelocity,vel));
    }
    return steer;
  }
  
  //avoid. If weight == true avoidance vector is larger the closer the boid is to the target
  PVector avoid(PVector target,boolean weight)
  {
    //Avoiding walls
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(pos,target)); //steering vector points away from target
    if(weight)
      steer.mult(1/sq(PVector.dist(pos,target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
  
  PVector seperation(ArrayList<Boid> boids)
  {
    PVector posSum = new PVector(0,0,0);
    PVector repulse = new PVector(0, 0, 0);
    for(int i=0;i<boids.size();i++)
    {
      Boid b = boids.get(i);
      float d = PVector.dist(pos,b.pos);
      if((d>0) && (d<=neighborhoodRadius))
      {
        repulse = PVector.sub(pos,b.pos);
        repulse.normalize();
        repulse.div(d);
        posSum.add(repulse);
      }
    }
    return posSum;
  }
  
  PVector alignment(ArrayList<Boid> boids)
  {
    PVector velSum = new PVector(0,0,0);
    int count = 0;
    for(int i=0;i<boids.size();i++)
    {
      Boid b = boids.get(i);
      float d = PVector.dist(pos,b.pos);
      if((d>0) && (d<=neighborhoodRadius))
      {
        velSum.add(b.vel);
        count++;
      }
    }
    if(count>0)
    {
      velSum.div((float)count);
      velSum.limit(maxSteerForce);
    }
    return velSum;
  }
  
  PVector cohesion(ArrayList<Boid> boids)
  {
    PVector posSum = new PVector(0,0,0);
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for(int i=0;i<boids.size();i++)
    {
      Boid b = boids.get(i);
      float d = dist(pos.x,pos.y,b.pos.x,b.pos.y);
      if(d>0 && d<=neighborhoodRadius)
      {
        posSum.add(b.pos);
        count++;
      }
    }
    if(count>0)
    {
      posSum.div((float)count);
    }
    steer = PVector.sub(posSum,pos);
    steer.limit(maxSteerForce); 
    return steer;
  }
}
