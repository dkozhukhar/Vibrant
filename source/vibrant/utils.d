module utils;

import std.math;
import std.random;
import gfm.math;

__gshared Xorshift32 random;

alias powd = pow;

void swap(T)(ref T a, ref T b)
{
    T temp = a;
    a = b;
    b = temp;
}

void sincos(T)(T angle, ref T sina, ref T cosa)
{
    cosa = cos(angle);
    sina = sin(angle);
}

T exp3(T)(T x)
{
    if (x < cast(T)(-1.15365L))
        return 0;

    return cast(T)1.0L + x * (cast(T)1.0L + x * (cast(T)0.5L + x * cast(T)0.3333333333333L));
}

T sqr(T)(T x)
{
    return x * x;
}

shared static this()
{
    random = Xorshift32();
}

float nextAngle(ref Xorshift32 random)
{
    return uniform(0.0f, cast(float)PI, random);
}

float nextFloat(ref Xorshift32 random)
{
    return uniform(0.0f, 1.0f, random);
}

// returns a float in [-1;1[
float nextFloat2(ref Xorshift32 random)
{
    return uniform(-1.0f, 1.0f, random);
}


// get a random integer in [0..range-1]
int nextRange(ref Xorshift32 random, int range)
{
    return  uniform(0, range, random);
}

// get a random integer in the range [min, max_p_1 - 1]
int nextRange(ref Xorshift32 random, int min, int max_p_1)
{
    return uniform(min, max_p_1, random);
}

float normalizeAngle(float angle)
{
    double PI2 = 6.283185307179586476925286766559;

    while(angle > PI)
        angle -= PI2;

    while(angle < -PI)
        angle += PI2;

    return angle;
}

/*
void keepAtLeastThatSize(T)(ref T[] slice)
{
    auto capacity = slice.capacity;
    auto length = slice.length;
    if (capacity < length)
        slice.reserve(length); // should not reallocate
}*/


// polar
vec2!(T) polarOld(T)(T angle, T radius)
{
    T c = cos(angle);
    T s = sin(angle);
    return vec2!(T)(c * radius, s * radius);
}


mat2f mat2frotate(float angle)
{
    float cosa = cos(angle);
    float sina = sin(angle);
    return mat2f
        (
         cosa, -sina,
         sina,  cosa
         );
}

// returns the largest box2 within with asked ratio
box2i subRectWithRatio(box2i input, double asked_ratio)
{
    box2i r = input;
    double ratio = input.width() / cast(float)(input.height());

    if (ratio < asked_ratio) // crop because of ratio if needed
    {
        auto new_height = input.width * (1.0 / asked_ratio);
        auto diff = input.height - new_height;
        r.min.y += cast(int)round(diff * 0.5);
        r.max.y -= cast(int)round(diff * 0.5);
    }
    else if (ratio > asked_ratio)
    {
        auto new_width = input.height * asked_ratio;
        auto diff = input.width - new_width;
        r.min.x += cast(int)round(diff * 0.5);
        r.max.x -= cast(int)round(diff * 0.5);
    }
    return r;
}