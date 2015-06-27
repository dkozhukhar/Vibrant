module math.box3;

import math.common;
import math.vec3;
import math.ray;
import std.string;

// structure for box3
// currently very rough

struct box3(T)
{
    private
    {
        // the defined rectangle is

        T m_xmin,  // the smallest x int the box3
          m_ymin,  // the smallest y in the box3
          m_zmin,  // the smallest z in the box3
          m_xmax,  // the smallest x >= m_xmin and outside the box3 (if m_xmin == m_xmax, the width is 0)
          m_ymax,  // the smallest y >= m_ymin and outside the box3 (if m_ymin == m_ymax, the height is 0)
          m_zmax;  // the smallest z >= m_zmin and outside the box3 (if m_zmin == m_zmax, the depth is 0)
    }

    public
    {
        //////////////////
        // constructors //
        //////////////////

        static box3 opCall(T x1, T y1, T z1, T x2, T y2, T z2)
        {
            box3 v = void;
            v.m_xmin = min(x1, x2);
            v.m_xmax = max(x1, x2);
            v.m_ymin = min(y1, y2);
            v.m_ymax = max(y1, y2);
            v.m_zmin = min(z1, z2);
            v.m_zmax = max(z1, z2);
            return v;
        }

        // construct from 2 point
        static box3 opCall(vec3!(T) a, vec3!(T) b)
        {
            return box3(a.x, a.y, a.z, b.x, b.y, b.z);
        }

        static box3 opCall(vec3!(T) a, T x, T y, T z)
        {
            return box3(a.x, a.y, a.z, x, y, z);
        }

        static box3 opCall(T x, T y, T z, vec3!(T) a)
        {
            return box3(x, y, z, a.x, a.y, a.z);
        }

        /////////////
        // getters //
        /////////////

        vec3!(T) a()
        {
            return vec3!(T)(m_xmin, m_ymin, m_zmin);
        }

        vec3!(T) b()
        {
            return vec3!(T)(m_xmax, m_ymax, m_zmax);
        }

        T xmin() { return m_xmin; }
        T xmax() { return m_xmax; }
        T ymin() { return m_ymin; }
        T ymax() { return m_ymax; }
        T zmin() { return m_zmin; }
        T zmax() { return m_zmax; }

        T centerX()
        {
            return cast(T)((m_xmin + m_xmax) * 0.5L);
        }

        T centerY()
        {
            return cast(T)(( m_ymin + m_ymax) * 0.5L);
        }

        T centerZ()
        {
            return cast(T)(( m_zmin + m_zmax) * 0.5L);
        }

        vec3!(T) size()
        {
            return vec3!(T)(width, height, depth);
        }

        vec3!(T) center()
        {
            return vec3!(T)(centerX, centerY, centerZ);
        }


        T width() { return m_xmax - m_xmin; }
        T height() { return m_ymax - m_ymin; }
        T depth() { return m_zmax - m_zmin; }

        box3 opAdd(vec3!(T) a)
        {
            return box3(m_xmin + a.x, m_ymin + a.y, m_zmin + a.z, m_xmax + a.x, m_ymax + a.y, m_zmax + a.z);
        }

        box3 opSub(vec3!(T) v)
        {
            return box3(m_xmin - a.x, m_ymin - a.y, m_zmin - a.z, m_xmax - a.x, m_ymax - a.y, m_zmax - a.z);
        }

        string toString()
        {
            return format("( %s , %s, %s ) - ( %s , %s, %s )", m_xmin, m_ymin, m_zmin, m_xmax, m_ymax, m_zmax);
        }

        bool contains(vec3!(T) pt)
        {
            return (pt.x >= m_xmin) && (pt.x < m_xmax)
                && (pt.y >= m_ymin) && (pt.y < m_ymax)
                && (pt.z >= m_zmin) && (pt.z < m_zmax);
        }

        bool contains(box3!(T) b)
        {
            return contains(vec3!(T)(b.xmin, b.ymin, b.zmin))
                && contains(vec3!(T)(b.xmax, b.ymax, b.zmax));
        }

        box3 combine(vec3!(T) p)
        {
            vec3!(T) na = min3!(T)(p, a);
            vec3!(T) nb = max3!(T)(p, b);
            return box3(na, nb);
        }

        box3 combine(box3 bb)
        {
            vec3!(T) na = min3!(T)(bb.a, a);
            vec3!(T) nb = max3!(T)(bb.b, b);
            return box3(na, nb);
        }

        box3 enlarge(T border)
        {
            return box3(a - vec3!(T)(border), b + vec3!(T)(border));
        }

        // for getting vertices easily
        vec3!(T) xyz() { return vec3!(T)(m_xmin, m_ymin, m_zmin); }
        vec3!(T) xyZ() { return vec3!(T)(m_xmin, m_ymin, m_zmax); }
        vec3!(T) xYz() { return vec3!(T)(m_xmin, m_ymax, m_zmin); }
        vec3!(T) xYZ() { return vec3!(T)(m_xmin, m_ymax, m_zmax); }
        vec3!(T) Xyz() { return vec3!(T)(m_xmax, m_ymin, m_zmin); }
        vec3!(T) XyZ() { return vec3!(T)(m_xmax, m_ymin, m_zmax); }
        vec3!(T) XYz() { return vec3!(T)(m_xmax, m_ymax, m_zmin); }
        vec3!(T) XYZ() { return vec3!(T)(m_xmax, m_ymax, m_zmax); }

        static if (!is(T : int)) // make no sense on integers
        {
            bool hit(ray!(T) r, out T distance, out vec3!(T) point, out vec3!(T) normal)
            {
                // BUG TODO : normal !

                T epsilon = 1e-4;
                T t_near = -T.infinity;
                T t_far = +T.infinity;

                vec3!(T) n_near, n_far;

                for (int i = 0; i < 2; ++i)
                {
                    if (r.dir[i] == 0)
                    {
                        if ((r.start[i] < a[i]) || (r.start[i] > b[i])) return false;
                    }
                    else
                    {
                        T t_1 = (a[i] - r.start[i]) / r.dir[i];
                        T t_2 = (b[i] - r.start[i]) / r.dir[i];

                        vec3!(T) n_1 = vec3!(T).AXIS[i];
                        vec3!(T) n_2 = vec3!(T).AXIS[i];

                        if (t_1 > t_2)
                        {
                            swap(t_1, t_2);
                            swap(n_1, n_2);
                        }

                        if (t_1 > t_near)
                        {
                            t_near = t_1;
                            n_near = n_1;
                        }

                        if (t_2 < t_far)
                        {
                            t_far = t_2;
                            n_far = n_2;
                        }

                        if ((t_near > t_far) || (t_far < epsilon)) return false;
                    }
                }

                // hit
                distance = (t_near > epsilon) ? t_near : t_far;
                normal = (t_near > epsilon) ? n_near : n_far;
                point = r.progress(distance);


                return true;
            }
        }
    }
}

alias box3!(int) box3i;
alias box3!(float) box3f;
alias box3!(double) box3d;
