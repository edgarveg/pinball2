class Pair {
  Particle p1;
  Box p2;
  float len;
  Pair(float x, float y, Particle p1_, Box p2_) {
    len = 32;
    p1 = p1_;
    p2 = p2_;
    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = p1.body;
    djd.bodyB = p2.body;
    djd.length = box2d.scalarPixelsToWorld(len);
    djd.frequencyHz = 3; 
    djd.dampingRatio = 0.1; 
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
  }
  void display() {
    stroke(0);
    strokeWeight(2);
    p1.display();
    p2.display();
  }
}

//

class Particle {
  Body body;
  float r;
  Particle(float x, float y) {
    r = 8;
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.STATIC;
    body = box2d.world.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
  }
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(127);
    noStroke();
    strokeWeight(2);
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}

//

class Spring {
  MouseJoint mouseJoint;
  Spring() {
    mouseJoint = null;
  }
  void update(float x, float y) {
    if (mouseJoint != null) {
      // Always convert to world coordinates!
      Vec2 mouseWorld = box2d.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }
  void display() {
    if (mouseJoint != null) {
      Vec2 v1 = new Vec2(0,0);
      mouseJoint.getAnchorA(v1);
      Vec2 v2 = new Vec2(0,0);
      mouseJoint.getAnchorB(v2);
      v1 = box2d.coordWorldToPixels(v1);
      v2 = box2d.coordWorldToPixels(v2);
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }
  void bind(float x, float y, Box box) {
    MouseJointDef md = new MouseJointDef();
    md.bodyA = box2d.getGroundBody();
    md.bodyB = box.body;
    Vec2 mp = box2d.coordPixelsToWorld(x,y);
    md.target.set(mp);
    md.maxForce = 1000.0 * box.body.m_mass;
    md.frequencyHz = 5.0;
    md.dampingRatio = 0.9;
    mouseJoint = (MouseJoint) box2d.world.createJoint(md);
  }

  void destroy() {
    if (mouseJoint != null) {
      box2d.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }

}
