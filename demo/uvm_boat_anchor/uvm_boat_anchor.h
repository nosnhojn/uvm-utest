#include <iostream>
#include <string>
#include <stdlib.h>
#include <ncurses.h>
#include <time.h>
#include <signal.h>
#include <list>

using namespace std;

const int BOTTOM = 2;
const int TRAVEL = 66;

class uvm_boat_anchor {
  private: 
    list<string> sky;
    list<string> boat;
    list<string> water;
    list<string> updatedWater;
    list<string> chain;
    list<string> anchor;
    list<string> bottom;
    WINDOW * myWin;

    list<string> fullDrawing;
    list<string>::iterator fullDrawingIt;

    void updateWater(int);
    void buildAll(int, int);
    void makeItRain(int, int);
    void drawAll();

  public:
    uvm_boat_anchor();
    void setWindow(WINDOW*);
    void startingScene();
    void sailIn();
    void startRaining();
    void sailOut();
    void finalScene();
    void wait (float);
};
