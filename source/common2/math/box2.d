module math.box2;

import math.common;
import math.vec2;
import std.string;

// structure for box2
// currently very rough

struct box2(T)
{
    private
    {
        // the defined rectangle is

        T m_xmin,  // the smaller x int the box2
          m_ymin,  // the smaller y in the box2
          m_xmax,  // the smaller x >= x1 and outside the box2 (if x1 == x2, the width is 0)
          m_ymax;  // the smaller y >= y2 and outside the box2 (if x1 == x2, the height is 0)
    }

    public
    {
        //////////////////
        // constructors //
        //////////////////

        static box2 opCall(T x1, T y1, T x2, T y2)
        {
            box2 v = void;
            v.m_xmin = min(x1, x2);
            v.m_xmax = max(x1, x2);
            v.m_ymin = min(y1, y2);
            v.m_ymax = max(y1, y2);
            return v;
        }

        // construct from 2 point
        static box2 opCall(vec2!(T) a, vec2!(T) b)
        {
            return box2(a.x, a.y, b.x, b.y);
        }

        static box2 opCall(vec2!(T) a, T x, T y)
        {
            return box2(a.x, a.y, x, y);
        }

        static box2 opCall(T x, T y, vec2!(T) a)
        {
            return box2(x, y, a.x, a.y);
        }

        /////////////
        // getters //
        /////////////

        vec2!(T) a()
        {
            return vec2!(T)(m_xmin, m_ymin);
        }

        vec2!(T) b()
        {
            return vec2!(T)(m_xmax, m_ymax);
        }

        T xmin() { return m_xmin; }
        T xmax() { return m_xmax; }
        T ymin() { return m_ymin; }
        T ymax() { return m_ymax; }

        T centerX()
        {
            return cast(T)((m_xmin + m_xmax) * 0.5L);
        }

        T centerY()
        {
            return cast(T)(( m_ymin + m_ymax) * 0.5L);
        }

        vec2!(T) size()
        {
            return vec2!(T)(width, height);
        }

        vec2!(T) center()
        {
            return vec2!(T)(centerX, centerY);
        }


        T width() { return m_xmax - m_xmin; }
        T height() { return m_ymax - m_ymin; }

        double ratio() { return width / cast(double)height; }


        box2 opAdd(vec2!(T) a)
        {
            return box2(m_xmin + a.x, m_ymin + a.y, m_xmax + a.x, m_ymax + a.y);
        }

        box2 opSub(vec2!(T) v)
        {
            return box2(m_xmin - a.x, m_ymin - a.y, m_xmax - a.x, m_ymax - a.y);
        }

        // returns the largest box2 within with asked ratio
        box2 subRectWithRatio(double asked_ratio)
        {
            box2 r = this;

            if (ratio < asked_ratio) // crop because of ratio if needed
            {
                auto new_height = width * (1.0 / asked_ratio);
                auto diff = height - new_height;
                r.m_ymin += cast(T)round(diff * 0.5);
                r.m_ymax -= cast(T)round(diff * 0.5);
            }
            else if (ratio > asked_ratio)
            {
                auto new_width = height * asked_ratio;
                auto diff = width - new_width;
                r.m_xmin += cast(T)round(diff * 0.5);
                r.m_xmax -= cast(T)round(diff * 0.5);
            }
            return r;
        }

        bool contains(vec2!(T) pt)
        {
            return (pt.x >= m_xmin) && (pt.x < m_xmax) && (pt.y >= m_ymin) && (pt.y < m_ymax);
        }

        bool contains(box2!(T) b)
        {
            return contains(vec2!(T)(b.xmin, b.ymin))
                && contains(vec2!(T)(b.xmax, b.ymax));
        }

        box2 combine(vec2!(T) p)
        {
            vec2!(T) na = min2!(T)(p, a);
            vec2!(T) nb = max2!(T)(p, b);
            return box2(na, nb);
        }

        box2 combine(box2 bb)
        {
            vec2!(T) na = min2!(T)(bb.a, a);
            vec2!(T) nb = max2!(T)(bb.b, b);
            return box2(na, nb);
        }

        static if (is(T : float) || is(T : double)  || is(T : real) )
        {

            // Euclidean squared distance from a point
            // source: Numerical Recipes Third Edition (2007)
            T distanceTo(vec2!(T) p)
            {
                T distanceSquared = 0;

                if (p.x < a.x)
                    distanceSquared += sqr(p.x - a.x);

                if (p.x > b.x)
                    distanceSquared += sqr(p.x - b.x);

                if (p.y < a.y)
                    distanceSquared += sqr(p.y - a.y);

                if (p.y > b.y)
                    distanceSquared += sqr(p.y - b.y);

                return sqrt!(T)(distanceSquared);
            }
        }
    }
}

alias box2!(int) box2i;
alias box2!(float) box2f;
alias box2!(double) box2d;
