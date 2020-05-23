class obstaculos
{
  Body body;

  float rad;
  obstaculos(float x, float y, float r) {
    rad = r;
    makeBody(x,y,r);
    body.setUserData(this); 
  }
  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    noStroke();
    rotate(a);
    fill(255,255,0);
    ellipse (0,0,rad,rad);
    popMatrix();
  }
  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.STATIC;
    bd.bullet = true;
    body = box2d.world.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(rad);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = .99;
    body.createFixture(fd);
  }
}

//

class palancas
{
  Body body;
  Body anchor;
  RevoluteJoint joint;
  float speed;
  float jointRadius;
  float endRadius;
  float flipperLength;
  float posSlope;
  float negSlope;
  float rectLength;
  float rectWidth;
  Vec2 upperDisp;
  Vec2 lowerDisp;
  palancas(float pX, float pY, float pSpeed, float pLowerAngle, float pUpperAngle, boolean pLeft, float r1, float r2, float flen)
  {
    jointRadius = r1; 
    endRadius = r2; 
    flipperLength = flen; 
    makeBody(new Vec2(pX, pY), pLeft);
    body.setUserData(this); 
    if(pLeft)
    {
      speed = pSpeed;
    }
    else
    {
      speed = -pSpeed; 
    }
    RevoluteJointDef rjd = new RevoluteJointDef();
    rjd.initialize(body, anchor, body.getPosition());
    rjd.motorSpeed = speed;
    rjd.maxMotorTorque = 200000.0;
    rjd.enableMotor = true;
    rjd.lowerAngle = pLowerAngle;
    rjd.upperAngle = pUpperAngle;
    rjd.enableLimit = true;
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }
  void makeBody(Vec2 center, boolean left)
  {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    CircleShape jointCircle = new CircleShape();
    jointCircle.m_radius = box2d.scalarPixelsToWorld(jointRadius);
    CircleShape endCircle = new CircleShape();
    endCircle.m_radius = box2d.scalarPixelsToWorld(endRadius);
    Vec2 endCircleOffset = new Vec2(0, flipperLength);
    endCircleOffset = box2d.vectorPixelsToWorld(endCircleOffset);
    endCircle.m_p.set(endCircleOffset);
    posSlope = atan((jointRadius - endRadius)/flipperLength);
    negSlope = -posSlope;
    rectLength = sqrt(flipperLength * flipperLength + sq(jointRadius - endRadius));
    rectWidth = (endRadius / (cos(posSlope)));
    upperDisp = new Vec2(jointRadius / 2, flipperLength / 2);
    lowerDisp = new Vec2(-(jointRadius / 2), flipperLength / 2);
    PolygonShape upperRect = new PolygonShape();
    upperRect.setAsBox(box2d.scalarPixelsToWorld(rectWidth) / 2,box2d.scalarPixelsToWorld(rectLength) / 2,box2d.vectorPixelsToWorld(upperDisp),negSlope);
    PolygonShape lowerRect = new PolygonShape();
    lowerRect.setAsBox(box2d.scalarPixelsToWorld(rectWidth) / 2,box2d.scalarPixelsToWorld(rectLength) / 2,box2d.vectorPixelsToWorld(lowerDisp),posSlope);
    body.createFixture(jointCircle, 1.0);
    body.createFixture(endCircle, 1.0);
    body.createFixture(upperRect, 1.0);
    body.createFixture(lowerRect, 1.0);
    Vec2 pos = body.getPosition();
    float angle = body.getAngle();
    if(left)
    {
      body.setTransform(pos, angle + HALF_PI);
    }
    else
    {
      body.setTransform(pos, angle - HALF_PI);
    }
    BodyDef abd = new BodyDef();
    abd.type = BodyType.STATIC;
    abd.position.set(box2d.coordPixelsToWorld(center));
    anchor = box2d.createBody(abd);
    PolygonShape anchBod = new PolygonShape();
    anchBod.setAsBox(box2d.scalarPixelsToWorld(1), box2d.scalarPixelsToWorld(1));
    anchor.createFixture(anchBod, 1.0);
  }
  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    fill(247,244,38);
    noStroke();
    strokeWeight(1);
    rectMode(CENTER);
    ellipseMode(RADIUS);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    ellipse(0,0,jointRadius, jointRadius);
    popMatrix();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    rotate(negSlope);
    rect(0,40,rectWidth, rectLength);
    popMatrix(); 
  }
  void reverseSpeed()
  {
    speed *= -1;
    joint.setMotorSpeed(speed);
  }
}
