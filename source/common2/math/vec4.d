module math.vec4;

import std.string: format;
//import util.math;
import math.half;
import math.vec2;
import math.vec3;
import math.vectorop;

struct vec4(T)
{
    public
    {
        union
        {
            struct
            {
                T x, y, z, w;
            }
            T[4] v;
        }

        mixin VectorOp!(T, v);

        //////////////////
        // constructors //
        //////////////////

        static vec4 opCall(T x, T y, T z, T w)
        {
            vec4 v = void;
            v.x = x;
            v.y = y;
            v.z = z;
            v.w = w;
            return v;
        }

        static vec4 opCall(T x)
        {
            return vec4(x, x, x, x);
        }

        static vec4 opCall(vec2!(T) v, T z, T w)
        {
            return vec4(v.x, v.y, z, w);
        }

        static vec4 opCall(vec2!(T) v, vec2!(T) v2)
        {
            return vec4(v.x, v.y, v2.x, v2.y);
        }

        static vec4 opCall(vec3!(T) v, T w)
        {
            return vec4(v.x, v.y, v.z, w);
        }

        ///////////////
        // constants //
        ///////////////

        static vec4 ZEROS, ONES;
        static this()
        {
            ZEROS = vec4(cast(T)0);
            ONES = vec4(cast(T)1);
        }


        ///////////////////////////
        // GLSL style properties //
        ///////////////////////////

        vec2!(T) xx() { return vec2!(T)(x, x); }
        vec2!(T) xy() { return vec2!(T)(x, y); }
        vec2!(T) xz() { return vec2!(T)(x, z); }
        vec2!(T) xw() { return vec2!(T)(x, w); }
        vec2!(T) yx() { return vec2!(T)(y, x); }
        vec2!(T) yy() { return vec2!(T)(y, y); }
        vec2!(T) yz() { return vec2!(T)(y, z); }
        vec2!(T) yw() { return vec2!(T)(y, w); }
        vec2!(T) zx() { return vec2!(T)(z, x); }
        vec2!(T) zy() { return vec2!(T)(z, y); }
        vec2!(T) zz() { return vec2!(T)(z, z); }
        vec2!(T) zw() { return vec2!(T)(z, w); }
        vec2!(T) wx() { return vec2!(T)(w, x); }
        vec2!(T) wy() { return vec2!(T)(w, y); }
        vec2!(T) wz() { return vec2!(T)(w, z); }
        vec2!(T) ww() { return vec2!(T)(w, w); }

        vec3!(T) xxx() { return vec3!(T)(x, x, x); }
        vec3!(T) xxy() { return vec3!(T)(x, x, y); }
        vec3!(T) xxz() { return vec3!(T)(x, x, z); }
        vec3!(T) xxw() { return vec3!(T)(x, x, w); }
        vec3!(T) xyx() { return vec3!(T)(x, y, x); }
        vec3!(T) xyy() { return vec3!(T)(x, y, y); }
        vec3!(T) xyz() { return vec3!(T)(x, y, z); }
        vec3!(T) xyw() { return vec3!(T)(x, y, w); }
        vec3!(T) xzx() { return vec3!(T)(x, z, x); }
        vec3!(T) xzy() { return vec3!(T)(x, z, y); }
        vec3!(T) xzz() { return vec3!(T)(x, z, z); }
        vec3!(T) xzw() { return vec3!(T)(x, z, w); }
        vec3!(T) xwx() { return vec3!(T)(x, w, x); }
        vec3!(T) xwy() { return vec3!(T)(x, w, y); }
        vec3!(T) xwz() { return vec3!(T)(x, w, z); }
        vec3!(T) xww() { return vec3!(T)(x, w, w); }

        vec3!(T) yxx() { return vec3!(T)(y, x, x); }
        vec3!(T) yxy() { return vec3!(T)(y, x, y); }
        vec3!(T) yxz() { return vec3!(T)(y, x, z); }
        vec3!(T) yxw() { return vec3!(T)(y, x, w); }
        vec3!(T) yyx() { return vec3!(T)(y, y, x); }
        vec3!(T) yyy() { return vec3!(T)(y, y, y); }
        vec3!(T) yyz() { return vec3!(T)(y, y, z); }
        vec3!(T) yyw() { return vec3!(T)(y, y, w); }
        vec3!(T) yzx() { return vec3!(T)(y, z, x); }
        vec3!(T) yzy() { return vec3!(T)(y, z, y); }
        vec3!(T) yzz() { return vec3!(T)(y, z, z); }
        vec3!(T) yzw() { return vec3!(T)(y, z, w); }
        vec3!(T) ywx() { return vec3!(T)(y, w, x); }
        vec3!(T) ywy() { return vec3!(T)(y, w, y); }
        vec3!(T) ywz() { return vec3!(T)(y, w, z); }
        vec3!(T) yww() { return vec3!(T)(y, w, w); }

        vec3!(T) zxx() { return vec3!(T)(z, x, x); }
        vec3!(T) zxy() { return vec3!(T)(z, x, y); }
        vec3!(T) zxz() { return vec3!(T)(z, x, z); }
        vec3!(T) zxw() { return vec3!(T)(z, x, w); }
        vec3!(T) zyx() { return vec3!(T)(z, y, x); }
        vec3!(T) zyy() { return vec3!(T)(z, y, y); }
        vec3!(T) zyz() { return vec3!(T)(z, y, z); }
        vec3!(T) zyw() { return vec3!(T)(z, y, w); }
        vec3!(T) zzx() { return vec3!(T)(z, z, x); }
        vec3!(T) zzy() { return vec3!(T)(z, z, y); }
        vec3!(T) zzz() { return vec3!(T)(z, z, z); }
        vec3!(T) zzw() { return vec3!(T)(z, z, w); }
        vec3!(T) zwx() { return vec3!(T)(z, w, x); }
        vec3!(T) zwy() { return vec3!(T)(z, w, y); }
        vec3!(T) zwz() { return vec3!(T)(z, w, z); }
        vec3!(T) zww() { return vec3!(T)(z, w, w); }

        vec3!(T) wxx() { return vec3!(T)(w, x, x); }
        vec3!(T) wxy() { return vec3!(T)(w, x, y); }
        vec3!(T) wxz() { return vec3!(T)(w, x, z); }
        vec3!(T) wxw() { return vec3!(T)(w, x, w); }
        vec3!(T) wyx() { return vec3!(T)(w, y, x); }
        vec3!(T) wyy() { return vec3!(T)(w, y, y); }
        vec3!(T) wyz() { return vec3!(T)(w, y, z); }
        vec3!(T) wyw() { return vec3!(T)(w, y, w); }
        vec3!(T) wzx() { return vec3!(T)(w, z, x); }
        vec3!(T) wzy() { return vec3!(T)(w, z, y); }
        vec3!(T) wzz() { return vec3!(T)(w, z, z); }
        vec3!(T) wzw() { return vec3!(T)(w, z, w); }
        vec3!(T) wwx() { return vec3!(T)(w, w, x); }
        vec3!(T) wwy() { return vec3!(T)(w, w, y); }
        vec3!(T) wwz() { return vec3!(T)(w, w, z); }
        vec3!(T) www() { return vec3!(T)(w, w, w); }

        vec2!(T) xy(vec2!(T) v) { x = v.x; y = v.y; return v; }
        vec2!(T) xz(vec2!(T) v) { x = v.x; z = v.y; return v; }
        vec2!(T) xw(vec2!(T) v) { x = v.x; w = v.y; return v; }
        vec2!(T) yx(vec2!(T) v) { y = v.x; x = v.y; return v; }
        vec2!(T) yz(vec2!(T) v) { y = v.x; z = v.y; return v; }
        vec2!(T) yw(vec2!(T) v) { y = v.x; w = v.y; return v; }
        vec2!(T) zx(vec2!(T) v) { z = v.x; x = v.y; return v; }
        vec2!(T) zy(vec2!(T) v) { z = v.x; y = v.y; return v; }
        vec2!(T) zw(vec2!(T) v) { z = v.x; w = v.y; return v; }
        vec2!(T) wx(vec2!(T) v) { w = v.x; x = v.y; return v; }
        vec2!(T) wy(vec2!(T) v) { w = v.x; y = v.y; return v; }
        vec2!(T) wz(vec2!(T) v) { w = v.x; w = v.y; return v; }

        vec3!(T) xyz(vec3!(T) v) { x = v.x; y = v.y; z = v.z; return v; }
        vec3!(T) xyw(vec3!(T) v) { x = v.x; y = v.y; w = v.z; return v; }
        vec3!(T) xzy(vec3!(T) v) { x = v.x; z = v.y; y = v.z; return v; }
        vec3!(T) xzw(vec3!(T) v) { x = v.x; z = v.y; w = v.z; return v; }
        vec3!(T) xwy(vec3!(T) v) { x = v.x; w = v.y; y = v.z; return v; }
        vec3!(T) xwz(vec3!(T) v) { x = v.x; w = v.y; z = v.z; return v; }

        vec3!(T) yxz(vec3!(T) v) { y = v.x; x = v.y; z = v.z; return v; }
        vec3!(T) yxw(vec3!(T) v) { y = v.x; x = v.y; w = v.z; return v; }
        vec3!(T) yzx(vec3!(T) v) { y = v.x; z = v.y; x = v.z; return v; }
        vec3!(T) yzw(vec3!(T) v) { y = v.x; z = v.y; w = v.z; return v; }
        vec3!(T) ywx(vec3!(T) v) { y = v.x; w = v.y; x = v.z; return v; }
        vec3!(T) ywz(vec3!(T) v) { y = v.x; w = v.y; z = v.z; return v; }

        vec3!(T) zxy(vec3!(T) v) { z = v.x; x = v.y; y = v.z; return v; }
        vec3!(T) zxw(vec3!(T) v) { z = v.x; x = v.y; w = v.z; return v; }
        vec3!(T) zyx(vec3!(T) v) { z = v.x; y = v.y; x = v.z; return v; }
        vec3!(T) zyw(vec3!(T) v) { z = v.x; y = v.y; w = v.z; return v; }
        vec3!(T) zwx(vec3!(T) v) { z = v.x; w = v.y; x = v.z; return v; }
        vec3!(T) zwy(vec3!(T) v) { z = v.x; w = v.y; y = v.z; return v; }

        vec3!(T) wxy(vec3!(T) v) { w = v.x; x = v.y; y = v.z; return v; }
        vec3!(T) wxz(vec3!(T) v) { w = v.x; x = v.y; z = v.z; return v; }
        vec3!(T) wyx(vec3!(T) v) { w = v.x; y = v.y; x = v.z; return v; }
        vec3!(T) wyz(vec3!(T) v) { w = v.x; y = v.y; z = v.z; return v; }
        vec3!(T) wzx(vec3!(T) v) { w = v.x; z = v.y; x = v.z; return v; }
        vec3!(T) wzy(vec3!(T) v) { w = v.x; z = v.y; y = v.z; return v; }
    /*
        vec4!(T) xyz(vec4 v) { x = v.x; y = v.y; z = v.z; return v; }
        vec4 xyw(vec4 v) { x = v.x; y = v.y; w = v.z; return v; }
        vec4 xzy(vec4 v) { x = v.x; z = v.y; y = v.z; return v; }
        vec4 xzw(vec4 v) { x = v.x; z = v.y; w = v.z; return v; }
        vec4 xwy(vec4 v) { x = v.x; w = v.y; y = v.z; return v; }
        vec4 xwz(vec4 v) { x = v.x; w = v.y; z = v.z; return v; }*/


        // cast
        final vec4!(U) to(U)()
        {
            return vec4!(U)(cast(U)x, cast(U)y, cast(U)z, cast(U)w);
        }

        //////////////////////////
        // operator overloading    //
        //////////////////////////

        vec4 opAdd(T a)
        {
            return vec4(x + a, y + a, z + a, w + a);
        }

        vec4 opAdd(vec4 v)
        {
            return vec4(x + v.x, y + v.y, z + v.z, w + v.w);
        }

        vec4 opSub(vec4 v)
        {
            return vec4(x - v.x, y - v.y, z - v.z, w - v.w);
        }

        vec4 opSub(T a)
        {
            return vec4(x - a, y - a, z - a, w - a);
        }

        vec4 opSub_r(T a)
        {
            return vec4(a - x, a - y, a - z, a - w);
        }

        vec4 opMul(vec4 v)
        {
            return vec4(x * v.x, y * v.y, z * v.z, w * v.w);
        }


        vec4 opMul(T a)
        {
            return vec4(x * a, y * a, z * a, w * a);
        }

        vec4 opDiv(vec4 v)
        {
            return vec4(x / v.x, y / v.y, z / v.z, w / v.w);
        }

        vec4 opDiv(T a)
        {
            return  vec4(x / a, y / a, z / a, w / a);
        }

        void opAddAssign(T a)
        {
            x += a;
            y += a;
            z += a;
            w += a;
        }

        void opAddAssign(vec4 v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
            w += v.w;
        }

        void opSubAssign(T a)
        {
            x -= a;
            y -= a;
            z -= a;
            w -= a;
        }

        void opSubAssign(vec4 v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
            w -= v.w;
        }


        void opMulAssign(T a)
        {
            x *= a;
            y *= a;
            z *= a;
            w *= a;
        }

        void opMulAssign(vec4 v)
        {
            x *= v.x;
            y *= v.y;
            z *= v.z;
            w *= v.w;
        }


        void opDivAssign(T a)
        {
            x /= a;
            y /= a;
            z /= a;
            w /= a;
        }

        void opDivAssign(vec4 v)
        {
            x /= v.x;
            y /= v.y;
            z /= v.z;
            w /= v.w;
        }

        vec4 opNeg()
        {
            return   vec4(-x, -y, -z, -w);
        }

        string toString()
        {
            return format("( %s , %s , %s , %s )", x, y, z, w);
        }
    }
}

alias vec4!(int) vec4i;
alias vec4!(float) vec4f;
alias vec4!(double) vec4d;

alias vec4!(real) vec4l;
alias vec4!(half) vec4h;


vec4!(T) min4(T)(vec4!(T) a, vec4!(T) b)
{
    T x = math.common.min(a.x, b.x);
    T y = math.common.min(a.y, b.y);
    T z = math.common.min(a.z, b.z);
    T w = math.common.min(a.w, b.w);
    return vec4!(T)(x, y, z, w);
}

vec4!(T) max4(T)(vec4!(T) a, vec4!(T) b)
{
    T x = math.common.max(a.x, b.x);
    T y = math.common.max(a.y, b.y);
    T z = math.common.max(a.z, b.z);
    T w = math.common.max(a.w, b.w);
    return vec4!(T)(x, y, z, w);
}

alias max4!(int) max4i;
alias max4!(float) max4f;
alias max4!(double) max4d;
