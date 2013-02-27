module mousex;

import utils;

struct Tmouse
{
    int x, y;
    int vx, vy;
    int buttons;
}

const MOUSE_LEFT = 1,
      MOUSE_RIGHT = 2,
      MOUSE_CENTER = 4;

