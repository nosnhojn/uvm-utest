#include "launch.h"

SCREEN * fullScreen;
FILE * fdfile;
WINDOW * simWin;
WINDOW * guiWin;
ifstream iStream;
uvm_boat_anchor boat_anchor;

void register_sig_handler(void);
void setup(void);
void runSim(void);
void sailBoat(void);
void shutdown(void);

void sig_handler (int);

struct sigaction act;
char iBuf [400];

int xSimPos = 0;
int ySimPos = 0;

int main()
{
  register_sig_handler();

  setup();

  runSim();

  sailBoat();

  shutdown();

}


// register_sig_handler
void register_sig_handler() {
  act.sa_handler = sig_handler;
  sigemptyset(&act.sa_mask);
  act.sa_flags = 0;
  sigaction(SIGINT, &act, 0);
}


// setup
void setup() {
  fdfile = fopen("/dev/lft0", "r+");
  fullScreen=newterm("linux", fdfile, fdfile);
  set_term(fullScreen);

  simWin = newwin(SIMWINHEIGHT, 400, xSimPos, ySimPos);
  wmove(simWin, xSimPos, ySimPos);
  waddstr(simWin, "jokes");
  wmove(simWin, ++xSimPos, ySimPos);
  wrefresh(simWin);

  guiWin = newwin(GUIWINHEIGHT, 400, SIMWINHEIGHT+1, 0);
  waddstr(guiWin, "dingle");
  wrefresh(guiWin);
}


// runSim
void runSim() {
  system("./run");
  iStream.open("sim.log", ifstream::in);
  while (!iStream.eof()) {
    iStream.getline(iBuf, 400);
    waddstr(simWin, iBuf);
    wmove(simWin, ++xSimPos, ySimPos);
    wrefresh(simWin);
  }
}


void sailBoat() {
  boat_anchor.setWindow(guiWin);
  boat_anchor.sailIn();
  boat_anchor.startRaining();
  boat_anchor.sailOut();
}


// shutdown
void shutdown() {
  delwin(simWin);
  endwin();
}

void sig_handler (int sig)
{
  endwin();
  exit(1);
}
