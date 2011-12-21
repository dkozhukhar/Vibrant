module lfo;

import math.common;

/**
 * Quadrature LFO.
 */
struct LFO
{
    private
    {
        float a;
    }

    public
    {
        float s, c;

        static LFO opCall(float frequency)
        {
            LFO lfo = void;
            lfo.s = 0.f;
            lfo.c = 1.f;
            lfo.a = 2.f * sin(frequency * PI_F / 44100.f);
            return lfo;
        }

        float phase(float p)
        {
            s = sin(p);
            c = cos(p);
            return p;
        }

        void next()
        {
            s = s + a * c;
            c = c - a * s;
        }

        void resync()
        {
            float tmp = 1.5f - 0.5f * (c * c + s * s);
            s *= tmp;
            c *= tmp;
        }
    }
}
