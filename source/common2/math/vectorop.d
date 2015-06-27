module math.vectorop;

// common code to vec2, vec3 and vec4. Used as a mixin

import math.common : sqrt, abs;

template VectorOp(T, alias V)
{
    alias typeof(this) VEC;

    public
    {
        final T * ptr()
        {
            return V.ptr;
        }
/*
        VEC dup()
        {
            return this; // because vectors are value types
        }*/

        T opIndex(size_t index)
        {
            return v[index];
        }

        T opIndexAssign(T value, size_t index)
        {
            return v[index] = value;
        }

        T squaredLength()
        {
            T res = 0;
            for (int i = 0; i < V.length; i++)
            {
                res += ( V[i] * V[i] );
            }
            return res;
        }

        T squaredDistanceTo(VEC v)
        {
            VEC u = v - this;
            return u.squaredLength();
        }

        T dot(VEC u)
        {
            T res = 0;
            for (int i = 0; i < V.length; i++)
            {
                res += ( V[i] * u[i]);
            }
            return res;
        }

        static if (is(T : float) || is(T : double)  || is(T : real) ) // make no sense on integers
        {
            T length()
            {
                return cast(T) math.common.sqrt( squaredLength() );
            }

            void normalize()
            {
                T l2 = length();
                T rsqrt = 1 / l2;
                this *= rsqrt;
            }

            VEC normalized()
            {
                VEC v = this;
                v.normalize();
                return v;
            }

            T distanceTo(VEC v)
            {
                return cast(T) math.common.sqrt(squaredDistanceTo(v));
            }
        }
    }
}
