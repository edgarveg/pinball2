class Box 
{
  Body body;
  float w;
  float h;
  Box(float x_, float y_, float width_, float height_) {
    float x = x_;
    float y = y_;
    w = width_;
    h = height_; 
    makeBody(new Vec2(x,y),w,h);
    body.setUserData(this);
  }
  void killBody() {
    box2d.destroyBody(body);
  }
  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(255);
    noStroke();
    strokeWeight(1);
    rect(0,0,45,60);
    popMatrix();
  }
  void makeBody(Vec2 center, float w_, float h_) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    body.createFixture(fd);
  }
}

//

class choque {
  float x;
  float y;
  float w;
  float h;
  Body b;
  choque(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    b.createFixture(sd,1);
  }
  void display() {
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(x,y,w,h);
  }
}

//

class Pinball{
  Body body;
  float rad;
  boolean active;
  color col;
  Pinball(float x, float y, float r) {
    rad = r;
    makeBody(x,y,r);
    body.setUserData(this); 
    col = color(251,227,55);
  }
  void killBody() {
    box2d.destroyBody(body);
  }
  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+rad*2) {
      killBody();
      return true;
    }
    return false;
  }
  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    fill(col);
    strokeWeight(1);
    noStroke();
    rotate(a);
    ellipse(0,0,rad*2,rad*2);
    popMatrix();
  }
  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    bd.bullet = true;
    body = box2d.world.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(rad);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = .7;
    body.createFixture(fd);
    body.setAngularVelocity(random(-10, 10));
  }
  void change() {
    col = color(random(0,255),random(0,255), random(0,255)); 
  }
}

//

class regreso
{
 ArrayList<Vec2> points;
    regreso()
    {
    points = new ArrayList<Vec2>();
    float theta = 0;
    float count = 5;
    points.add(new Vec2(width-2,height));
    while (radians(theta) > (-PI))
    {
      points.add(new Vec2(width/2+(width/2)*cos(radians(theta)),200+200*sin(radians(theta))));
      theta -= count;
    }
    points.add(new Vec2(0, height - 100));
    ChainShape c = new ChainShape();
    Vec2[] v = new Vec2[points.size()];
    for(int i=0;i < v.length; ++i)
    {
      v[i] = box2d.coordPixelsToWorld(points.get(i));
    }
    c.createChain(v,v.length); 
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    body.createFixture(c, 1);
  }
}
