module futils;

import std.conv;
import std.string;

import misc.all;


// polar
vec2!(T) polarOld(T)(T angle, T radius)
{
    T s = void, c = void;
    sincos(angle, s, c);
    return vec2!(T)(c * radius, s * radius);
}

