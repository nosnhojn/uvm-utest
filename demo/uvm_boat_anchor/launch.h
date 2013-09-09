#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>
#include <time.h>
#include <signal.h>
#include <string.h>
#include <fstream>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include "uvm_boat_anchor.h"

const int SIMWINHEIGHT = 23;
const int GUIWINHEIGHT = 70;

using namespace std;
