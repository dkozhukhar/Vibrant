module misc.framecounter;

import derelict.sdl.sdl;
/*
version(Windows)
{
    import win32.windows;
}

*/
class FrameCounter
{
    protected
    {
        double m_initTime;
        double m_elapsedTime = 0.0;
        double m_frameRate, m_dt;
        int m_totalFrames = -1;

        double getTime()
        {
    /*        version(Windows)
            {
                return GetTickCount() * 0.001;
            }
            else
            {
    */            return SDL_GetTicks() * 0.001;
    //        }
        }

        this()
        {
            reset();
        }
    }

    public
    {

        double frameRate()
        {
            return m_frameRate;
        }

        double deltaTime()
        {
            return m_dt;
        }

        double elapsedTime()
        {
            return m_elapsedTime;
        }

        abstract bool tick(); /* true if FPS changed */

        int totalFrames()
        {
            return m_totalFrames;
        }

        void reset()
        {
            m_initTime = getTime();
        }
    }
}

final class VariableFrameCounter : FrameCounter
{
    private
    {
        int m_frame = 0;
        double m_lastTime;
        double m_updateDuration;
        double m_lastUpdateTime;
        bool m_isFirstFrame;
    }

    public
    {
        this(double updateDuration)
        {
            super();
            m_updateDuration = updateDuration;
            m_dt = 0.0;
            m_lastTime = m_lastUpdateTime = m_initTime;
            m_frameRate = 0.0;
            m_isFirstFrame = true;
        }

        override bool tick()
        {
            m_frame++;
            m_totalFrames++;

            auto now = getTime();
            m_elapsedTime = now - m_initTime;
            auto delta = now - m_lastUpdateTime;
            if (m_isFirstFrame)
            {
                m_dt = 1.0 / 30.0;
                m_isFirstFrame = false;
            } else
            {
                m_dt = now - m_lastTime;
            }
            m_lastTime = now;

            if (delta >= m_updateDuration)
            {
                m_frameRate = m_frame / delta;
                m_lastUpdateTime = now;
                m_frame = 0;
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}

final class FixedFrameCounter : FrameCounter
{
    private
    {
        bool m_firstTick;
        double m_lastTime;
    }

    public
    {
        this(double fixedFrameRate)
        {
            super();
            m_firstTick = true;
            m_frameRate = fixedFrameRate;
            m_dt = 1.0 / fixedFrameRate;
            m_lastTime = m_initTime;
        }

        override bool tick()
        {
            auto now = getTime();
            m_totalFrames++;
            m_elapsedTime += m_dt;
            auto wasFirstTick = m_firstTick;
            m_firstTick = false;

            /* on attend un peu car pas la peine de se depecher */
            auto delta = now - m_lastTime;
            auto toWait = cast(int) ((m_dt - delta) * 1000.0 - 10.0);
            if (toWait > 0) SDL_Delay(toWait);


            m_lastTime = now;
            return wasFirstTick;
        }
    }
}





