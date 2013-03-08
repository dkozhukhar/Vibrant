module players;

import vutils;
import oldfonts;
import palettes;
import vga2d;
import utils;
import globals;
import sdl.all;
import mousex;
import math.all;
import std.stdio;
import misc.logger;
import joy, sound;
import game;
import particles;
import powerup;
import map;
import bullettime;
import camera;

// Attitudes

enum Attitude {HUMAN, AGGRESSIVE, FEARFUL, KAMIKAZE, OCCUPIED };

class Player
{
    const int MAX_DRAGGED_POWERUPS = 4; // can't drag more than that powerup

    Game game;
    Camera _camera;
    bool dead;
    vec2f pos;
    vec2f mov;
    vec2f lastPos;
    float armsPhase;
    float angle, vangle;
    vec3f color;
    Random random;
    float life;
    float baseVelocity; // velocity at size 7
    float shipSize;
    float energy;
    float waitforshootTime;
    float destroy;
    Attitude attitude;
    bool turbo;
    float energygain;
    int weaponclass;
    float shieldAngle;
    float invincibility;
    float livingTime; // livingTime, modulo 256 sec
    float mapEnergyGain;
    bool bounced;
    bool isHuman;
    Player _catchedPlayer;
    float _catchedPlayerDistance;

    private Powerup[MAX_DRAGGED_POWERUPS] _draggedPowerups;
    private int _numDraggedPowerups;

    static const float SHIELD_SIZE_FACTOR = 2.f;
    static const float INVICIBILITY_SIZE_FACTOR = 2.f;
    static const float LIVING_TIME_CYCLE = 256.f;

    this(Game game, bool isHuman_, vec2f pos, float angle)
    {
        this.isHuman = isHuman_;
        this.pos = pos;
        this.angle = angle;
        this.lastPos = pos;
        this.game = game;
        this.random = Random();
        this.mapEnergyGain = 0.f;
        _camera = game.camera();
        vangle = 0.f;
        mov = vec2f(0.f);
        dead = false;
        destroy = 0.f;
        life = 1;
        

        turbo = false;
        shipSize = 7.f + sqr(random.nextFloat) * 7;
        weaponclass = 1 + round(sqr(random.nextFloat)*2);
        energygain = BASE_ENERGY_GAIN;
        shieldAngle = random.nextFloat;
        armsPhase = random.nextAngle;

        livingTime = 0.f;

        _draggedPowerups[] = null;
        _numDraggedPowerups = 0;
        _catchedPlayer = null;

        if (isHuman)
        {
            life = 1.0;
            weaponclass = 1;
            attitude = Attitude.HUMAN;
            shipSize = 7.0;
            color = vec3f(1, 0, 0);
            baseVelocity = PLAYER_BASE_VELOCITY;
            waitforshootTime = 0.f;
            invincibility = level > 0 ? 2.f : 0.f;
            energy = 0;
        }
        else
        {
            energy = ENERGYMAX;
            waitforshootTime = random.nextFloat;
            invincibility = 0.f;

            vec3f colorchoose()
            {
                float r = void, g = void, b = void;
                bool ok = false;
                do
                {
                    r = random.nextFloat;
                    g = random.nextFloat;
                    b = random.nextFloat;
                    ok = (r+g+b > 1.f) && (r*g*b < 0.5);
                } while(!ok);
                return vec3f(r, g, b);
            }
            color = colorchoose;
            angle = random.nextFloat * TAU_F;

            // AI have slightly different velocities
            baseVelocity = PLAYER_BASE_VELOCITY * (1.f + (random.nextFloat - 0.5f) * 0.1f);

            attitude = (random.nextRange(2) == 0) ? Attitude.OCCUPIED : Attitude.FEARFUL;
        }
    }

    void cleanup()
    {
        stopDraggingPlayer();       
        stopDraggingPowerups();
    }

    void checkDragInvariant()
    {
        // check for non-presence
        for (int i = 0; i < _numDraggedPowerups; ++i)
        {
            assert(_draggedPowerups[i] !is null);
            assert(_draggedPowerups[i].getDragger() is this);
        }
    }

    void startDragPowerup(Powerup p)
    {
        debug checkDragInvariant();
        assert(_numDraggedPowerups < MAX_DRAGGED_POWERUPS);
        
        // check for non-presence
        for (int i = 0; i < _numDraggedPowerups; ++i)
            assert(_draggedPowerups[i] !is p);

        _draggedPowerups[_numDraggedPowerups++] = p;
                  
        game.soundManager.playSound(p.pos, 0.7f + random.nextFloat * 0.3f, SOUND.CATCH_POWERUP);
        debug checkDragInvariant();
    }

    void stopDragPowerup(Powerup p)
    {        
        debug checkDragInvariant();
        bool found = false;
        int i = 0;
        while (i < _numDraggedPowerups)
        {        
            if (p is _draggedPowerups[i])
            {
                assert(!found);
                found = true;
                --_numDraggedPowerups;
                _draggedPowerups[i] = _draggedPowerups[_numDraggedPowerups];
                _draggedPowerups[_numDraggedPowerups] = null;
            }
            else
            {
                i++;
            }
        }
        assert(found);
        debug checkDragInvariant();
    }

    void stopDraggingPlayer()
    {
        if (_catchedPlayer !is null)
        {
            _catchedPlayer._catchedPlayer = null;
            _catchedPlayer = null;
        }
    }

    void stopDraggingPowerups()
    {
        int i = 0;
        while (_numDraggedPowerups > 0)
        {
            assert(_draggedPowerups[0].getDragger() is this);
            _draggedPowerups[0].setDragger(null);
            ++i;
        }      
        debug checkDragInvariant();
    }    

    float invMass()
    {
        return 7.f / shipSize;
    }

    float mass()
    {
        return shipSize / 7.f;
    }

    bool isInvincible()
    {
        return invincibility > 0;
    }

    bool isAlive()
    {
        return (destroy == 0);
    }

    float effectiveSize()
    {
        if (invincibility > 0)
        {
            return shipSize * INVICIBILITY_SIZE_FACTOR;
        }

        if (life > 1.00001)
        {
            return shipSize * SHIELD_SIZE_FACTOR;
        } else
        {
            return shipSize;
        }
    }

    bool isVulnerable() // will explode at next hit
    {
        return life < DAMAGE_MULTIPLIER * BULLET_DAMAGE * damageMultiplier();
    }

    bool isReallyReallyVulnerable() // will explode at next hit
    {
        return life * 8.f < DAMAGE_MULTIPLIER * BULLET_DAMAGE * damageMultiplier();
    }

    vec3f maincolor()
    {
        vec3f r = void;
        float expo = shipSize - 6.0;

        if (isVulnerable() && (cos(TAU_F * 6.f * livingTime) >= 0))
        {
            r = vec3f(1.f) - color;
        }
        else
        {
            r = color;
        }

        if (attitude == Attitude.KAMIKAZE)
        {
            r = vec3f(1.f, r.y, r.z);
        }

        if (invincibility > 0)
        {
            r = vec3f(r.x, r.y, mixf(r.z, 1.f, minf(1.f, invincibility)));
        }

        r.z = min(1.f, r.z + mapEnergyGain * 0.1f);

        return r;
    }

    static bool collisioned(Player s1, Player s2)
    {
        // trick: collision do not happen outside of vision :)
        if ((!player._camera.canSee(s1.pos)) || (!player._camera.canSee(s2.pos)))
            return false;

        return s1.pos.squaredDistanceTo(s2.pos) < (sqr(s1.effectiveSize + s2.effectiveSize));
    }

    void show()
    {
        const ENGINE_ARMS = 3;
        if ((dead) || (!_camera.canSee(pos)))
        {
            return;
        }

        if (_catchedPlayer !is null)
        {
            GL.begin(GL.LINES);
                GL.color = RGBAF(0xff606060);
                vertexf(pos);
                vertexf(_catchedPlayer.pos);
            GL.end();
        }

        pushmatrix;

        vga2d.translate(pos);

        scale(shipSize, shipSize);

        GL.enable(GL.BLEND);

        // invincibility shield
        if (isInvincible())
        {
            GL.begin(GL.TRIANGLE_FAN);

            GL.color = vec4f(0.0f,0.0f,0.1f,0.8f);
            for (int i = 0; i < 32; ++i)
            {
                float fi = i / 32.f;
                float angle = TAU_F * fi;
                float sina = void, cosa = void;
                sincos(angle, sina, cosa);
                vertexf(cosa * INVICIBILITY_SIZE_FACTOR, sina * INVICIBILITY_SIZE_FACTOR);
            }
            GL.end();

            pushmatrix;

            rotate(shieldAngle);
            GL.begin(GL.LINE_STRIP);


            for (int i = 0; i <= 32; ++i)
            {
                float fi = i / 32.f;
                float angle = TAU_F * fi;
                vec3f c = mix(mix(vec3f(0,0,1), color, fi), vec3f(0), (i+1) / 32.f);
                GL.color = vec4f(c, 0.8f);
                float sina = void, cosa = void;
                sincos(angle, sina, cosa);
                vertexf(cosa * INVICIBILITY_SIZE_FACTOR, sina * INVICIBILITY_SIZE_FACTOR);
            }
            GL.end();
            popmatrix;

        }

        // life shield
        if ((life > 1.00001) && (!isInvincible()))
        {
            pushmatrix;

            rotate(shieldAngle);

            GL.begin(GL.LINE_STRIP);

            for (int i = 0; i <= 32; ++i)
            {
                float fi = i / 32.f;
                float angle = TAU_F * fi;
                vec3f c = mix(  mix(vec3f(1,1,0), color, fi), vec3f(0), (i+1) / 32.f);
                GL.color = vec4f(c, (life - 1) * 0.7f );
                float cosa = void, sina = void;
                sincos(angle, sina, cosa);
                vertexf(cosa * SHIELD_SIZE_FACTOR, sina * SHIELD_SIZE_FACTOR);
            }
            GL.end();
            popmatrix;
        }

        rotate(-angle + PI_2_F);
        if (destroy == 0)
        {
            GL.color = maincolor();
            GL.begin(GL.QUADS);
            {
                vertexf(0.0,1.0);
                vertexf(-0.72,-1.0);
                vertexf(0.0,-0.29);
                vertexf(0.72,-1.0);
            }
            GL.end();


            GL.color = mix(color, RGBF(ColorROL(Frgb(color), 12 + weaponclass)), 0.5f);

            {
                float wingswidth = min(3, weaponclass);
                pushmatrix;
                rotate(-waitforshootTime*60*0.2);
                GL.begin(GL.TRIANGLES);
                {
                    vertexf(-0.72,-0.143);
                    vertexf(-0.29,-0.143);
                    vertexf(-0.51-0.29*weaponclass,0.43+0.29*weaponclass);
                  }
                  GL.end();
                  rotate(waitforshootTime*60*0.4);
                  GL.begin(GL.TRIANGLES);
                {
                    vertexf(0.72,-0.143);
                    vertexf(0.29,-0.143);
                    vertexf(+0.51+0.29*weaponclass,0.43+0.29*weaponclass);
                }
                GL.end();
                  popmatrix;
              }

              GL.color = mix(color, RGBF(ColorROR(Frgb(color), 24)), 0.5f);

            GL.begin(GL.QUADS);
            {
                vertexf(0.0,0.5);
                vertexf(-0.36,-0.5);
                vertexf(0.0,-0.143);
                vertexf(0.36,-0.5);
            }
            GL.end();
            {
                pushmatrix;

                vga2d.translate(0.f,1.f);

                GL.color = 0.5f * color + 0.5f * vec3f(1.f, waitforshootTime * 960 / 255.f, 1.f);

                rotate( armsPhase + PI_F * 20.f * energy / cast(float)(ENERGYMAX));

                for (int j = 0; j < ENGINE_ARMS; ++j)
                {
                    GL.begin(GL.LINES);
                    vertexf(0,0);

                    float px = 0.01;
                    float py = 0.01;

                    float baseangle = j * 6.2831853f / 3.f;

                    assert(!isNaN(baseangle));


                    static const float[4] disp = [-0.6f, -1.2f, -1.8f, -2.4f];

                    for (int i = 0; i < 4; ++i)
                    {
                        float ang = baseangle - disp[0];
                        assert(!isNaN(ang));
                        float dist = 0.21f;
                        float sina = void, cosa = void;
                        sincos(ang, sina, cosa);
                        px = px + cosa * dist;
                        py = py + sina * dist;
                        vertexf(px,py);
                        vertexf(px,py);
                    }
                    GL.end();
                }

                popmatrix;
            }

        }
        else
        {
            GL.begin(GL.LINES);
            for (int i = 0; i < 6; ++i)
            {

                if (random.nextRange(4) == 0)
                {
                    GL.color = vec4f(0.5f,0.5f,0.5f,1);
                }
                else
                {
                    GL.color = vec4f(0,0,0,1);
                }
                float d = random.nextFloat * destroy / 7.f;
                vertexf(0.0,0.0);
                float angle = random.nextAngle;
                float cosa = void, sina = void;
                sincos(angle, sina, cosa);
                vertexf(cosa * d, sina * d);
            }
            GL.end();
        }
        popmatrix;

        GL.check();
    }

    // damage mulitplier, with ship size in account
    float damageMultiplier()
    {
        return pow(shipSize - 6.0,-2.0 / 3.0);
    }

    float damageToExplode()
    {
        return (life + 1e-2f) / (damageMultiplier() * DAMAGE_MULTIPLIER);
    }

    void damage(float amount)
    {
        if (invincibility > 0) return;

        amount *= DAMAGE_MULTIPLIER;
        life = life - amount * damageMultiplier();

        if (life <= 0)
        {
            explode(amount * 0.5 + 0.25f);
            if (isHuman)
            {
                BulletTime.exit();
            }
            
            life = -0.001;
        }
    }

    uint particleColor()
    {
        vec3f r = color;
      
        if (invincibility > 0)
            r.z = 1;

        if (attitude == Attitude.KAMIKAZE)
            r.x = 1;

        r.z = min(1.f, r.z + mapEnergyGain * 0.02f);

        return Frgb(r);
    }

    void explode(float explode_power)
    {
        if (isAlive())
        {
            game.soundManager.playSound(pos, 0.5f + 0.3f * random.nextFloat, SOUND.EXPLODE);

            explode_power = clamp(explode_power, 0.f, 1.f);
            destroy = 0.0001f;
            cleanup();
            angle = PI_F + normalizeAngle(angle - PI_F);

            int nParticul = round((100 + random.nextRange(60)) * PARTICUL_FACTOR * (shipSize / 7.f));
            auto cc = particleColor();
            for (int i = 0; i <= nParticul; ++i)            
            {
                int life = round(sqr(random.nextFloat) * random.nextRange(800 - round(400 * explode_power))) + 5;
                game.particles.add(pos, sqr(random.nextFloat) * mov * invMass,  0, 0, random.nextAngle,
                                   (sqr(random.nextFloat) + sqr(random.nextFloat) * 0.3f) * 7.0f * explode_power,
                            cc, life);
            }

            // move nearby powerups
            for (int i = 0; i < powerupIndex; ++i)
            {
                Powerup m = powerupPool[i];
                assert(m.getDragger() !is this);
                float d = pos.squaredDistanceTo(m.pos);
                m.mov += 100 * (m.pos - pos) / (d + 1.f);
            }

            // move nearby players
            void movePlayer(Player p)
            {
                if (p is null) return;
                if (p is this) return;
                if (p.dead) return;
                float d = pos.squaredDistanceTo(p.pos);
                p.mov += ((random.nextFloat + random.nextFloat) * 0.5f) * sqr(mass()) * 100 * (p.pos - pos) / (d + 100.f);
            }

            for (int i = 0; i < NUMBER_OF_IA; ++i)
            {
                movePlayer(ia[i]);
            }
            movePlayer(player);

            int nPowerup = 1 + round(random.nextFloat * level * 0.08);
            for (int i = 0; i < nPowerup; ++i)
            {
                float t = random.nextFloat;
                game.addPowerup(pos, mov * t, random.nextAngle, random.nextFloat * 5);
            }
        }
    }

    bool buyWithEnergy(float amount)
    {
        if (energy < amount)
            return false;

        energy -= amount;
        return true;
    }

    void shoot()
    {
        if (weaponclass == 0) return;
        if (waitforshootTime > 0.f) return;


        if (!buyWithEnergy(BULLET_COST))
            return;

        if (isAlive())
        {
            float baseangle = angle;

            int forwardBullet = min(weaponclass, 3);
            int mguided = isHuman ? 50 : 20;


            for (int i = 0; i < forwardBullet; ++i)
            {
                float mangle = baseangle + 0.07f * (i - (forwardBullet-1) * 0.5f);

                float mspeed = ((forwardBullet == 3) && (i == 1)) ? BULLET_BASE_SPEED + 0.5 : BULLET_BASE_SPEED;
                if (isHuman) 
                    mspeed *= 1.25;

                vec2f vel = mov;
                vec2f dir = polarOld(mangle, 1.f);
                vec2f v = mspeed * dir + vel;


                vec2f mpos = pos + dir * shipSize;

                auto mcolor = (RGBF(0xFFA0A0) + color) * 0.5f;
                Player owner = this;
                game.addBullet(mpos, v, mcolor, mangle, mguided, owner);
            }

            mov -= polarOld(baseangle, 1.f) * 0.5f; // recul

            waitforshootTime = RELOADTIME;
            game.soundManager.playSound(pos, 1.f, SOUND.SHOT);
        }
    }


    void move(Map map, double dt)
    {
        auto BUMPFACTOR = 1.414;
        auto CONSTANT_BUMP = 0.0;
        float f = void;
        if (dead) return;

        bounced = false;
        lastPos = pos;

        livingTime += dt;
        while (livingTime > LIVING_TIME_CYCLE) livingTime -= LIVING_TIME_CYCLE;

        {
            armsPhase += dt * 0.6 * PI_F;

            while (armsPhase > 32.f * TAU_F)
            {
                armsPhase -= 64.f * TAU_F;
            }
        }

        angle = normalizeAngle(angle + (vangle * invMass()) * 60.f * dt);

        vangle = vangle * exp(-dt * 0.955f);

        shieldAngle = shieldAngle + 12 * dt;

        while(shieldAngle > PI_F * 2)
        {
            shieldAngle -= PI_F * 2;
        }

        waitforshootTime -= dt;
        if (waitforshootTime < 0.f) waitforshootTime = 0.f;

        if (invincibility > 0)
        {
             invincibility = maxf(0.f, invincibility - dt);
        }

        if (energy < ENERGYMAX)
        {
            energy = energy + energygain * 60.f * dt;
        }

        if (life < 1)
        {
            life = life + LIFEREGEN * 60.f * dt;
            if (life > 1) life = 0.999;
        }


        if (_catchedPlayer !is null)
        {
            float d = _catchedPlayer.pos.squaredDistanceTo(pos);
            if (d > 1e-3f)
            {
                _catchedPlayerDistance -= dt * 5f; // like TRAP
                if (_catchedPlayerDistance < 1.f) _catchedPlayerDistance = 1.f;
                _catchedPlayer._catchedPlayerDistance = _catchedPlayerDistance;

                d = sqrt(d);
                vec2f middle = (_catchedPlayer.pos + pos) * 0.5f;
                vec2f idealPosThis = middle + (pos - middle) * _catchedPlayerDistance / d;
                vec2f idealPosOther = middle - (pos - middle) * _catchedPlayerDistance / d;
                pos += (idealPosThis - pos) * min!(float)(1.f, 2.f * dt);
                _catchedPlayer.pos += (idealPosOther - _catchedPlayer.pos) * min!(float)(1.f, 2.f * dt);
                mov += (idealPosThis - pos) * min!(float)(1.f, 0.25f * dt);
                _catchedPlayer.mov += (idealPosOther - _catchedPlayer.pos) * min!(float)(1.f, 0.25f * dt);
            }
        }

        pos = pos + mov * invMass * 60.f * dt;

        // damping
        {
            // horrible legacy code, there is two damping, one of which is anosotropic :(
            // was unstable
            {
                const SPEEDATENUATOR = 0.00003;
                double speedAtten = clamp(1 - SPEEDATENUATOR * (abs(mov.x * mov.x * mov.x) + abs(mov.y * mov.y * mov.y)), 1e-5, 1.0);

                // It's very difficutl to replace the anisotropic damping...
                //double movL = mov.length();
                //double speedAtten = clamp(1 - SPEEDATENUATOR * movL * movL * movL, 1e-5, 1.0);

                float vFact = expd(dt * logd(speedAtten) * 60.f);
                mov *= vFact;
            }

            {
                double spF = clampd(1.0 - mov.squaredLength / sqr(SPEED_MAX), 1e-10, 1.0);
                double speedAtten2 = sqrt(spF);
                float vFact2 = expd(dt * logd(speedAtten2) * 60.f);
                mov *= vFact2;
            }
        }

        // gain energy from map borders (yes, like in the real world, just go the the edge of the World :)
        {
            mapEnergyGain = 0.f;

            float fx = map.distanceToBorder(pos);
   
            if (fx < 100)
            {
                mapEnergyGain += 0.4f * dt * (100 - fx) * mov.squaredLength;
            }

            energy = clampf(energy + mapEnergyGain, 0.f, 2 * ENERGYMAX);
        }

        //  borders
        {
            int bounces = map.enforceBounds(pos, mov, angle, effectiveSize, BUMPFACTOR, CONSTANT_BUMP);

            bounced = bounces > 0;

            if (bounced)
            {
                stopDraggingPlayer();
            }

            if (bounces > 0)
            {
                energy = 0;
                invincibility = 0.0f;
                game.soundManager.playSound(pos, 1.f, SOUND.BORDER);
            }
        }

        if (destroy > 0.f)
        {
            destroy += dt;
            if (destroy >= 16 / 60.f)
            {                
                dead = true;
            }
        }

        if (attitude != Attitude.HUMAN)
        {
            if (random.nextFloat < 0.0025 * 60.f * dt) attitude = Attitude.AGGRESSIVE;
            if (random.nextFloat < 0.002 * 60.f * dt) attitude = Attitude.OCCUPIED;
            if ((life < 0.42) && (random.nextFloat < 0.0025 * 60.f * dt)) attitude = Attitude.FEARFUL;
            if ((life < 0.21) && (random.nextFloat < 0.01 * 60.f * dt)) attitude = Attitude.KAMIKAZE;

            if (!player.isValidTarget()) attitude = Attitude.OCCUPIED;
        }
    }

    void becomeMad()
    {
        attitude = Attitude.KAMIKAZE;
    }

    bool isValidTarget()
    {
        return isAlive();
    }

    void intelligence(ref Tmouse mouse, float dt)
    {
        if (destroy > 0) return;
        switch (attitude)
        {
            case Attitude.HUMAN:
            {
                auto axisx = joyAxis(0);
                auto axisy = joyAxis(1);
                bool isAlt = iskeydown(SDLK_LALT) || iskeydown(SDLK_RALT) || joyButton(3);
                bool isShift = iskeydown(SDLK_LSHIFT) || iskeydown(SDLK_RSHIFT);


                bool isUp = iskeydown(SDLK_UP) || iskeydown(SDLK_w);
                bool isDown = iskeydown(SDLK_DOWN) || iskeydown(SDLK_s);
                bool isLeft = iskeydown(SDLK_LEFT) || iskeydown(SDLK_a);
                bool isRight = iskeydown(SDLK_RIGHT) || iskeydown(SDLK_d);

                bool mouseLeft = 0 != (mouse.buttons & MOUSE_LEFT);
                bool mouseRight = 0 != (mouse.buttons & MOUSE_RIGHT);
                bool mouseCenter = 0 != (mouse.buttons & MOUSE_CENTER);

                bool isFire = iskeydown(SDLK_LCTRL) || iskeydown(SDLK_RCTRL) || iskeydown(SDLK_c) || mouseLeft || joyButton(1);

                if (isFire)
                {
                    shoot();
                }

                if (   keyoff(SDLK_SPACE)
                    || (joyButton(2) && lastTimeButton2WasOff)
                    || keyoff(SDLK_z)
                    || mouseCenter )
                {
                    drag();
                }

                mouse.buttons &= (~MOUSE_CENTER); // disable continuous powerup catch


                lastTimeButton2WasOff = !joyButton(2);

                turbo = isShift || joyButton(0) || iskeydown(SDLK_x) || mouseRight;

                if (isLeft && (!isAlt))
                {
                    angle += dt * 60.f * TURNSPEED * invMass();
                }

                if (isRight && (!isAlt))
                {
                    angle -= dt * 60.f * TURNSPEED * invMass();
                }

                if (turbo || isUp)
                {
                    progress(velocity(), 0, dt);
                }

                if (isDown)
                {
                    progress(velocity(), PI_F, dt);
                }
                if (isLeft && isAlt) { progress(velocity(), + PI_2_F, dt); }
                if (isRight && isAlt) { progress(velocity(), - PI_2_F, dt); }


                angle -= axisx * dt * 60.f * TURNSPEED * invMass();
                progress(-velocity() * axisy, 0, dt);
                break;
            }

            default: // IA
            {
                vec2f targetPos()
                {
                    if (player is null) return vec2f(0.f);

                    float intelligence = min(1.f, level / 30.f);

                    if (attitude == Attitude.KAMIKAZE)
                        return player.pos + intelligence * player.mov * 60;

                    if (attitude == Attitude.AGGRESSIVE)
                    {
                        float speed = (mov * invMass).length;

                        float d = (pos - player.pos).length / (BULLET_BASE_SPEED + speed);
                        return player.pos + intelligence * player.mov * d;
                    }
                    return player.pos;
                }


                vec2f target = targetPos();
                float targetAngle = player is null ? angle + PI_F : player.angle;


                float dx = pos.x - target.x;
                float dy = pos.y - target.y;
                float d = vec2f(dx,dy).length;
                float a = atan2(dy, dx) + PI_F;

                float dangle = normalizeAngle(a - angle);
                float dpangle = normalizeAngle(a - targetAngle);
                if (random.nextFloat < 0.6 * dt) 
                    drag();

                switch(attitude)
                {
                    case Attitude.AGGRESSIVE:
                        {
                            if (abs(dangle) < 1.f)
                            {
                                angle += dangle * TURNSPEED;
                                if ((d > 150) && (random.nextFloat < 0.01f)) turbo = true;
                            }
                            else
                            {
                                angle += dangle * TURNSPEED * 0.5f;
                            }
                            progress(velocity() * (min(0.4f, 1.f -(abs(dangle) / PI_F))), 0, dt);
                            if (abs(dangle) < 0.2f)
                            {
                                shoot();
                            }
                            else if (random.nextFloat < 0.6 * dt)
                            {
                                vangle += dangle * TURNSPEED * (random.nextFloat + 0.5f);
                            }
                        }
                        break;

                    case Attitude.FEARFUL:
                        {
                            if (random.nextFloat < 3 * dt) vangle = vangle - dangle * TURNSPEED* random.nextFloat * 0.2;
                            progress(velocity(), 0, dt);
                            if (random.nextFloat < 1.5 * dt) turbo = true;
                            if (abs(dangle) < 12 * dt) shoot();
                        }
                        break;

                    case Attitude.KAMIKAZE:
                        {
                            angle = angle + dangle * TURNSPEED * 1.8;
                            if (abs(dangle) < 0.1)
                            {
                                if (random.nextFloat < 3 * dt) turbo = true;
                            }
                            float advance = clamp(1 - sqr(abs(dangle)/PI_F), 0.f, 1.f);
                            progress(velocity() * advance, 0, dt);
                        }
                        break;

                    case Attitude.OCCUPIED:
                    default:
                        {
                            vangle = vangle + random.nextFloat2 * TURNSPEED * 0.012;
                            if (random.nextFloat < 0.1f * dt) turbo = !turbo;
                            progress(velocity() * 0.5,0, dt);
                            if (random.nextFloat < 0.6 * dt) 
                                drag();
                        }
                        break;
                }
            }
        }
    }

    float velocity()
    {
        return baseVelocity * (1.0f + (shipSize - 7) * 0.07f);
    }

    void progress(float acceleration, float theta, float dt)
    {
        if (abs(acceleration) < 1e-2) return;
        float r = acceleration;// * Fclamp(s.life + half);

        if ((turbo) && (r > 0))
        {
            if (!buyWithEnergy(TURBO_COST * dt * 60.f))
            {                
                turbo = false;
            }
            else
            {
                r = r * TURBO_FACTOR;
            }
        }

        vec2f thrust = polarOld(angle + theta, 1.f) * r;

        vec2f dec = polarOld(angle + theta, shipSize * 0.5f);

        mov += thrust * 60.f * dt;

        int nParticul = cast(int)(0.4f + (1 + round(r * r * 2)) * PARTICUL_FACTOR * 85 * dt);
        uint pcolor = particleColor();
        for (int i = 0; i < nParticul; ++i)
        {
            float where = random.nextFloat - 0.5f;
            game.particles.add(pos + where * mov - dec, vec2f(0), angle + PI_F + theta, 0,
                               random.nextAngle, random.nextFloat, pcolor, random.nextRange(80));

        }
    }

    void drag()
    {
        if (!isAlive()) return;
        float dmin = sqr(DRAG_DISTANCE);
        Powerup nearest = null;
        Player nearestPlayer = null;        

        int count = 0;

        for (int i = 0; i < powerupIndex; ++i)
        {
            Powerup p = powerupPool[i];
            assert(!p.dead);

            if (p.getDragger() !is this)
            {
                float f = pos.squaredDistanceTo(p.pos);
                if (f < dmin)
                {
                    dmin = f;
                    if ((p.getDragger() is null) || ( p.getDragger.pos.squaredDistanceTo(p.pos) > f))
                    {
                        nearest = p;
                    }
                }
            }
        }

        // big ships, with life, with invincibility, want to drag you more
        float probOfCatching = 0.0025f * shipSize * life * (isInvincible() ? 3 : 1);
        
        void catchOtherPlayer(Player other)
        {
            if (other is null)
                return;
            if (!other.isAlive())
                return;
            if (_catchedPlayer !is null)
                return;
            if (other._catchedPlayer !is null)
                return;
            if (!isHuman && !other.isHuman)
                return;

            if (this !is other)
            {
                float dist2 = pos.squaredDistanceTo(other.pos);
                if (dist2 < dmin)
                {
                    dmin = dist2;
                    nearest = null;
                    nearestPlayer = other;
                }
            }
        }
        if (isHuman || (random.nextFloat() < probOfCatching)) // AI rarely catch you
        {
            catchOtherPlayer(player);
            for (int i = 0; i < ia.length; ++i) 
                catchOtherPlayer(ia[i]);
        }

        if (nearestPlayer !is null)
        {
            _catchedPlayer = nearestPlayer; // enforce distance between two players
            _catchedPlayer._catchedPlayer = this;
            _catchedPlayerDistance = _catchedPlayer.pos.distanceTo(pos);
            _catchedPlayer._catchedPlayerDistance = _catchedPlayerDistance;
            assert(isFinite(_catchedPlayerDistance));    
            game.soundManager.playSound(_catchedPlayer.pos, 0.7f + random.nextFloat * 0.3f, 
                                        SOUND.CATCH_POWERUP);
        }
        else if ((nearest !is null) && (_numDraggedPowerups < MAX_DRAGGED_POWERUPS))
        {
            nearest.setDragger(this);          
        }
        else // nearest is null
        {
            if (isHuman)
            {
                game.soundManager.playSound(pos, 0.25f + random.nextFloat * 0.15f, SOUND.FAIL);
            }
        }
    }

    void rotatePush(float vangleAmount)
    {
        vangle += vangleAmount;
        if (isHuman)
            game.camera().dizzy(10 * abs(vangleAmount));
    }

    static void computeCollision(SoundManager soundManager, Player p1, Player p2)
    {
        if (p1 is null) return;
        if (p2 is null) return;
        if (!p1.isAlive()) return;
        if (!p2.isAlive()) return;

        if (Player.collisioned(p1, p2))
        {
            if (p2.isInvincible && (!p1.isInvincible))
            {
                p1.damage(p1.damageToExplode());
            }
            else if ((!p2.isInvincible) && p1.isInvincible)
            {
                p2.damage(p2.damageToExplode());
            }
            else
            {
                float v1 = p1.mov.length;
                float v2 = p2.mov.length;
                float damage = p2.mov.distanceTo(p1.mov) * COLLISION_DAMAGE_FACTOR / (v1 + v2 + 0.01f);
                p1.damage(v2 * damage);
                p2.damage(v1 * damage);

                soundManager.playSound(p2.pos, damage, SOUND.COLLISION);

                if ((p1.isAlive()) && (p2.isAlive()))
                {
                    if ((p1.isInvincible) && (p2.isInvincible))
                    {
                        p1.mov *= 2.f;
                        p2.mov *= 2.f;
                        p1.invincibility = 0.0f;
                        p2.invincibility = 0.0f;
                    }                    
                }
                else
                {
                    // weapon stealing
                    int weapon = max(p1.weaponclass, p2.weaponclass);
                    p1.weaponclass = weapon;
                    p2.weaponclass = weapon;
                }

                p1.rotatePush((p1.random.nextFloat - 0.5) * damage * (p1.isHuman ? 0.07 : 0.1));
                p2.rotatePush((p2.random.nextFloat - 0.5) * damage * (p2.isHuman ? 0.07 : 0.1));
            }
        }
    }
}

Player[NUMBER_OF_IA] ia;

Player player;

void playerkillia()
{
    for (int i = 0; i < ia.length; ++i)
    {
        if (ia[i] !is null)
        {
            ia[i].damage(100.f);
        }
    }
}


bool allEnemiesAreDead()
{
    for (int i = 0; i < NUMBER_OF_IA; ++i)
    {
        if (ia[i] !is null)
        {
            if (!ia[i].dead)
            {
                return false;
            }
        }
    }
    return true;
}
