module math.ray;

import math.vec3;
import math.vec4;
import math.mat4;

struct ray(T)
{
    public
    {
        vec3!(T) start;
        vec3!(T) dir;
    }

    public
    {
        static ray opCall(vec3!(T) start, vec3!(T) dir)
        {
            ray r = void;
            r.dir = dir.normalized;
            r.start = start;
            return r;
        }

        vec3!(T) progress(T t)
        {
            return start + dir * t;
        }

        // To change a ray from world space to object space
        // after that, direction may not conserve its length
        // disallow perspective change !
        ray transform(mat4!(T) mat)
        {
            vec4!(T) newStart = mat * vec4!(T)(start, 1);
            vec4!(T) newDir = mat * vec4!(T)(dir, 0);
            return ray(newStart.xyz, newDir.xyz);
        }
    }
}

alias ray!(float) rayf;
alias ray!(double) rayd;

