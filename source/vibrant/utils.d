module utils;

import math.all;

__gshared Random random;

shared static this()
{
    random = Random();
}

float normalizeAngle(float angle)
{
    double PI2 = 6.283185307179586476925286766559;
    float val = angle;
    while(val > PI2 * 2)
        val -= PI2;
    while(val < -PI2 * 2)
        val += PI2;
    return val;
}


// polar
vec2!(T) polarOld(T)(T angle, T radius)
{
    T s = void, c = void;
    sincos(angle, s, c);
    return vec2!(T)(c * radius, s * radius);
}
