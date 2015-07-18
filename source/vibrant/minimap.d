module minimap;

import std.math;
import vga2d;
import sdl.all;
import utils;
import globals;
import palettes;
import mousex;
import players;
import bullet;
import misc.all;
import powerup;
import sound;
import camera;
import map;
import gfm.math;

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
        GL.color(vec4f(0.0, 0.0, 0.0, 0.9f));
        vertexf(MAP_TRANSLATE_X, MAP_TRANSLATE_Y);
        GL.color(vec4f(0.03, 0.0, 0.0, 0.9f));
        for (int i = 0; i <= 64; ++i)
        {
            float angle = 2 * PI * i / 64.0f;
            vertexf(MAP_TRANSLATE_X + MAP_RADIUS * cos(angle), MAP_TRANSLATE_Y + MAP_RADIUS * sin(angle));
        }
        GL.end();
    }

    GL.lineWidth(1);

    vec2f refPos = player.currentPosition;

    // draw borders
    
    {
        void line(vec2f a, vec2f b)
        {
            
            float distA = MAP_RADIUS * refPos.distanceTo(a) / MAP_LIMIT;
            float distB = MAP_RADIUS * refPos.distanceTo(b) / MAP_LIMIT;            

            float angleA = atan2(a.y - refPos.y, a.x - refPos.x) - camera.angle - PI_2;

            if (!isFinite(angleA)) return;

            float angleB = atan2(b.y - refPos.y, b.x - refPos.x) - camera.angle - PI_2;
            if (!isFinite(angleB)) return;

            float sA = void, cA = void;
            float sB = void, cB = void;
            sA = sin(-angleA);
            cA = cos(-angleA);
            sB = sin(-angleB);
            cB = cos(-angleB);

            vec2f at = vec2f(MAP_TRANSLATE_X + distA * sA, MAP_TRANSLATE_Y + distA * cA);
            vec2f bt = vec2f(MAP_TRANSLATE_X + distB * sB, MAP_TRANSLATE_Y + distB * cB);

            float alpha_a = std.algorithm.max(0.0f, 0.5f - 2.0f * vec2f(MAP_TRANSLATE_X, MAP_TRANSLATE_Y).squaredDistanceTo(at) / (MAP_RADIUS * MAP_RADIUS));
            float alpha_b = std.algorithm.max(0.0f, 0.5f - 2.0f * vec2f(MAP_TRANSLATE_X, MAP_TRANSLATE_Y).squaredDistanceTo(bt) / (MAP_RADIUS * MAP_RADIUS));
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

        float d = refPos.distanceTo(currentPosition);

        // fix for seeing out-of-reach players
        if (d >= MAP_LIMIT - 200) d = MAP_LIMIT - 200;

        if (d <= MAP_LIMIT)
        {
            float a = atan2(currentPosition.y - refPos.y, currentPosition.x - refPos.x) - camera.angle - PI_2;

            if (isFinite(a))
            {
                pushmatrix;

                if (ia[i].isInvincible())
                    GL.color = vec3f(0.5, 0.7, 1);
                else
                    GL.color = ia[i].maincolor();
                vga2d.translate(MAP_TRANSLATE_X,MAP_TRANSLATE_Y);
                rotate(-a);
                vga2d.translate(0,MAP_RADIUS * d / MAP_LIMIT);
                rotate(a);
                GL.begin(GL.LINES);
                vertexf(-4,0);
                vertexf(-1,0);
                vertexf(1,0);
                vertexf(4,0);

                vertexf(0,-4);
                vertexf(0,-1);
                vertexf(0,1);
                vertexf(0,4);
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

        float sqrd = refPos.squaredDistanceTo(bullet.pos[0]);

        if (sqrd <= MAP_LIMIT * MAP_LIMIT)
        {
            float d = sqrt(sqrd);
            float a = atan2(bullet.pos[0].y - refPos.y, bullet.pos[0].x - refPos.x) - camera.angle - PI_2;

            if (isFinite(a))
            {
                GL.color = bullet.color;
                float dist = MAP_RADIUS * d / MAP_LIMIT;
                float sine = void, cosine = void;
                sine = sin(-a);
                cosine = cos(-a);
                vertexf(MAP_TRANSLATE_X + dist * sine, MAP_TRANSLATE_Y + dist * cosine);
            }
        }        
    }
    GL.end();

    GL.pointSize(1.0);
    GL.begin(GL.POINTS);
    for (int i = 0; i < powerupIndex; ++i)
    with (powerupPool[i])
    {

        float d = refPos.distanceTo(pos);
        if (d <= MAP_LIMIT)
        {
            float a = atan2(pos.y - refPos.y, pos.x - refPos.x) - camera.angle - PI_2;

            if (isFinite(a))
            {
                GL.color = color1;

                float dist = MAP_RADIUS * d / MAP_LIMIT;
                float sine = void, cosine = void;
                sine = sin(-a);
                cosine = cos(-a);
                float px = MAP_TRANSLATE_X + dist * sine;
                float py = MAP_TRANSLATE_Y + dist * cosine;
                vertexf(px, py);

                GL.color = color2;
                vertexf(px + 1, py);
                GL.color = color3;
                vertexf(px, py + 1);
            }

        }
    }

    GL.end();
    popmatrix;
}
