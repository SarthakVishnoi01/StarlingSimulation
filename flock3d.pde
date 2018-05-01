/*Main runner area
* Matt Wetmore
* Changelog
* ---------
* 12/14/09: Started work
* 12/18/09: Reimplemented with BoidList class
*/


int initBoidNum = 500; //amount of boids to start the program with
BoidList flock1 = new BoidList(500,0);//,flock2,flock3;
float zoom=-50;
boolean smoothEdges = false;
boolean avoidWalls = true;
//boolean stop = true;
float angleX = 0, angleY = 0, angleZ = 0;
//float dirX = 0, dirY =0;
float zoom_add = 0.0f;
String show ="Number of birds are: ";
float a=500,b=350;
//int count =0;

//As no external force is applied so total momentum of the system remains constant.
void draw()
{
  //image(img,0,0);
  //clear screen
  //beginCamera();
  //camera(1000,0,1000,0,0,0,0,1,0);
  //rotateX(map(mouseY,0,height,0,TWO_PI));
  //rotateY(map(mouseX,width,0,0,TWO_PI));

  //rotateZ(angleZ);
  
  /*
  if(mousePressed == true){
    a = mouseX;
    b = mouseY;

    System.out.print("X coordinate of current position of mouse is: " + a);
    System.out.println("Y coordinated of position of mouse is: " + b);
  }
  */
  //background(img);
  translate(500,350,0);
  pushMatrix();
  background(0);
  translate(0,0,zoom);
  rotateX(angleX);
  rotateY(angleY);
  //endCamera();
  
  //directionalLight(255,255,255, 0, 1, -100); 
  //noFill();
  //stroke(0);
  
  //line(0,0,0,width,0,0);
  //line(0,0,0,0,height,0);
  //line(width,0,0,width,height,0);
  //line(width,height,0,0,height,0);

  //line(0,0,100,  0,height,100);
  //line(0,0,1200,  0,height,1200);
  //line(0,0,100,  width,0,100);
  //line(0,0,1200,  width,0,1200);
  
  //line(width,0,100,  width,height,100);
  //line(width,0,1200,  width,height,1200);
  //line(0,height,100,  width,height,100);
  //line(0,height,1200,  width,height,1200);
  
  //line(0,0,100,  0,0,1200);
  //line(0,height,100,  0,height,1200);
  //line(width,0,100,  width,0,1200);
  //line(width,height,100,  width,height,1200);
  
  flock1.run(avoidWalls);
  System.out.println(frameRate);
  //System.out.println("Height: "+height);
  //System.out.println("Width: "+width);
  //System.out.println(flock1.boids.get(0).pos.x);
  //System.out.println(flock1.boids.get(0).pos.y);
  //System.out.println(flock1.boids.get(0).pos.z);
  //System.out.println();

  /*GUI Crap*/
  textSize(20);
  drawAxes();
  popMatrix();
  fill(255);
  drawGUI();

}

void keyPressed()
{
  switch(keyCode){
    case UP:    angleX = angleX + (PI/10.0); break;
    case DOWN:  angleX = angleX - (PI/10.0); break;
    case RIGHT: angleY = angleY + (PI/10.0); break;
    case LEFT:  angleY = angleY - (PI/10.0); break;
  }
  switch (key)
  {
    case 's': smoothEdges = !smoothEdges; break;
    case 'a': avoidWalls = !avoidWalls; break;
  //  case 'g': stop = !stop; break;
  //  case 'o': zoom-=zoom_add*50; break; //zoom out
  //  case 'i': zoom+=zoom_add*50; break; // zoom in
  //  case 'x': angleX = angleX + (PI/10.0); break;
  //  case 'y': angleY = angleY + (PI/10.0); break;
  //  case 'z': angleZ = angleZ + (PI/10.0); break;
  //  case 'b': angleX = angleX - (PI/10.0); break;
  //  case 'n': angleY = angleY - (PI/10.0); break;
  //  case 'm': angleZ = angleZ - (PI/10.0); break;
    case 'p': flock1.add(); break;
  }
}

void mouseWheel (MouseEvent event){
    zoom_add = event.getCount();
    zoom = zoom + zoom_add * 50;
}

void drawGUI(){
  textSize(20);
  //text("YOLO", 500,300,0);
  String whatGoesOnScreen = show + flock1.boids.size();
  //System.out.println(whatGoesOnScreen);
  text(whatGoesOnScreen, -600, 480, 0);
  PVector a = getMomentum();
  String mom = "Total momentum of the flock is: (" + a.x + ", " + a.y + ", " + a.z + ") m/s ";
  text(mom,-600,520,0);
  float k = getKE();
  String ke = "Total Kinetic Energy of the flock is: " + k + " kg*m/s^2";
  text(ke,-600,560,0);
}

void drawAxes() {
  stroke(255, 0, 0);
  line(-500, 0, 0, 500, 0, 0);
  text("+x", 530, 0, 0);
  text("-x", -530, 0, 0);
  stroke(0, 255, 0);
  line(0, -350, 0, 0, 350, 0);
  text("+y", 0, 380, 0);
  text("-y", 0, -380, 0);
  stroke(0, 0, 255);
  line(0, 0, -300, 0, 0, 300);
  text("+z", 0, 0, 330);
  text("-z", 0, 0, -300);
}

PVector getMomentum(){
  PVector momentum = new PVector(0,0,0);
  for(int i=0; i<flock1.boids.size(); i++){
    momentum.add(flock1.boids.get(i).mom);
  }
  return momentum;
}

float getKE(){
  float kE =0.0;
  for(int i=0; i<flock1.boids.size(); i++)
    kE = kE + flock1.boids.get(i).kineticEnergy;
  return kE;
}
