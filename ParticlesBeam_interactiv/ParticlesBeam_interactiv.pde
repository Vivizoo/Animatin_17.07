import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

int num = 20000;
Particle[] particles = new Particle[num];
float noiseScale = 800, noiseStrength = 3;

float mood = 0;

color particleColor = color(200);

void setup() {
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
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
  //println(mood);
  update();
}

void update() {
  float percentX = 0.0;
  float percentY = 0.0;
  
  
  if (mood == 0.1){
    percentX = 90;
    percentY = 10;
    println("sad");
  } else if (mood == 0.2){
    percentX = 50;
    percentY = 50;
    println("happy");
  } else if (mood == 0.3){
    percentX = 90;
    percentY = 90;
    println("neutral");
  } else if (mood == 0.4){
    percentX = 10;
    percentY = 10;
    println("angry");
  } else if (mood == 0.5){
    percentX = 10;
    percentY = 90;
    println("fear");
  } else if (mood == 0.6){
    percentX = 10;
    percentY = 50;
    println("disgust");
  } else if (mood == 0.7){
    percentX = 50;
    percentY = 20;
    println("surprise");
  }
  
  

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


void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("f")) { //Now looking for 2 parameters
        mood = theOscMessage.get(0).floatValue();
        //println(theOscMessage.get(0).floatValue());

        //Now use these params
        
        //println("Received new params value from Wekinator");  
      } else {
        println("Error: unexpected params type tag received by Processing");
      }
 }
}
