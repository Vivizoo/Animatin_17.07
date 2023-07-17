int num = 70000;
Particle[] particles = new Particle[num];
float noiseScale = 800, noiseStrength = 3;

color particleColor = color(200);

void setup() {
  size(1900, 900);
  noStroke();

  noiseSeed(3);
  randomSeed(2);

  for (int i = 0; i < num; i++) {
    PVector loc = new PVector(random(width * 1.2), random(height), 1.5);
    float angle = random(TWO_PI);
    PVector dir = new PVector(cos(angle), sin(angle));
    float speed = random(0.8,7);
    particles[i] = new Particle(loc, dir, speed);
  }
}

void draw() {
  fill(0, 10);
  noStroke();
  rect(0, 0, width, height);
  fill(225);

  for (int i = 0; i < particles.length; i++) {
    particles[i].run();
  }
}

void mouseMoved() {
  float percentX = (float) mouseX / width;
  float percentY = (float) mouseY / height;
  float newNoiseScale = map(percentX, 0, 1, 50, 900);//hier
  float newNoiseStrength = map(percentY, 0, 1, 4, 0.7); // hier
  
  
  noiseScale = newNoiseScale;
  noiseStrength = newNoiseStrength;
  
  particleColor = color(percentX * 255, percentY * 255, 0, 40);
  
}

class Particle {
  PVector loc, dir, vel;
  float speed;
  int d = 2; // hier: direction change

  Particle(PVector _loc, PVector _dir, float _speed) {
    loc = _loc;
    dir = _dir;
    speed = _speed;
  }

  void run() {
    move();
    checkEdges();
    update();
  }

  void move() {
    float angle = noise(loc.x / noiseScale, loc.y / noiseScale, frameCount / noiseScale) * TWO_PI * noiseStrength;
    dir.x = cos(angle);
    dir.y = sin(angle);
    vel = dir.get();
    vel.mult(speed * d);
    loc.add(vel);
  }

  void checkEdges() {
    
    float distance = dist(width/2, height/2, loc.x, loc.y);
    if (distance>150) 
  
      if (loc.x<0 || loc.x>width || loc.y<0 || loc.y>height) {    
      loc.x = random(width*1.2);
      loc.y = random(height);
    }
  }

  void update() {
    //fill(#1B2DE3,90);
    fill(#0016F2,90); //hier
    //fill(#2734BF,90);
    ellipse(loc.x, loc.y, loc.z, loc.z);
    
    fill(particleColor);
    ellipse(loc.x, loc.y, loc.z, loc.z);
  }
}
