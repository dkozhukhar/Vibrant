module vibrantprogram;

import sdl.all;
import misc.all;
import math.all;
import gl.all;
import std.gc;
import globals;
import game;
import vutils;
import mousex;
import joy;
import derelict.opengl.gl, derelict.opengl.glu, derelict.opengl.gl20, derelict.util.exception;

class VibrantProgram : SDLApp
{
    private
    {
        Image m_buffer;
        Game m_game;
        box2i m_view;

        wchar[] cheatString;
        Texture2D m_blurTex;
        Tmouse _mouse;

    //    double mA1, mA2;

        bool m_doRender = true;
    }

    public
    {
        this(int asked_width, int asked_height, double ratio, bool fullscreen, int fsaa, bool playMusic, float gamma, bool vsync, bool doBlur)
        {
            info(">VibrantProgram.this");
            FSAA aa = void;
            if (fsaa == 2) aa = FSAA.FSAA2X;
            else if (fsaa == 4) aa = FSAA.FSAA4X;
            else if (fsaa == 8) aa = FSAA.FSAA8X;
            else if (fsaa == 16) aa = FSAA.FSAA16X;
            else aa = FSAA.OFF;

            super(asked_width, asked_height, fullscreen, false, "Vibrant", "data/icon.bmp", aa, 0, OpenGLVersion.Version13, true);

            bool doPostProcessing = void;

            try
            {
                // try to load OpenGL 2.0
                DerelictGL.loadVersions(GLVersion.Version20);
                doPostProcessing = true;
            }
            catch(SharedLibProcLoadException e)
            {
                warn(e.msg);
                warn("Fallback to ugly mode, upgrade your gfx card!");
                doPostProcessing = false;
            }
        //    doPostProcessing = false;

            GL.check();

            SDL_ShowCursor(SDL_DISABLE);

            if (abs(ratio) < 0.0001) // auto ratio
            {
                ratio = cast(double)width / height;
                if (ratio < 5.0 / 4.0) ratio = 5.0 / 4.0;
                if (ratio > 16.0 / 9.0) ratio = 16.0 / 9.0;
            }

            // adjust viewport according to ratio
            m_view = box2i(0, 0, width, height).subRectWithRatio(ratio);
            GL.check();
            info(">OpenGL settings");
            GL.disable(GL.DEPTH_TEST, GL.LINE_SMOOTH, GL.POLYGON_SMOOTH, GL.POINT_SMOOTH);
            GL.disable(GL.BLEND, GL.FOG, GL.LIGHTING, GL.NORMALIZE, GL.STENCIL_TEST, GL.CULL_FACE);
            GL.disable(GL.AUTO_NORMAL, GL.DITHER, GL.FOG, GL.LIGHTING, GL.NORMALIZE);        
            GL.disable(GL.POLYGON_SMOOTH, GL.LINE_SMOOTH, GL.POINT_SMOOTH);

            info("<OpenGL settings");
            info(">new Game");
            m_game = new Game(m_view, doPostProcessing);
            info("<new Game");

            cheatString = "";
            info("<VibrantProgram.this");
        }

        void close()
        {
            m_game.close();
        }

        override void onRender(double elapsedTime)
        {
            if (m_doRender)
            {
                GL.clearColor = vec4f(0, 0, 0, 1);
                GL.clear(true, true, true);
  
                m_game.draw();
            }
        }

        override void onMove(double elapsedTime, double dt)
        {
            if (m_game.isPaused())
                return;

            // restart a game
            {
                bool mouseLeft = 0 != (_mouse.buttons & MOUSE_LEFT);
                bool isFire = iskeydown(SDLK_LCTRL) || iskeydown(SDLK_RCTRL) || iskeydown(SDLK_c) || mouseLeft || joyButton(1);

                if (isFire)
                {
                    m_game.newGame();
                }
            }

            dt *= 75.0 / 60.0;
            debug
            {
                if (iskeydown(SDLK_PAGEDOWN))
                    m_game.addZoomFactor(1.2f * dt);
               
                if (iskeydown(SDLK_PAGEUP))
                    m_game.addZoomFactor(- 1.2f * dt);
            }
            m_game.progress(_mouse, dt);
        }

        override void onKeyUp(int key, int mod, wchar ch)
        {
            if (key == SDLK_ESCAPE) terminate();

            if (key == SDLK_DELETE)
            {
                m_game.suicide();
            }
        }

        override void onFrameRateChanged(float frameRate)
        {
            debug
            {
                title = format("Vibrant FPS=%s", frameRate);
            }
        }

        override void onKeyDown(int key, int mod, wchar ch)
        {

            debug
            {
                if (key == SDLK_F1)
                {
                    m_doRender = !m_doRender;
                }
            }
            m_game.keyTyped(ch);
        }

        override void onMouseMove(int x, int y, int dx, int dy)
        {
            _mouse.x = x;
            _mouse.y = y;
            _mouse.vx = dx;
            _mouse.vy = dx;
        }

        override void onMouseDown(int button)
        {
            if (button == SDL_BUTTON_LEFT)
                _mouse.buttons |= MOUSE_LEFT;

            if (button == SDL_BUTTON_MIDDLE)
                _mouse.buttons |= MOUSE_CENTER;

            if (button == SDL_BUTTON_RIGHT)
                _mouse.buttons |= MOUSE_RIGHT;

            if (button == SDL_BUTTON_WHEELUP)
                _mouse.buttons |= MOUSE_CENTER;    // hack to catch powerups with mousewheel

            if (button == SDL_BUTTON_WHEELDOWN)
                _mouse.buttons |= MOUSE_CENTER;    // hack to catch powerups with mousewheel
        }

        override void onMouseUp(int button)
        {
            if (button == SDL_BUTTON_LEFT)
                _mouse.buttons &= ~MOUSE_LEFT;

            if (button == SDL_BUTTON_MIDDLE)
                _mouse.buttons &= ~MOUSE_CENTER;

            if (button == SDL_BUTTON_RIGHT)
                _mouse.buttons &= ~MOUSE_RIGHT;
        }

        override void onReshape(int width, int height)  {  }

        // GAME LOOP
        void run()
        {
            m_frameCounter.reset();

            bool firstFrame = true;

            while (! m_finished)
            {
                firstFrame = false;

                final double time = m_frameCounter.elapsedTime;

                double dt = m_frameCounter.deltaTime;                
                //processEvents();
                //onMove(time, dt / 2);
                processEvents();
                onMove(time, dt);
                //processEvents();
                //onMove(time + dt / 2, dt  /2);

                if (!firstFrame) swapBuffers();

                firstFrame = false;

                if (m_frameCounter.tick())
                {
                    onFrameRateChanged(m_frameCounter.frameRate);
                }
                onRender(time);
                //std.gc.fullCollect();
                //std.gc.minimize();
            }

            // flush pending events
            processEvents();
        }
    }
}



