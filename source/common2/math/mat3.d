module math.mat3;


import math.common;
import std.string;// : format, toString;
import math.vec2;
import math.vec3;
import math.box2;
import math.box3;

debug
{
    import std.stdio;
}

struct mat3(T)
{
    public {

        union
        {
            T[3][3] c;
            T[9] v;
            struct
            {
                T c00, c01, c02, c10, c11, c12, c20, c21, c22;
            }
        }

        this(T c00, T c01, T c02,
             T c10, T c11, T c12,
             T c20, T c21, T c22)
        {
            c[0][0] = c00;    c[0][1] = c01;    c[0][2] = c02;
            c[1][0] = c10;    c[1][1] = c11;    c[1][2] = c12;
            c[2][0] = c20;    c[2][1] = c21;    c[2][2] = c22;
        }

        this(vec3!(T) c0, vec3!(T) c1, vec3!(T) c2)
        {
            c[0][0] = c0.x;    c[0][1] = c1.x;    c[0][2] = c2.x;
            c[1][0] = c0.y;    c[1][1] = c1.y;    c[1][2] = c2.y;
            c[2][0] = c0.z;    c[2][1] = c1.z;    c[2][2] = c2.z;
        }

        this(T x)
        {
            this(x, x, x, x, x, x, x, x, x);
        }

        vec3!(T) c0() { return vec3!(T)(c[0][0], c[1][0], c[2][0]); }
        vec3!(T) c1() { return vec3!(T)(c[0][1], c[1][1], c[2][1]); }
        vec3!(T) c2() { return vec3!(T)(c[0][2], c[1][2], c[2][2]); }

        vec3!(T) l0() { return vec3!(T)(c[0][0], c[0][1], c[0][2]); }
        vec3!(T) l1() { return vec3!(T)(c[1][0], c[1][1], c[1][2]); }
        vec3!(T) l2() { return vec3!(T)(c[2][0], c[2][1], c[2][2]); }

        final mat3!(U) to(U)()
        {
            return mat3!(U)(cast(U)c00, cast(U)c01, cast(U)c02,
                            cast(U)c10, cast(U)c11, cast(U)c12,
                            cast(U)c20, cast(U)c21, cast(U)c22);
        }


        mat3 opMul(mat3 m) {

            return mat3(
                c[0][0] * m.c[0][0] + c[0][1] * m.c[1][0] + c[0][2] * m.c[2][0],
                c[0][0] * m.c[0][1] + c[0][1] * m.c[1][1] + c[0][2] * m.c[2][1],
                c[0][0] * m.c[0][2] + c[0][1] * m.c[1][2] + c[0][2] * m.c[2][2],

                c[1][0] * m.c[0][0] + c[1][1] * m.c[1][0] + c[1][2] * m.c[2][0],
                c[1][0] * m.c[0][1] + c[1][1] * m.c[1][1] + c[1][2] * m.c[2][1],
                c[1][0] * m.c[0][2] + c[1][1] * m.c[1][2] + c[1][2] * m.c[2][2],

                c[2][0] * m.c[0][0] + c[2][1] * m.c[1][0] + c[2][2] * m.c[2][0],
                c[2][0] * m.c[0][1] + c[2][1] * m.c[1][1] + c[2][2] * m.c[2][1],
                c[2][0] * m.c[0][2] + c[2][1] * m.c[1][2] + c[2][2] * m.c[2][2]
            );

        }

        vec3!(T) opMul(vec3!(T) v)
        {
            return vec3!(T)
            (
                c[0][0] * v.v[0] + c[0][1] * v.v[1] + c[0][2] * v.v[2],
                c[1][0] * v.v[0] + c[1][1] * v.v[1] + c[1][2] * v.v[2],
                c[2][0] * v.v[0] + c[2][1] * v.v[1] + c[2][2] * v.v[2]
            );
        }

        vec2!(T) opMul(vec2!(T) v)
        {
            vec3!(T) p = this * vec3!(T)(v, 1);
            return p.xy / p.z;
        }

        // multiply a AABB by a matrix and return a larger AABB
        box2!(T) opMul(box2!(T) bb)
        {
            vec2!(T) a = this * vec2!(T)(bb.xmin, bb.ymin);
            vec2!(T) b = this * vec2!(T)(bb.xmax, bb.ymin);
            vec2!(T) c = this * vec2!(T)(bb.xmax, bb.ymax);
            vec2!(T) d = this * vec2!(T)(bb.xmin, bb.ymax);

            vec2!(T) m = min2(min2(a, b), min2(c, d));
            vec2!(T) M = max2(max2(a, b), max2(c, d));

            return box2!(T)(m, M);
        }

        // multiply a AABB by a matrix and return a larger AABB
        box3!(T) opMul(box3!(T) bb)
        {
            vec3!(T) a = this * vec3!(T)(bb.xmin, bb.ymin, bb.zmin);
            vec3!(T) b = this * vec3!(T)(bb.xmax, bb.ymin, bb.zmin);
            vec3!(T) c = this * vec3!(T)(bb.xmax, bb.ymax, bb.zmin);
            vec3!(T) d = this * vec3!(T)(bb.xmin, bb.ymax, bb.zmin);
            vec3!(T) e = this * vec3!(T)(bb.xmin, bb.ymin, bb.zmax);
            vec3!(T) f = this * vec3!(T)(bb.xmax, bb.ymin, bb.zmax);
            vec3!(T) g = this * vec3!(T)(bb.xmax, bb.ymax, bb.zmax);
            vec3!(T) h = this * vec3!(T)(bb.xmin, bb.ymax, bb.zmax);

            vec3!(T) m = min3(min3(min3(a, b), min3(c, d)), min3(min3(e, f), min3(g, h)));
            vec3!(T) M = max3(max3(max3(a, b), max3(c, d)), max3(max3(e, f), max3(g, h)));

            return box3!(T)(m, M);
        }

        mat3 opMul(T v) {

            return mat3(
                c[0][0] * v,
                c[0][1] * v,
                c[0][2] * v,
                c[1][0] * v,
                c[1][1] * v,
                c[1][2] * v,
                c[2][0] * v,
                c[2][1] * v,
                c[2][2] * v
            );

        }

        mat3 opAdd(mat3 v)
        {
            return mat3(
                c[0][0] + v.c[0][0],
                c[0][1] + v.c[0][1],
                c[0][2] + v.c[0][2],
                c[1][0] + v.c[1][0],
                c[1][1] + v.c[1][1],
                c[1][2] + v.c[1][2],
                c[2][0] + v.c[2][0],
                c[2][1] + v.c[2][1],
                c[2][2] + v.c[2][2]
            );
        }

        mat3 opSub(mat3 v)
        {
            return mat3(
                c[0][0] - v.c[0][0],
                c[0][1] - v.c[0][1],
                c[0][2] - v.c[0][2],
                c[1][0] - v.c[1][0],
                c[1][1] - v.c[1][1],
                c[1][2] - v.c[1][2],
                c[2][0] - v.c[2][0],
                c[2][1] - v.c[2][1],
                c[2][2] - v.c[2][2]
            );
        }


        mat3 opAddAssign(mat3 v)
        {
            c[0][0] += v.c[0][0];
            c[0][1] += v.c[0][1];
            c[0][2] += v.c[0][2];
            c[1][0] += v.c[1][0];
            c[1][1] += v.c[1][1];
            c[1][2] += v.c[1][2];
            c[2][0] += v.c[2][0];
            c[2][1] += v.c[2][1];
            c[2][2] += v.c[2][2];
            return this;
        }


        mat3 opSubAssign(mat3 v)
        {
            c[0][0] -= v.c[0][0];
            c[0][1] -= v.c[0][1];
            c[0][2] -= v.c[0][2];
            c[1][0] -= v.c[1][0];
            c[1][1] -= v.c[1][1];
            c[1][2] -= v.c[1][2];
            c[2][0] -= v.c[2][0];
            c[2][1] -= v.c[2][1];
            c[2][2] -= v.c[2][2];
            return this;
        }
        /*
        mat3 opMulAssign(mat3 v)
        {
            mat3 m = *this * v;
            return *this = m;
        }*/

        mat3 transposed()
        {
            return mat3
            (
                c[0][0], c[1][0], c[2][0],
                c[0][1], c[1][1], c[2][1],
                c[0][2], c[1][2], c[2][2]
            );

        }

        void transpose()
        {
            swap(c[0][1],c[1][0]);
            swap(c[0][2],c[2][0]);
            swap(c[1][2],c[2][1]);
        }

        // orthonormalize a rotation matrix (introduce some error)
        mat3 orthonormalized()
        {
            vec3!(T) right   = vec3!(T)(c[0][0], c[1][0], c[2][0]);
            vec3!(T) up      = vec3!(T)(c[0][1], c[1][1], c[2][1]);
            vec3!(T) forward = vec3!(T)(c[0][2], c[1][2], c[2][2]);
            right.normalize;
            up.normalize;
            forward.normalize;


            right = vec3!(T).cross(up, forward); // right is normalized
            up = vec3!(T).cross(forward, right);

            return mat3(
                right.x  , up.x , forward.x,
                right.y  , up.y , forward.y,
                right.z  , up.z , forward.z
            );
        }

        void orthonormalize()
        {
            auto nml = orthonormalized;
            this = nml;
        }

        string toString()
        {
            return format("((%s, %s, %s)\n (%s, %s, %s)\n (%s, %s, %s))",
                          c00, c01, c02, c10, c11, c12, c20, c21, c22);
        }

        static mat3 IDENTITY, ZERO;

        static this()
        {
            ZERO = mat3(0);
            IDENTITY = mat3(1, 0, 0,
                            0, 1, 0,
                            0, 0, 1);
        }


        static {

            mat3 zero()
            {
                return ZERO;
            }

            mat3 identity()
            {
                return IDENTITY;
            }

            mat3 scale(T f)
            {
                return mat3
                (
                    f, 0, 0,
                    0, f, 0,
                    0, 0, 1
                );

            }

            mat3 scale(T x, T y)
            {
                return mat3
                (
                    x, 0, 0,
                    0, y, 0,
                    0, 0, 1
                );

            }

            mat3 scale(vec2!(T) v)
            {
                return mat3
                (
                    v.x,   0,   0,
                      0, v.y,   0,
                      0,   0,   1
                );
            }

            mat3 translate(T x, T y)
            {
                return mat3
                (
                    1, 0, x,
                    0, 1, y,
                    0, 0, 1
                );

            }

            mat3 translate(vec2!(T) v)
            {
                return mat3
                (
                    1, 0, v.x,
                    0, 1, v.y,
                    0, 0, 1
                );
            }

            mat3 rotateX(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat3
                (
                    1,    0,     0,
                    0, cosa, -sina,
                    0, sina,  cosa
                );
            }


            mat3 rotateY(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat3
                (
                    cosa, 0, -sina,
                       0, 1,     0,
                    sina, 0,  cosa
                );
            }


            mat3 rotateZ(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat3
                (
                    cosa, -sina, 0,
                    sina,  cosa, 0,
                       0,     0, 1
                );
            }
        }
    }
}

alias mat3!(float) mat3f;
alias mat3!(double) mat3d;

static assert(mat3f.sizeof == 9 * float.sizeof);
static assert(mat3d.sizeof == 9 * double.sizeof);
