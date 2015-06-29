module math.math2d;

import math.vec2;
import math.common;




// distance from a point to a segment
double distanceToSegment(double Xp, double Yp, double Xa, double Ya, double Xb, double Yb)
{
    //Xa,Ya is point 1 on the line segment.
    //Xb,Yb is point 2 on the line segment.
    //Xp,Yp is the point.

    double xu = Xp - Xa;
    double yu = Yp - Ya;
    double xv = Xb - Xa;
    double yv = Yb - Ya;
    if (xu * xv + yu * yv < 0) return sqrt( (Xp-Xa)*(Xp-Xa) + (Yp-Ya)*(Yp-Ya));

    xu = Xp - Xb;
    yu = Yp - Yb;
    xv = -xv;
    yv = -yv;
    if (xu * xv + yu * yv < 0) return sqrt( (Xp-Xb)*(Xp-Xb) + (Yp-Yb)*(Yp-Yb) );

    return abs( ( Xp * ( Ya - Yb ) + Yp * ( Xb - Xa ) + ( Xa * Yb - Xb * Ya ) ) / sqrt( ( Xb - Xa )*( Xb - Xa ) + ( Yb - Ya )*( Yb - Ya ) ) );
}

// distance from a point to a segment
float distanceToSegment(vec2f p, vec2f a, vec2f b)
{
    return distanceToSegment(p.x, p.y, a.x, a.y, b.x, b.y);
}

// The code below is from Wm. Randolph Franklin <wrf@ecse.rpi.edu>
// with some minor modifications for speed.  It returns 1 for strictly
// interior points, 0 for strictly exterior, and 0 or 1 for points on
// the boundary.
// This code is not yet tested!
bool pointInPolygon(vec2f point, vec2f[] p)
{
    bool result = false;
    int j = cast(int)(p.length) - 1;
    for (int i = 0; i < p.length; i++)
    {
        if ( (   ( (p[i].y <= point.y) && (point.y < p[j].y) )
              || ( (p[j].y <= point.y ) && (point.y < p[i].y)) )
            && (point.x < (p[j].x - p[i].x) * (point.y - p[i].y) / (p[j].y - p[i].y) + p[i].y))
        {
            result = !result;
            j = i + 1;
        }
    }
    return result;
}

bool pointInTriangle(vec2f x, vec2f a, vec2f b, vec2f c)
{
    vec2f[3] points;
    points[0] = a;
    points[1] = b;
    points[2] = c;
    return pointInPolygon(x, points);
}

