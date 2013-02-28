module map;

import math.all;
import camera, palettes;
import vga2d;
import utils;

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

void ground(Camera camera)
{
    void eclairs(vec2f a, vec2f b)
    {        

        if (!camera.canSee(a) && !camera.canSee(b))
            return;

        float d = a.distanceTo(b);
        float t = 0;

        GL.begin(GL.LINE_STRIP);

        vertexf(a);
        while (t < 1.f)
        {
            vec2f pt = t * b + (1 - t) * a;
            vec2f p = pt + vec2f(random.nextFloat2 * random.nextFloat2 , random.nextFloat2 * random.nextFloat2) * 5.f;

            vertexf(p);

            t = t + 5.f / d;
        }
        vertexf(b);
        GL.end();
    }

    GL.color = RGBAF(0xff4040c0);
    auto SOM = gmap.size();
    int som = round(SOM / 200.f);
    for(int i = -som; i < som; ++i)
    {
        eclairs(vec2f(i*200.f, SOM), vec2f((i+1)*200, SOM));
        eclairs( vec2f(i*200.f, -SOM), vec2f((i+1)*200, -SOM));
        eclairs( vec2f(SOM, i*200.f), vec2f(SOM, (i+1)* 200) );
        eclairs( vec2f(-SOM, i*200.f), vec2f(-SOM, (i+1)* 200));
    }

    //setCurrentColor = 0xff404040;
    GL.lineWidth(3);
    GL.begin(GL.LINES);
    GL.color = 0.40f * vec3f(0.13,0.13,0.25);
    for(int i = -som + 1; i < som; ++i)
    {
        vertexf(i * 200, SOM);
        vertexf(i * 200, -SOM);
    }
    for(int i = -som + 1; i < som; ++i)
    {
        vertexf(SOM, i * 200);
        vertexf(-SOM, i * 200);
    }
    GL.end();

}