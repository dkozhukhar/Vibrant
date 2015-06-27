module math.mat2;


import math.common;
import std.string;// : format, toString;
import math.vec2;
import math.box2;

debug
{
    import std.stdio;
}

struct mat2(T)
{
    public {

        union
        {
            T[2][2] c;
            T[4] v;
            struct
            {
                T c00, c01, c10, c11;
            }
        }

        static mat2 opCall(T c00, T c01,
                           T c10, T c11)
        {
            mat2 m = void;
            m.c[0][0] = c00;    m.c[0][1] = c01;
            m.c[1][0] = c10;    m.c[1][1] = c11;
            return m;
        }

        static mat2 opCall(vec2!(T) c0, vec2!(T) c1)
        {
            mat2 m = void;
            m.c[0][0] = c0.x;    m.c[0][1] = c1.x;
            m.c[1][0] = c0.y;    m.c[1][1] = c1.y;
            return m;
        }

        static mat2 opCall(T x)
        {
            return mat2(x, x, x, x);
        }

        vec2!(T) c0() { return vec2!(T)(c[0][0], c[1][0]); }
        vec2!(T) c1() { return vec2!(T)(c[0][1], c[1][1]); }

        vec2!(T) l0() { return vec2!(T)(c[0][0], c[0][1]); }
        vec2!(T) l1() { return vec2!(T)(c[1][0], c[1][1]); }

        final mat2!(U) to(U)()
        {
            return mat2!(U)(cast(U)c00, cast(U)c01,
                            cast(U)c10, cast(U)c11);
        }


        mat2 opMul(mat2 m) {

            return mat2(
                c[0][0] * m.c[0][0] + c[0][1] * m.c[1][0],
                c[0][0] * m.c[0][1] + c[0][1] * m.c[1][1],
                c[1][0] * m.c[0][0] + c[1][1] * m.c[1][0],
                c[1][0] * m.c[0][1] + c[1][1] * m.c[1][1]
            );
        }

        vec2!(T) opMul(vec2!(T) v)
        {
            return vec2!(T)
            (
                c[0][0] * v.v[0] + c[0][1] * v.v[1],
                c[1][0] * v.v[0] + c[1][1] * v.v[1]
            );
        }

        mat2 opMul(T v) {

            return mat2(
                c[0][0] * v,
                c[0][1] * v,
                c[1][0] * v,
                c[1][1] * v
            );

        }

        mat2 opAdd(mat2 v)
        {
            return mat2(
                c[0][0] + v.c[0][0],
                c[0][1] + v.c[0][1],
                c[1][0] + v.c[1][0],
                c[1][1] + v.c[1][1]
            );
        }

        mat2 opSub(mat2 v)
        {
            return mat2(
                c[0][0] - v.c[0][0],
                c[0][1] - v.c[0][1],
                c[1][0] - v.c[1][0],
                c[1][1] - v.c[1][1]
            );
        }


        mat2 opAddAssign(mat2 v)
        {
            c[0][0] += v.c[0][0];
            c[0][1] += v.c[0][1];
            c[1][0] += v.c[1][0];
            c[1][1] += v.c[1][1];
            return this;
        }


        mat2 opSubAssign(mat2 v)
        {
            c[0][0] -= v.c[0][0];
            c[0][1] -= v.c[0][1];
            c[1][0] -= v.c[1][0];
            c[1][1] -= v.c[1][1];
            return this;
        }

        mat2 opMulAssign(mat2 m)
        {
            T nc00 = c[0][0] * m.c[0][0] + c[0][1] * m.c[1][0];
            T nc01 = c[0][0] * m.c[0][1] + c[0][1] * m.c[1][1];
            T nc10 = c[1][0] * m.c[0][0] + c[1][1] * m.c[1][0];
            T nc11 = c[1][0] * m.c[0][1] + c[1][1] * m.c[1][1];
            c00 = nc00;
            c01 = nc01;
            c10 = nc10;
            c11 = nc11;
            return this;
        }

        mat2 transposed()
        {
            return mat2
            (
                c[0][0], c[1][0],
                c[0][1], c[1][1]
            );

        }

        void transpose()
        {
            swap(c[0][1],c[1][0]);
        }

        string toString()
        {
            return format("((%s, %s)\n" " (%s, %s))",
                          c00, c01, c10, c11);
        }

        static mat2 IDENTITY, ZERO;

        static this()
        {
            ZERO = mat2(0);
            IDENTITY = mat2(1, 0,
                            0, 1);
        }

        static {

            mat2 zero()
            {
                return ZERO;
            }

            mat2 identity()
            {
                return IDENTITY;
            }

            mat2 scale(T f)
            {
                return mat2
                (
                    f, 0,
                    0, f
                );
            }

            mat2 scale(T fx, T fy)
            {
                return mat2
                (
                    fx, 0,
                    0, fy
                );
            }

            mat2 rotate(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat2
                (
                    cosa, -sina,
                    sina,  cosa
                );
            }
        }
    }
}

alias mat2!(float) mat2f;
alias mat2!(double) mat2d;

static assert(mat2f.sizeof == 4 * float.sizeof);
static assert(mat2d.sizeof == 4 * double.sizeof);
