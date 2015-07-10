module lfo;

import std.math;

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
            lfo.s = 0.0f;
            lfo.c = 1.0f;
            lfo.a = 2.0f * sin(frequency * PI / 44100.0f);
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
