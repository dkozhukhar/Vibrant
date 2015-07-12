module bullet;

import std.math;

import gfm.math;

import gl.all;

import sound;
import particles, palettes, globals, utils, vga2d, players, game;
import map;
import camera;

import gfm.core.memory;

final struct Bullet
{
    // tail length
    static const MAX_TAIL = 24;
    bool dead;
    Player owner;
    Game game;
    Camera _camera;
    vec2f[MAX_TAIL] pos; // pos[0] = current   pos[1] = last frame position
    vec2f mov;
    vec3f color;
    float angle;
    int guided;
    float remainingtime;
    float _damage;
    float liveliness;
    int _tailLength;
    bool wasFiredByPlayer;

    Xorshift32* random;

    static Bullet opCall(Game game, vec2f pos, vec2f mov, vec3f color, float angle, 
                          int guided, Player owner, float damage)
    {
        Bullet res = void;

        res.random = game.random();

        res._tailLength = guided > 90 ? MAX_TAIL : 14;

        for (int i = 0; i < MAX_TAIL; ++i)
            res.pos[i] = pos;
        res.mov = mov;

        res.color = color;
        res.angle = angle;
        res.guided = guided;
        res.remainingtime = 500 / 60.0f;
        res.owner = owner;
        res._damage = damage;
        res.dead = false;
        res.game = game;
        res._camera = game.camera();
        res.wasFiredByPlayer = owner is player;
        return res;
    }

    bool isCollisionedWith(Player s)
    {
        if (s is null) return false;
        if (owner is s) return false;
        if (s is player && wasFiredByPlayer) return false;
        if (s.destroy > 0) return false;

        float limit = s.effectiveSize + BULLET_SIZE;

        if (abs(pos[0].x - s.currentPosition.x) > limit) return false;
        if (abs(pos[0].y - s.currentPosition.y) > limit) return false;

        float limit2 = limit * limit;

        float dist2 = pos[0].squaredDistanceTo(s.currentPosition);

        if (dist2 < limit2)
        {
            return true;
        }
        else if (dist2 > OUT_OF_SIGHT_SQUARED)
        {
            return false;
        }
        else
        {
            vec2f posm = (pos[0] + pos[1]) * 0.5f;
            vec2f sposm = (s.currentPosition + s.lastPosition) * 0.5f;

            return posm.squaredDistanceTo(sposm) < limit2;
        }

    }

    void applyAttraction(Player s, float dt)
    {
        if (s is null) return;
        if (owner is s) return;
        if (s is player && wasFiredByPlayer) return;
        if (s.destroy > 0) return;
        float sqrdist = pos[0].squaredDistanceTo(s.currentPosition);
        if (sqrdist > 1000000.0) return;


        // apply attraction
        {
            float mul = s.isInvincible() ? 2.0f : 1.0f;
            float f = mul * guided / (sqrdist + 0.01f);
            //float force = s.isInvincible ? -1.0f : 1.0f;
            auto P = clamp(f, 0.0f, 1.0f) * ((bullettimeTime > 0.0f) ? 2.0f : 1.0f);
            P = std.algorithm.min(1.0f, P);
            pos[0] += (s.currentPosition - pos[0]) * P * dt * 85.0f;
        }
    }

    void checkCollision(float dt)
    {
        for (int i = 0; i < ia.length; ++i)
        {
            applyAttraction(ia[i], dt);
            blastPlayer(ia[i]);
        }

        applyAttraction(player, dt);
        blastPlayer(player);
    }

    void blastPlayer(Player p)
    {
        if (p is null) return;
        if (p.destroy > 0) return;
        if (isCollisionedWith(p))
        {
            for (int i = 0; i < 15 * PARTICUL_FACTOR; ++i)
            {
                game.particles.add(pos[0], vec2f(0), 0, 0, (*random).nextAngle,
                                   ((*random).nextFloat * 2.0) ^^ 2 + (*random).nextFloat * 6.0, Frgb(color), (*random).nextRange(64) + 10);
            }

            game.soundManager.playSound(p.currentPosition, 0.73, SOUND.DAMAGED);

            bool destroyBullet = !p.isInvincible();
            if (destroyBullet)
            {
                dead = true;
            }
            else
            {
                // take owner ship of bullet
                owner = p;

                _damage = 3;

                // reflect bullet on shield
                vec2f diff = pos[0] - p.currentPosition;
                if ((diff.length > 0.001f) && (mov.length > 0.001f))
                {
                    diff = diff.normalized;
                    vec2f movN = mov.normalized;
                    vec2f newMov = diff - 2 * movN.dot(diff) * movN;
                    mov = newMov * mov.length();
                }
            }
            
            p.damage(BULLET_DAMAGE * _damage);

            // change attitude of AI when receiving player bullets
            if (!p.isHuman && owner.isHuman)
            {
                if ((*random).nextFloat < 0.3f) p.attitude = Attitude.AGGRESSIVE;
                if ((*random).nextFloat < 0.3f) p.attitude = Attitude.FEARFUL;
                if ((*random).nextFloat < 0.3f) p.attitude = Attitude.KAMIKAZE;
            }

            if (p.destroy == 0) //  not dead
            {
                {
                    float power = p.isInvincible ? 0.125f : 1.0f;
                    vec2f vel = pos[0] - pos[1];
                    vec2f pvel = p.currentPosition - p.lastPosition;
                    vec2f diffVel = pvel - vel;
                    vec2f diffPos = p.lastPosition - pos[1];

                    float force = diffVel.length;
                    float L = 1e-2f;
                    if ( isFinite(force) && (abs(diffVel.x) > L) && (abs(diffVel.y) > L)
                       && (abs(diffPos.x) > L) && (abs(diffPos.y) > L)
                       && (isFinite(diffVel.x)) && (isFinite(diffVel.y))
                       && (isFinite(diffPos.x)) && (isFinite(diffPos.y)) )
                    {

                        double angle = atan2(diffVel.y, diffVel.x) - atan2(diffPos.y, diffPos.x);

                        if (isFinite(angle))
                        {
                            float pushAmount = -cos(angle) * 0.5f;
                            float rotAmount = -sin(angle) * (p.isHuman ? 0.4f : 0.75f);

                            if (isFinite(pushAmount))
                            {
                                p.mov = p.mov - (diffVel * power * pushAmount) * ((*random).nextFloat);// + (*random).nextFloat + (*random).nextFloat) * 0.3333f);
                            }

                            if (isFinite(rotAmount))
                            {
                                p.rotatePush(- force * power * rotAmount * 0.05 * (0.5 + ((*random).nextFloat + (*random).nextFloat + (*random).nextFloat) * 0.3333f));
                            }
                        }
                    }
                }
            }
        }

    }

    void move(Map map, float dt)
    {
        for (int i = _tailLength - 1; i > 0; --i)
        {
            pos[i] = pos[i - 1];
        }

        const BULLET_CONSTANT_ROTATION = -0.08 * 60.0f;

        angle = angle + BULLET_CONSTANT_ROTATION * dt;
        vec2f anc = pos[0];
        pos[0] = pos[0] + mov * dt * 60.0f;

        if (_camera.canSee(pos[0]))
        {
            float nParticles = 85.0f * dt * 1.0f * PARTICUL_FACTOR;
            for (int i = 0; i < nParticles; ++i)
            {
                float a = (*random).nextFloat;
                vec2f p = lerp(anc, pos[0], vec2f(a));
                game.particles.add(p, vec2f(0), 0, 0, (*random).nextAngle, (*random).nextFloat * 0.6f,
                                   Frgb(color * 0.5f), (*random).nextRange(5) + 1);
            }
        }

        int bc = map.enforceBounds(pos[0], mov, BULLET_SIZE, 1.0f, 0.0f);

        if (bc > 0)
        {
            game.soundManager.playSound(pos[0], 1.0f, SOUND.BORDER2);
        }

        remainingtime -= dt;
        if (remainingtime <= 0) dead = true;

        if (remainingtime < 16.0f / 60.0f)
        {
            liveliness = remainingtime / (16.0f / 60.0f);
        }
        else
            liveliness = 1.0f;

    }

    void show1()
    {
        if (!_camera.canSee(pos[0])) 
            return;

        vec3f colorBase = color;
        float scale = 1.0f;
        if (_damage > 1.5f)
        {
            colorBase += vec3f(-0.5f, -0.5f, +0.7f);
            scale = 1.3f;
        }


        mat2f m = mat2frotate(angle) * mat2f(scale, 0, 0, scale);
        vec3f c2 = colorBase + vec3f(2.0f / 255.0f, 20.0f / 255.0f, 20.0f / 255.0f);

        colorBase *= liveliness;
        c2 *= liveliness;

        GL.color = colorBase;
        vertexf(m * vec2f(-1.20,-1.38) + pos[0]);
        vertexf(m * vec2f(1.20,-1.38) + pos[0]);
        vertexf(m * vec2f(0.0,3.09) + pos[0]);
        GL.color = c2;
        m = m.transposed();
        vertexf(m * vec2f(-1.20,-1.38) + pos[0]);
        vertexf(m * vec2f(1.20,-1.38) + pos[0]);
        vertexf(m * vec2f(0.0,3.09) + pos[0]);

    }

    void show2()
    {
        if (!_camera.canSee(pos[0])) 
            return;

        vec3f colorBase = color;
        float scale = 1.0f;
        if (_damage > 1.5f)
        {
            colorBase += vec3f(-0.5f, -0.5f, +0.7f);
            scale = 1.3f;
        }
    
        colorBase *= liveliness;
        
        GL.begin(GL.TRIANGLE_STRIP);
        for (int i = 0; i < _tailLength - 1; ++i)
        {
            float df = i / cast(float)(_tailLength - 1);
            GL.color = vec4f(colorBase * 0.5f, 0.8f * (1 - df)*(1-df) + 0.2f);
            vec2f B = pos[i];
            vec2f E = pos[i + 1];
            vec2f diff = B - E;
            double dl = diff.length();

            if (dl < 1e-3f)
                break;

            float expectedWidthN = 1.0f * (1 - df);
            expectedWidthN = std.algorithm.min(expectedWidthN, dl);
            diff.normalize();

            vec2f D = B + vec2f(diff.y, -diff.x) * expectedWidthN;
            vec2f F = B + vec2f(-diff.y, diff.x) * expectedWidthN;
            vertexf(D);
            vertexf(F);
        }
        vertexf(pos[_tailLength - 1]);        
        GL.end();
    }
}

class BulletPool
{
    public
    {
        this()
        {
            Bullet* pBulletPool = cast(Bullet*)alignedMalloc(Bullet.sizeof * MAX_BULLETS, 128); // this will leak but is once per run
            _bulletPool = pBulletPool[0..MAX_BULLETS];
            _bulletIndex = 0;
        }

        void add(Game game, vec2f pos, vec2f mov, vec3f color, float angle, int guided, Player owner)
        {
            if (_bulletIndex >= MAX_BULLETS)
                return;

            float damage = owner.isInvincible() ? 2.0f : 1.0f;            
            _bulletPool[_bulletIndex++] = Bullet(game, pos, mov, color, angle, guided, owner, damage);
        }

        void move(Map map, float dt)
        {
            for(int i = 0; i < _bulletIndex; ++i)
            {
                _bulletPool[i].move(map, dt);
            }
        }

        void checkCollision(float dt)
        {
            for(int i = 0; i < _bulletIndex; ++i)
            {
                _bulletPool[i].checkCollision(dt);
            }
        }

        void draw()
        {
            GL.enable(GL.BLEND);
            for(int i = 0; i < _bulletIndex; ++i)
                _bulletPool[i].show2();

            GL.disable(GL.BLEND);

            GL.begin(GL.TRIANGLES);
            for(int i = 0; i < _bulletIndex; ++i)
            {
                _bulletPool[i].show1();
            }
            GL.end();
        }

        void removeDead()
        {
            int i = 0;
            while(i < _bulletIndex)
            {
                if (_bulletPool[i].dead)
                {
                    _bulletPool[i] = _bulletPool[--_bulletIndex];
                }
                else
                {
                    i++;
                }
            }

        }

        size_t length()
        {
            return _bulletIndex;
        }

        Bullet* item(size_t i)
        {
            return &_bulletPool[i];
        }
    }

    private
    {
        const MAX_BULLETS = 1000;

        Bullet[] _bulletPool;
        int _bulletIndex;
    }
}

