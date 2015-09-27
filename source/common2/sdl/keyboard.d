module sdl.keyboard;

import derelict.sdl2.sdl;


/// Holds SDL keyboard state.
/// Bugs: This class should disappear.
final class SDLKeyboard
{
    public
    {
        this()
        {
            clearState();
        }

        /// Returns: true if a key is pressed.
        bool isPressed(SDL_Keycode key)
        {
            SDL_Scancode scan = SDL_GetScancodeFromKey(key);
            return (_state[scan] == PRESSED);
        }

        /// Mark a key as unpressed.
        /// Returns: true if a key was pressed.
        bool markAsReleased(SDL_Keycode key)
        {
            SDL_Scancode scan = SDL_GetScancodeFromKey(key);
            return markKeyAsReleased(scan);
        }

        /// Mark a key as unpressed.
        /// Returns: true if a key was pressed.
        bool markAsPressed(SDL_Keycode key)
        {
            SDL_Scancode scan = SDL_GetScancodeFromKey(key);
            return markKeyAsPressed(scan);
        }
    }

    package
    {
        void clearState()
        {
            _state[] = RELEASED;
        }

        // Mark key as pressed and return previous state.
        bool markKeyAsPressed(SDL_Scancode scancode)
        {
            bool oldState = _state[scancode];
            _state[scancode] = PRESSED;
            return oldState;
        }

        // Mark key as released and return previous state.
        bool markKeyAsReleased(SDL_Scancode scancode)
        {
            bool oldState = _state[scancode];
            _state[scancode] = RELEASED;
            return oldState;
        }
    }

    private
    {
        bool[SDL_NUM_SCANCODES] _state;

        static const PRESSED = true,
                     RELEASED = false;
    }
}
