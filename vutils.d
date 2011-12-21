module vutils;

import fast32;
import vga2d;
import sdl.all;
import utils, futils;
import globals;
import palettes;
import sdl.all;
import mousex;
import players;
import bullet;
import misc.all;
import math.all;
import powerup;
import sound;
import camera;
import map;


bool keyoff(SDLKey key)
{
    return SDL.instance.keyboard.markAsReleased(key);
}

bool keyon(SDLKey key)
{
    return SDL.instance.keyboard.markAsPressed(key);
}

bool iskeydown(SDLKey key)
{
    return SDL.instance.keyboard.isPressed(key);
}



void Bar(int x, int y, int height, float status, uint c)
{
    mb.drawBox(x-4,y-height-1,x+4,y+2, clwhite);
    int up = y - round((height - 1.f) * clamp(status, 0.f, 1.f));
    if (up >= y) return;
    mb.drawLine(x-2,y,x-2,up, average(c,clblack));
    mb.drawLine(x-1,y,x-1,up, average(average(c,clwhite),clwhite));
    mb.drawLine(x,y,x,up, c);
    mb.drawLine(x+1,y,x+1,up, average(c,clwhite));
    mb.drawLine(x+1,y,x+1,up, average(average(c,clwhite),clwhite));
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
    GL.color = 0.65f * vec3f(0.13,0.13,0.25);
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

void drawMinimap(Camera camera, BulletPool bulletPool)
{
    auto MAP_RADIUS = round(SCREENY * 0.2f);
    auto MAP_X = MAP_RADIUS;
    auto MAP_Y = SCREENY - MAP_RADIUS;
    auto MAP_LIMIT = 2500;
    auto MAP_TRANSLATE_X = MAP_X - (SCREENX >> 1);
    auto MAP_TRANSLATE_Y = (SCREENY >> 1) - MAP_Y;

    if (player is null) return;

    GL.enable(GL.BLEND);
    GL.blend(GL.BlendMode.ADD, GL.BlendFactor.SRC_ALPHA, GL.BlendFactor.ONE_MINUS_SRC_ALPHA);

    pushmatrix;
    loadIdentity;
    scale(2.f / SCREENY, 2.f / SCREENY);

    // clear the minimap zone
    {
        GL.begin(GL.TRIANGLE_FAN);
        GL.color(vec4f(0, 0, 0, 0.5f));
        vertexf(MAP_TRANSLATE_X, MAP_TRANSLATE_Y);
        for (int i = 0; i <= 64; ++i)
        {
            float angle = TAU_F * i / 64.f;
            vertexf(MAP_TRANSLATE_X + MAP_RADIUS * cos(angle), MAP_TRANSLATE_Y + MAP_RADIUS * sin(angle));
        }
        GL.end();
    }

    GL.lineWidth(1);

    // draw borders
    {
        void line(vec2f a, vec2f b)
        {
            float distA = MAP_RADIUS * player.pos.distanceTo(a) / MAP_LIMIT;
            float distB = MAP_RADIUS * player.pos.distanceTo(b) / MAP_LIMIT;
            float angleA = atan2(a.y - player.pos.y, a.x - player.pos.x) - camera.angle - PI_2_F;

            if (!isFinite(angleA)) return;

            float angleB = atan2(b.y - player.pos.y, b.x - player.pos.x) - camera.angle - PI_2_F;
            if (!isFinite(angleB)) return;



            float sA = void, cA = void;
            float sB = void, cB = void;
            sincosf(-angleA, sA, cA);
            sincosf(-angleB, sB, cB);

            vec2f at = vec2f(MAP_TRANSLATE_X + distA * sA, MAP_TRANSLATE_Y + distA * cA);
            vec2f bt = vec2f(MAP_TRANSLATE_X + distB * sB, MAP_TRANSLATE_Y + distB * cB);

            GL.begin(GL.LINE_STRIP);

            for (int i = 0; i <= 10; ++i)
            {

                vec2f pt = at + (bt - at) * 0.1 * i;
                float dist = max(0.f, 0.5f - 2.f * vec2f(MAP_TRANSLATE_X, MAP_TRANSLATE_Y).squaredDistanceTo(pt) / (MAP_RADIUS * MAP_RADIUS));
                GL.color = vec4f(0.5,0.5,0.6, dist);
                vertexf(pt);
            }

            GL.end();
        }

        // only for rectangular maps
        {
            float M = gmap.size();
            {
                float d = abs(player.pos.x - M);
                if (d < MAP_LIMIT)
                {
                    float dist = sqrtf(sqrf(MAP_LIMIT) - sqrf(d));
                    float ymin = maxf(-M, player.pos.y - dist);
                    float ymax = minf(+M, player.pos.y + dist);
                    line(vec2f(M, ymin), vec2f(M, ymax));
                }
            }
            {
                float d = abs(player.pos.x + M);
                if (d < MAP_LIMIT)
                {
                    float dist = sqrtf(sqrf(MAP_LIMIT) - sqrf(d));
                    float ymin = maxf(-M, player.pos.y - dist);
                    float ymax = minf(+M, player.pos.y + dist);
                    line(vec2f(-M, ymin), vec2f(-M, ymax));
                }
            }
            {
                float d = abs(player.pos.y - M);
                if (d < MAP_LIMIT)
                {
                    float dist = sqrtf(sqrf(MAP_LIMIT) - sqrf(d));
                    float xmin = maxf(-M, player.pos.x - dist);
                    float xmax = minf(+M, player.pos.x + dist);
                    line(vec2f(xmin, M), vec2f(xmax, M));
                }
            }
            {
                float d = abs(player.pos.y + M);
                if (d < MAP_LIMIT)
                {
                    float dist = sqrtf(sqrf(MAP_LIMIT) - sqrf(d));
                    float xmin = maxf(-M, player.pos.x - dist);
                    float xmax = minf(+M, player.pos.x + dist);
                    line(vec2f(xmin, -M), vec2f(xmax, -M));
                }
            }

        }


    }



    // draw AIs
    for (int i = 0; i < ia.length; ++i)
    if ((ia[i] !is null) && (!ia[i].dead))
    with(ia[i])
    {

        float d = player.pos.distanceTo(pos);

        // fix for seeing out-of-reach players
        if (d >= MAP_LIMIT - 200) d = MAP_LIMIT - 200;

        if (d <= MAP_LIMIT)
        {
            float a = atan2(pos.y - player.pos.y, pos.x - player.pos.x) - camera.angle - PI_2_F;

            if (isFinite(a))
            {
                pushmatrix;

                GL.color = ia[i].maincolor();
                vga2d.translate(MAP_TRANSLATE_X,MAP_TRANSLATE_Y);
                rotate(-a);
                vga2d.translate(0,MAP_RADIUS * d / MAP_LIMIT);
                rotate(a);
                GL.begin(GL.LINES);
                vertexf(-5,0);
                vertexf(5,0);
                vertexf(0,-5);
                vertexf(0,5);
                GL.end();
                popmatrix;
            }
        }
    }

    // draw bullets
    GL.pointSize(1);
    GL.begin(GL.POINTS);
    for (int i = 0; i < bulletPool.length; ++i)
    {
        Bullet* bullet = bulletPool.item(i);

        float sqrd = player.pos.squaredDistanceTo(bullet.pos);

        if (sqrd <= MAP_LIMIT * MAP_LIMIT)
        {
            float d = sqrt(sqrd);
            float a = atan2(bullet.pos.y - player.pos.y, bullet.pos.x - player.pos.x) - camera.angle - PI_2_F;

            if (isFinite(a))
            {
                GL.color = bullet.color;
                float dist = MAP_RADIUS * d / MAP_LIMIT;
                float sine = void, cosine = void;
                sincosf(-a, sine, cosine);
                vertexf(MAP_TRANSLATE_X + dist * sine, MAP_TRANSLATE_Y + dist * cosine);
            }
        }        
    }
    GL.end();

    GL.pointSize(1);
    GL.begin(GL.POINTS);
    for (int i = 0; i < powerupIndex; ++i)
    with (powerupPool[i])
    {

        float d = player.pos.distanceTo(pos);
        if (d <= MAP_LIMIT)
        {
            float a = atan2(pos.y - player.pos.y, pos.x - player.pos.x) - camera.angle - PI_2_F;

            if (isFinite(a))
            {
                GL.color = color1;

                float dist = MAP_RADIUS * d / MAP_LIMIT;
                float sine = void, cosine = void;
                sincosf(-a, sine, cosine);
                vertexf(MAP_TRANSLATE_X + dist * sine, MAP_TRANSLATE_Y + dist * cosine);
            }

        }
    }

    GL.end();
    popmatrix;
}
