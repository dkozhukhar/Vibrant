module math.triangle3;

import math.common;
import math.vec3;
import std.string;

/**
 * Abstract 3D triangle shape.
 */
struct triangle3(T)
{
    public
    {
        vec3!(T) a, b, c;
    }

    public
    {
        //////////////////
        // constructors //
        //////////////////

        static triangle3 opCall(vec3!(T) a, vec3!(T)b, vec3!(T)c)
        {
            triangle3 t = void;
            t.a = a;
            t.b = b;
            t.c = c;
            return t;
        }

        // construct from 2 point

        string toString()
        {
            return format("%s - %s - %s", a, b, c);
        }
    }
}

alias triangle3!(float) triangle3f;
alias triangle3!(double) triangle3d;
