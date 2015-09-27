module mousex;

import sdl.all;

struct MouseState
{
    int x, y;
    int vx, vy;
    int buttons;
}

const MOUSE_LEFT = 1,
      MOUSE_RIGHT = 2,
      MOUSE_CENTER = 4;

bool keyoff(SDL_Keycode key)
{
    return SDL.instance.keyboard.markAsReleased(key);
}

bool keyon(SDL_Keycode key)
{
    return SDL.instance.keyboard.markAsPressed(key);
}

bool iskeydown(SDL_Keycode key)
{
    return SDL.instance.keyboard.isPressed(key);
}