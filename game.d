
import globals;

import misc.image;
import math.all;
import misc.logger;
import math.all;;
import gl.all;
import vga2d;
import fast32;

import utils;
import boxes;
import oldfonts;
import vutils;
import futils;
import palettes;
import bullettime;
import players;
import cheatcode;
import postprocessing;

import particles, bullet, powerup;
import std.stdio;
import sdl.all;
import camera;
import map;

import derelict.opengl.extension.sgis.generate_mipmap;

import sound, joy;

final class Game
{
    private
    {
        bool _mainPlayerMustReborn;
        Texture2D m_fbTex;
        
        Image m_ui;
        box2i m_viewport;
        SoundManager m_soundManager;
        CheatcodeManager m_cheatcodeManager;
        Texture2D m_mainTexture;

        FBO m_mainFBO, m_defaultFBO;
        PostProcessing m_postProcessing;
        Shader m_blit;
        ParticleManager m_particleManager;
        BulletPool m_bulletPool;

        bool m_usePostProcessing = false;

        int _tipIndex;
        Random _random;
        float _zoomFactor;
        double _localTime;

        Camera _camera;

        bool _paused;
        float _timeBeforeReborn = 0.f;

        void renewTipIndex()
        {
            _tipIndex = abs(_random.nextRange(TIPS.length));
        }

        void setZoomfactor(float zoom)
        {
            _zoomFactor = clamp(zoom, 0.5f, 1.5f);
        }
    }

    public
    {
        ParticleManager particles()
        {
            return m_particleManager;
        }

        Camera camera()
        {
            return _camera;
        }
    }

    public
    {

        this(box2i viewport, bool usePostProcessing)
        {
            _mainPlayerMustReborn = true;
            _random = Random();
            renewTipIndex();
            setZoomfactor(1.f);
            _paused = false;
            _localTime = 0.0;

            _camera = new Camera();

            m_usePostProcessing = usePostProcessing;
            mb = new Image(SCREENX, SCREENY);

            info(">create m_fbTex");
            m_fbTex = new Texture2D(SCREENX, SCREENY, Texture.IFormat.RGBA8, false, false, false);
            m_fbTex.minFilter = Texture.Filter.NEAREST;
            m_fbTex.magFilter = Texture.Filter.NEAREST;
            m_fbTex.wrapS = Texture.Wrap.CLAMP_TO_EDGE;
            m_fbTex.wrapT = Texture.Wrap.CLAMP_TO_EDGE;
            info("<create m_fbTex");
            if (m_usePostProcessing)
            {
                info(">create main texture");
                m_mainTexture = new Texture2D(viewport.width, viewport.height, Texture.IFormat.RGBA8, true, false, false);
                m_mainTexture.minFilter = Texture.Filter.LINEAR_MIPMAP_LINEAR;
                m_mainTexture.magFilter = Texture.Filter.LINEAR;
                m_mainTexture.wrapS = Texture.Wrap.CLAMP_TO_EDGE;
                m_mainTexture.wrapT = Texture.Wrap.CLAMP_TO_EDGE;
                m_mainTexture.generateMipmaps();

                GL.check;
                info("<create main texture");
            }            

            if (m_usePostProcessing)
            {
                info(">create m_mainFBO");
                m_mainFBO = new FBO();
                m_mainFBO.color[0].setTarget(m_mainTexture, 0);                
                m_mainFBO.setWrite(FBO.Component.COLORS);
                int drawBuffer[1];
                drawBuffer[0] = 0;
                m_mainFBO.setDrawBuffers(drawBuffer[]);
                m_mainFBO.check();
                //m_mainFBO.use();
                info("<create m_mainFBO");

                info(">create default FBO");
                m_defaultFBO = new FBO(true);
                info("<create default FBO");
            }

            GL.clear();
            GL.check();


            if (m_usePostProcessing)
            {
                info(">create postProcessing");
                m_postProcessing = new PostProcessing(m_defaultFBO, m_mainTexture, viewport, m_fbTex);
                info("<create postProcessing");

                info(">m_blit");
                m_blit = new Shader("data/blit.vs", "data/blit.fs");
                info("<m_blit");
            }

            info(">create m_uiImage");
            SDLImage m_uiImage = new SDLImage("data/ui.png");
            info("<create m_uiImage");
            m_ui = new Image(m_uiImage);
            m_viewport = viewport;

            // sound
            info(">create m_soundManager");
            m_soundManager = new SoundManager(_camera);
            info("<create m_soundManager");
            m_cheatcodeManager = new CheatcodeManager(this);
            m_particleManager = new ParticleManager(this, _camera);
            m_bulletPool = new BulletPool();
        }

        void close()
        {
            m_soundManager.close();
        }

        void addZoomFactor(float x)
        {
            setZoomfactor(_zoomFactor + x);
        }

        void keyTyped(wchar ch)
        {
            if (ch == 'p')
                pause();
            else
                m_cheatcodeManager.keyTyped(ch);
        }

        double ratio()
        {
            return SCREENX / cast(double)SCREENY;
        }

        void suicide()
        {
            if (player !is null)
            {
                player.damage(10.f);
            }
        }

        void newGame()
        {
            if (((player is null) || player.dead) && (_timeBeforeReborn <= 0))
            {
                _mainPlayerMustReborn = true;
                _camera.nodizzy();
            }
        }

        void respawnEnnemies()
        {
            playerkillia;
        }

        void pause()
        {
            _paused = !_paused;
            m_soundManager.setPaused(_paused);
        }

        bool isPaused()
        {
            return _paused;
        }

        void progress(double dt)
        {
            _localTime += dt;
            m_soundManager.timePassed(dt);

            if (joyButton(1)) newGame();

            _timeBeforeReborn = max!(float)(_timeBeforeReborn - dt, 0.f);

            BulletTime.progress(dt);

            if (_mainPlayerMustReborn)
            {
                vec2f posBirth = _camera.position(); 
                float playerBirthAngle = _camera.angle() + PI_2_F;
                player = new Player(this, true, posBirth, playerBirthAngle);
                m_soundManager.setMainPlayer(player);

                _mainPlayerMustReborn = false;
                renewTipIndex();
            }

            bool playerWasAlive = player !is null && !player.dead;

            if ((_localTime > 22) && (allEnemiesAreDead())) // new game
            {
                initenemies;
            }

            int minPowerupCount = 5 + level;

            if (powerupIndex < minPowerupCount)
            {
                addPowerup(gmap.randomPoint(), vec2f(0), 0, 0);
            }

            if (player !is null) player.intelligence(dt);
            for (int i = 0; i < ia.length; ++i)
            {
                if (ia[i] !is null)
                {
                    ia[i].intelligence(dt);
                }
            }

            if (player !is null) player.move(dt);
            for (int i = 0; i < ia.length; ++i)
            {
                if (ia[i] !is null)
                {
                    ia[i].move(dt);
                }
            }

            m_particleManager.move(dt);

            m_bulletPool.move(dt);            

            for (int i = 0; i < powerupIndex; ++i)
            {
                powerupPool[i].move(dt);
            }

            m_bulletPool.checkCollision(dt);            
            m_bulletPool.removeDead();

            for (int i = 0; i < powerupIndex; ++i)
            {
                powerupPool[i].checkCollision(dt);
            }
            removeDeadPowerups();

            foreach(Player p; ia)
            {
                Player.computeCollision(m_soundManager, player, p);
            }
            for (int i = 0; i < ia.length; ++i)
                for (int j = i + 1; j < ia.length; ++j)
                    Player.computeCollision(m_soundManager, ia[i], ia[j]);


            // camera
            bool isRotateViewNow = (player !is null);

            if ((player !is null) && (!player.dead))
            {
                float advance = isRotateViewNow ? 7.f : 5.f;
                float constantAdvance = isRotateViewNow ? 75.f : 0.f;

                vec2f targetPos = player.pos + player.mov * advance + polarOld(player.angle, 1.f) * constantAdvance;
                float targetAngle = isRotateViewNow ? normalizeAngle(player.angle - PI_2_F) : 0.f;
                _camera.setTarget(targetPos, targetAngle);
            }

            bool playerIsDead = player !is null && player.dead;

            if (playerWasAlive && playerIsDead)
                _timeBeforeReborn = 1.4f;

            _camera.progress(dt, isRotateViewNow);

        }


        void showbars()
        {
            if (player !is null)
            {
                int s = (mb.height >> 1) - 14;

                // bullet time bar
                float bu = 2.f * BulletTime.fraction;
                Bar(mb.width - 29, mb.height - 14,max(s, round(s * bu)), bu, rgb(160,24,160));

                // energy bar
                Bar(mb.width - 18, mb.height - 14, max(s, round(player.energy / cast(float)ENERGYMAX * s)), player.energy / cast(float)ENERGYMAX,  rgb(252, 26, 15));

                // life bar
                Bar(mb.width - 7, mb.height - 14, max(s,round(player.life*s)),player.life, rgb(42, 6, 245));

                // invicibility bar
                Bar(mb.width - 7, mb.height - 14, max(s,round(player.life*s)),player.life * min(3.f, player.invincibility) / 3.f, rgb(252, 26, 15));

                if (player.isInvincible)
                {
                    mb.drawFilledBox(mb.width - 11, mb.height - 4,mb.width - 3, mb.height - 12, rgb(128,128,128));
                }
            }
        }

        void draw()
        {
            if (m_usePostProcessing)
            {
                m_mainFBO.use();

                GL.viewport = box2i(0, 0, m_viewport.width, m_viewport.height);

                GL.clear();                
            }
            else
            {        
                GL.viewport = m_viewport;
            }            
            if (_localTime < 5.0)
            {
                setZoomfactor(0.85f + 0.35f * sin(-PI_2_F + PI_F * _localTime / 5));
            }

            mb.data[] = m_ui.data[];

            if (_localTime >= 5.0 && _localTime < 21.0)
            {
                text.setAttr(0);
                text.setColor(0xFF8080FF);
                text.setFont(FontType.SMALL);

                int BX = 200;
                auto BY = 101 + 1 * 16;

                WindowBox(BX - 16, BY - 28, BX + 30 * 8 + 16, BY + 36 + 16 * 6, 0x8F8080FF);

                text.drawString(BX, BY     , "      The Homeric wars.       ");
                text.drawString(BX, BY + 16, "  In these times of trouble,  ");
                text.drawString(BX, BY + 32, "  it was common for the best  ");
                text.drawString(BX, BY + 48, "  warrior of a defeated tribe ");
                text.drawString(BX, BY + 64, "    to face an humiliating    ");
                text.drawString(BX, BY + 80, "  execution, fighting against ");
                text.drawString(BX, BY + 96, "   members of his own house.  ");
            }


            if ((player !is null) && (player.dead) && (!_paused))
            {

                // help screen

                WindowBox(130, 116, 510, 364, 0xffffffff);

                auto BX = 101 + 2 * 8;
                auto BY = 101 + 3 * 16;

                text.setAttr(0);
                text.setColor(0xFFFFFFFF);
                text.setFont(FontType.SMALL);

                text.drawString(BX, BY,      "                   Vibrant v1.6");
                text.setColor(0xffff7477);

                text.drawString(BX, BY + 16, "               www.gamesfrommars.fr    ");

                {
                    BY = 100 + 16 * 13;

                    char[] tip = "Tip: " ~ TIPS[_tipIndex];

                    text.setCursorPosition(320 - 4 * tip.length, BY);
                    text.setColor(0xff7477ff);
                    text.outputString(tip);

                    if (_timeBeforeReborn == 0.f)
                    {
                        char[] msg = "Now press FIRE to continue";
                        text.setCursorPosition(320 - 4 * msg.length, BY + 20);
                        text.setColor(clwhite);
                        text.outputString(msg);
                    }
                }

                {
                    BX = 101 + 8 * 8;
                    BY = 101 + 4 * 16 - 4;
                    text.setColor(clwhite);
                    text.setCursorPosition(BX, BY + 48);
                    text.outputString("       Keys");
                    text.setColor(clgrey);
                    text.setCursorPosition(BX, BY + 64);
                    text.outputString("   move: ARROWS");
                    text.setCursorPosition(BX, BY + 80);
                    text.outputString("   fire: CTRL, C");
                    text.setCursorPosition(BX, BY + 96);
                    text.outputString("   turbo: SHIFT, X");
                    text.setCursorPosition(BX, BY + 112);
                    text.outputString("   catch: SPACE, Z");
                }

                {
                    BX = 101 + 27 * 8;
                    BY = 101 + 4 * 16 - 4;
                    text.setColor(clwhite);
                    text.setCursorPosition(BX, BY + 48);
                    text.outputString("      Credits");
                    text.setColor(clgrey);
                    text.setCursorPosition(BX, BY + 64);                    
                    text.outputString("   code: ponce");
                    text.setCursorPosition(BX, BY + 80);
                    text.outputString("   music: DeciBeats");
                    text.setCursorPosition(BX + 8 * 10, BY + 96);
                    text.outputString("aka Evil");
                }
            }

            if (_paused)
            {
                WindowBox(280, 222, 360, 262, 0xffffffff);
                text.setAttr(0);
                text.setColor(clwhite);
                text.setFont(FontType.SMALL);
                text.setCursorPosition(320 - 8 * 3, 240);
                text.outputString("Paused");
            }

            GL.disable(GL.BLEND);
            GL.disable(GL.ALPHA_TEST);

            mat4f projectionMatrix = mat4f.scale(1 / ratio, 1.f, 1.f);
            float viewScale = 2.f * (1.0f / _zoomFactor) /  mb.height;
            mat4f modelViewMatrix = mat4f.scale(vec3f(viewScale, viewScale,1.f))
                                    * mat4f.rotateZ(-_camera.angle())
                                    * mat4f.translate(vec3f(-_camera.position(), 0.f));

            setProjectionMatrix(projectionMatrix);
            setModelViewMatrix(modelViewMatrix);

            if (m_usePostProcessing)
            {
                m_blit.use;
            }

            ground(_camera);
            m_particleManager.draw();

            showPowerups();

            m_bulletPool.draw();

            if (player !is null) player.show();

            foreach (ref p; ia)
            {
                if (p !is null) p.show();
            }

            if (m_usePostProcessing)
            {
                  m_blit.unuse;
                //m_mainFBO.setDrawBuffers(0);
            }

            char[] padZero(int n, int size, char[] pad)
            {
                char[] res = format("%s", n);
                while (res.length < size)
                {
                    res = pad ~ res; // TODO : remove inefficiency
                }
                return res;
            }


            {
                int x = 44;
                int by = 10;
                text.setFont(FontType.LARGE);
                text.setAttr(0);
                text.setColor(0xffff7477);
                text.setCursorPosition(x, by);
                text.outputString(padZero(level, 5, " "));
                
            }
            
            drawMinimap(_camera, m_bulletPool);
            showbars;
            
            GL.enable(GL.ALPHA_TEST);
            GL.alphaFunc(GL.GREATER, 0.001f);
            debug(2) crap("14");
            m_fbTex.setSubImage(0, 0, 0, SCREENX, SCREENY, Texture.Format.RGBA, Texture.Type.UBYTE, mb.ptr);
            debug(2) crap("15");
            
            {
                int texUnit = m_fbTex.use();

                GL.enable(GL.BLEND);
                GL.blend(GL.BlendMode.ADD, GL.BlendFactor.SRC_ALPHA, GL.BlendFactor.ONE_MINUS_SRC_ALPHA);

                setProjectionMatrix(mat4f.identity);
                setModelViewMatrix(mat4f.identity);
                GL.color(vec4f(1.f,1.f,1.f, 1.f));

                GL.begin(GL.QUADS);
                    GL.texCoord(texUnit, m_fbTex.smin, m_fbTex.tmax); GL.vertex(-1,-1);
                    GL.texCoord(texUnit, m_fbTex.smax, m_fbTex.tmax); GL.vertex(+1,-1);
                    GL.texCoord(texUnit, m_fbTex.smax, m_fbTex.tmin); GL.vertex(+1,+1);
                    GL.texCoord(texUnit, m_fbTex.smin, m_fbTex.tmin); GL.vertex(-1,+1);
                GL.end();

                m_fbTex.unuse();
            }
            if (m_usePostProcessing)
            {
                vec3f globalColor = _paused ?  vec3f(0.7f,0.7f,1.1f) : vec3f(1.f,1.f,1.f);
                m_postProcessing.render(projectionMatrix *  modelViewMatrix, globalColor);
            }
        }

    }

    public
    {
        void addBullet(vec2f pos, vec2f mov, vec3f color, float angle, int guided, Player owner)
        {
            m_bulletPool.add(this, pos, mov, color, angle, guided, owner);            
        }

        void addPowerup(vec2f pos, vec2f mov, float angle, float v)
        {
            if (powerupIndex >= MAX_POWERUPS) 
                return;
            powerupPool[powerupIndex++] = new Powerup(this, pos, mov + polarOld(angle, 1.f) * v);
        }

        void initenemies()
        {
            level++;
            if (level > 1) 
                soundManager.playSound(_camera.position() + vec2f(0.001f), 1.f, SOUND.PSCHIT);
            
            int realLevel = min(NUMBER_OF_IA, level);

            for (int i = 0; i < realLevel; ++i)
            {
                float a = i * 6.2831 / cast(float)(realLevel);
                assert(!isNaN(a));

                vec2f p = polarOld(a, 1.f) * (10 + 5.0 * realLevel);

                ia[i] = new Player(this, false, p, a);
            }

        }

        SoundManager soundManager()
        {
            return m_soundManager;
        }
    }
}
