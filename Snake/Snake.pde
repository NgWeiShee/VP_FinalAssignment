import gifAnimation.*;

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Gif animation;

AudioPlayer player;
Minim minim;//audio context

AudioPlayer player2;
Minim minim2;

int num=80;


color col= color(15,71,103);
color foodColor= color(255,0,0);
float speed = 100;
int cx, cy;

int len;
int moveX = 0;
int moveY = 0;
int snakeX = 0;
int snakeY = 0;
int foodX = -1;
int foodY = -1;
boolean check = true;
int []snakesX;
int []snakesY;
int snakeSize = 1;
boolean gameOver = false;
PFont Font = createFont("Gunplay3D-Regular",40, true);
PFont sFont= createFont("Impact",22,true);
int score= 0;
int highscore=0;

PImage imgA;
float [] ellipseSize;
float [] x;
float [] y;
 
float [] velocityX;
float [] velocityY;

void setup(){    
  size(680,480);
  smooth();
  imgA= loadImage("fish.png");
  initArrays();
  initValues ();
   
  background(198,219,255);
  speed = 200;
  speed=speed/frameRate;
  snakesX = new int[100];
  snakesY = new int[100];
  
  minim = new Minim(this);
      player = minim.loadFile("snakeo.mp3");
      player.loop();
      
  animation= new Gif(this, "gameover.gif");
  animation.play();

  
 
  
  cx = width/2;
  cy = height/2;
   
  snakeX = cx-5;
  snakeY = cy-5;
  foodX = -1;
  foodY = -1;
  gameOver = false;
  check = true;
  snakeSize =1;
}
  
void draw(){
  if(speed%10 == 0){
    background(198,219,255);
     displayEllipse ();
     moveEllipse ();
     checkEdges ();  
    runGame();
  }
  speed++;
}  

void checkEdges ()
{
  int i = 0;
  while (i < num)
  {
 
    if (x [i] < ellipseSize [i] / 2)
    {
      x [i] = ellipseSize [i] / 2;
      velocityX [i] = velocityX [i] * -1;
    }
    else if (x [i] > width- ellipseSize [i] / 2)
    {
      x [i] = width- ellipseSize [i] / 2;
      velocityX [i] = velocityX [i] * -1;
    }
 
    if (y [i] < ellipseSize [i] / 2)
    {
      y [i] = ellipseSize [i] / 2;
      velocityY [i] = velocityY [i] * -1;
    }
    else if (y [i] > height- ellipseSize [i] / 2)
    {
      y [i] = height- ellipseSize [i] / 2;
      velocityY [i] = velocityY [i]* -1;
    }
 
    i = i + 1;
  }
}
 
void initArrays ()
{
  ellipseSize = new float [num];
 
  x = new float [num];
  y = new float [num];
 
  velocityX = new float [num];
  velocityY = new float [num];
}
 
void initValues ()
{
  int i = 0;
  while (i < num)
  {
 
    ellipseSize [i] = random (5, 20);
 
    x [i] = random (width);
    y [i] = random (height);
 
    velocityX [i] = random (-2, 2);
    velocityY [i] = random (-2, 2);
    i = i +1;
  }
}
 
void moveEllipse ()
{
  int i = 0;
  while (i < num)
  {
    x [i] = x [i] + velocityX [i]; 
    y [i] = y [i] + velocityY [i];
 
    i = i +1;
  }
}
 
void displayEllipse ()
{
 
  int i = 0;
  while (i < num)
  {
    float colorValue = map (ellipseSize [i], 5, 20, 0, 1);
    color c = lerpColor (#ffedbc, #57385c, colorValue);
    color strokeColor = lerpColor (#D3EFFF, #AEDDFA, 1-colorValue);
 
    noFill();
    stroke (strokeColor);
 
    ellipse (x [i], y [i], ellipseSize [i], ellipseSize [i]);
 
    i = i +1;
  }
}


void runGame(){
  if(gameOver== false){
    drawScoreboard();
    drawfood();
    drawSnake();
    snakeMove();
    ateFood();
    checkHitSelf();
  }else{
    background(0);
      minim2 = new Minim(this);
        player2 = minim2.loadFile("ending.mp3");
        player2.play();
        
      image(animation,90,30); 
      fill(255);
      textAlign(CENTER);
      textFont(Font);
      text("G.A.M.E O.V.E.R", width/2, 250);
      textFont(sFont);
      textSize(22);
      text("Press ENTER to Retry", width/2,280);
        
      player.close();
      minim.stop();
      
       
  }
}
  

void drawScoreboard(){
  textFont(sFont);
  textSize(20);
  textAlign(CENTER);
  fill(242,252,252);
  text("Score: "+score,550,80);
  text("HighScore: "+highscore,550,110);
  
   
}

void checkHitSelf(){
   for(int i = 1; i < snakeSize; i++){
       if(snakeX == snakesX[i] && snakeY== snakesY[i]){
          gameOver = true;
      }
   } 
}


void ateFood(){
  if(foodX == snakeX && foodY == snakeY){
     check = true;
     snakeSize++;
     score++;
     speed++;
   }
     if(score> highscore){
       highscore=score;
}
}
void drawfood(){
  image(imgA,foodX-5,foodY-5,15,15);
  fill(255,50);
  stroke(255,150);
  ellipse(foodX,foodY,30,30);
  fill(167,240,196);
 
  
  while(check){
    int x = (int)random(1,680/10);
    int y =  (int)random(1,480/10);
    foodX = 5+x*10;
    foodY = 5+y*10;
     
    for(int i = 0; i < snakeSize; i++){
       if(x == snakesX[i] && y == snakesY[i]){
         check = true;
         i = snakeSize;
       }else{
         check = false;
       }
    }
     
  }
   
     
}
void drawSnake(){
  
 
  for(int i = 0; i < snakeSize; i++) {
    int X = snakesX[i];
    int Y = snakesY[i];
    fill(col);
    rect(X-5,Y-5,10,10);
  }
   
  for(int i = snakeSize; i > 0; i--){
    snakesX[i] = snakesX[i-1];
    snakesY[i] = snakesY[i-1];
  }
}
 
void snakeMove(){
  snakeX += moveX;
  snakeY += moveY;
  if(snakeX > width-5 || snakeX < 5||snakeY > height-5||snakeY < 5){
     gameOver = true;
  }
  snakesX[0] = snakeX;
  snakesY[0] = snakeY;
   
}

void reset(){
  snakeX = cx-5;
  snakeY = cy-5;
  gameOver = false;
  check = true;
  snakeSize =1;
  moveY = 0;
  moveX = 0;
  score = 0;
      minim = new Minim(this);
      player = minim.loadFile("snakeo.mp3");
      player.loop();
         }
  
void keyPressed() {
  if(keyCode == UP) {  if(snakesY[1] != snakesY[0]-10){moveY = -10; moveX = 0;}}
  if(keyCode == DOWN) {  if(snakesY[1] != snakesY[0]+10){moveY = 10; moveX = 0;}}
  if(keyCode == LEFT) { if(snakesX[1] != snakesX[0]-10){moveX = -10; moveY = 0;}}
  if(keyCode == RIGHT) { if(snakesX[1] != snakesX[0]+10){moveX = 10; moveY = 0;}}
  if(keyCode == ENTER) {reset();
                        }
  if(keyCode == ' '){
       noLoop();
        fill(255);
        textAlign(CENTER);
        textFont(sFont);
        textSize(70);
        text("..Pause..",width/2,220);
        textSize(18);
        text("Press R to Resume", width/2,250);
        fill(55,0,0);
        rect(600,600,0,0); 
        
      }
      else if(key =='r' || key =='R'){loop();}
}


