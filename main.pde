import java.util.*;

// cell state
// 0 : null
// 1 : flag
// 2 : num
// 3 : mine
PImage FlagImg;
PImage MineImg;
PImage BgImage;

PImage Num1;
PImage Num2;
PImage Num3;
PImage Num4;
PImage Num5;
PImage Num6;
PImage Num7;
PImage Num8;

int res = 50;
int  rows = height/res;

class Cell {
  int state = 0;
  int pos;
  boolean flagged = false;
  Cell(int state, int pos) {
     this.state = state;
     this.pos = pos;
  }
  
  boolean isMine() {return this.state == 3;}
  
  PImage getImage() {
    switch(this.state) {
      case -1 :
        return BgImage;
      case 0 :
      return this.getNumImage();
       case 1 :
         return FlagImg;
       case 2:
         return this.getNumImage();
       case 3:
         return MineImg;
    }
    return null;
  }

  PImage getNumImage() {

    int neighNum = this.checkNeighboringMines();
    switch( neighNum) {
      case 1:
      return Num1;
      case 2:
      return Num2;
      case 3:
      return Num3;
      case 4:
      return Num4;
      case 5:
      return Num5;
      case 6:
      return Num6;
      case 7:
      return Num7;
      case 8:
      return Num8;
      case 0:
      return BgImage;

    }
    return null;
  }

  ArrayList<Cell> getNeighbours() {
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    int x = this.pos / res;
    int y = this.pos % res;
    for(int i = -1; i <= 1; i++){
      for(int j = -1; j <= 1; j++){
        if(i == 0 && j == 0){
          continue;
        }
        int xIndex = x + i;
        int yIndex = y + j;

        if (xIndex*res+yIndex <= res*res && 0 <= xIndex*res+yIndex){
          neighbors.add(cells.get(xIndex*res+yIndex));
        }

      }
    }
    return neighbors;
  }

  int checkNeighboringMines() {
    int count = 0;
    ArrayList<Cell> neighs = getNeighbours();
    for (Cell c : neighs) {
      if (c.isMine()) {count++;}
    }
     return count ;
  }

  void clearNeighbors() {

    int x = this.pos / res;
    int y = this.pos % res;

    int randX = (int) random(3);
    int randY = (int) random(3);

    for(int i = -1 * randX; i <= randX; i++){
      for(int j = -1 * randY; j <= randY; j++){
        int xIndex = x + i;
        int yIndex = y + j;

        if (xIndex*res+yIndex <= res*res && 0 <= xIndex*res+yIndex){

          if ((i == randX || i == -1 * randX || j == randY || j == -1 * randY  )&& !cells.get(xIndex*res+yIndex).isMine()) {
            image(cells.get(xIndex*res+yIndex).getImage(), xIndex * res, yIndex*res, res, res);
          } else {
          cells.get(xIndex*res+yIndex).setState(-1);
          image(cells.get(xIndex*res+yIndex).getImage(), xIndex * res, yIndex*res, res, res);
          }


        }

      }
    }
  }

  int getState() {return this.state;}

  void setState(int state) {this.state = state;}
}



ArrayList<Cell> cells = new ArrayList<Cell>();
int MinesCount = 0;


int rand() {
  if(random(1) < .7){
    return 0;
  }
  else{
    MinesCount++;
    return 3;
  }
}


void setup() {
  size(600, 600);

  // Initialize columns and rows
  rows = height/res;

  FlagImg = loadImage("./assets/flag.png");
  MineImg = loadImage("./assets/mine.png");
  BgImage = loadImage("./assets/bg.png");

  Num1 = loadImage("./assets/1.jpg");
  Num2 = loadImage("./assets/2.jpg");
  Num3 = loadImage("./assets/3.jpg");
  Num4 = loadImage("./assets/4.jpg");
  Num5 = loadImage("./assets/5.jpg");
  Num6 = loadImage("./assets/6.jpg");
  Num7 = loadImage("./assets/7.jpg");
  Num8 = loadImage("./assets/8.jpg");
  
  for ( int i = 0; i < res*res; i++){
    cells.add(new Cell(rand(), i));
  }
  
  for (int i = 0; i < rows; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      // Scaling up to draw a rectangle at (x,y)
      int x = i*res;
      int y = j*res;
      Cell current = cells.get(i*res + j);
      if ( current.getState() == 0) {
        fill(255);
      } else {
        image(current.getImage(), x,y,res,res);
      }
      stroke(0);
 
      rect(x, y, res, res);
    }
  }

}

void draw() {


}

boolean First = true;
boolean Stop = false;

void clear() {

  for (int i = 0; i < rows; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      // Scaling up to draw a rectangle at (x,y)
      int x = i*res;
      int y = j*res;
      stroke(255);
      fill(255);
      rect(x, y, res, res);
    }
  }
}

void showMines() {
  for (int i = 0; i < rows; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      int x = i*res;
      int y = j*res;
      Cell current = cells.get(i*res + j);
      if ( current.isMine()) {
        image(current.getImage(), x,y,res,res);
      }
    }
  }
}

int tries = 0;
boolean win = true;

void mouseClicked() {
  if (Stop) {
    return;
  }
  int x = (int) mouseX / res;
  int y = (int) mouseY / res;
  Cell current = cells.get(x*res+y);
  

  if (First) {
    First = false;
    current.clearNeighbors();
  }

  // reveal
  if (mouseButton == LEFT) {
    if (current.isMine()) {
      Stop = true;
      clear();
      showMines();
      fill(0);
      textSize(100);
      text("You Lose!", 50, height/2);
      fill(0);
      return;
    }

    image(current.getImage(), x*res, y*res, res,res);
    return;
  }

  tries++;
  if (current.getState() != -1 ) {
    current.flagged = true;
    image(FlagImg, x*res,y*res,res,res);
  }

  if (tries == MinesCount) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < rows; j++) {

        x = i*res;
        y = j*res;
        current = cells.get(i*res + j);
        if (current.isMine()) {
          win = win && current.flagged;
        }

      }
    }

    if (win) {
      Stop = true;
      clear();
      showMines();
      fill(0);
      textSize(100);
      text("You Win!", 50, height/2);
      fill(0);
      return;
    }
  }


}
