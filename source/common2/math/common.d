module math.common;


/**
 * Some function will be imported from std.math, some won't.
 *
 * In particular, rounding and truncing function of std.math are bypassed, because
 * lround exists (in D2) but still not ltrunc.
 *
 * In std.math, some functions works for real, with overhead in intermediate results and parameters.
 * That's why i reinvent the wheel.
 *
 * Generally I don't take into account denormals, infinities or NaN since they are symptoms of bugs,
 * not causes.
 */

import std.math;

alias std.math.cos cos;
alias std.math.sin sin;
alias std.math.tan tan;
alias std.math.acos acos;
alias std.math.asin asin;
alias std.math.atan atan;

alias std.math.acosh acosh;
alias std.math.asinh asinh;
alias std.math.atanh atanh;
alias std.math.acosh acosh;
alias std.math.asinh asinh;
alias std.math.atanh atanh;
alias std.math.atan2 atan2;

alias std.math.isnan isNaN;
alias std.math.isfinite isFinite;

alias std.math.round round;
alias std.math.trunc trunc;
alias std.math.floor floor;

version(D_Version2)
{
    alias std.math.isSubnormal isSubnormal;
    alias std.math.isInfinity isInfinity;
}
else
{
    alias std.math.issubnormal isSubnormal;
    alias std.math.isinf isInfinity;
}


alias std.math.E E;
alias std.math.LOG2T LOG2T;
alias std.math.LOG2E LOG2E;
alias std.math.LOG2 LOG2;
alias std.math.LOG10E LOG10E;
alias std.math.LN2 LN2;
alias std.math.LN10 LN10;
alias std.math.PI PI;
alias std.math.PI_2 PI_2;
alias std.math.PI_4 PI_4;
alias std.math.M_1_PI M_1_PI;
alias std.math.M_2_PI M_2_PI;
alias std.math.M_2_SQRTPI M_2_SQRTPI;
alias std.math.SQRT2 SQRT2;
alias std.math.SQRT1_2 SQRT1_2;

alias M_2_PI TAU;
// some more typed constants

const float PI_F = PI;
const float TWO_PI_F = PI * 2L;
alias TWO_PI_F TAU_F;
const float PI_2_F = PI_2;
const float PI_4_F = PI_4;
const float SQRT2_F = SQRT2;
const float SQRT2_INV_F = 1.0L / SQRT2;

const double PI_D = PI;
const double TWO_PI_D = PI * 2L;
alias TWO_PI_D TAU_D;
const double PI_2_D = PI_2;
const double PI_4_D = PI_4;
const double SQRT2_D = SQRT2;
const double SQRT2_INV_D = 1.0L / SQRT2;

void swap(T)(ref T a, ref T b)
{
    T c = a;
    a = b;
    b = c;
}


/**
 * Convert from radians to degrees
 */
T degrees(T)(T x)
{
    return (x * 180) / cast(T)PI;
}

/**
 * Convert from degrees to radians
 */
T radians(T)(T x)
{
    return (x * cast(T)PI) / 180;
}

T abs(T)(T x)
{
    return (x >= 0)    ? x : -x;
}

alias abs!(int) absi;
alias abs!(float) absf;
alias abs!(double) absd;

/**
 * Returns the minimum of a and b
 */
T min(T)(T a, T b)
{
    return (a < b) ? a : b;
}

alias min!(int) mini;
alias min!(float) minf;
alias min!(double) mind;

/**
 * Returns the maximum of a and b
 */
T max(T)(T a, T b)
{
    return (a > b) ? a : b;
}

alias max!(int) maxi;
alias max!(float) maxf;
alias max!(double) maxd;


/**
 * Linear intepolation between a and b
 * Similar to GLSL
 */
T mix(T, U)(T a, T b, U t)
{
    return t * b + (1 - t) * a;
}

alias mix!(float, float) mixf;
alias mix!(double, double) mixd;



/**
 * Clamping, like in GLSL
 */
T clamp(T)(T x, T min, T max)
{
    return x > max ? max : (x < min ? min : x);
}

alias clamp!(int) clampi;
alias clamp!(float) clampf;
alias clamp!(double) clampd;



/**
 * distort and clip (useful for audio and parameter tuning)
 */
T amplify(T)(T x)
{
    T y = clamp(x, cast(T)-1, cast(T)1);
    return y * cast(T)1.5 - cast(T)0.5 * y * y * y;
}

/**
 * amplify several times
 */
T amplifyN(T)(T x, int n)
{
    T tmp = x;
    for (int i = 0; i < n; ++i)
    {
        tmp = amplify(tmp);
    }
    return tmp;
}


/**
 * Useful for mapping a parameter finely for small values with preserved range
 * WARNING : min and max must have the same sign
 *           min cannot be near 0
 */
T expMap(T)(T min, T max, T x)
{
    return min * pow(max / min, x);
}

alias expMap!(float) expMapf;
alias expMap!(double) expMapd;





/**
 * Fractional part, useful for interpolating.
 */
T fract(T)(T x)
{
    return x - cast(int)floor(x);
}

alias fract!(float) fractf;
alias fract!(double) fractd;


T pow2(T)(T x)
{
    return cast(T)std.math.pow(2, x);
}

alias pow2!(float) pow2f;
alias pow2!(double) pow2d;

T pow(T)(T base, T exp)
{
    return cast(T)std.math.pow(base, exp);
}

alias pow!(float) powf;
alias pow!(double) powd;


T exp(T)(T x)
{
    return pow(cast(T)E, x);
}

alias exp!(float) expf;
alias exp!(double) expd;

T log2(T)(T x)
{
    asm
    {
        fld1;
        fld x;
        fyl2x;
    }
}

alias log2!(float) log2f;
alias log2!(double) log2d;

T log10(T)(T x)
{
    asm
    {
        fldlg2;
        fld x;
        fyl2x;
    }
}

alias log10!(float) log10f;
alias log10!(double) log10d;

T log(T)(T x)
{
    asm
    {
        fldln2;
        fld x;
        fyl2x;
    }
}

alias log!(float) logf;
alias log!(double) logd;

/**
 * Square
 */
T sqr(T)(T s)
{
    return s * s;
}

alias sqr!(float) sqrf;
alias sqr!(double) sqrd;

/**
 * Cube
 */
T cube(T)(T s)
{
    return s * s * s;
}

alias cube!(float) cubef;
alias cube!(double) cubed;

/**
 * Square root
 */
T sqrt(T)(T x)
{
    asm
    {
        fld x;
        fsqrt;
    }
}

alias sqrt!(float) sqrtf;
alias sqrt!(double) sqrtd;

/**
 * returns the angle of the vector (x,y)
 * in [-PI, PI[
 */
 /*
T atan2(T)(T x, T y)
{
    T u;
    asm
    {
        fld x;
        fld y;
        fpatan;
        fstp u;
    }
    return u;
}

alias atan2!(float) atan2f;
alias atan2!(double) atan2d;
*/

/**
 * return the first m with m = 2^k and m >= n
 * n must be >= 0
 * BUG: dumb implementation
 */
int nextPow2(int n)
{
    for (int i = 0; i < 31; i++)
    {
        int m = (1 << i);
        if ((1 << i) >= n) return m;
    }
    return -1;
}


/+
/**
 * linear interpolation
 */
T linearInterp(T)(T[] table, float index)
{
    if (index < 0)
    {
        return table[0];
    }
    else if (index >= table.length - 1)
    {
        return table[table.length - 1];
    }
    else
    {
        int ipart = cast(int)(index);
        float fpart = index - ipart;
        T a = table[ipart] * (1 - fpart);
        T b = table[ipart + 1] * fpart;
        return a + b;
    }
}


// hermite 3 point interpolation
T hermite(T)(float frac_pos, T xm1, T x0, T x1, T x2)
{
   auto final c = (x1 - xm1) * cast(T)0.5;
   auto final v = x0 - x1;
   auto final w = c + v;
   auto final a = w + v + (x2 - x0) * cast(T)0.5;
   auto final b_neg = w + a;
   return ((((a * frac_pos) - b_neg) * frac_pos + c) * frac_pos + x0);
}
+/


/**                  ___
 * step function ___/
 *
 * potential BUG : division by a denormal when (b-a) is small
 */
T step(T)(T a, T b, T t)
{
    if (t <= a) return cast(T)0;
    else if (t >= b) return cast(T)1;
    else return (t - a) / (b - a);
}

alias step!(float) stepf;
alias step!(double) stepd;

/**
 * smoothstep function : same as in GLSL
 *
 * potential BUG : division by a denormal when (b-a) is small
 */
T smoothStep(T)(T  a, T  b, T  t)
{
    if (t <= a) return cast(T)0;
    else if (t >= b) return cast(T)1;
    else
    {
        T x = (t - a) / (b - a);
        return x * x * (cast(T)3 - cast(T)2 * x);
    }
}

alias smoothStep!(float) smoothStepf;
alias smoothStep!(double) smoothStepd;

//                   ___
// pulse function __|   |____
//
T pulse(T)(T  a, T  b, T  t)
{
    if (t <= a) return 0;
    else if (t >= b) return 0;
    else return 1;
}

alias pulse!(float) pulsef;
alias pulse!(double) pulsed;



/**
 * Computes a sinus and cosinus at the same time
 */
void sincos(T)(T angle, ref T s, ref T c)
{
    creal cossin = expi(angle);
    s = cossin.im;
    c = cossin.re;
}

/*
void sincos(T)(T angle, ref T s, ref T c)
{
    T sine = void, cosine = void;
    asm
    {
        fld angle;
        fsincos;
        fstp cosine;
        fstp sine;
    }
    s = sine;
    c = cosine;
}
*/

/*
void sincos(T)(T angle, ref T s, ref T c)
{
    s = sin(angle);
    c = cos(angle);
}
*/

alias sincos!(float) sincosf;
alias sincos!(double) sincosd;


/**
 * exp approximation. This is useful for implicit Euler integration, for FPS independent moves
 */
T exp3(T)(T x)
{

    if (x < cast(T)(-1.15365L))
    {
        return 0;
    }
    else
    {
        return cast(T)1.0L + x * (cast(T)1.0L + x * (cast(T)0.5L + x * cast(T)0.3333333333333L));
    }
}

alias exp3!(float) exp3f;
alias exp3!(double) exp3d;


T remap(T)(T value, T a, T b, T c, T d)
{
    return c + (d - c) * (value - a) / (b - a);
}

alias remap!(float) remapf;
alias remap!(double) remapd;


/**
 * Safe asin: clamps between -1 and 1
 */
T safeAsin(T)(T x)
{
    if (x < -1) x = -1;
    if (x > 1) x = 1;
    return asin(x);
}

alias safeAsin!(float) safeAsinf;
alias safeAsin!(double) safeAsind;

/**
 * Safe acos: clamps between -1 and 1
 */
T safeAcos(T)(T x)
{
    if (x < -1) x = -1;
    if (x > 1) x = 1;
    return acos(x);
}

alias safeAcos!(float) safeAcosf;
alias safeAcos!(double) safeAcosd;


/**
 * Cube root.
 */
T cbrt(T)(T x)
{
    if (x > 0) return pow(x, cast(T)(1.0L / 3.0L));
    if (x < 0) return -pow(-x, cast(T)(1.0L / 3.0L));
    return 0;
}
