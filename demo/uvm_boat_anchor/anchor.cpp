#include <iostream>
#include <string>
#include <stdlib.h>
#include <ncurses.h>
#include <time.h>
#include <signal.h>

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

  string updatedWater[2];

  string skyBoatWater[18];

  void updateWater(int distance) {
    for (int i=0; i<2; i++) updatedWater[i] = water[i];

    if (distance <= 64) updatedWater[0][64-distance] = '/';
    if (distance <= 43) updatedWater[0][43-distance] = '\\';

    if (distance <= 64)
      if (updatedWater[1][63-distance] == '_') updatedWater[1][63-distance] = '/';
    if (distance <= 43)
      if (updatedWater[1][44-distance] == '_') updatedWater[1][44-distance] = '\\';
  }

  void drawSkyBoatWater(int distance) {
    for (int i=0; i<6; i++) {
      skyBoatWater[i] = sky[i];
    }
   
    for (int i=0; i<10; i++) {
      skyBoatWater[i+6] = boat[i].substr(distance).c_str();
    }
   
    updateWater(distance);
    for (int i=0; i<2; i++) {
      skyBoatWater[i+16] = updatedWater[i];
    }

    for (int i=0; i<18; i++) {
      addstr(skyBoatWater[i].c_str());
    }
  }

  void drawChain(int chainLength) {
    for (int i=0; i<chainLength; i+=1) {
      addstr("                                                |\n");
    }
  }

  void drawAnchor() {
    addstr("                                      /\\        O        /\\  \n");
    addstr("                                      | \\      / \\      / |  \n");
    addstr("                                      |  \\     | |     /  |   \n");
    addstr("                                      | |\\\\    | |    //| |  \n");
    addstr("                                      | | \\\\   | |   // | |  \n");
    addstr("                                      \\ \\  '   | |   '  / /  \n");
    addstr("                                       \\ \\     | |     / /   \n");
    addstr("                                        \\ \\    | |    / /    \n");
    addstr("                                         \\ '---^ ^---' /      \n");
    addstr("                                          \\   U V M   /       \n");
    addstr("                                          '-----^-----'        \n");
  }

  void drawBottom() {
      addstr("/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\n");
  }

  int draw(int distance, int chainLength) {
      clear();
      drawSkyBoatWater(distance);
      drawChain(chainLength);
      if (chainLength > 0) drawAnchor();
      if (chainLength == BOTTOM) drawBottom();
      refresh();
  }

  void sailIn() {
    // boat sails in
    for (int i=TRAVEL; i>=0; i--) {
      draw(i, 0);
      wait(0.1);
    }

    // anchor goes down
    for (int i=0; i<=BOTTOM; i++) {
      draw(0, i);
      wait(0.1);
    }

    wait(2);
  }


  void sailOut() {
    // anchor goes up
    for (int i=BOTTOM; i>=0; i--) {
      draw(0, i);
      wait(0.1);
    }

    wait(1);

    // boat sails away
    for (int i=0; i<=TRAVEL; i++) {
      draw(i, 0);
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
