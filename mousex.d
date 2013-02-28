module mousex;

import sdl.all;

struct Tmouse
{
    int x, y;
    int vx, vy;
    int buttons;
}

const MOUSE_LEFT = 1,
      MOUSE_RIGHT = 2,
      MOUSE_CENTER = 4;

bool keyoff(SDLKey key)
{
    return SDL.instance.keyboard.markAsReleased(key);
}

bool keyon(SDLKey key)
{
    return SDL.instance.keyboard.markAsPressed(key);
}

bool iskeydown(SDLKey key)
{
    return SDL.instance.keyboard.isPressed(key);
}