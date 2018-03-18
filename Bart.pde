static int drawPress = 0;
static float drawPointX  = 0;
static float drawPointY  = 0;
static int clickcount = 0;
float x1, y1, x2, y2;
float slope = 0;
float greaterX,lessX,greaterY,lessY = 0;
float pointOneX = 0;
float pointOneY = 0;
float pointTwoX = 0;
float pointTwoY = 0;

void setup()
{
  size(900, 900);
  background(255);
  smooth();
  noStroke();
}

void draw()
{
  //color of the background
  float ellipseposX   = width/4; 
  float ellipseposY   = height/4; 

  if (drawPress == 0){
    noStroke();
    //constrain movement in y direction
    float test = constrain(mouseY, 0 , 360);
    float multp     = 95; 
    pointOneX = ellipseposX + (cos(radians(90-test)) * multp);
    pointOneY = ellipseposY + (sin(radians(90-test)) * multp);
    pointTwoX = ellipseposX + (cos(radians(110-test)) * multp);
    pointTwoY = ellipseposY + (sin(radians(110-test)) * multp);
    fill(20,111,219,200);
    ellipse(ellipseposX, ellipseposY, 200, 200);
    fill(0);
    ellipse(ellipseposX, ellipseposY, 190, 190);
    fill(155,50,67);
    fill(20,111,219,200);
    triangle(ellipseposX, ellipseposY, pointOneX, pointOneY, pointTwoX, pointTwoY);
    fill(0);
    ellipse(ellipseposX, ellipseposY, 130, 130);
    fill(20,220,67,150);

    //find the larger of the two points
    if(pointOneX > pointTwoX){
       greaterX = pointOneX;
       lessX = pointTwoX;
    }else {
       greaterX = pointTwoX;
       lessX = pointOneX;
    }
    
    if(pointOneY > pointTwoY) {
      greaterY = pointOneY;
      lessY = pointTwoY;
    }else {
      greaterY = pointTwoY;
      lessY = pointOneY;
    }
    
    //find the slope of the line for drawing
    slope = (ellipseposY - (greaterY - ((greaterY-lessY)/2)))/ (ellipseposX - (greaterX - ((greaterX-lessX)/2)));
    fill(176);
    
    //print relevant measurements
    text("pointOneX = " + pointOneX, 160, 185+20);
    text("pointTwoX = " + pointTwoX, 160, 200+20);
    text("pointOneY = " + pointOneY, 160, 215+20);
    text("pointTwoY = " + pointTwoY, 160, 230+20);
    text("slope = " + slope, 160, 245+20);
  }
  else
  {
    stroke(0);
    line(x1,y1,x2,y2);
  }
}

void mouseDragged(){
  x2 = mouseX;
  y2 = (x2-x1)*slope+y1;
}

void mousePressed(){
  x1 = mouseX;
  y1 = mouseY;
  x2 = x1;
  y2 = y1;
  if (drawPress == 1)
    drawPress = 0;
  else 
    drawPress = 1;
}
