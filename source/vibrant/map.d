module map;

import std.math;

import gfm.math;
import camera, palettes;
import vga2d;
import utils;
import misc.alignedbuffer;

public import geodesic;

enum TILE_SIZE = 200.0f;
enum TILE_OUTSIDE = 0;
enum TILE_NORMAL = 1;

enum LINE_ELECTRIC_ARC = 0;
enum LINE_TILE_SEP = 1;

enum NTILE_X = 34;
enum NTILE_Y = 34;

struct MapLine
{
    vec2f a;
    vec2f b;
    int type;
}

struct MapTile
{
    public
    {
        this(Xorshift32* random, int type, vec2i index) nothrow @nogc
        {
            this.random = random;
            _type = type;
            _index = index;
        }

        int type() nothrow @nogc
        {
            return _type;
        }

        vec2f pos() nothrow @nogc
        {
            return //geom.current_geom
                (vec2f((_index.x - NTILE_X / 2) * TILE_SIZE,
                         (_index.y - NTILE_Y / 2) * TILE_SIZE));
        }

        box2f bounds() nothrow @nogc
        {
            vec2f p = pos();
            return box2f(p, p + //geom.current_geom
                    (vec2f(TILE_SIZE, TILE_SIZE)));
        }
    }

    private
    {
        Xorshift32* random;
        int _type;
        vec2i _index;
    }
}

final class Map
{
    public
    {
    
        AlignedBuffer!MapLine _outLines;
        Xorshift32* random;

        this(Xorshift32* random)
        {
            this.random = random;

            _tiles.length = NTILE_X * NTILE_Y;
            for (int j = 0; j < NTILE_Y; ++j)
                for (int i = 0; i < NTILE_X; ++i)
                {
                    bool border = i <= 1 || j <= 1 || i >= NTILE_X - 2 || j >= NTILE_Y - 2;
                    _tiles[j * NTILE_X + i] = MapTile(random, border ? TILE_OUTSIDE : TILE_NORMAL, vec2i(i, j));
                }

            _outLines = new AlignedBuffer!MapLine();
        }

        static bool indexInMap(vec2i i) nothrow @nogc
        {
            return i.x >= 0 && i.x < NTILE_X && i.y >= 0 && i.y < NTILE_Y;
        }

        static vec2i getIndex(vec2f pos) nothrow @nogc
        {
            return vec2i(cast(int)(floor(pos.x / TILE_SIZE)) + (NTILE_X / 2),
                         cast(int)(floor(pos.y / TILE_SIZE) + (NTILE_Y / 2)));
        }

        MapTile getTile(vec2i i) nothrow @nogc
        {
            assert(indexInMap(i));
            return _tiles[i.y * NTILE_X + i.x];
        }

        MapTile getTile(int ix, int iy) nothrow @nogc
        {
            assert(indexInMap(vec2i(ix, iy)));
            return _tiles[iy * NTILE_X + ix];
        }

        MapTile getTileAtPoint(vec2f pos) nothrow @nogc
        {
            vec2i i = getIndex(pos);
            return getTile(i);
        }

        // returns a random point in the map
        vec2f randomPoint()
        {
            // choose a tile at random
            MapTile t;

            do
            {
                t = getTile((*random).nextRange(NTILE_X), (*random).nextRange(NTILE_Y));
            }
            while (t.type() != TILE_NORMAL);

            // chose a random position on this tile
            box2f b = t.bounds();
            return vec2f( b.min.x + b.width * (*random).nextFloat(), b.min.y + b.height * (*random).nextFloat());
        }

        // get 9 neighbours
        void getNeighbourTiles(vec2f pos, MapTile[] outputTiles)
        {
            vec2i i = getIndex(pos);
            assert(indexInMap(i));

            for (int y = 0; y < 3; ++y)
                for (int x = 0; x < 3; ++x)
                    outputTiles[y * 3 + x] = getTile(vec2i (i.x + x - 1, i.y + y - 1));
        }

        // doesn't need to be precise above 100
        float distanceToBorder(vec2f pos)
        {
            MapTile[9] neighbours;
            getNeighbourTiles(pos, neighbours[]);

            float minDist = 100;

            for (int i = 0; i < 9; ++i)
            {
                if (neighbours[i].type() == TILE_OUTSIDE)
                {
                    float dist = neighbours[i].bounds().distance(pos);
                    if (dist < minDist)
                        minDist = dist;
                }
            }
            return minDist;
        }

        // ensure an object is inside bounds
        void enforceBounds_obsolette(ref vec2f pos, float radius)
        {
        // box.contains (pos + radiusx,pos+radiusy,pos-radiusx,pos-radiusy)
        // ~~ box-radius.contains(pos)
            float m = SIZE_OF_MAP - radius;
            if (m < 0.0f) m = 0.0f;
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

        void enforceBounds(ref vec2f pos, float radius)
        {
        // box.contains (pos + radiusx,pos+radiusy,pos-radiusx,pos-radiusy)
        // ~~ box-radius.contains(pos)
            enforceBounds_obsolette(pos, radius);
        }
        // ensure an object is inside bounds
        // and make it bounce
        int enforceBounds(ref vec2f pos, ref vec2f mov, float radius, float bounce, float constantBounce)
        {
            float m = SIZE_OF_MAP - radius;
            if (m < 0.0f) m = 0.0f;

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
            float m = SIZE_OF_MAP - radius;
            if (m < 0.0f) m = 0.0f;

            int res = 0;

            if (pos.x < -m)
            {
                pos.x = -m;
                mov.x = - mov.x * bounce + constantBounce;
                res++;
                if (abs(angle)> PI_2) angle = PI - angle;
            }
            else if (pos.x > m)
            {
                pos.x = m;
                mov.x = - mov.x * bounce - constantBounce;
                res++;
                if (abs(angle)< PI_2) angle = PI - angle;
            }

            if (pos.y < -m)
            {
                pos.y = -m;
                mov.y = -mov.y*bounce + constantBounce;
                res++;
                if (angle < 0.0 ) angle = 2*PI - angle;

            }
            else if (pos.y > m)
            {
                pos.y = m;
                mov.y = -mov.y*bounce - constantBounce;
                res++;
                if (angle > 0.0) angle = 2*PI - angle;
            }

            return res;
        }

        void generateMapLines(AlignedBuffer!MapLine outLines) @nogc
        {
            int nline = 0;
            outLines.clearContents();

            for (int j = 0; j < NTILE_Y - 1; ++j)
                for (int i = 0; i < NTILE_X - 1; ++i)
                {
                    MapTile here = getTile(vec2i(i, j));

                    box2f bounds = here.bounds();

                    vec2f a = bounds.min;
                    vec2f b = bounds.max;
                    vec2f c = vec2f(bounds.min.x, bounds.max.y);
                    vec2f d = vec2f(bounds.max.x, bounds.min.y);

                    MapTile down = getTile(i, j + 1);
                    MapTile right = getTile(i + 1, j);

                    void push(vec2f p1, vec2f p2, MapTile t1, MapTile t2) @nogc
                    {
                        int lineType;
                        if (t1.type() != t2.type())
                            lineType = LINE_ELECTRIC_ARC;
                        else if (t1.type() == TILE_NORMAL && t2.type() == TILE_NORMAL)
                            lineType = LINE_TILE_SEP;
                        else
                            return;

                        outLines.pushBack( MapLine(p1, p2, lineType) );
                    }

                    push(b, d, here, right);
                    push(c, b, here, down);
                }
        }

        void draw(Camera camera)
        {
            vec4f colE = RGBAF(0xff4848b0);

            void eclairs(vec2f a, vec2f b)
            {
                float d = a.distanceTo(b);
                float t = 0;

                GL.begin(GL.LINE_STRIP);
                GL.color = colE;

                vertexf(a);
                while (t < 1.0f)
                {
                    vec2f pt = t * b + (1 - t) * a;
                    vec2f p = pt + vec2f((*random).nextFloat2 * (*random).nextFloat2 , (*random).nextFloat2 * (*random).nextFloat2) * 5.0f;

                    vertexf(p);

                    t = t + 5.0f / d;
                }
                vertexf(b);
                GL.end();
            }

            generateMapLines(_outLines);

            GL.lineWidth(3);
            GL.begin(GL.LINES);
            GL.color = 0.40f * vec3f(0.13,0.13,0.25);

            for (size_t i = 0; i < _outLines.length; ++i)
                with (_outLines[i])
                {
                    if (type == LINE_TILE_SEP)
                    {
                        if (camera.canSee(a) || camera.canSee(b))
                        {
                            GL.vertex(a);
                            GL.vertex(b);
                        }
                    }
                }

            GL.end();

            for (size_t i = 0; i < _outLines.length; ++i)
                with (_outLines[i])
                {
                    if (type == LINE_ELECTRIC_ARC)
                    {
                        if (camera.canSee(a) || camera.canSee(b))
                        {
                            eclairs(a, b);
                        }
                    }
                }
        }
    }

    private
    {
        static immutable float SIZE_OF_MAP = 3000;
        MapTile[] _tiles;
    }
}

