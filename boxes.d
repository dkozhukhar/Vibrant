module boxes;

import futils;
import fast32;
import palettes;
import math.all;
import vga2d;

void WindowBox(int x1, int y1, int x2, int y2, uint c)
{
    mb.drawBox(x1, y1, x2, y2, c);
    mb.drawFilledBox(x1+1,y1+1,x2-1,y2-1, 0xE0000000);
}

