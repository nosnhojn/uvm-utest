#include "vpi_user.h"
#include "cimports.h"
#include <iostream>
#include <string>
#include <stdlib.h>
#include <ncurses.h>
#include <time.h>
#include <signal.h>
#include <list>

using namespace std;

const int BOTTOM = 5;
const int TRAVEL = 66;

extern "C" void c_setup();
extern "C" void c_sailIn();
extern "C" void c_build();
extern "C" void c_startRaining();
extern "C" void c_sailOut();
extern "C" void c_teardown();

int draw(int, int);
void wait (float);
void sig_handler(int);

struct ascii_out_t;
