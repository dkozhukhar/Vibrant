module math.vec2;

import std.string: format;

import math.half;
import math.vectorop;
import math.common;


struct vec2(T)
{

    public {

        union {
            struct {
                T x, y;
            }
            T[2] v;
        }
    }

    mixin VectorOp!(T, v);


    public
    {
        //////////////////
        // constructors //
        //////////////////

        static vec2 opCall(T x, T y)
        {
            vec2 v = void;
            v.x = x;
            v.y = y;
            return v;
        }

        static vec2 opCall(T x)
        {
            vec2 v = void;
            v.x = x;
            v.y = x;
            return v;
        }

        ///////////////
        // constants //
        ///////////////

        static vec2 ZEROS, ONES;

        static this()
        {
            ZEROS = vec2(cast(T)0);
            ONES = vec2(cast(T)1);
        }


        ///////////////////////////
        // GLSL style properties //
        ///////////////////////////

        vec2 xx() { return vec2(x, x); }
        vec2 xy() { return vec2(x, y); }
        vec2 yx() { return vec2(y, x); }
        vec2 yy() { return vec2(y, y); }

        vec2 xy(vec2 v) { x = v.x; y = v.y; return v; }
        vec2 yx(vec2 v) { y = v.x; x = v.y; return v; }

        // cast
        final vec2!(U) to(U)()
        {
            return vec2!(U)(cast(U)x, cast(U)y);
        }


        //////////////////////////
        // operator overloading    //
        //////////////////////////

        vec2 opAdd(T a)
        {
            return vec2(x + a, y + a);
        }

        vec2 opAdd(vec2 v)
        {
            return vec2(x + v.x, y + v.y);
        }

        vec2 opSub(vec2 v)
        {
            return vec2(x - v.x, y - v.y);
        }

        vec2 opSub(T a)
        {
            return vec2(x - a, y - a);
        }

        vec2 opSub_r(T a)
        {
            return vec2(a - x, a - y);
        }

        vec2 opMul(vec2 v)
        {
            return vec2(x * v.x, y * v.y);
        }

        vec2 opMul(T a)
        {
            return vec2(x * a, y * a);
        }

        vec2 opDiv(vec2 v)
        {
            return vec2(x / v.x, y / v.y);
        }

        vec2 opDiv(T a)
        {
            return vec2(x / a, y / a);
        }

        void opAddAssign(T a)
        {
            x += a;
            y += a;
        }

        void opAddAssign(vec2 v)
        {
            x += v.x;
            y += v.y;
        }

        void opSubAssign(T a)
        {
            x -= a;
            y -= a;
        }

        void opSubAssign(vec2 v)
        {
            x -= v.x;
            y -= v.y;
        }

        void opMulAssign(T a)
        {
            x *= a;
            y *= a;
        }

        void opMulAssign(vec2 v)
        {
            x *= v.x;
            y *= v.y;
        }

        void opDivAssign(T a)
        {
            x /= a;
            y /= a;
        }

        void opDivAssign(vec2 v)
        {
            x /= v.x;
            y /= v.y;
        }

        vec2 opNeg()
        {
            return vec2(-x, -y);
        }

        string toString()
        {
            return format("(%s %s)", x, y);
        }
    }
}

alias vec2!(int) vec2i;
alias vec2!(float) vec2f;
alias vec2!(double) vec2d;

alias vec2!(real) vec2l;
alias vec2!(half) vec2h;


// polar
vec2!(T) polar(T)(T angle, T radius)
{
    return vec2!(T)(sin(angle) * radius, cos(angle) * radius);
}

vec2!(T) min2(T)(vec2!(T) a, vec2!(T) b)
{
    T x = math.common.min(a.x, b.x);
    T y = math.common.min(a.y, b.y);
    return vec2!(T)(x, y);
}

vec2!(T) max2(T)(vec2!(T) a, vec2!(T) b)
{
    T x = math.common.max(a.x, b.x);
    T y = math.common.max(a.y, b.y);
    return vec2!(T)(x, y);
}

alias min2!(int) min2i;
alias min2!(float) min2f;
alias min2!(double) min2d;

alias max2!(int) max2i;
alias max2!(float) max2f;
alias max2!(double) max2d;

