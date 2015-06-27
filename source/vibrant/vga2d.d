module vga2d;

import utils, palettes;
import math.all;
import std.stdio;
import globals;
import camera;

public
{
    import gl.all;
}

void scale( float fx, float fy)
{
    GL.scale(vec3f(fx, fy, 1.0f));
}

void translate(float vx, float vy)
{
    GL.translate(vec3f(vx, vy, 0.0f));
}

void translate(vec2f v)
{
    GL.translate(vec3f(v.x, v.y, 0.0f));
}

void rotate(float theta)
{
    static float c = -180.0f / PI_F;
    GL.rotate(theta * c, 0, 0, 1);
}

void setModelViewMatrix(mat4f m)
{
    GL.modelviewMatrix = m;
}

void setProjectionMatrix(mat4f m)
{
    GL.projectionMatrix = m;
}

void loadIdentity()
{
    GL.loadIdentity();
}

vec2f transform(vec2f pt)
{
    vec3d projectSub(vec3d pos, vec4i viewport)
    {
        double[16] projection = void;
        double[16] modelview = void;
        GL.getDoublev(GL.MODELVIEW_MATRIX, modelview.ptr);
        GL.getDoublev(GL.PROJECTION_MATRIX, projection.ptr);
        vec3d res = void;
        GL.project(pos.x, pos.y, pos.z, modelview.ptr, projection.ptr, viewport.ptr, &res.x, &res.y, &res.z);

        return res;
    }
    vec3d tr = projectSub(vec3d(pt.x, pt.y, 0.0f), vec4i(0,0,SCREENX, SCREENY));

    vec2f res = vec2f(tr.x, SCREENY - 1 - tr.y);
    return res;
}


void vertexf(float px, float py)
{
    GL.vertex(px, py);
}


void vertexf(vec2f v)
{
    GL.vertex(v);
}

void Pushmatrix()
{
    GL.pushMatrix();
}

alias Pushmatrix pushmatrix;

void Popmatrix()
{
    GL.popMatrix();
}

alias Popmatrix popmatrix;
