module map;

import math.common;
import math.vec2;
import math.random;
import futils;

class Map
{
    public
    {
        // return the size of the map (which is a square)
        float size()
        {
            return SIZEOFMAP;
        }

        // returns a random point in the map
        vec2f randomPoint()
        {
            return vec2f(random.nextFloat2 * SIZEOFMAP, random.nextFloat2 * SIZEOFMAP);
        }

        // ensure an object is inside bounds
        void enforceBounds(ref vec2f pos, float radius)
        {
            float m = SIZEOFMAP - radius;
            if (m < 0.f) m = 0.f;
            int res = 0;
            if (pos.x < -m)
            {
                pos.x = -m;
                res = 0;
            }
            else if (pos.x > m)
            {
                pos.x = m;
                res = 0;
            }
            if (pos.y < -m)
            {
                pos.y = -m;
                res = 0;
            }
            else if (pos.y > m)
            {
                pos.y = m;
                res = 0;
            }
        }

        // ensure an object is inside bounds
        // and make it bounce
        int enforceBounds(ref vec2f pos, ref vec2f mov, float radius, float bounce, float constantBounce)
        {
            float m = SIZEOFMAP - radius;
            if (m < 0.f) m = 0.f;

            int res = 0;
            if (pos.x < -m)
            {
                pos.x = -m;
                mov.x = -mov.x * bounce + constantBounce;
                res++;
            }
            else if (pos.x > m)
            {
                pos.x = m;
                mov.x = -mov.x * bounce - constantBounce;
                res++;
            }
            if (pos.y < -m)
            {
                pos.y = -m;
                mov.y = -mov.y * bounce + constantBounce;
                res++;
            }
            else if (pos.y > m)
            {
                pos.y = m;
                mov.y = -mov.y * bounce - constantBounce;
                res++;
            }
            return res;
        }

        // ensure an object is inside bounds
        // and make it bounce, and turn its angle
        int enforceBounds(ref vec2f pos, ref vec2f mov, ref float angle,
                          float radius, float bounce, float constantBounce)
        {
            float m = SIZEOFMAP - radius;
            if (m < 0.f) m = 0.f;

            int res = 0;

            if (pos.x < -m)
            {
                pos.x = -m;
                mov.x = - mov.x * bounce + constantBounce;
                res++;
                if (abs(angle)> PI_2_F) angle = PI_F - angle;
            }
            else if (pos.x > m)
            {
                pos.x = m;
                mov.x = - mov.x * bounce - constantBounce;
                res++;
                if (abs(angle)< PI_2_F) angle = PI_F - angle;
            }

            if (pos.y < -m)
            {
                pos.y = -m;
                mov.y = -mov.y*bounce + constantBounce;
                res++;
                if (angle < 0.0 ) angle = TAU_F - angle;

            }
            else if (pos.y > m)
            {
                pos.y = m;
                mov.y = -mov.y*bounce - constantBounce;
                res++;
                if (angle > 0.0) angle = TAU_F - angle;
            }

            return res;
        }

        this()
        {
            random = Random();
        }
    }

    private
    {
        const float SIZEOFMAP = 3000;
        Random random;
    }
}

Map gmap;

static this()
{
    gmap = new Map();
}
