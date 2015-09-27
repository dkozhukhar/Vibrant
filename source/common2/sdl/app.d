module sdl.app;

import gfm.math;
import derelict.sdl2.sdl;
import sdl.state, std.stdio, std.string, std.conv;
import misc.framecounter;
import gl.state;


enum FSAA { OFF, FSAA2X, FSAA4X, FSAA8X, FSAA16X };

class SDLApp
{

    protected
    {
        bool m_fullscreen;
        bool m_finished;
        bool m_resizable;
        int m_width, m_height;

        SDL m_sdl;
        GLState m_GLState;
        //SDL_Surface* m_screen;
        SDL_Window* _window;
        FrameCounter m_frameCounter;

        int m_mousex, m_mousey, m_ancmousex, m_ancmousey;

    }

    private
    {
        static const int[FSAA.max + 1] FSAA_toInt = [-1,2,4,8,16];
        int m_delayBetweenFrames;
    }

    public
    {
        enum AUTO_DETECT = -1; // a utiliser a la place de width et height pour utiliser la taille courante de l'ecran

        this(int width,  // desired window width, could be AUTO_DETECT to match current resolution
             int height, // desired window height, could be AUTO_DETECT to match current resolution
             bool fullscreen, // fullscreen or not
             bool resizable, // resizeable or not
          //   bool border, // frame or not
             string initTitle,
             string iconFile, // can be null
             FSAA fsaa,
             int wantedFrameRate, // if wantedFrameRate == 0 then the frame counter will count frames to find the frame rate
             OpenGLVersion requiredGLVersion,
             bool verticalSync,
             int delayBetweenFrames = 0) // in ms
        {
            m_sdl = SDL.instance; // init SDL if required
            m_fullscreen = fullscreen;
            m_resizable = resizable & (! fullscreen);

            SDL_DisplayMode videoInfo;
            int should_be_zero = SDL_GetCurrentDisplayMode(0, &videoInfo);

            m_width = (width == AUTO_DETECT) ? videoInfo.w : width;
            m_height = (height == AUTO_DETECT) ? videoInfo.h : height;

            uint flags = SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE
                       | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS;
            if (resizable) flags |= SDL_WINDOW_RESIZABLE;
            if (fullscreen) flags |= SDL_WINDOW_FULLSCREEN;

     /*       if (iconFile !is null)
            {
                SDL_Surface* icon = SDL_LoadBMP(toStringz(iconFile));
                uint colorkey = SDL_MapRGB(icon.format, 255, 0, 255); // magenta is transparent
                SDL_SetColorKey(icon, SDL_SRCCOLORKEY, colorkey);
                SDL_WM_SetIcon(icon, null);
            }*/

            SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
            SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

            _window = SDL_CreateWindow(toStringz(initTitle),
                SDL_WINDOWPOS_CENTERED,
                SDL_WINDOWPOS_CENTERED,
                m_width,
                m_height,
                flags);

            title = initTitle;

            m_GLState = GL = new GLState();

            if (wantedFrameRate > 0)
            {
                m_frameCounter = new FixedFrameCounter(wantedFrameRate);
            }
            else
            {
                m_frameCounter = new VariableFrameCounter(1.0);
            }
            m_finished = false;
            m_delayBetweenFrames = delayBetweenFrames;

            //version(darwin)
            //    SDL_WM_GrabInput(SDL_GRAB_ON);
        }

        final int width()
        {
             return m_width;
        }

        final int height()
        {
             return m_height;
        }

        final string title(string s)
        {
            SDL_SetWindowTitle(_window, toStringz(s));
            return s;
        }

        final void terminate()
        {
            m_finished = true;
        }

        final void swapBuffers()
        {
            SDL_GL_SwapWindow(_window);
        }

        final void processEvents()
        {
            SDL_Event event;
            while (SDL_PollEvent(&event))
            {
                switch (event.type)
                {
                    // handle keyboard

                    case SDL_KEYUP:
                    {
                        SDL_Keycode key = event.key.keysym.sym;
                        SDL_Keymod mod = event.key.keysym.mod;
                        dchar ch = event.key.keysym.unicode;
                        SDL.instance.keyboard.markAsReleased( key );
                        onKeyUp( key, mod, ch );
                        break;
                    }

                    case SDL_KEYDOWN:
                    {
                        SDL_Keycode key = event.key.keysym.sym;
                        SDL_Keymod mod = event.key.keysym.mod;
                        dchar ch = event.key.keysym.unicode;
                        SDL.instance.keyboard.markAsPressed( key );
                        onKeyDown( key, mod, ch );
                        break;
                    }

                    // handle mouse

                    case SDL_MOUSEMOTION:
                        m_ancmousex = m_mousex;
                        m_ancmousey = m_mousey;
                        m_mousex = event.motion.x;
                        m_mousey = event.motion.y;

                        onMouseMove(m_mousex, m_mousey, m_mousex - m_ancmousex, m_mousey - m_ancmousey);
                        break;

                    case SDL_MOUSEBUTTONDOWN:
                        onMouseDown(event.button.button);
                        break;

                    case SDL_MOUSEBUTTONUP:
                        onMouseUp(event.button.button);
                        break;

                    case SDL_JOYAXISMOTION:
                        int joy_index = event.jaxis.which;
                        int axis_index = event.jaxis.axis;
                        float value = event.jaxis.value / cast(float)(short.max);
                        SDL.instance.joystick(joy_index).setAxis(axis_index, value);
                        break;

                    case SDL_JOYBUTTONUP:
                    case SDL_JOYBUTTONDOWN:
                    {
                        int joy_index = event.jbutton.which;
                        int button_index = event.jbutton.button;
                        bool value = (event.jbutton.state == SDL_PRESSED);
                        SDL.instance.joystick(joy_index).setButton(button_index, value);
                        break;
                    }

                    case SDL_QUIT:
                        terminate();
                        break;

                    case SDL_WINDOWEVENT:

                        switch(event.window.event)
                        {
                        case SDL_WINDOWEVENT_RESIZED:
                        case SDL_WINDOWEVENT_SIZE_CHANGED:
                            m_width = event.window.data1;
                            m_height = event.window.data2;
                            onReshape(m_width,m_height);
                            break;
                        default:
                            break;
                        }
                        break;

                    default:
                        break;
                }
            }
        }

        // events handlers

        abstract void onRender(double elapsedTime);
        abstract void onMove(double elapsedTime, double dt);
        abstract void onKeyUp(int key, int mod, dchar ch);
        abstract void onKeyDown(int key, int mod, dchar ch);

        abstract void onMouseMove(int x, int y, int dx, int dy);
        abstract void onMouseDown(int button);
        abstract void onMouseUp(int button);
        abstract void onReshape(int width, int height);
        abstract void onFrameRateChanged(float frameRate);

        final vec2i mousePos()
        {
             return vec2i(m_mousex , m_mousey);
        }

        final float FPS()
        {
            return m_frameCounter.frameRate();
        }
    }
}


