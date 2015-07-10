module misc.random;

import std.random : unpredictableSeed;
import gfm.math;

/+
// more adapted now
struct Random
{
    private
    {
        uint m_seed;
    }

    public
    {
        static Random opCall()
        {
            return Random(cast(uint) unpredictableSeed());
        }

        static Random opCall(uint seed)
        {
            Random r;
            r.m_seed = seed;
            return r;
        }

        uint seed()
        {
            return m_seed;
        }

        uint seed(uint s)
        {
            return m_seed = s;
        }

        // get a random unsigned integer
        uint nextUint()
        {
            return (m_seed = (m_seed * 1664525) + 1013904223);
        }

        // get a random integer
        int nextInt()
        {
            return (m_seed = (m_seed * 1664525) + 1013904223);
        }

        // get a random boolean
        bool nextBool()
        {
            return ((nextUint() >> 8) & 1) == 0;
        }

        // get a random integer in [0..range-1]
        int nextRange(int range)
        {
            return cast(int) (nextDouble() * range);
        }

        // get a random element of an array
        T take(T)(T[] a)
        {
            return a[nextRange(a.length)];
        }

        // get a random integer in the range [min, max_p_1 - 1]
        int nextRange(int min, int max_p_1)
        {
            return min + nextRange(max_p_1 - min);
        }

        // returns a float in [0;1[
        float nextFloat()
        {
            return nextUint() / cast(real)(uint.max + 1.0) ;
        }

        // returns a float in [-1;1[
        float nextFloat2()
        {
            return (nextFloat - 0.5f) * 2.0f;
        }

        // returns a double in [0; 1 [
        double nextDouble()
        {
            return nextUint() / cast(real)(uint.max + 1.0) ;
        }

        // approximate a Gaussian noise
        float nextGaussf()
        {
            return (nextFloat() + nextFloat() + nextFloat() - 1.5f) / 1.5f;
        }

        // approximate a Gaussian noise
        vec2f nextGauss2f()
        {
            return vec2f(nextGaussf(), nextGaussf());
        }

        // approximate a Gaussian noise
        vec3f nextGauss3f()
        {
            return vec3f(nextGaussf(), nextGaussf(), nextGaussf());
        }

        // approximate a Gaussian noise
        vec4f nextGauss4f()
        {
            return vec4f(nextGaussf(), nextGaussf(), nextGaussf(), nextGaussf());
        }

        mat3f nextRotation3f() // not fairly distributed, actually
        {
            auto angle1 = PI_F * nextFloat2 * 0.99f;
            auto angle2 = PI_F * nextFloat2 * 0.49f;
            auto angle3 = PI_F * nextFloat2 * 0.49f;
            return mat3f.rotateY(angle2) * mat3f.rotateZ(angle3) * mat3f.rotateX(angle1);
        }

        mat4f nextRotation4f()
        {
            return mat4f(nextRotation3f);
        }
    }
}

private
{
    __gshared uint randSeed = 0;
}+/
/+
// initialize the random seed
deprecated void srand(uint seed)
{
    randSeed = seed;
}

// get a random integer
deprecated uint randUint()
{
    return (randSeed = (randSeed * 1664525) + 1013904223);
}

// get a random integer
deprecated int randInt()
{
    return (randSeed = (randSeed * 1664525) + 1013904223);
}

// get a random integer in [0..range-1]
deprecated int randRange(int range)
{
    return cast(int) (randDouble() * range);
}

// get a random integer in the range [min, max_p_1 - 1]
deprecated int randRange(int min, int max_p_1)
{
    return min + randRange(max_p_1 - min);
}

// returns a float in [0; 1 [

deprecated float randFloat()
{
    return cast(double)(randUint()) / cast(double)(uint.max + 1.0) ;
}

// returns a float in [-1; 1 [
deprecated float randFloat2()
{
    static __gshared int mirand = 1;
    static __gshared float randFloatFast_corr = 3.0f;
    asm
    {
        mov EAX, mirand;
        mov ECX, 16807;
        mul ECX;
        and EAX, 0x007fffff;
        or EAX, 0x40000000;
        mov mirand, EAX;
        fld mirand;
        fsub randFloatFast_corr;
    }
}


// returns a double in [0; 1 [
deprecated double randDouble()
{
    return cast(double)(randUint()) / cast(double)(uint.max + 1.0) ;
}

// approximate a Gaussian noise
deprecated float randGaussf()
{
    return (randFloat() + randFloat() + randFloat() - 1.5f) / 1.5f;
}
+/