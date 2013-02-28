module sound;

import sdl.mixer.all;
import derelict.sdl.mixer;
import sdl.all;
import utils;
import math.common;
import camera;
import math.all;
import misc.logger;
import players;
import lfo;
import globals;
import bullettime;

enum SOUND { SHOT, EXPLODE, BLAST, CATCH_POWERUP, DAMAGED, BORDER, BORDER2, COLLISION,
             POWERUP1, POWERUP2, POWERUP3, POWERUP4, PSCHIT, FAIL };

float[SOUND.max + 1] TIME_TO_WAIT = [0, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 0];
version = music;

static const BUF_LENGTH = 0x4000;

final class SoundManager
{
    public
    {
        this(Camera camera)
        {
            _camera = camera;
            try
            {
                m_SDLMixer = SDLMixer.instance;
            }
            catch(SDLError e)
            {
                m_SDLMixer = null; // no sound
                return;
            }

            m_music = new Music("deciBeats-Martini_Trip.ogg");
            Music.setVolume(0.8f);

            version(music)
            {
                m_music.play(true);
            }

            _paused = false;

            m_chunks.length = SOUND.max + 1;
            for (SOUND i = SOUND.min; i <= SOUND.max; ++i)
            {
                m_chunks[i] = m_SDLMixer.createChunk("data/" ~ wavFiles[i]);
                _timeToWait[i] = 0;
            }

            // register globalLowpass as a post-mix effect
            m_bufL.length = BUF_LENGTH;
            m_bufL[] = 0.0;
            m_bufR.length = BUF_LENGTH;
            m_bufR[] = 0.0;

            lfo1 = LFO(1.f / TAU_F);
            lfo2 = LFO(87.307f);
            lfo3 = LFO(0.9f);
            lfo4 = LFO(87.307f * 2.f);
            lfo5 = LFO(0.05f);
            lfo6 = LFO(0.07f);

            _mainPlayer = null;

            limiterAttack = powd(0.01, 1.0 / ( 1 * 44100 * 0.001));
            limiterRelease = powd(0.01, 1.0 / ( 10 * 44100 * 0.001));

            int res = Mix_RegisterEffect(MIX_CHANNEL_POST, &processFXCallback, null, cast(void*)this);

            if (res == 0)
            {
                warn(format("Cannot register the master lowpass: %s", Mix_GetError()));
            }            
        }

        synchronized void setMainPlayer(Player p)
        {            
            _mainPlayer = p;
        }

        // because the GC destroys this when the callback is running :(
        void close()
        {
            version(music)
            {
                m_music.stop();
            }

            Mix_UnregisterAllEffects(MIX_CHANNEL_POST);          
        }

        synchronized void setPaused(bool paused)
        {
            _paused = paused;
            if (paused) 
            {
                Mix_Pause(-1);
                Mix_PauseMusic();
            }
            else
            {
                Mix_Resume(-1);
                Mix_ResumeMusic();
            }
        }

        ~this()
        {            
        }

        
        void playSound(vec2f position, float baseVolume, SOUND sound)
        {
            if( m_SDLMixer !is null)
            {
                float x = position.x, y = position.y;
                vec2f camPos = _camera.position();
                float dx = camPos.x - x;
                float dy = camPos.y - y;

                float dist = sqrt(dx * dx + dy * dy) / 500.0;

                float a = atan2(x - camPos.x, y - camPos.y) - _camera.angle() - PI_2_F;

                if (dist > 1.f) return;

                m_chunks[sound].playPosition(baseVolume, dist, a);
            }
        }

        void playSound(float baseVolume, SOUND sound)
        {
            playSound(_camera.position(), baseVolume, sound);
        }

        void timePassed(double dt)
        {
            for (SOUND s = SOUND.min; s <= SOUND.max; ++s)
                _timeToWait[s] = max!(double)(0, _timeToWait[s] - dt);

        }
    }
    private
    {
        SDLMixer m_SDLMixer;
        Music m_music;
        Player _mainPlayer;
        Camera _camera;
        double[SOUND.max + 1] _timeToWait;
        Chunk[] m_chunks;
        double[] m_bufL;
        double[] m_bufR;    
        bool _paused;

        static const char[][] wavFiles =
        [
            "shot1.wav",
            "explode_ship.wav",
            "bonusblast1.wav",
            "catchbonus1.wav",
            "damaged1.wav",
            "border1.wav",
            "border2.wav",
            "collision1.wav",
            "bonus6.wav",
            "bonus7.wav",
            "bonus4.wav",
            "bonus5.wav",
            "pschit.wav",
            "fail.wav",
        ];

   
        double l0 = 0.0;
        double l1 = 0.0;
        double l2 = 0.0;
        double l3 = 0.0;

        double r0 = 0.0;
        double r1 = 0.0;
        double r2 = 0.0;
        double r3 = 0.0;

        float t = 0.0f;
        double dR = 0.0;
        double dL = 0.0;
        double dR2 = 0.0;
        double dL2 = 0.0;
        float m = 0.0;
        float lastFeedBackAmount = 0.f;
        float lastSubAmount = 0.f;
        float lastInvincibilityAmount = 0.f;
        float oldGainL = 1.f;
        float oldGainR = 1.f;

        float limiterAttack, limiterRelease;

        float envL = 0.f;
        float envR = 0.f;

        int delayIndex = 0;

        LFO lfo1, lfo2, lfo3, lfo4, lfo5, lfo6;

        bool firstCallback = true;

        synchronized void processFX(int chan, void *stream, int len, void *udata)
        {
            int N = len >> 2;

            double * delayBufL = m_bufL.ptr;
            double * delayBufR = m_bufR.ptr;

            float mgoal = void;
            float mFact = void;
            if (BulletTime.isEnabled())
            {
                float attF = 5e-5f;
                mgoal = 1.f;
                mFact = attF;
            }
            else
            {
                float relF = 1e-2f;
                mgoal = 0.f;
                mFact = relF;
            }

            bool playerAlive = (_mainPlayer !is null) && (!_mainPlayer.dead);

            float subBassGoal = playerAlive ? ( _mainPlayer.mapEnergyGain * (1.f + 0.3f * cos(t * 1.2f))) : 0.f;
            float invincibilityGoal = void;

            if (playerAlive && (_mainPlayer.isInvincible))
            {
                invincibilityGoal = 1.f;
            }
            else
            {
                invincibilityGoal = 0.f;
            }

            float feedbackAmount = min!(float)(bullettimeTime / 5.f + 0.2f, 1.f);


            short* p = cast(short*) stream;

            static double saturate(double x)
            {
                if (x > 1.0) x = 1.0;
                if (x < -1.0) x = -1.0;
                return (1.5 - 0.5 * x * x) * x;
            }

            static const float INC_TIME = 1.f / 44100.f;
            static const float MAX_PHASE = TAU_F * 32.f;
            static const float XTAU = 1e-3f;

            for (int i = 0; i < N; ++i)
            {
                m += (mgoal - m) * mFact;
                lastFeedBackAmount += (feedbackAmount - lastFeedBackAmount) * XTAU;
                lastSubAmount += (subBassGoal - lastSubAmount) * XTAU;
                lastInvincibilityAmount += (invincibilityGoal - lastInvincibilityAmount) * XTAU * 0.3f;

                t += INC_TIME;

                lfo1.next;
                lfo2.next;
                lfo3.next;
                lfo4.next;
                lfo5.next;
                lfo6.next;

                float mod6 = 0.9f + 0.1f * lfo6.s;
                float am = (m + lfo1.c * 0.05f) * mod6;
                float A = cos(am * TAU_F * 0.21f);
                float B = (1.f - A);

                float fact = -1.0f * B / short.max;
                double feedL = saturate(l3 * fact) * short.max;
                double feedR = saturate(r3 * fact) * short.max;


                float subbass = 200 * lastSubAmount * saturate(lfo2.s + lfo4.s * 0.2f);

                float delayModL = (lfo3.c ) * lastInvincibilityAmount;
                float delayModR = (lfo3.s ) * lastInvincibilityAmount;

                float delaySamplesL = 90 + 5.f * delayModL;
                float delaySamplesR = 80 + 5.f * delayModR;


                int indexL = cast(int)(delaySamplesL);
                int indexR = cast(int)(delaySamplesR);
                float fractL = delaySamplesL - indexL;
                float fractR = delaySamplesR - indexR;

                double Lm1 = delayBufL[((delayIndex - indexL - 1 + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Lp0 = delayBufL[((delayIndex - indexL     + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Lp1 = delayBufL[((delayIndex - indexL + 1 + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Lp2 = delayBufL[((delayIndex - indexL + 2 + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Rm1 = delayBufR[((delayIndex - indexR - 1 + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Rp0 = delayBufR[((delayIndex - indexR     + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Rp1 = delayBufR[((delayIndex - indexR + 1 + BUF_LENGTH) & (BUF_LENGTH - 1)) ];
                double Rp2 = delayBufR[((delayIndex - indexR + 2 + BUF_LENGTH) & (BUF_LENGTH - 1)) ];

                double delayL = hermite!(double)(fractL, Lm1, Lp0, Lp1, Lp2);
                double delayR = hermite!(double)(fractR, Rm1, Rp0, Rp1, Rp2);
                dL  = dL * 0.7f + (delayL + delayBufR[delayIndex] * 0.15f) * 0.3f;
                dR  = dR * 0.7f + (delayR + delayBufL[delayIndex] * 0.14f) * 0.3f;
                dL2 = dL2 * 0.8f + dL * 0.2f;
                dR2 = dR2 * 0.8f + dR * 0.2f;

                float mod5 = (0.9f + 0.1f * lfo5.s);
                delayL = short.max * saturate(dL2 * lastInvincibilityAmount / short.max) * -0.496f * mod5;
                delayR = short.max * saturate(dR2 * lastInvincibilityAmount / short.max) * -0.496f * mod5;

                double inL = p[i * 2] + feedL * lastFeedBackAmount + subbass + delayL ;
                double inR = p[i * 2 + 1] + feedR * lastFeedBackAmount + subbass + delayR ;

                l0 = inL * A + l0 * B;
                l1 = l0  * A + l1 * B;
                l2 = l1  * A + l2 * B;
                l3 = l2  * A + l3 * B;

                r0 = inR * A + r0 * B;
                r1 = r0  * A + r1 * B;
                r2 = r1  * A + r2 * B;
                r3 = r2  * A + r3 * B;

                // sub-bass (energy from map borders)
                float correction = 1.f + m * 0.9f;

                double inLimiterL = l3 * correction;
                double inLimiterR = r3 * correction;

                delayBufL[delayIndex] = inLimiterL * 0.85f;
                delayBufR[delayIndex] = inLimiterR * 0.85f;

                delayIndex = (delayIndex + 1) & (BUF_LENGTH - 1);


                // peak limiter

                float envValueL = abs(inLimiterL / short.max);
                float envValueR = abs(inLimiterR / short.max);

                float factL = (envValueL > envL) ? limiterAttack : limiterRelease;
                float factR = (envValueR > envR) ? limiterAttack : limiterRelease;

                envL = factL * (envL - envValueL) + envValueL;
                envR = factR * (envR - envValueR) + envValueR;

                static const float threshold = 0.9f;
                static const float ratio = 0.1f;

                float gainL = (envL < threshold) ? 1.f : (envL / (threshold + (envL - threshold) * ratio));
                float gainR = (envR < threshold) ? 1.f : (envR / (threshold + (envR - threshold) * ratio));

                if (_paused)
                {
                    gainL = 0;
                    gainR = 0;
                }

                oldGainL = (oldGainL + gainL) * 0.5f;
                oldGainR = (oldGainR + gainR) * 0.5f;
                                    

                double left = inLimiterL * oldGainL;
                double right = inLimiterR * oldGainR;


                short outL = cast(short)clampd(left, short.min + 1, short.max);
                short outR = cast(short)clampd(right, short.min + 1, short.max);

                p[i * 2] = outL;
                p[i * 2 + 1] = outR;
            }

            float ANTI_DENORMAL = 1e-25f;
            lastFeedBackAmount += ANTI_DENORMAL;
            lastFeedBackAmount -= ANTI_DENORMAL;
            m += ANTI_DENORMAL;
            m -= ANTI_DENORMAL;
            lastSubAmount += ANTI_DENORMAL;
            lastSubAmount -= ANTI_DENORMAL;
            lastInvincibilityAmount += ANTI_DENORMAL;
            lastInvincibilityAmount -= ANTI_DENORMAL;


            while (t > MAX_PHASE) t -= MAX_PHASE;

            lfo1.resync();
            lfo2.resync();
            lfo3.resync();
            lfo4.resync();
            lfo5.resync();
            lfo6.resync();
        }
    }
}

// hermite 3 point interpolation
static T hermite(T)(T frac_pos, T xm1, T x0, T x1, T x2)
{
   T c = (x1 - xm1) * cast(T)0.5;
   T v = x0 - x1;
   T w = c + v;
   T a = w + v + (x2 - x0) * cast(T)0.5;
   T b_neg = w + a;
   return ((((a * frac_pos) - b_neg) * frac_pos + c) * frac_pos + x0);
}


void makePowerupSound(SoundManager soundManager, vec2f pos)
{
    SOUND which;
    switch (random.nextRange(4))
    {
        case 0: which = SOUND.POWERUP1; break;
        case 1: which = SOUND.POWERUP2; break;
        case 2: which = SOUND.POWERUP3; break;
        case 3: default: which = SOUND.POWERUP4; break;
    }

    soundManager.playSound(pos, 0.65f + 0.2f * random.nextFloat, which);
}


// FX processor:
//   - pan effect when invicible
//   - 4LP filter sweep with reso when bullet time
//   - subbass when approaching borders

extern(C) void processFXCallback(int chan, void *stream, int len, void *udata)
{
    SoundManager manager = cast(SoundManager)udata;    
    manager.processFX(chan, stream, len, udata);    
}
