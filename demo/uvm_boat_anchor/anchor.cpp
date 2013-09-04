#include <iostream>
#include <string>
#include <stdlib.h>
#include <ncurses.h>
#include <time.h>
#include <signal.h>
#include <queue>

using namespace std;

const int BOTTOM = 5;
const int TRAVEL = 66;

int draw(int, int);
void wait (float);
void sig_handler(int);

struct ascii_out_t
{
  string sky[6] = {
                   "                                                      * ** ** ** *   \n",
                   "                                                     * *  *  *  * ** \n",
                   "                                                     *   *  *  *  *  \n",
                   "                                                      *** ** ** **   \n",
                   "                                                                     \n",
                   "                                                                     \n"
                  };

  string boat[10] = {
                   "                                                     .             \n",
                   "                                                    /|\\           \n",
                   "                                                   / | \\          \n",
                   "                                                  /  |  \\         \n",
                   "                                                 /   |   \\        \n",
                   "                                                /    |    \\       \n",
                   "                                               /     |     \\      \n",
                   "                                              /      |      \\     \n",
                   "                                             ._______|_______.     \n",
                   "                                      `--.___________|___________  \n"
                  };

  string water[2] = {
                     "___     ___     ____    ____      ____     ___    ___    ___    ___    ___\n",
                     "   \\___/   \\___/    \\__/    \\____/    \\___/   \\__/   \\__/   \\__/   \\__/   \\__\n"
                    };

  string chain = "                                                |\n";

  string anchor[11] = {
                   "                                      /\\        O        /\\  \n",
                   "                                      | \\      / \\      / |  \n",
                   "                                      |  \\     | |     /  |   \n",
                   "                                      | |\\\\    | |    //| |  \n",
                   "                                      | | \\\\   | |   // | |  \n",
                   "                                      \\ \\  '   | |   '  / /  \n",
                   "                                       \\ \\     | |     / /   \n",
                   "                                        \\ \\    | |    / /    \n",
                   "                                         \\ '---^ ^---' /      \n",
                   "                                          \\   U V M   /       \n",
                   "                                          '-----^-----'        \n"
                  };
  string bottom = "/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\n";

  string updatedWater[2];

  queue<string> fullDrawing;

  void updateWater(int distance) {
    for (int i=0; i<2; i++) updatedWater[i] = water[i];

    if (distance <= 64) updatedWater[0][64-distance] = '/';
    if (distance <= 43) updatedWater[0][43-distance] = '\\';

    if (distance <= 64)
      if (updatedWater[1][63-distance] == '_') updatedWater[1][63-distance] = '/';
    if (distance <= 43)
      if (updatedWater[1][44-distance] == '_') updatedWater[1][44-distance] = '\\';
  }

  void buildAll(int distance, int chainLength) {
    for (int i=0; i<6; i++) {
      fullDrawing.push(sky[i]);
    }
   
    for (int i=0; i<10; i++) {
      fullDrawing.push(boat[i].substr(distance).c_str());
    }
   
    updateWater(distance);
    for (int i=0; i<2; i++) {
      fullDrawing.push(updatedWater[i]);
    }

    for (int i=0; i<chainLength; i+=1) {
      fullDrawing.push(chain.c_str());
    }

    if (chainLength > 0) {
      for (int i=0; i<11; i+=1) {
        fullDrawing.push(anchor[i].c_str());
      }
    }

    if (chainLength == BOTTOM) fullDrawing.push(bottom.c_str());
  }

  void makeItRain(int length) {
    
  }

  void drawAll() {
    while (!fullDrawing.empty()) {
      addstr(fullDrawing.front().c_str());
      fullDrawing.pop();
    }
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
    clear();

    buildAll(0, BOTTOM);
    makeItRain(50);
    drawAll();

    refresh();
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



int main() {
  struct sigaction act;

  // signal handling to return the endwin()
  act.sa_handler = sig_handler;
  sigemptyset(&act.sa_mask);
  act.sa_flags = 0;
  sigaction(SIGINT, &act, 0);

  initscr();

  ascii_out.sailIn();

  ascii_out.startRaining();

  ascii_out.sailOut();

  endwin();

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
