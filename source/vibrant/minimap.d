module minimap;

import vga2d;
import sdl.all;
import utils;
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

void drawMinimap(Camera camera, Map map, BulletPool bulletPool)
{
    auto MAP_RADIUS = cast(int)(0.5f + SCREENY * 0.2f);
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
    scale(2.0f / SCREENY, 2.0f / SCREENY);

    // clear the minimap zone
    {
        GL.begin(GL.TRIANGLE_FAN);
        GL.color(vec4f(0, 0, 0, 0.75f));
        vertexf(MAP_TRANSLATE_X, MAP_TRANSLATE_Y);
        for (int i = 0; i <= 64; ++i)
        {
            float angle = TAU_F * i / 64.0f;
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

            float alpha_a = max!(float)(0.0f, 0.5f - 2.0f * vec2f(MAP_TRANSLATE_X, MAP_TRANSLATE_Y).squaredDistanceTo(at) / (MAP_RADIUS * MAP_RADIUS));
            float alpha_b = max!(float)(0.0f, 0.5f - 2.0f * vec2f(MAP_TRANSLATE_X, MAP_TRANSLATE_Y).squaredDistanceTo(bt) / (MAP_RADIUS * MAP_RADIUS));
            if (alpha_a <= 0.001 && alpha_b <= 0.001)
                return;

            GL.color = vec4f(0.5,0.5,0.6, alpha_a);
            vertexf(at);
            GL.color = vec4f(0.5,0.5,0.6, alpha_b);
            vertexf(bt);            
        }

        AlignedBuffer!MapLine outLines = map._outLines;

        int numOutlines = cast(int)(outLines.length);
        GL.begin(GL.LINES);
        for (int i = 0; i < numOutlines; ++i)
        {
            with (outLines[i])
                if (type == LINE_ELECTRIC_ARC)
                    line(a, b);
        }
        GL.end();
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
    GL.enable(GL.POINT_SMOOTH);


    GL.pointSize(1);
    GL.begin(GL.POINTS);
    for (int i = 0; i < bulletPool.length; ++i)
    {
        Bullet* bullet = bulletPool.item(i);

        float sqrd = player.pos.squaredDistanceTo(bullet.pos[0]);

        if (sqrd <= MAP_LIMIT * MAP_LIMIT)
        {
            float d = sqrt(sqrd);
            float a = atan2(bullet.pos[0].y - player.pos.y, bullet.pos[0].x - player.pos.x) - camera.angle - PI_2_F;

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

    GL.pointSize(2.0);
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
