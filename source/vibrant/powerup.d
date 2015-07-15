module powerup;

import std.math;
import gfm.math;
import vga2d;
import utils, bullet, palettes, oldfonts, globals, players;
import misc.all;
import sound;
import particles;
import game;
import camera;
import map;
import bullettime;

const POWERUP_WIDTH = 1.0,
      SQRPOWERUP_WIDTH = POWERUP_WIDTH * POWERUP_WIDTH;

enum PowerupType { LIFE, ENERGY_CELL, IMPROVE_WEAPON, ENERGY_GAIN, HIROSHIMA, IMPROVE_SIZE, MADNESS, TRAP, IMPROVE_ENGINE, BULLET_TIME, INVINCIBILITY };

private static immutable int[PowerupType.max + 1] DRAG_SPEED = [    18,     24,        24,        24,      18,      24,        24,      5,        24,            24,             18 ];

static immutable string[PowerupType.max + 1] POWERUP_NAMES =   ["life", "cell", "weapon+",  "energy", "blast", "size+", "madness", "trap", "engine+", "bullet time", "invincibility"];

static immutable uint[PowerupType.max + 1] powerupWeights =    [    40,      0,        10,        10,      12,       8,         0,      8,        10,            10,               5];


final class Powerup
{
    bool dead;
    private Player _dragger;
    PowerupType type;
    float fromdragger;
    float counter;
    private Game game;
    private bool _isVisible;
    private bool _isLinkVisible;

    vec2f pos;
    vec2f mov;
    private vec2f lastPos;
    private vec3f finalcolor1,finalcolor2,finalcolor3;
    vec3f color1, color2, color3;
    Xorshift32* random;


    this(Game game, vec2f pos, vec2f mov)
    {    
        PowerupType choosePowerupClass()
        {
            int totalWeight = 0;
            for (PowerupType bt = PowerupType.min; bt <= PowerupType.max; bt++)
            {
                totalWeight += powerupWeights[bt];
            }

            int i = (*random).nextRange(totalWeight);
            for (PowerupType bt = PowerupType.min; bt <= PowerupType.max; bt++)
            {
                i -= powerupWeights[bt];
                if (i < 0) return bt;
            }
            return PowerupType.LIFE;
        }

        this.random = game.random();
        this.game = game;
        this.type = choosePowerupClass();
        this.pos = pos;
        this.mov = mov;
        this.lastPos = pos;

        const uint[PowerupType.max + 1] colors1 = [0xffffffff,0xffa010C0,0xffffff00,0xffa010C0,0xffffff00,0xffffffff,0xff80C080,0xffC0C0C0,0xffffffff, 0xff9000, 0xff00ff];
        const uint[PowerupType.max + 1] colors2 = [0xffff0000,0xff10a0c0,0xff00ffff,0xff10a0c0,0xff00ffff,0xffc000a0,0xff00ff00,0xff808080,0xff00ff00, 0xff9080, 0xff8000];
        const uint[PowerupType.max + 1] colors3 = [0xffffff00,0xff0000ff,0xffffff00,0xffffffff,0xffff00ff,0xff800060,0xffffff00,0xff808080,0xff00ffff, 0x804000, 0xaf0040];

        this.finalcolor1 = RGBF(colors1[this.type]);
        this.finalcolor2 = RGBF(colors2[this.type]);
        this.finalcolor3 = RGBF(colors3[this.type]);

        this.color1 = vec3f(0.0f);
        this.color2 = vec3f(0.0f);
        this.color3 = vec3f(0.0f);
        this.counter = 0.0f;

        this.dead = false;
        this._dragger = null;
    }

    void cleanup()
    {
        setDragger(null);
    }

    Player getDragger()
    {
        return _dragger;
    }

    void setDragger(Player p)
    {
        if (p is _dragger)
            return; // no changes

        if (_dragger !is null)
            _dragger.stopDragPowerup(this);

        _dragger = p;
        if (_dragger is null)
        {
            fromdragger = 0;
        }
        else
        {
            _dragger.startDragPowerup(this);
            fromdragger = _dragger.currentPosition.distanceTo(pos);
        }
    }

    void updateVisibility()
    {
        Camera cam = game.camera();
        if (dead)
        {
            _isVisible = false;
            _isLinkVisible = false;
        }
        else
        {
            _isVisible = cam.canSee(pos);
            _isLinkVisible = (_dragger !is null) && (_isVisible || cam.canSee(_dragger.currentPosition));
        }
    }

    void applyAttraction(Player s, float dt)
    {
        if (s is null) return;
        if (s.destroy > 0) return;

        float sqrde = pos.squaredDistanceTo(s.currentPosition);

        if (sqrde >= 1000000.0) return;

        if (_dragger is null)
        {
            float f = 60.0f / (sqrde + 0.01);
            float P = clamp(f, 0.0f, 1.0f);
            pos = pos - (s.currentPosition - pos) * P * dt * 85.0f; // could be better
        }
    }

    bool caught(Player s1)
    {
        if (s1 is null) return false;
        if (s1.destroy > 0) return false;

        float sqrde = pos.squaredDistanceTo(s1.currentPosition);

        return sqrde < SQRPOWERUP_WIDTH + sqr(s1.effectiveSize);
    }

    void checkCollision(float dt)
    {

        if (player !is null)
        {
            applyAttraction(player, dt);
            checkCaughtByPlayer(player);
        }
        for (int i = 0; i < ia.length; ++i)
        if (ia[i] !is null)
        {
            applyAttraction(ia[i], dt);
            checkCaughtByPlayer(ia[i]);
        }
    }

    void checkCaughtByPlayer(Player s)
    {
        if (s is null) return;
        if (s.destroy > 0) return;
        if (!caught(s)) return;
        dead = true;

        switch(type)
        {
            case PowerupType.LIFE:
            {
                s.life = std.algorithm.min(2.0f, s.life + 0.5f);
                makePowerupSound(game.soundManager, random, pos);                
                break;
            }
            case PowerupType.ENERGY_CELL:
            {
                s.energy = 2 * ENERGYMAX;
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.ENERGY_GAIN:
            {
                s.energy = 2 * ENERGYMAX;
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.IMPROVE_SIZE:
            {
                s.shipSize = std.algorithm.min(SHIP_MAX_SIZE, s.shipSize + 1.0f);
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.IMPROVE_ENGINE:
            {
                s.baseVelocity = std.algorithm.min(PLAYER_BASE_VELOCITY * 1.8f, s.baseVelocity + PLAYER_BASE_VELOCITY * 0.2f);
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.IMPROVE_WEAPON:
            {
                s.weaponclass = std.algorithm.min(3, s.weaponclass + 1);
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.MADNESS:
            {
                for (int i = 0; i < ia.length; ++i)
                {
                    if (ia[i] !is null)    ia[i].becomeMad;
                }
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.BULLET_TIME:
            {
                if (s is player)
                {
                    BulletTime.enter(10);
                }
                else
                {
                    s.becomeMad();
                }
                makePowerupSound(game.soundManager, random, pos);
                break;
            }
            case PowerupType.HIROSHIMA:
            {
                int count = cast(int)round(s.shipSize * 4);
                for (int i = 0; i < count; ++i)
                {
                    vec3f color = s.color;
                    float angle = s.angle + 2 * PI * i / cast(float)count;
                    float d = 0.3f * (8.0f - (i & 1) * 2.0f);

                    if (!s.isHuman) 
                        d /= 1.25f;

                    vec2f mov = polarOld(angle, d) + s.mov;
                    int mguided = s.isHuman ? 200 : 100;
                    game.addBullet(pos, mov, color, angle, mguided, s);
                }
                game.soundManager.playSound(pos, 1.0f, SOUND.BLAST);
                break;
            }

            case PowerupType.INVINCIBILITY:
            {
                s.invincibility = std.algorithm.min(s.invincibility + 8.0f, MAX_INVINCIBILITY);
                makePowerupSound(game.soundManager, random, pos);
                break;
            }

            case PowerupType.TRAP:
            default:
            {
                if (!s.isInvincible)
                {
                    s.damage(s.damageToExplode);
                }
                break;
            }

        }

        for (int i = 0; i < 10 * PARTICUL_FACTOR; ++i)
        {
            uint color = Frgb(color1);
             game.particles.add(pos, vec2f(0), 0, 0, (*random).nextAngle, sqr((*random).nextFloat)+(*random).nextFloat, color,(*random).nextRange(12)+10);
        }
        for (int i = 0; i < 10 * PARTICUL_FACTOR; ++i)
        {
            uint color = Frgb(color2);
            game.particles.add(pos, vec2f(0), 0, 0, (*random).nextAngle, sqr((*random).nextFloat)+(*random).nextFloat,color,(*random).nextRange(12)+10);
        }
    }

    void move(Map map, float dt)
    {
        if (dead) return;
        const BUMP_FACTOR = 1.0f;
        const BUMP = 3.0f;
        float dt2 = 60.0f * dt;

        lastPos = pos;

        pos += mov * dt2;

        float vfactor = exp(dt2 * log(0.99f));
        mov *= vfactor;

        if ((_dragger !is null) && (_dragger.isAlive()))
        {

            if (_dragger.bounced)
            {
                mov += _dragger.mov * 0.5f;
                setDragger(null);
            }
            else
            {
                float d = _dragger.currentPosition.squaredDistanceTo(pos);

                if (d < DRAG_DISTANCE * DRAG_DISTANCE)
                {
                    float oldfromdragger = fromdragger;
                    float a = 2.0f - (fromdragger - 100.0f) * 0.01f;
                    if (a > 2.0f) a = 2.0f;
                    if (a < 0.0f) a = 0.0f;

                    d = sqrt(d);                    

                    fromdragger = fromdragger - a * DRAG_SPEED[type] * dt;

                    if (fromdragger < 1.0f) fromdragger = 1.0f;

                    if (d > 1e-3f)
                    {
                        pos = _dragger.currentPosition - (_dragger.currentPosition - pos) * fromdragger / d;
                    }
                }
                else
                {
                    setDragger(null);
                }
            }
        }

        map.enforceBounds(pos, mov, 0.0f, BUMP_FACTOR, BUMP);

        float fact = 1.0 - exp(-dt * 3.0);
        color1 += (finalcolor1 - color1) * fact;
        color2 += (finalcolor2 - color2) * fact;
        color3 += (finalcolor3 - color3) * fact;

        if ((*random).nextFloat < dt * 2.0f) swap(finalcolor1,finalcolor3);
        if ((*random).nextFloat < dt * 2.0f) swap(finalcolor2,finalcolor1);
        if ((*random).nextFloat < dt * 2.0f) swap(finalcolor3,finalcolor2);

        counter += dt * 0.75f;
    }

    void show1()
    {
        if (_isLinkVisible)
        {
            GL.color = RGBAF(0xff606060);
            vertexf(pos);
            vertexf(_dragger.currentPosition);
        }
    }

    void show2()
    {
        if (_isVisible)
        {
            vec2f p = pos;
            mat2f m = mat2f(1.45f, 0, 0, 1.45f);

            mat2f m2 = m * mat2frotate(counter * 6);
            mat2f m3 = mat2frotate(2*PI / 3.0f);
            float sina = void, cosa = void;
            sincos(counter * 0.6f, sina, cosa);
            m2 *= mat2f(0.7+0.3*cosa, 0, 0, 0.7+0.3*sina);

            GL.color = color1;
            vertexf(p);
            vertexf(p + m2 * vec2f(0,4));
            vertexf(p + m2 * vec2f(-3.4614,-2));

            m2 *= m3;
            GL.color = color2;
            vertexf(p);
            vertexf(p + m2 * vec2f(0,4));
            vertexf(p + m2 * vec2f(-3.4614,-2));

            m2 *= m3;
            GL.color = color3;
            vertexf(p);
            vertexf(p + m2 * vec2f(0,4));
            vertexf(p + m2 * vec2f(-3.4614,-2));

            vec3f[3] colors;
            colors[0] = color1;
            colors[1] = color2;
            colors[2] = color3;

            for (int i = 0; i <= 2; ++i)
            {
                m2 = m * mat2frotate(-counter * 3.0 * (i+1) + i);
                vec2f p2 = vec2f(8.0f * cos(counter * 3 * (i + 1)+i), 0);

                GL.color = colors[i];

                vertexf( p + m2 * (vec2f(0,0) + p2) );
                vertexf( p + m2 * (vec2f(0,1) + p2) );
                vertexf( p + m2 * (vec2f(1,1) + p2) );
            }
        }
    }

    void show3(TextRenderer text)
    {
        if (!_isVisible)
            return;

        if ((_dragger !is null) && (_dragger.isHuman))
        {
            text.setFont(FontType.SMALL);
            auto textpos = transform(pos) + vec2f(8,-3);
            text.setCursorPosition(cast(int)round(textpos.x), cast(int)round(textpos.y));
            text.setAttr(0);
            text.setColor(0xffffffff);
            text.outputString(POWERUP_NAMES[type]);
        }
    }
}

void showPowerups(TextRenderer text)
{
    for (int i = 0; i < powerupIndex; ++i)
        powerupPool[i].updateVisibility();
    
    GL.begin(GL.LINES);
    for (int i = 0; i < powerupIndex; ++i)
        powerupPool[i].show1();
    
    GL.end();

    GL.begin(GL.TRIANGLES);
    for (int i = 0; i < powerupIndex; ++i)
        powerupPool[i].show2();
    GL.end;

    for (int i = 0; i < powerupIndex; ++i)
        powerupPool[i].show3(text);
}

const MAX_POWERUPS = 200;


__gshared Powerup[] powerupPool;
__gshared int powerupIndex = 0;



private uint approach(uint c, uint target)
{
    int nottoofar(int s)
    {
        if (s > 4) s = 4;
        if (s < -4) s = -4;
        return s;
    }
    int r = Rvalue(c);
    int g = Gvalue(c);
    int b = Bvalue(c);
    int a = Avalue(c);

    return rgba(r + nottoofar(Rvalue(target) - r),
                g + nottoofar(Gvalue(target) - g),
                b + nottoofar(Bvalue(target) - b),
                a + nottoofar(Avalue(target) - a));

}


void removeDeadPowerups()
{
    int i = 0;
    while(i < powerupIndex)
    {
        if (powerupPool[i].dead)
        {
            powerupPool[i].cleanup();
            powerupPool[i] = powerupPool[--powerupIndex];
            powerupPool[powerupIndex] = null;
        }
        else
        {
            i++;
        }
    }
}

