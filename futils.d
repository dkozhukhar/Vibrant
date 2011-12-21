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

char[] Fstr(float n)
{
    char[] res = toString(n);
    if (n >= 0) res = "+" ~ res;
    return res;
}

float Fval(char[] s)
{
    return toFloat(s);
}

bool sort(ref float a, ref float b)
{
    if (a < b) return false;
    else
    {
        swap(a,b);
        return true;
    }
}
/*
float Fclamp(float n)
{
    return clamp(n, 0.f, 1.f);
}
*/

//alias Fclamp fclamp;

float Fhypot(float a, float b)
{
    return sqrt(a * a + b * b);
}

alias Fhypot fhypot;

float FSqrhypot(float a, float b)
{
    return a * a + b * b;
}

// polar
vec2!(T) polarOld(T)(T angle, T radius)
{
    T s = void, c = void;
    sincos(angle, s, c);
    return vec2!(T)(c * radius, s * radius);
}
