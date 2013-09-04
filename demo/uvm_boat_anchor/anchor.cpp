#include <iostream>
#include <string>
#include <stdlib.h>
#include <ncurses.h>
#include <time.h>
#include <signal.h>

using namespace std;

const int BOTTOM = 10;
const int TRAVEL = 66;

int draw(int, int);
void drawSky();
void drawBoat(int);
void drawWater(int);
void drawChain(int);
void drawAnchor();
void drawBottom();
void wait (float);
void sig_handler(int);

int main() {
  int i;
  struct sigaction act;

  // signal handling to return the endwin()
  act.sa_handler = sig_handler;
  sigemptyset(&act.sa_mask);
  act.sa_flags = 0;
  sigaction(SIGINT, &act, 0);

  initscr();

  // boat sails in
  for (i=TRAVEL; i>=0; i--) {
    draw(i, 0);
    wait(0.1);
  }

  // anchor goes down
  for (i=0; i<=BOTTOM; i++) {
    draw(0, i);
    wait(0.1);
  }

  wait(2);

  // anchor goes up
  for (i=BOTTOM; i>=0; i--) {
    draw(0, i);
    wait(0.1);
  }

  wait(1);

  // boat sails away
  for (i=0; i<=TRAVEL; i++) {
    draw(i, 0);
    wait(0.1);
  }

  wait(1);

  endwin();
}


int draw(int distance, int chainLength) {
    clear();
    drawSky();
    drawBoat(distance);
    drawWater(distance);
    drawChain(chainLength);
    if (chainLength > 0) drawAnchor();
    if (chainLength == BOTTOM) drawBottom();
    refresh();
}

void drawSky()
{
    string sky[6] = {
         "                                                      * ** ** ** *   ",
         "                                                     * *  *  *  * ** ",
         "                                                     *   *  *  *  *  ",
         "                                                      *** ** ** **   ",
         "                                                                     ",
         "                                                                     "
                    };
    for (int i=0; i<6; i++) {
      addstr(sky[i].c_str());
      addstr("\n");
    }
}


void drawBoat(int distance)
{
    string boat[10] = {
         "                                                     .                                                       \n",
         "                                                    /|\\                                                     \n",
         "                                                   / | \\                                                    \n",
         "                                                  /  |  \\                                                   \n",
         "                                                 /   |   \\                                                  \n",
         "                                                /    |    \\                                                 \n",
         "                                               /     |     \\                                                \n",
         "                                              /      |      \\                                               \n",
         "                                             ._______|_______.                                               \n",
         "                                      `--.___________|___________                                            \n"
    };
    for (int i=0; i<10; i++) {
      addstr(boat[i].substr(distance).c_str());
    }
}

void drawWater(int distance)
{
    string top = "___     ___     ____    ____      ____     ___    ___    ___    ___    ___\n";
    if (distance <= 64) top[64-distance] = '/';
    if (distance <= 43) top[43-distance] = '\\';
    addstr(top.c_str());

    string bottom = "   \\___/   \\___/    \\__/    \\____/    \\___/   \\__/   \\__/   \\__/   \\__/   \\__\n";
    if (distance <= 64)
      if (bottom[63-distance] == '_') bottom[63-distance] = '/';
    if (distance <= 43)
      if (bottom[44-distance] == '_') bottom[44-distance] = '\\';
    addstr(bottom.c_str());
}


void drawChain(int chainLength) {
  for (int i=0; i<chainLength; i+=1) {
    addstr("                                                |\n");
  }
}


void drawAnchor() {
    addstr("                                      /\\        O        /\\                                                  \n");
    addstr("                                      | \\      / \\      / |                                                  \n");
    addstr("                                      |  \\     | |     /  |                                                  \n");
    addstr("                                      | |\\\\    | |    //| |                                                  \n");
    addstr("                                      | | \\\\   | |   // | |                                                  \n");
    addstr("                                      \\ \\  '   | |   '  / /                                                  \n");
    addstr("                                       \\ \\     | |     / /                                                   \n");
    addstr("                                        \\ \\    | |    / /                                                    \n");
    addstr("                                         \\ '---^ ^---' /                                                     \n");
    addstr("                                          \\   U V M   /                                                      \n");
    addstr("                                          '-----^-----'                                                      \n");
}

void drawBottom() {
    addstr("/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\\n");
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
