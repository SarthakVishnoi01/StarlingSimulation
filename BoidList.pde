/*BoidList object class
* Matt Wetmore
* Changelog
* ---------
* 12/18/09: Started work
*/

class BoidList
{
  ArrayList<Boid> boids; //will hold the boids in this BoidList
  float h; //for color
  
  BoidList(int n,float ih)
  {
    boids = new ArrayList<Boid>();
    h = ih;
    for(int i=0;i<n;i++)
      boids.add(new Boid(new PVector(0,0,0)));
  }
  
  void add()
  {
    boids.add(new Boid(new PVector(random(-500,500), random(-350,350), random(-200,200))));
  }
  
  void addBoid(Boid b)
  {
    boids.add(b);
  }
  
  void run(boolean aW)
  {
    for(int i=0;i<boids.size();i++) //iterate through the list of boids
    {
      Boid tempBoid = boids.get(i); //create a temporary boid to process and make it the current boid in the list
      tempBoid.h = h;
      tempBoid.avoidWalls = aW;
      tempBoid.run(boids); //tell the temporary boid to execute its run method
    }
  }
}