module sdl.mutex;

import derelict.sdl.sdl;
import std.stdio;
import sdl.state;

final class Mutex
{
    private
    {
        SDL_mutex *m_handle;
    }

    public
    {
        this()
        {
            m_handle = SDL_CreateMutex();

            if (m_handle is null)
            {
                throw new SDLError("Unable to create a SDL mutex");
            }
        }

        ~this()
        {
            SDL_DestroyMutex(m_handle);
        }

        void lock()
        {
            int r = SDL_mutexP(m_handle);
            if (r != 0)
            {
                throw new SDLError("Unable to lock the SDL mutex");
            }
        }

        void unlock()
        {
            int r = SDL_mutexV(m_handle);
            if (r != 0)
            {
                throw new SDLError("Unable to unlock the SDL mutex");
            }
        }


    }

}
