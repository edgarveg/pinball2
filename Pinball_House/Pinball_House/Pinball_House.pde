import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import ddf.minim.*;
Box2DProcessing  box2d;
AudioPlayer[] player = new AudioPlayer[1]; 
Minim minim;
PImage calv;
PFont font;
int lives = 3;
palancas pl;
palancas pr;
Spring spring;
ArrayList<Pair> pairs;
ArrayList<choque> bumpers;
ArrayList<obstaculos> obs;
regreso a;
Pinball pb;
boolean lp;
boolean rp; 
int Panto;
Pantallas primera, segunda;
class Particula{ 
  float x,y;
  float dx,dy;
  float r;
  color c;
  Particula(float x_, float y_, float r_, color c_){
    x = x_;
    y = y_;
    dx = random(-1,1);
    dy = random(-1,1);
    r = r_;
    c = c_;
  }
  void display(){
    noStroke();
    fill(c);
    ellipse(x,y,r*2,r*2);
  }
  void mover(){
    x+=dx;
    y+=dy;
    if(x<0+r || x>width-r){
      dx *=-1;
    }
    if(y<0+r || y>height-r){
      dy *=-1;
    }
  }
}
ArrayList<Particula> particulas;
void setup()
{
  size(400, 600);
  box2d = new Box2DProcessing (this);
  box2d.createWorld();  
  box2d.listenForCollisions();  
  box2d.setGravity(0, -25);
 
  calv= loadImage ("calv.png");
  a = new regreso();
  pb = new Pinball(380, height - 220, 8);
  bumpers = new ArrayList<choque>();
  pairs = new ArrayList<Pair>();
  obs = new ArrayList<obstaculos>();
  Pair p = new Pair(width,height/2, new Particle(width+15, height-200), new Box(width-10, height-200, 30, 30));
  pairs.add(p);
  bumpers.add(new choque(375, height, 60, 250));
  bumpers.add(new choque(350, height, 15, 700));
  minim = new Minim(this);
  pr = new palancas(250 + 20, 550, 25, -QUARTER_PI/2, QUARTER_PI, false, 15, 10, 90);
  pl = new palancas(200 - 130,550, 25, -QUARTER_PI/2 - radians(15), QUARTER_PI - radians(20), true, 15, 10, 90);
  player[0] = minim.loadFile("pinball.mp3");  
  player[0].play(); 
  player[0].loop();
  spring = new Spring();
  obstaculos o1 = new  obstaculos(10, 40, 60);
  obstaculos o2 = new  obstaculos(390, 40, 60);
  obstaculos o3 = new  obstaculos(195, 50, 25);
  obstaculos o4 = new  obstaculos(50, 200, 30);
  obstaculos o5 = new  obstaculos(300, 200, 30);
  obstaculos o6 = new  obstaculos(75, 300, 20);
  obstaculos o7 = new  obstaculos(175, 300, 20);
  obstaculos o8 = new  obstaculos(275, 300, 20);
  obstaculos o9 = new  obstaculos(125, 375, 20);
  obstaculos o10 = new obstaculos(225, 375, 20);
  obstaculos o11 = new obstaculos(315, 425, 30);
  obstaculos o12 = new obstaculos(25, 425, 30);
  obstaculos o13 = new obstaculos(175, 450, 30);
  obstaculos o14 = new obstaculos(20, 530, 20);
  obstaculos o15 = new obstaculos(315, 530, 20);
  obs.add(o1);
  obs.add(o2);
  obs.add(o3);
  obs.add(o4);
  obs.add(o5);
  obs.add(o6);
  obs.add(o7);
  obs.add(o8);
  obs.add(o9);
  obs.add(o10);
  obs.add(o11);
  obs.add(o12);
  obs.add(o13);
  obs.add(o14);
  obs.add(o15);
  rp = false;
  lp = false;
  font = loadFont("Bauhaus93-48.vlw");
  textFont(font, 24);
  textAlign(CENTER);
  particulas = new ArrayList<Particula>();
  for(int i = 0; i<5; i++){
  color c = color(random(255),random(245),random(255));
  particulas.add(new Particula(random(400),random(400),random(10,50),c));;
  Panto = 1;
  primera = new Pantallas(1);
  segunda= new Pantallas(2);
   }
}
void draw()
{
  background(0); 
   for(Particula p: particulas){
    p.display();
    p.mover();
  }
  switch (Panto)
  {
    case 1:
        primera.DibujodePantalla();
    break;
    case 2:
         segunda.DibujodePantalla();
         }   
}
void mousePressed() 
{  
    if (pairs.get(0).p2.contains(mouseX, mouseY))
    {
    spring.bind(mouseX,mouseY,pairs.get(0).p2);
    }
  color c = color(random(211),random(255),random(255));
  particulas.add(new Particula(mouseX,mouseY,random(10,50),c)); 
}
void keyPressed( )
{
  if(keyCode == RIGHT && rp)
  {
    pr.reverseSpeed();
    pl.reverseSpeed();
    rp = false;
    lp = false;
  }
  if(keyCode == LEFT && lp)
  {
    pl.reverseSpeed();
    pr.reverseSpeed();
    lp = false;
    rp = false;
  }
      if(Panto==1)
  {
    if (key == ENTER)
    {
  Panto++;
  }
  }
}
void keyReleased( )
{
  if(keyCode == RIGHT && rp)
  {
    pr.reverseSpeed();
    pl.reverseSpeed();
    rp = true;
    lp = true;
  }
  if(keyCode == LEFT && lp)
  {
    pl.reverseSpeed();
    pr.reverseSpeed();
    lp = true;
    rp = true;
  }
}
void beginContact(Contact cp)
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if (o1 instanceof obstaculos && o2 instanceof Pinball)
  {
    Pinball p2 = (Pinball) o2;
    p2.change();
    p2.body.applyAngularImpulse(500000);
  }
  if (o1 instanceof Pinball && o2 instanceof obstaculos)
  {
    Pinball p1 = (Pinball) o1;
    p1.change();
    p1.body.applyAngularImpulse(500000);
  }
}
