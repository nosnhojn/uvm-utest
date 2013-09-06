#include "uvm_boat_anchor.h"

struct ascii_out_t
{
  list<string> sky;
  list<string> boat;
  list<string> water;
  list<string> updatedWater;
  list<string> chain;
  list<string> anchor;
  list<string> bottom;

  ascii_out_t() {
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
    boat.push_back("                                               /     |     \\                    \n");
    boat.push_back("                                              /      |      \\                   \n");
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

  list<string> fullDrawing;
  list<string>::iterator fullDrawingIt;

  void updateWater(int distance) {
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

  void buildAll(int distance, int chainLength) {
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


  void makeItRain(int i, int total) {
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

  void drawAll() {
    fullDrawingIt = fullDrawing.begin();
    while (fullDrawingIt != fullDrawing.end()) {
      addstr((*fullDrawingIt).c_str());
      fullDrawingIt++;
    }
    fullDrawing.clear();
  }

  void sailIn() {
    // boat sails in
    for (int i=TRAVEL; i>=0; i--) {
      clear();

      buildAll(i, 0);
      drawAll();

      refresh();
      wait(0.1);
    }

    // anchor goes down
    for (int i=0; i<=BOTTOM; i++) {
      clear();

      buildAll(0, i);
      drawAll();

      refresh();
      wait(0.1);
    }

    wait(2);
  }

  void startRaining() {
    for (int i=0; i<=50; i++) {
      clear();

      buildAll(0, BOTTOM);
      makeItRain(i, 50);
      drawAll();

      refresh();

      wait(0.2);
    }

    wait(2);
  }


  void sailOut() {
    // anchor goes up
    for (int i=BOTTOM; i>=0; i--) {
      clear();

      buildAll(0, i);
      drawAll();

      refresh();
      wait(0.1);
    }

    wait(1);

    // boat sails away
    for (int i=0; i<=TRAVEL; i++) {
      clear();

      buildAll(i, 0);
      drawAll();

      refresh();
      wait(0.1);
    }

    wait(1);
  }
} ascii_out;


struct sigaction act;
void c_setup()
{
  act.sa_handler = sig_handler;
  sigemptyset(&act.sa_mask);
  act.sa_flags = 0;
  sigaction(SIGINT, &act, 0);
  initscr();
}

void c_sailIn() {
  ascii_out.sailIn();
}

void c_build() {
  ascii_out.buildAll(0, 0);
  ascii_out.drawAll();
}

void c_startRaining() {
  ascii_out.startRaining();
}

void c_sailOut() {
  ascii_out.sailOut();
}

void c_teardown() {
  endwin();
}

int main() {
  c_setup();

  c_sailIn();

  c_startRaining();

  c_sailOut();

  c_teardown();
}

void sig_handler (int sig)
{
  endwin();
  exit(1);
}


void wait ( float seconds )
{
  clock_t endwait;
  endwait = clock () + seconds * CLOCKS_PER_SEC ;
  while (clock() < endwait) {}
}
