module fast32;

import utils;
import misc.image;
import palettes;

Image mb; // framebuffer

private uint currentHUDColor = 0xffffffff; // current HUD color

void setHUDColor(uint color)
{
    currentHUDColor = color;
}

uint getHUDColor() { return currentHUDColor; }

