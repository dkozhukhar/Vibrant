module joy;

import sdl.all;

// will work even when there are no joystick
float joyAxis(int i)
{
    int nJoy = SDL.instance.numJoysticks();
    if (nJoy <= 0) return 0.f;

    auto j = SDL.instance.joystick(0);

    if (j is null) return 0.f;

    if ((i < 0) || (i >= j.getNumAxis))
    {
        return 0.f;
    }

    return j.axis(i);
}

bool joyButton(int i)
{
    int nJoy = SDL.instance.numJoysticks();
    if (nJoy <= 0) return false;

    auto j = SDL.instance.joystick(0);

    if (j is null) return false;

    if ((i < 0) || (i >= j.getNumAxis))
    {
        return false;
    }

    return j.button(i);
}
