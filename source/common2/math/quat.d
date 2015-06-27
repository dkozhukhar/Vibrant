module math.quat;

import math.common;
import math.mat3;
import math.mat4;
import math.vec3;
import math.vec4;
import std.string;

struct quat(T)
{
    public
    {
        union
        {
            struct
            {
                T w, x, y, z;
            }
            T[4] v;
        }

        alias std.string.format format;

        //////////////////
        // constructors //
        //////////////////

        static quat opCall(T w, T x, T y, T z)
        {
            quat q = void;
            q.w = w;
            q.x = x;
            q.y = y;
            q.z = z;
            return q;
        }

        static quat opCall(vec4!(T) a)
        {
            return quat(a.w, a.x, a.y, a.z);
        }

        quat conj()
        {
            return quat(w, -x, -y, -z);
        }

        // from axis

        static quat opCall(vec3!(T) axis, T angle)
        {
            T cos_a = void,
              sin_a = void;
            sincos(angle * cast(T)0.5, sin_a, cos_a);
            quat q = quat(cos_a, sin_a * axis.x, sin_a * axis.y, sin_a * axis.z);
            q.normalize();
            return q;
        }

        static quat ONE;
        shared static this()
        {
            ONE = quat(1, 0, 0, 0);
        }

        //////////////////////////
        // operator overloading    //
        //////////////////////////

        quat opMul(quat q)
        {
            return quat(w * q.w - x * q.x - y * q.y - z * q.z,
                        w * q.x + x * q.w + y * q.z - z * q.y,
                        w * q.y + y * q.w + z * q.x - x * q.z,
                        w * q.z + z * q.w + x * q.y - y * q.x);
        }

        quat opMul(T a)
        {
            return quat(w * a, x * a, y * a, z * a);
        }


        void opMulAssign(quat q)
        {
            T nw = w * q.w - x * q.x - y * q.y - z * q.z,
              nx = w * q.x + x * q.w + y * q.z - z * q.y,
              ny = w * q.y + y * q.w + z * q.x - x * q.z,
              nz = w * q.z + z * q.w + x * q.y - y * q.x;
            w = nw;
            x = nx;
            y = ny;
            z = nz;
        }

        void opMulAssign(T a)
        {
            w *= a;
            x *= a;
            y *= a;
            z *= a;
        }

        T squaredLength()
        {
            return ( x * x + y * y + z * z + w * w );
        }

        T length()
        {
            return cast(T) sqrt( cast(real) (x * x + y * y + z * z + w * w) );
        }

        void normalize()
        {
            static if (is(T : int))
            {
                static assert(false); // make no sense on integers
            } else
            {
                T l2 = squaredLength();
                if (abs(1 - l2) > T.epsilon)
                {
                    T rsqrt = cast(T) (1 / l2);
                    this *= rsqrt;
                }
            }

        }

        quat normalized()
        {
            quat v = this;
            v.normalize();
            return v;
        }

        mat3!(T) toMat3()
        {
            T xx = x * x,
              xy = x * y,
              xz = x * z,
              xw = x * w,
              yy = y * y,
              yz = y * z,
              yw = y * w,
              zz = z * z,
              zw = z * w;
            return mat3!(T)
            (
                1 - 2 * (yy + zz)    , 2 * (xy - zw)        , 2 * (xz + yw)    ,
                2 * (xy + zw)        , 1 - 2 * (xx + zz)    , 2 * (yz - xw)    ,
                2 * (xz - yw)        , 2 * (yz + xw)     , 1 - 2 * (xx + yy)
            );
        }

        mat4!(T) toMat4()
        {
            T xx = x * x,
              xy = x * y,
              xz = x * z,
              xw = x * w,
              yy = y * y,
              yz = y * z,
              yw = y * w,
              zz = z * z,
              zw = z * w;
            return mat4!(T)
            (
                1 - 2 * (yy + zz)    , 2 * (xy - zw)        , 2 * (xz + yw)        ,     0 ,
                2 * (xy + zw)        , 1 - 2 * (xx + zz)    , 2 * (yz - xw)        ,    0 ,
                2 * (xz - yw)        , 2 * (yz + xw)     , 1 - 2 * (xx + yy)    ,    0 ,
                0                    , 0                    , 0                    ,    1
            );
        }

        string toString()
        {
            return format("( %s , %s , %s , %s )", w, x, y, z);
        }
    }
}

alias quat!(float) quatf;
alias quat!(double) quatd;
