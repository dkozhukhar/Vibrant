module math.mat4;

import math.common;
import std.string;// : format, toString;
import math.vec2;
import math.vec3;
import math.vec4;
import math.mat3;
import math.box3;


struct mat4(T)
{
    private
    {
        T minor (int r0, int r1, int r2, int c0, int c1, int c2)
        {
            return c[r0][c0] * (c[r1][c1] * c[r2][c2] - c[r2][c1] * c[r1][c2]) -
                   c[r0][c1] * (c[r1][c0] * c[r2][c2] - c[r2][c0] * c[r1][c2]) +
                   c[r0][c2] * (c[r1][c0] * c[r2][c1] - c[r2][c0] * c[r1][c1]);
        }
    }

    public
    {
        union
        {
            T[4][4] c;
            T[16] v;
            struct
            {
                T c00, c01, c02, c03,
                  c10, c11, c12, c13,
                  c20, c21, c22, c23,
                  c30, c31, c32, c33;
              }
        }

        this(T c00, T c01, T c02, T c03,
                           T c10, T c11, T c12, T c13,
                           T c20, T c21, T c22, T c23,
                           T c30, T c31, T c32, T c33)
        {
            c[0][0] = c00;    c[0][1] = c01;    c[0][2] = c02;    c[0][3] = c03;
            c[1][0] = c10;    c[1][1] = c11;    c[1][2] = c12;    c[1][3] = c13;
            c[2][0] = c20;    c[2][1] = c21;    c[2][2] = c22;    c[2][3] = c23;
            c[3][0] = c30;    c[3][1] = c31;    c[3][2] = c32;    c[3][3] = c33;
        }

        this(vec4!(T) c0, vec4!(T) c1, vec4!(T) c2, vec4!(T) c3)
        {
            c[0][0] = c0.x;    c[0][1] = c1.x;    c[0][2] = c2.x;    c[0][3] = c3.x;
            c[1][0] = c0.y;    c[1][1] = c1.y;    c[1][2] = c2.y;    c[1][3] = c3.y;
            c[2][0] = c0.z;    c[2][1] = c1.z;    c[2][2] = c2.z;    c[2][3] = c3.z;
            c[3][0] = c0.w;    c[3][1] = c1.w;    c[3][2] = c2.w;    c[3][3] = c3.w;
        }

        this(T x)
        {
            this(x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x);
        }

        this(mat3!(T) m)
        {
            this(m.c[0][0], m.c[0][1], m.c[0][2], 0,
                 m.c[1][0], m.c[1][1], m.c[1][2], 0,
                 m.c[2][0], m.c[2][1], m.c[2][2], 0,
                 0        , 0        , 0        , 1);
        }

        static mat4 IDENTITY, ZERO;

        static this()
        {
            ZERO = mat4(0);
            IDENTITY = mat4(1, 0, 0, 0,
                            0, 1, 0, 0,
                            0, 0, 1, 0,
                            0, 0, 0, 1);
        }

        final T * ptr()
        {
            return &c[0][0];
        }

        final mat4!(U) to(U)()
        {
            return mat4!(U)(c[0][0], c[0][1], c[0][2], c[0][3],
                            c[1][0], c[1][1], c[1][2], c[1][3],
                            c[2][0], c[2][1], c[2][2], c[2][3],
                            c[3][0], c[3][1], c[3][2], c[3][3]);
        }

        vec4!(T) c0() { return vec4!(T)(c00, c10, c20, c30); }
        vec4!(T) c1() { return vec4!(T)(c01, c11, c21, c31); }
        vec4!(T) c2() { return vec4!(T)(c02, c12, c22, c32); }
        vec4!(T) c3() { return vec4!(T)(c03, c13, c23, c33); }

        vec4!(T) l0() { return vec4!(T)(c00, c01, c02, c03); }
        vec4!(T) l1() { return vec4!(T)(c10, c11, c12, c13); }
        vec4!(T) l2() { return vec4!(T)(c20, c21, c22, c23); }
        vec4!(T) l3() { return vec4!(T)(c30, c31, c32, c33); }

        mat4 opMul(mat4 m) {

            return mat4(
                c[0][0] * m.c[0][0] + c[0][1] * m.c[1][0] + c[0][2] * m.c[2][0] + c[0][3] * m.c[3][0],
                c[0][0] * m.c[0][1] + c[0][1] * m.c[1][1] + c[0][2] * m.c[2][1] + c[0][3] * m.c[3][1],
                c[0][0] * m.c[0][2] + c[0][1] * m.c[1][2] + c[0][2] * m.c[2][2] + c[0][3] * m.c[3][2],
                c[0][0] * m.c[0][3] + c[0][1] * m.c[1][3] + c[0][2] * m.c[2][3] + c[0][3] * m.c[3][3],

                c[1][0] * m.c[0][0] + c[1][1] * m.c[1][0] + c[1][2] * m.c[2][0] + c[1][3] * m.c[3][0],
                c[1][0] * m.c[0][1] + c[1][1] * m.c[1][1] + c[1][2] * m.c[2][1] + c[1][3] * m.c[3][1],
                c[1][0] * m.c[0][2] + c[1][1] * m.c[1][2] + c[1][2] * m.c[2][2] + c[1][3] * m.c[3][2],
                c[1][0] * m.c[0][3] + c[1][1] * m.c[1][3] + c[1][2] * m.c[2][3] + c[1][3] * m.c[3][3],

                c[2][0] * m.c[0][0] + c[2][1] * m.c[1][0] + c[2][2] * m.c[2][0] + c[2][3] * m.c[3][0],
                c[2][0] * m.c[0][1] + c[2][1] * m.c[1][1] + c[2][2] * m.c[2][1] + c[2][3] * m.c[3][1],
                c[2][0] * m.c[0][2] + c[2][1] * m.c[1][2] + c[2][2] * m.c[2][2] + c[2][3] * m.c[3][2],
                c[2][0] * m.c[0][3] + c[2][1] * m.c[1][3] + c[2][2] * m.c[2][3] + c[2][3] * m.c[3][3],

                c[3][0] * m.c[0][0] + c[3][1] * m.c[1][0] + c[3][2] * m.c[2][0] + c[3][3] * m.c[3][0],
                c[3][0] * m.c[0][1] + c[3][1] * m.c[1][1] + c[3][2] * m.c[2][1] + c[3][3] * m.c[3][1],
                c[3][0] * m.c[0][2] + c[3][1] * m.c[1][2] + c[3][2] * m.c[2][2] + c[3][3] * m.c[3][2],
                c[3][0] * m.c[0][3] + c[3][1] * m.c[1][3] + c[3][2] * m.c[2][3] + c[3][3] * m.c[3][3]
            );

        }

        vec4!(T) opMul(vec4!(T) v) {

            return vec4!(T)(
                c[0][0] * v.v[0] + c[0][1] * v.v[1] + c[0][2] * v.v[2] + c[0][3] * v.v[3],
                c[1][0] * v.v[0] + c[1][1] * v.v[1] + c[1][2] * v.v[2] + c[1][3] * v.v[3],
                c[2][0] * v.v[0] + c[2][1] * v.v[1] + c[2][2] * v.v[2] + c[2][3] * v.v[3],
                c[3][0] * v.v[0] + c[3][1] * v.v[1] + c[3][2] * v.v[2] + c[3][3] * v.v[3]
            );
        }

        vec3!(T) opMul(vec3!(T) v)
        {
            vec4!(T) p = this * vec4!(T)(v, 1);
            return p.xyz / p.w;
        }

        /**
         * Multiply a AABB by a matrix and return a larger AABB
         * Allow perspective transformations.
         */
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

        mat4 opMul(T v) {

            return mat4(
                c[0][0] * v,
                c[0][1] * v,
                c[0][2] * v,
                c[0][3] * v,
                c[1][0] * v,
                c[1][1] * v,
                c[1][2] * v,
                c[1][3] * v,
                c[2][0] * v,
                c[2][1] * v,
                c[2][2] * v,
                c[2][3] * v,
                c[3][0] * v,
                c[3][1] * v,
                c[3][2] * v,
                c[3][3] * v
            );
        }

        mat4 opAdd(mat4 v) {

            return mat4(
                c[0][0] + v.c[0][0],
                c[0][1] + v.c[0][1],
                c[0][2] + v.c[0][2],
                c[0][3] + v.c[0][3],
                c[1][0] + v.c[1][0],
                c[1][1] + v.c[1][1],
                c[1][2] + v.c[1][2],
                c[1][3] + v.c[1][3],
                c[2][0] + v.c[2][0],
                c[2][1] + v.c[2][1],
                c[2][2] + v.c[2][2],
                c[2][3] + v.c[2][3],
                c[3][0] + v.c[3][0],
                c[3][1] + v.c[3][1],
                c[3][2] + v.c[3][2],
                c[3][3] + v.c[3][3]
            );

        }

        mat4 opSub(mat4 v) {

            return mat4(
                c[0][0] - v.c[0][0],
                c[0][1] - v.c[0][1],
                c[0][2] - v.c[0][2],
                c[0][3] - v.c[0][3],
                c[1][0] - v.c[1][0],
                c[1][1] - v.c[1][1],
                c[1][2] - v.c[1][2],
                c[1][3] - v.c[1][3],
                c[2][0] - v.c[2][0],
                c[2][1] - v.c[2][1],
                c[2][2] - v.c[2][2],
                c[2][3] - v.c[2][3],
                c[3][0] - v.c[3][0],
                c[3][1] - v.c[3][1],
                c[3][2] - v.c[3][2],
                c[3][3] - v.c[3][3]
            );

        }


        void opAddAssign(mat4 v) {

            c[0][0] += v.c[0][0];
            c[0][1] += v.c[0][1];
            c[0][2] += v.c[0][2];
            c[0][3] += v.c[0][3];
            c[1][0] += v.c[1][0];
            c[1][1] += v.c[1][1];
            c[1][2] += v.c[1][2];
            c[1][3] += v.c[1][3];
            c[2][0] += v.c[2][0];
            c[2][1] += v.c[2][1];
            c[2][2] += v.c[2][2];
            c[2][3] += v.c[2][3];
            c[3][0] += v.c[3][0];
            c[3][1] += v.c[3][1];
            c[3][2] += v.c[3][2];
            c[3][3] += v.c[3][3];

        }


        void opSubAssign(mat4 v) {

            c[0][0] -= v.c[0][0];
            c[0][1] -= v.c[0][1];
            c[0][2] -= v.c[0][2];
            c[0][3] -= v.c[0][3];
            c[1][0] -= v.c[1][0];
            c[1][1] -= v.c[1][1];
            c[1][2] -= v.c[1][2];
            c[1][3] -= v.c[1][3];
            c[2][0] -= v.c[2][0];
            c[2][1] -= v.c[2][1];
            c[2][2] -= v.c[2][2];
            c[2][3] -= v.c[2][3];
            c[3][0] -= v.c[3][0];
            c[3][1] -= v.c[3][1];
            c[3][2] -= v.c[3][2];
            c[3][3] -= v.c[3][3];

        }

        mat4 transposed() {

            return mat4(
                c[0][0], c[1][0], c[2][0], c[3][0],
                c[0][1], c[1][1], c[2][1], c[3][1],
                c[0][2], c[1][2], c[2][2], c[3][2],
                c[0][3], c[1][3], c[2][3], c[3][3]
            );

        }

        /**
         * in-place transpose
         */
        void transpose()
        {
            swap(c[0][1],c[1][0]);
            swap(c[0][2],c[2][0]);
            swap(c[0][3],c[3][0]);
            swap(c[1][2],c[2][1]);
            swap(c[1][3],c[3][1]);
            swap(c[2][3],c[3][2]);
        }




        T determinant() {

            return c[0][0] * minor( 1, 2, 3, 1, 2, 3) -
                   c[0][1] * minor( 1, 2, 3, 0, 2, 3) +
                   c[0][2] * minor( 1, 2, 3, 0, 1, 3) -
                   c[0][3] * minor( 1, 2, 3, 0, 1, 2);

        }


        mat4 adjoint() {

            return mat4(
                minor( 1, 2, 3, 1, 2, 3),
                -minor( 0, 2, 3, 1, 2, 3),
                minor( 0, 1, 3, 1, 2, 3),
                -minor( 0, 1, 2, 1, 2, 3),

                -minor( 1, 2, 3, 0, 2, 3),
                minor( 0, 2, 3, 0, 2, 3),
                -minor( 0, 1, 3, 0, 2, 3),
                minor( 0, 1, 2, 0, 2, 3),

                minor( 1, 2, 3, 0, 1, 3),
                -minor( 0, 2, 3, 0, 1, 3),
                minor( 0, 1, 3, 0, 1, 3),
                -minor( 0, 1, 2, 0, 1, 3),

                -minor( 1, 2, 3, 0, 1, 2),
                minor( 0, 2, 3, 0, 1, 2),
                -minor( 0, 1, 3, 0, 1, 2),
                minor( 0, 1, 2, 0, 1, 2)
            );

        }

        mat4 inversed()
        {
            T det2_01_01 = c[0][0] * c[1][1] - c[0][1] * c[1][0];
            T det2_01_02 = c[0][0] * c[1][2] - c[0][2] * c[1][0];
            T det2_01_03 = c[0][0] * c[1][3] - c[0][3] * c[1][0];
            T det2_01_12 = c[0][1] * c[1][2] - c[0][2] * c[1][1];
            T det2_01_13 = c[0][1] * c[1][3] - c[0][3] * c[1][1];
            T det2_01_23 = c[0][2] * c[1][3] - c[0][3] * c[1][2];

            T det3_201_012 = c[2][0] * det2_01_12 - c[2][1] * det2_01_02 + c[2][2] * det2_01_01;
            T det3_201_013 = c[2][0] * det2_01_13 - c[2][1] * det2_01_03 + c[2][3] * det2_01_01;
            T det3_201_023 = c[2][0] * det2_01_23 - c[2][2] * det2_01_03 + c[2][3] * det2_01_02;
            T det3_201_123 = c[2][1] * det2_01_23 - c[2][2] * det2_01_13 + c[2][3] * det2_01_12;

            double det = - det3_201_123 * c[3][0] + det3_201_023 * c[3][1] - det3_201_013 * c[3][2] + det3_201_012 * c[3][3];
            assert(abs(det) > T.epsilon);

            double invDet = 1 / det;

            T det2_03_01 = c[0][0] * c[3][1] - c[0][1] * c[3][0];
            T det2_03_02 = c[0][0] * c[3][2] - c[0][2] * c[3][0];
            T det2_03_03 = c[0][0] * c[3][3] - c[0][3] * c[3][0];
            T det2_03_12 = c[0][1] * c[3][2] - c[0][2] * c[3][1];
            T det2_03_13 = c[0][1] * c[3][3] - c[0][3] * c[3][1];
            T det2_03_23 = c[0][2] * c[3][3] - c[0][3] * c[3][2];
            T det2_13_01 = c[1][0] * c[3][1] - c[1][1] * c[3][0];
            T det2_13_02 = c[1][0] * c[3][2] - c[1][2] * c[3][0];
            T det2_13_03 = c[1][0] * c[3][3] - c[1][3] * c[3][0];
            T det2_13_12 = c[1][1] * c[3][2] - c[1][2] * c[3][1];
            T det2_13_13 = c[1][1] * c[3][3] - c[1][3] * c[3][1];
            T det2_13_23 = c[1][2] * c[3][3] - c[1][3] * c[3][2];

            T det3_203_012 = c[2][0] * det2_03_12 - c[2][1] * det2_03_02 + c[2][2] * det2_03_01;
            T det3_203_013 = c[2][0] * det2_03_13 - c[2][1] * det2_03_03 + c[2][3] * det2_03_01;
            T det3_203_023 = c[2][0] * det2_03_23 - c[2][2] * det2_03_03 + c[2][3] * det2_03_02;
            T det3_203_123 = c[2][1] * det2_03_23 - c[2][2] * det2_03_13 + c[2][3] * det2_03_12;

            T det3_213_012 = c[2][0] * det2_13_12 - c[2][1] * det2_13_02 + c[2][2] * det2_13_01;
            T det3_213_013 = c[2][0] * det2_13_13 - c[2][1] * det2_13_03 + c[2][3] * det2_13_01;
            T det3_213_023 = c[2][0] * det2_13_23 - c[2][2] * det2_13_03 + c[2][3] * det2_13_02;
            T det3_213_123 = c[2][1] * det2_13_23 - c[2][2] * det2_13_13 + c[2][3] * det2_13_12;

            T det3_301_012 = c[3][0] * det2_01_12 - c[3][1] * det2_01_02 + c[3][2] * det2_01_01;
            T det3_301_013 = c[3][0] * det2_01_13 - c[3][1] * det2_01_03 + c[3][3] * det2_01_01;
            T det3_301_023 = c[3][0] * det2_01_23 - c[3][2] * det2_01_03 + c[3][3] * det2_01_02;
            T det3_301_123 = c[3][1] * det2_01_23 - c[3][2] * det2_01_13 + c[3][3] * det2_01_12;

            mat4 res = void;
            res.c[0][0] = - det3_213_123 * invDet;
            res.c[1][0] = + det3_213_023 * invDet;
            res.c[2][0] = - det3_213_013 * invDet;
            res.c[3][0] = + det3_213_012 * invDet;

            res.c[0][1] = + det3_203_123 * invDet;
            res.c[1][1] = - det3_203_023 * invDet;
            res.c[2][1] = + det3_203_013 * invDet;
            res.c[3][1] = - det3_203_012 * invDet;

            res.c[0][2] = + det3_301_123 * invDet;
            res.c[1][2] = - det3_301_023 * invDet;
            res.c[2][2] = + det3_301_013 * invDet;
            res.c[3][2] = - det3_301_012 * invDet;

            res.c[0][3] = - det3_201_123 * invDet;
            res.c[1][3] = + det3_201_023 * invDet;
            res.c[2][3] = - det3_201_013 * invDet;
            res.c[3][3] = + det3_201_012 * invDet;
            return res;
        }

        // orthonormalize a rotation matrix (introduce some error)
        mat4 orthonormalized()
        {
            vec3!(T) right   = vec3!(T)(c[0][0], c[1][0], c[2][0]);
            vec3!(T) up      = vec3!(T)(c[0][1], c[1][1], c[2][1]);
            vec3!(T) forward = vec3!(T)(c[0][2], c[1][2], c[2][2]);

            right.normalize();
            up.normalize();
            forward.normalize();

            right = vec3!(T).cross(up, forward); // right is normalized
            up = vec3!(T).cross(forward, right);

            return mat4(
                right.x  , up.x , forward.x, 0,
                right.y  , up.y , forward.y, 0,
                right.z  , up.z , forward.z, 0,
                0        , 0    , 0        , 1
            );
        }

        void orthonormalize()
        {
            auto nml = orthonormalized;
            this = nml;
        }

        string toString()
        {
            alias std.conv.to!string s;

            return "((" ~ s(c[0][0]) ~ ", " ~ s(c[0][1]) ~ ", " ~ s(c[0][2]) ~ ", " ~ s(c[0][3]) ~ ")\n"
                  ~" (" ~ s(c[1][0]) ~ ", " ~ s(c[1][1]) ~ ", " ~ s(c[1][2]) ~ ", " ~ s(c[1][3]) ~ ")\n"
                  ~" (" ~ s(c[2][0]) ~ ", " ~ s(c[2][1]) ~ ", " ~ s(c[2][2]) ~ ", " ~ s(c[2][3]) ~ ")\n"
                  ~" (" ~ s(c[3][0]) ~ ", " ~ s(c[3][1]) ~ ", " ~ s(c[3][2]) ~ ", " ~ s(c[3][3]) ~ "))";
        }

        // "basic" matrices used in 3D
        static
        {

            mat4 scale(vec3!(T) v)
            {

                return mat4(
                    v.x,   0,   0, 0,
                      0, v.y,   0, 0,
                      0,   0, v.z, 0,
                      0,   0,   0, 1
                );

            }

            mat4 scale(T x, T y, T z)
            {

                return mat4(
                    x, 0, 0, 0,
                    0, y, 0, 0,
                    0, 0, z, 0,
                    0, 0, 0, 1
                );

            }

            mat4 scale(T x)
            {
                return scale(x, x, x);
            }

            // any use case ?
        /*
            mat4 scale(vec4!(T) v) {

                return mat4(
                    v.x,   0,   0, 0,
                      0, v.y,   0, 0,
                      0,   0, v.z, 0,
                      0,   0,   0, v.w
                );
            }
            */

            mat4 translate(T x, T y, T z)
            {
                return mat4(
                    1, 0, 0, x,
                    0, 1, 0, y,
                    0, 0, 1, z,
                    0, 0, 0, 1
                );
            }

            mat4 translate(vec3!(T) v)
            {
                return mat4(
                    1, 0, 0, v.x,
                    0, 1, 0, v.y,
                    0, 0, 1, v.z,
                    0, 0, 0, 1
                );
            }

            mat4 identity()
            {
                return IDENTITY;
            }

            mat4 zero()
            {
                return ZERO;
            }

            mat4 rotateX(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat4(
                    1,    0,     0, 0,
                    0, cosa, -sina, 0,
                    0, sina,  cosa, 0,
                    0,    0,     0, 1
                );
            }


            mat4 rotateY(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat4(
                    cosa, 0, -sina, 0,
                       0, 1,     0, 0,
                    sina, 0,  cosa, 0,
                       0, 0,     0, 1
                );
            }


            mat4 rotateZ(T angle)
            {
                T cosa = void;
                T sina = void;
                sincos(angle, sina, cosa);
                return mat4(
                    cosa, -sina, 0, 0,
                    sina,  cosa, 0, 0,
                       0,     0, 1, 0,
                       0,     0, 0, 1
                );

            }

            // fovy in degree
            mat4 perspective(T fovy, T aspect, T zNear, T zFar)
            {
                T f = 1 / tan( fovy * PI_D / 360);
                T d = 1 / (zNear - zFar);

                return mat4(
                    f / aspect, 0,                  0,                    0,
                             0, f,                  0,                    0,
                             0, 0, (zFar + zNear) * d, 2 * d * zFar * zNear,
                             0, 0,                 -1,                    0
                );
            }


            // use it to set up a camera (seems to work but could be inverted)
            mat4 lookAt(vec3!(T)eye, vec3!(T)center, vec3!(T)up)
            {
                auto f = (center - eye).normalized();
                auto upp = up.normalized();
                auto s = vec3!(T).cross(f, upp);
                auto u = vec3!(T).cross(s, f);


                auto rot =
                mat4(
                    -s.x, u.x, -f.x, 0,
                    -s.y, u.y, -f.y, 0,
                    -s.z, u.z, -f.z, 0,
                    0  ,   0,    0,  1
                ).transposed();

                auto tr = translate(-eye);

                return rot * tr;
            }




            // ortho
            mat4 ortho(float left, float right, float bottom, float top, float near, float far)
            {
                float dx = right - left,
                      dy = top - bottom,
                      dz = far - near;

                float tx = -(right + left) / dx;
                float ty = -(top + bottom) / dy;
                float tz = -(far + near) / dz;

                return
                mat4(
                    2.0f / dx, 0.0f,      0.0f,      tx,
                    0.0f,      2.0f / dy, 0.0f,      ty,
                    0.0f,      0.0f,      2.0f / dz, tz,
                    0.0f,      0.0f,      0.0f,      1.0f
                );
            }

        }

    }
}

alias mat4!(float) mat4f;
alias mat4!(double) mat4d;

static assert(mat4f.sizeof == 16 * float.sizeof);
static assert(mat4d.sizeof == 16 * double.sizeof);
