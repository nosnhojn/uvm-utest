#include "launch.h"

SCREEN * fullScreen;
FILE * fdfile;
WINDOW * simWin;
WINDOW * guiWin;
ifstream iStream;

void wait(float);
void sig_handler (int);
struct sigaction act;
char iBuf [50];

int xPos = 0;
int yPos = 0;

int main()
{
  act.sa_handler = sig_handler;
  sigemptyset(&act.sa_mask);
  act.sa_flags = 0;
  sigaction(SIGINT, &act, 0);

  fdfile = fopen("/dev/lft0", "r+");
  fullScreen=newterm("linux", fdfile, fdfile);
  set_term(fullScreen);
  simWin = newwin(100, 40, xPos, yPos);
  wmove(simWin, xPos, yPos);

  system("ls > myFile");
  iStream.open("myFile", ifstream::in);
  while (!iStream.eof()) {
    iStream.getline(iBuf, 50);
    waddstr(simWin, iBuf);
    wmove(simWin, ++xPos, yPos);
    wrefresh(simWin);
  }

  delwin(simWin);
  endwin();
}

void wait ( float seconds )
{
  clock_t endwait;
  endwait = clock () + seconds * CLOCKS_PER_SEC ;
  while (clock() < endwait) {}
}

void sig_handler (int sig)
{
  endwin();
  exit(1);
}
