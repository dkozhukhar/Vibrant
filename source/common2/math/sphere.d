module math.sphere;

// logical sphere

import math.common;
import math.vec3;
import math.ray;

struct sphere(T)
{
    public
    {
        vec3!(T) center;
        T radius;

        static sphere opCall(vec3!(T) center, T radius)
        {
            sphere s = void;
            s.center = center;
            s.radius = radius;
            return s;
        }

        bool contains(vec3!(T) pt)
        {
            return pt.squaredDistanceTo(pt) < radius * radius;
        }

        bool contains(sphere s)
        {
            return center.distanceTo(s.center) + s.radius < radius;
        }

        bool hit(ray!(T) r, out T distance, out vec3!(T) point, out vec3!(T) normal)
        {
            vec3!(T) R0C = center - r.start;
            T R0C2 = R0C.squaredLength();
            bool inside = (R0C2 <= radius * radius);

            T toc = R0C.dot(r.dir);
            if ((toc < 0) && (!inside))
            {
                return false;
            }

            T D2 = R0C2 - toc * toc;
            T tsc2 = radius * radius - D2;

            if (tsc2 < 0)
            {
                return false;
            }

            T t = toc + (inside ? 1 : -1) * sqrt(tsc2);
            distance = t;
            point = r.progress(t);
            normal = (point - center).normalized;
            return true;
        }

        /**
         * Returns a sphere which contains all its point + this one
         */
        sphere combine(vec3!(T) pt)
        {
            T sd = pt.squaredDistanceTo(center);
            T rad = sd > radius * radius ? cast(T)sqrt(sd) : radius;
            return sphere(center, rad);
        }

        /**
         * Returns a sphere which contains these two sphere
         */
        sphere combine(sphere s)
        {
            assert(false);
        }
    }
}

alias sphere!(float) spheref;
alias sphere!(double) sphered;
