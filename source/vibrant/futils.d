module futils;

import std.conv;
import std.string;

import math.all;
import misc.all;

float normalizeAngle(float angle)
{
    double PI2 = 6.283185307179586476925286766559;

    asm
    {
        fld PI2;
        fld angle;
        fprem1;
        fstp ST(1);
    }
}


// polar
vec2!(T) polarOld(T)(T angle, T radius)
{
    T s = void, c = void;
    sincos(angle, s, c);
    return vec2!(T)(c * radius, s * radius);
}

