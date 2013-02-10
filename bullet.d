module bullet;

import gl.all;
import misc.logger;
import math.all;
import sound;
import particles, palettes, globals, utils, futils, vga2d, fast32, players, game;
import map;
import camera;

final struct Bullet
{
    bool dead;
    Player owner;
    Game game;
    Camera _camera;
    vec2f pos;
    vec2f mov;
    vec2f lastPos;
    vec2f dPos;
    vec3f color;
    float angle;
    int guided;
    float remainingtime;
    float _damage;

    static Bullet opCall(Game game, vec2f pos, vec2f mov, vec3f color, float angle, 
                          int guided, Player owner, float damage)
    {
        Bullet res = void;
        res.pos = pos;
        res.mov = mov;
        res.lastPos = pos;
        res.dPos = vec2f(0);
        res.color = color;
        res.angle = angle;
        res.guided = guided;
        res.remainingtime = 500 / 60.f;
        res.owner = owner;
        res._damage = damage;
        res.dead = false;
        res.game = game;
        res._camera = game.camera();
        return res;
    }

    bool isCollisionedWith(Player s)
    {
        if (s is null) return false;
        if (owner is s) return false;
        if (s.destroy > 0) return false;

        float limit = s.effectiveSize + BULLET_SIZE;

        if (abs(pos.x - s.pos.x) > limit) return false;
        if (abs(pos.y - s.pos.y) > limit) return false;

        float limit2 = sqr(limit);

        if (pos.squaredDistanceTo(s.pos) < limit2)
        {
            return true;
        }
        else
        {
            vec2f posm = (pos + lastPos) * 0.5f;
            vec2f sposm = (s.pos + s.lastPos) * 0.5f;

            return posm.squaredDistanceTo(sposm) < limit2;
        }

    }

    void applyAttraction(Player s, float dt)
    {
        if (s is null) return;
        if (owner is s) return;
        if (s.destroy > 0) return;
        float sqrdist = pos.squaredDistanceTo(s.pos);
        if (sqrdist > 1000000.0) return;


        // apply attraction
        {
            float mul = s.isInvincible() ? 2.f : 1.f;
            float f = mul * guided / (sqrdist + 0.01f);
            //float force = s.isInvincible ? -1.f : 1.f;
            auto P = clamp(f, 0.f, 1.f) * ((bullettimeTime > 0.f) ? 2.f : 1.f);
            P = min!(float)(1.f, P);
            pos += (s.pos - pos) * P * dt * 85.f;
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
                game.particles.add(pos, vec2f(0), 0, 0, random.nextAngle,
                                   sqr(random.nextFloat * 2.0) + random.nextFloat * 6.0, Frgb(color), random.nextRange(12) + 10);
            }

            game.soundManager.playSound(p.pos, 0.73, SOUND.DAMAGED);

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
                vec2f diff = pos - p.pos;
                if ((diff.length > 0.001f) && (mov.length > 0.001f))
                {
                    diff = diff.normalized;
                    vec2f movN = mov.normalized;
                    vec2f newMov = diff - 2 * movN.dot(diff) * movN;
                    mov = newMov * mov.length();
                }
            }
            
            p.damage(BULLET_DAMAGE * _damage);

            if (p.destroy == 0)
            {
                {
                    float power = p.isInvincible ? 0.125f : 1.f;
                    vec2f vel = pos - lastPos;
                    vec2f pvel = p.pos - p.lastPos;
                    vec2f diffVel = pvel - vel;
                    vec2f diffPos = p.lastPos - lastPos;

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
                                p.mov = p.mov - (diffVel * power * pushAmount) * 1.0 * (0.5 + (random.nextFloat + random.nextFloat + random.nextFloat) * 0.3333f);
                            }

                            if (isFinite(rotAmount))
                            {
                                p.rotatePush(- force * power * rotAmount * 0.05 * (0.5 + (random.nextFloat + random.nextFloat + random.nextFloat) * 0.3333f));
                            }
                        }
                    }
                }
            }
        }

    }

    void move(float dt)
    {
        this.lastPos = pos;

        const BULLET_CONSTANT_ROTATION = -0.08 * 60.f;

        angle = angle + BULLET_CONSTANT_ROTATION * dt;
        vec2f anc = pos;
        pos = pos + mov * dt * 60.f;

        if (_camera.canSee(pos))
        {
            float nParticles = 85.f * dt * 2.f * PARTICUL_FACTOR;
            for (int i = 0; i < nParticles; ++i)
            {
                float a = random.nextFloat;
                vec2f p = mix(anc, pos, vec2f(a));
                game.particles.add(p, vec2f(0), 0, 0, random.nextAngle, random.nextFloat * 0.6f,
                                   Frgb(color * 0.5f), random.nextRange(5) + 1);
            }
        }

        int bc = gmap.enforceBounds(pos, mov, BULLET_SIZE, 1.f, 0.f);

        if (bc > 0)
        {
            game.soundManager.playSound(pos, 1.f, SOUND.BORDER2);
        }

        remainingtime -= dt;
        if (remainingtime < 16.f / 60.f)
        {
            color.x -= max(0.f, color.x - random.nextRange(32) / 255.f);
            color.y -= max(0.f, color.y - random.nextRange(32) / 255.f);
            color.z -= max(0.f, color.z - random.nextRange(32) / 255.f);
        }
        if (remainingtime <= 0) dead = true;

        this.dPos = pos - lastPos;
    }

    void show()
    {
        if (!_camera.canSee(pos)) 
            return;

        vec3f colorBase = color;
        float scale = 1.f;
        if (_damage > 1.5f)
        {
            colorBase += vec3f(-0.5f, -0.5f, +0.7f);
            scale = 1.3f;
        }

        mat2f m = mat2f.rotate(angle) * scale;
        vec3f c2 = colorBase + vec3f(2.f / 255.f, 20.f / 255.f, 20.f / 255.f);

        GL.color = colorBase * 0.5f;
        vec2f displacement = pos - lastPos;
        vertexf(pos + displacement.yx * 0.15f);
        vertexf(pos - displacement.yx * 0.15f);
        vertexf(lastPos - displacement * 4.f);

        GL.color = colorBase;
        vertexf(m * vec2f(-1.20,-1.38) + pos);
        vertexf(m * vec2f(1.20,-1.38) + pos);
        vertexf(m * vec2f(0.0,3.09) + pos);
        GL.color = c2;
        m.transpose();
        vertexf(m * vec2f(-1.20,-1.38) + pos);
        vertexf(m * vec2f(1.20,-1.38) + pos);
        vertexf(m * vec2f(0.0,3.09) + pos);

    }
}

class BulletPool
{
    public
    {
        this()
        {
            _bulletPool.length = MAX_BULLETS;
            _bulletIndex = 0;
        }

        void add(Game game, vec2f pos, vec2f mov, vec3f color, float angle, int guided, Player owner)
        {
            if (_bulletIndex >= MAX_BULLETS)
                return;

            float damage = (owner.isInvincible()) ? 2.f : 1.f;            
            _bulletPool[_bulletIndex++] = Bullet(game, pos, mov, color, angle, guided, owner, damage);
        }

        void move(float dt)
        {
            for(int i = 0; i < _bulletIndex; ++i)
            {
                _bulletPool[i].move(dt);
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
            GL.begin(GL.TRIANGLES);
            for(int i = 0; i < _bulletIndex; ++i)
            {
                _bulletPool[i].show();
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

