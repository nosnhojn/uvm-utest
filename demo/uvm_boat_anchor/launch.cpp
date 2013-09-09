#include "launch.h"

SCREEN * fullScreen;
FILE * fdfile;
WINDOW * simWin;
WINDOW * guiWin;
fstream iStream;
uvm_boat_anchor boat_anchor;

void register_sig_handler(void);
void setup(void);
void runSim(void);
void sailBoat(void);
void shutdown(void);

void sig_handler (int);

struct sigaction act;
string iBuf;

int xSimPos = 10;
int ySimPos = 0;

int main()
{
  pid_t PID;
  int status;

  register_sig_handler();

  setup();

  runSim();

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

  simWin = newwin(SIMWINHEIGHT, 400, ySimPos, xSimPos);
  scrollok(simWin, TRUE);
  waddstr(simWin, "** Hang on a sec... just waiting for the uvm boat anchor demo to compile\n");
  wmove(simWin, ++ySimPos, xSimPos);
  waddstr(simWin, "** and start running. You'll see something happen shortly...\n\n");
  wmove(simWin, ++ySimPos, xSimPos);
  wrefresh(simWin);

  guiWin = newwin(GUIWINHEIGHT, 400, SIMWINHEIGHT+1, xSimPos);
  boat_anchor.setWindow(guiWin);
  boat_anchor.startingScene();
  wrefresh(guiWin);
}


// runSim
void runSim() {
  string lineInput;
  int postLogging = 0;

  while (getline(cin,iBuf)) {
    iBuf.append("\n");
    iBuf.replace(0, 1, " ");

    if (postLogging > 0) {
      waddstr(simWin, iBuf.c_str());
      wrefresh(simWin);
      wmove(simWin, ++ySimPos, xSimPos);
      boat_anchor.wait(0.2);
    }

    if (!iBuf.compare("  $cmd> Sail in\n")) {
      boat_anchor.setWindow(guiWin);
      boat_anchor.sailIn();
    }

    else if (!iBuf.compare("  $cmd> Sail away\n")) {
      boat_anchor.setWindow(guiWin);
      boat_anchor.sailOut();
    }

    else if (!iBuf.compare("  $cmd> All done\n")) {
      boat_anchor.setWindow(guiWin);
      boat_anchor.finalScene();
    }

    else if (!iBuf.compare("  run -all \n")) {
      postLogging = 243;
    }
  }
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
