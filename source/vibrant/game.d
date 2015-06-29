
import globals;

import misc.image;
import math.all;
import math.all;;
import gl.all;
import vga2d;
import mousex;

import utils;
import oldfonts;
import palettes;
import bullettime;
import players;
import cheatcode;
import postprocessing;
import minimap;

import particles, bullet, powerup;
import std.stdio;
import sdl.all;
import camera;
import map;
import overlay;

import derelict.opengl.extension.sgis.generate_mipmap;

import sound, joy;

final class Game
{
    private
    {
        bool _mainPlayerMustReborn;
        Texture2D m_fbTex;

        Overlay _overlay;
        
        Image m_ui;
        box2i m_viewport;
        SoundManager m_soundManager;
        CheatcodeManager m_cheatcodeManager;
        Texture2D m_mainTexture;
        Map _map;

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
        float _timeBeforeReborn = 0.0f;

        void renewTipIndex()
        {
            _tipIndex = abs(_random.nextRange(cast(int)(TIPS.length)));
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
            powerupPool.length = MAX_POWERUPS;

            _mainPlayerMustReborn = true;
            _random = Random();
            renewTipIndex();
            setZoomfactor(1.0f);
            _paused = false;
            _localTime = 0.0;

            _camera = new Camera();
            _map = new Map();

            m_usePostProcessing = usePostProcessing;
            _overlay = new Overlay();

            m_fbTex = new Texture2D(SCREENX, SCREENY, Texture.IFormat.RGBA8, false, false, false);
            m_fbTex.minFilter = Texture.Filter.NEAREST;
            m_fbTex.magFilter = Texture.Filter.NEAREST;
            m_fbTex.wrapS = Texture.Wrap.CLAMP_TO_EDGE;
            m_fbTex.wrapT = Texture.Wrap.CLAMP_TO_EDGE;
            if (m_usePostProcessing)
            {
                m_mainTexture = new Texture2D(viewport.width, viewport.height, Texture.IFormat.RGBA8, true, false, false);
                m_mainTexture.minFilter = Texture.Filter.LINEAR_MIPMAP_LINEAR;
                m_mainTexture.magFilter = Texture.Filter.LINEAR;
                m_mainTexture.wrapS = Texture.Wrap.CLAMP_TO_EDGE;
                m_mainTexture.wrapT = Texture.Wrap.CLAMP_TO_EDGE;
                m_mainTexture.generateMipmaps();

                GL.check;
            }            

            if (m_usePostProcessing)
            {
                m_mainFBO = new FBO();
                m_mainFBO.color[0].setTarget(m_mainTexture, 0);                
                m_mainFBO.setWrite(FBO.Component.COLORS);
                int[1] drawBuffer;
                drawBuffer[0] = 0;
                m_mainFBO.setDrawBuffers(drawBuffer[]);
                m_mainFBO.check();
                //m_mainFBO.use();

                m_defaultFBO = new FBO(true);
            }

            GL.clear();
            GL.check();


            if (m_usePostProcessing)
            {
                m_postProcessing = new PostProcessing(m_defaultFBO, m_mainTexture, viewport, m_fbTex);
             
                m_blit = new Shader("data/blit.vs", "data/blit.fs");
            }
            
            m_viewport = viewport;

            // sound
            m_soundManager = new SoundManager(_camera);
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
            if (ch == 'm')
                m_soundManager.toggleMusic();
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
                player.damage(10.0f);
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

        void progress(ref MouseState mouse, double dt)
        {
            _localTime += dt;
            m_soundManager.timePassed(dt);

            if (joyButton(1)) newGame();

            _timeBeforeReborn = max!(float)(_timeBeforeReborn - dt, 0.0f);

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
                addPowerup(_map.randomPoint(), vec2f(0), 0, 0);
            }

            if (player !is null) player.intelligence(mouse, dt);
            for (int i = 0; i < ia.length; ++i)
            {
                if (ia[i] !is null)
                {
                    ia[i].intelligence(mouse, dt);
                }
            }

            if (player !is null) player.move(_map, dt);
            for (int i = 0; i < ia.length; ++i)
            {
                if (ia[i] !is null)
                {
                    ia[i].move(_map, dt);
                }
            }

            m_particleManager.move(_map, dt);

            m_bulletPool.move(_map, dt);            

            for (int i = 0; i < powerupIndex; ++i)
            {
                powerupPool[i].move(_map, dt);
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
                float advance = isRotateViewNow ? 7.0f : 5.0f;
                float constantAdvance = isRotateViewNow ? 75.0f : 0.0f;

                vec2f targetPos = player.pos + player.mov * advance + polarOld(player.angle, 1.0f) * constantAdvance;
                float targetAngle = isRotateViewNow ? normalizeAngle(player.angle - PI_2_F) : 0.0f;
                _camera.setTarget(targetPos, targetAngle);
            }

            bool playerIsDead = player !is null && player.dead;

            if (playerWasAlive && playerIsDead)
                _timeBeforeReborn = 1.4f;

            _camera.progress(dt, isRotateViewNow);

        }


        void showBars()
        {
            if (player !is null)
            {
                int s = (SCREENY / 2) - 14;

                // bullet time bar
                float bu = 2.0f * BulletTime.fraction;

                _overlay.drawBar(SCREENX - 29, SCREENY - 14,max(s, cast(int)round(s * bu)), bu, rgb(160,24,160));

                // energy bar
                _overlay.drawBar(SCREENX - 18, SCREENY - 14, max(s, cast(int)round(player.energy / cast(float)ENERGYMAX * s)), player.energy / cast(float)ENERGYMAX,  rgb(252, 26, 15));

                // life bar
                _overlay.drawBar(SCREENX - 7, SCREENY - 14, max(s, cast(int)round(player.life*s)),player.life, rgb(42, 6, 245));

                // invicibility bar
                _overlay.drawBar(SCREENX - 7, SCREENY - 14, max(s,cast(int)round(player.life*s)),player.life * min(3.0f, player.invincibility) / 3.0f, rgb(252, 26, 15));

                if (player.isInvincible)
                {
                    _overlay._mb.drawFilledBox(SCREENX - 11, SCREENY - 4, SCREENX - 3, SCREENY - 12, rgb(128,128,128));
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

            _overlay.clearBuffer();
            
            if ((player !is null) && (player.dead) && (!_paused))
            {
                _overlay.drawHelpScreen(TIPS[_tipIndex], _timeBeforeReborn == 0.0f);
            }
            else if (_paused)
            {
                _overlay.drawPauseScreen();                
            }
            else if (_localTime >= 5.0 && _localTime < 21.0)
            {
                _overlay.drawIntroductoryText((_localTime - 5) / 16.0);
            }

            GL.disable(GL.BLEND);
            GL.disable(GL.ALPHA_TEST);

            mat4f projectionMatrix = mat4f.scale(1 / ratio, 1.0f, 1.0f);
            float viewScale = 2.0f * (1.0f / _zoomFactor) /  SCREENY;
            mat4f modelViewMatrix = mat4f.scale(vec3f(viewScale, viewScale,1.0f))
                                    * mat4f.rotateZ(-_camera.angle())
                                    * mat4f.translate(vec3f(-_camera.position(), 0.0f));

            setProjectionMatrix(projectionMatrix);
            setModelViewMatrix(modelViewMatrix);

            if (m_usePostProcessing)
            {
                m_blit.use;
            }

            _map.draw(_camera);
            m_particleManager.draw();

            showPowerups(_overlay._text);

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

            _overlay.drawStatus();
            
            drawMinimap(_camera, _map, m_bulletPool);
            showBars();
            
            GL.enable(GL.ALPHA_TEST);


            m_fbTex.setSubImage(0, 0, 0, SCREENX, SCREENY, Texture.Format.RGBA, Texture.Type.UBYTE, _overlay._mb.ptr);
            
            {
                int texUnit = m_fbTex.use();

                GL.enable(GL.BLEND);
                GL.blend(GL.BlendMode.ADD, GL.BlendFactor.SRC_ALPHA, GL.BlendFactor.ONE_MINUS_SRC_ALPHA);

                setProjectionMatrix(mat4f.identity);
                setModelViewMatrix(mat4f.identity);
                GL.color(vec4f(1.0f,1.0f,1.0f, 1.0f));

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
                vec3f globalColor = _paused ?  vec3f(0.7f,0.7f,1.1f) : vec3f(1.0f,1.0f,1.0f);
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
            powerupPool[powerupIndex++] = new Powerup(this, pos, mov + polarOld(angle, 1.0f) * v);
        }

        void initenemies()
        {
            level++;
            if (level > 1) 
                soundManager.playSound(_camera.position() + vec2f(0.001f), 1.0f, SOUND.PSCHIT);
            
            int realLevel = min(NUMBER_OF_IA, level);

            for (int i = 0; i < realLevel; ++i)
            {
                float a = i * 6.2831 / cast(float)(realLevel);
                assert(!isNaN(a));

                vec2f p = polarOld(a, 1.0f) * (10 + 5.0 * realLevel);

                ia[i] = new Player(this, false, p, a);
            }

        }

        SoundManager soundManager()
        {
            return m_soundManager;
        }
    }
}
