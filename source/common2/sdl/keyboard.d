module sdl.keyboard;

private import derelict.sdl.sdl;

class SDLKeyboard
{
    private
    {
        bool[SDLK_LAST] key_pressed;

        const PRESSED = true,
              RELEASED = false;
    }

    public
    {
        this()
        {
            key_pressed[] = RELEASED;
        }

        bool isPressed(SDLKey key)
        {
            return (key_pressed[key] == PRESSED);
        }

        bool markAsPressed(SDLKey key)
        {
            bool oldState = key_pressed[key];
            key_pressed[key] = PRESSED;
            return oldState;
        }

        bool markAsReleased(SDLKey key)
        {
            bool oldState = key_pressed[key];
            key_pressed[key] = RELEASED;
            return oldState;
        }
    }

}
