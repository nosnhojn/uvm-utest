#include "uvm_boat_anchor.h"

void uvm_boat_anchor::setWindow(WINDOW* win) {
  myWin = win;
}

uvm_boat_anchor::uvm_boat_anchor() {
  sky.push_back("                                                       *** ** ** ** * *** **     \n");
  sky.push_back("                                                      * * *  *  *  * * * *  *    \n");
  sky.push_back("                                                      ***   *  *  *  *  *   *    \n");
  sky.push_back("                                                       ***** ** ** ** ** ***     \n");
  sky.push_back("                                                                                 \n");
  sky.push_back("                                                                                 \n");

  boat.push_back("                                                     .                          \n");
  boat.push_back("                                                    /|\\                         \n");
  boat.push_back("                                                   / | \\                        \n");
  boat.push_back("                                                  /  |  \\                       \n");
  boat.push_back("                                                 /   |   \\                      \n");
  boat.push_back("                                                /    |    \\                     \n");
  boat.push_back("                                               /     |UVM- \\                    \n");
  boat.push_back("                                              /      |UTEST \\                   \n");
  boat.push_back("                                             ._______|_______.                  \n");
  boat.push_back("                                      `--.___________|___________               \n");

  water.push_back("___     ___     ____    ____      ____     ___    ___    ___    ___    ___\n");
  water.push_back("   \\___/   \\___/    \\__/    \\____/    \\___/   \\__/   \\__/   \\__/   \\__/   \\__\n");

  chain.push_back("                                                |\n");

  anchor.push_back("                                      /\\        O        /\\  \n");
  anchor.push_back("                                      | \\      / \\      / |  \n");
  anchor.push_back("                                      |  \\     | |     /  |   \n");
  anchor.push_back("                                      | |\\\\    | |    //| |  \n");
  anchor.push_back("                                      | | \\\\   | |   // | |  \n");
  anchor.push_back("                                      \\ \\  '   | |   '  / /  \n");
  anchor.push_back("                                       \\ \\     | |     / /   \n");
  anchor.push_back("                                        \\ \\    | |    / /    \n");
  anchor.push_back("                                         \\ '---^ ^---' /      \n");
  anchor.push_back("                                          \\   U V M   /       \n");
  anchor.push_back("                                          '-----^-----'        \n");

  bottom.push_back("/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\n");
}

void uvm_boat_anchor::updateWater(int distance) {
  updatedWater = list<string>(water);
  list<string>::iterator it = updatedWater.begin();

  if (distance <= 64) (*it)[64-distance] = '/';
  if (distance <= 43) (*it)[43-distance] = '\\';

  ++it;
  if (distance <= 64)
    if ((*it)[63-distance] == '_') (*it)[63-distance] = '/';
  if (distance <= 43)
    if ((*it)[44-distance] == '_') (*it)[44-distance] = '\\';
}

void uvm_boat_anchor::buildAll(int distance, int chainLength) {
  fullDrawing.insert(fullDrawing.end(), sky.begin(), sky.end());
 
  list<string>::iterator it;
  it = boat.begin();
  for (int i=0; i<10; i++) {
    fullDrawing.push_back((*it).substr(distance).c_str());
    it++;
  }

  updateWater(distance);
  fullDrawing.insert(fullDrawing.end(), updatedWater.begin(), updatedWater.end());
  if (chainLength > 0) {
    for (int i=0; i<chainLength; i++) fullDrawing.insert(fullDrawing.end(), chain.begin(), chain.end());
    fullDrawing.insert(fullDrawing.end(), anchor.begin(), anchor.end());
  }
  if (chainLength == BOTTOM) fullDrawing.insert(fullDrawing.end(), bottom.begin(), bottom.end());
}


void uvm_boat_anchor::makeItRain(int i, int total) {
  int j=0;

  fullDrawingIt = fullDrawing.begin();
  while (j<17) {
    fullDrawingIt++;
    j++;

    if (j >= 4) {
      if ((j-i+total-4) % 3 == 0) {
        (*fullDrawingIt)[53-(j-4)] = '/';
        (*fullDrawingIt)[55-(j-4)] = '/';
        (*fullDrawingIt)[57-(j-4)] = '/';
        (*fullDrawingIt)[59-(j-4)] = '/';
        (*fullDrawingIt)[61-(j-4)] = '/';
        (*fullDrawingIt)[63-(j-4)] = '/';
        (*fullDrawingIt)[65-(j-4)] = '/';
        (*fullDrawingIt)[67-(j-4)] = '/';
        (*fullDrawingIt)[69-(j-4)] = '/';
        (*fullDrawingIt)[71-(j-4)] = '/';
        (*fullDrawingIt)[73-(j-4)] = '/';
      }
    }
  }
}

void uvm_boat_anchor::drawAll() {
  fullDrawingIt = fullDrawing.begin();
  while (fullDrawingIt != fullDrawing.end()) {
    waddstr(myWin, (*fullDrawingIt).c_str());
    fullDrawingIt++;
  }
  fullDrawing.clear();
}

void uvm_boat_anchor::startingScene() {
  wclear(myWin);

  buildAll(TRAVEL, 0);
  drawAll();

  wrefresh(myWin);
}

void uvm_boat_anchor::sailIn() {
  // boat sails in
  for (int i=TRAVEL; i>=0; i--) {
    wclear(myWin);

    buildAll(i, 0);
    drawAll();

    wrefresh(myWin);
    wait(0.1);
  }

  // anchor goes down
  for (int i=0; i<=BOTTOM; i++) {
    wclear(myWin);

    buildAll(0, i);
    drawAll();

    wrefresh(myWin);
    wait(0.2);
  }

  wait(2);
}

void uvm_boat_anchor::startRaining() {
  for (int i=0; i<=50; i++) {
    wclear(myWin);

    buildAll(0, BOTTOM);
    makeItRain(i, 50);
    drawAll();

    wrefresh(myWin);

    wait(0.2);
  }
}


void uvm_boat_anchor::sailOut() {
  // anchor goes up
  for (int i=BOTTOM; i>=0; i--) {
    wclear(myWin);

    buildAll(0, i);
    drawAll();

    wrefresh(myWin);
    wait(0.2);
  }

  wait(1);

  // boat sails away
  for (int i=0; i<=TRAVEL; i++) {
    wclear(myWin);

    buildAll(i, 0);
    drawAll();

    wrefresh(myWin);
    wait(0.1);
  }

  wait(1);
}


void uvm_boat_anchor::finalScene() {
  sky.clear();
  sky.push_back("              TTTTTTT H   H EEEEEE      EEEEEE N    N DDDD                       \n");
  sky.push_back("                 T    H   H E           E      NN   N D   D                      \n");
  sky.push_back("                 T    HHHHH EEE         EEE    N N  N D    D                     \n");
  sky.push_back("                 T    H   H E           E      N  N N D    D                     \n");
  sky.push_back("                 T    H   H E           E      N   NN D   D                      \n");
  sky.push_back("                 T    H   H EEEEEE      EEEEEE N    N DDDD                       \n");

  boat.clear();
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                            http://www.agilesoc.com/open-source-projects/uvm-utest                  \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");
  boat.push_back("                                                                                                                                                    \n");

  wclear(myWin);

  buildAll(TRAVEL, 0);
  drawAll();

  wrefresh(myWin);
}

void uvm_boat_anchor::wait ( float seconds )
{
  clock_t endwait;
  endwait = clock () + seconds * CLOCKS_PER_SEC ;
  while (clock() < endwait) {}
}

