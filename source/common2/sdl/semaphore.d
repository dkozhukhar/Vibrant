module sdl.semaphore;

import derelict.sdl.sdl;
import sdl.state;


final class Semaphore
{
    private
    {
        SDL_sem * m_handle;
    }

    public
    {
        this(Uint32 initial_value)
        {
            m_handle = SDL_CreateSemaphore(initial_value);
            assert(m_handle !is null);
        }

        ~this()
        {
            SDL_DestroySemaphore(m_handle);
        }

        void lock()
        {
            int r = SDL_SemWait(m_handle);
            assert(r == 0);
        }

        void unlock()
        {
            int r = SDL_SemPost(m_handle);
            assert(r == 0);
        }

        Uint32 value()
        {
            return SDL_SemValue(m_handle);
        }


    }

}
