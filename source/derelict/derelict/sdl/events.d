/*
 * Copyright (c) 2004-2009 Derelict Developers
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the names 'Derelict', 'DerelictSDL', nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
module derelict.sdl.events;

private
{
    import derelict.sdl.types;
    import derelict.sdl.active;
    import derelict.sdl.keyboard;
    import derelict.sdl.mouse;
    import derelict.sdl.joystick;
    import derelict.sdl.syswm;
}

enum
{
    SDL_NOEVENT = 0,
    SDL_ACTIVEEVENT,
    SDL_KEYDOWN,
    SDL_KEYUP,
    SDL_MOUSEMOTION,
    SDL_MOUSEBUTTONDOWN,
    SDL_MOUSEBUTTONUP,
    SDL_JOYAXISMOTION,
    SDL_JOYBALLMOTION,
    SDL_JOYHATMOTION,
    SDL_JOYBUTTONDOWN,
    SDL_JOYBUTTONUP,
    SDL_QUIT,
    SDL_SYSWMEVENT,
    SDL_EVENT_RESERVEDA,
    SDL_EVENT_RESERVEDB,
    SDL_VIDEORESIZE,
    SDL_VIDEOEXPOSE,
    SDL_EVENT_RESERVED2,
    SDL_EVENT_RESERVED3,
    SDL_EVENT_RESERVED4,
    SDL_EVENT_RESERVED5,
    SDL_EVENT_RESERVED6,
    SDL_EVENT_RESERVED7,
    SDL_USEREVENT = 24,
    SDL_NUMEVENTS = 32
}

enum
{
    SDL_ACTIVEEVENTMASK         = (1<<SDL_ACTIVEEVENT),
    SDL_KEYDOWNMASK             = (1<<SDL_KEYDOWN),
    SDL_KEYUPMASK               = (1<<SDL_KEYUP),
    SDL_KEYEVENTMASK            = SDL_KEYDOWNMASK | SDL_KEYUPMASK,
    SDL_MOUSEMOTIONMASK         = (1<<SDL_MOUSEMOTION),
    SDL_MOUSEBUTTONDOWNMASK     = (1<<SDL_MOUSEBUTTONDOWN),
    SDL_MOUSEBUTTONUPMASK       = (1<<SDL_MOUSEBUTTONUP),
    SDL_MOUSEEVENTMADK          = (SDL_MOUSEMOTIONMASK |
                                   SDL_MOUSEBUTTONDOWNMASK |
                                   SDL_MOUSEBUTTONUPMASK),
    SDL_JOYAXISMOTIONMASK       = (1<<SDL_JOYAXISMOTION),
    SDL_JOYBALLMOTIONMASK       = (1<<SDL_JOYBALLMOTION),
    SDL_JOYHATMOTIONMASK        = (1<<SDL_JOYHATMOTION),
    SDL_JOYBUTTONDOWNMASK       = (1<<SDL_JOYBUTTONDOWN),
    SDL_JOYBUTTONUPMASK         = (1<<SDL_JOYBUTTONUP),
    SDL_JOYEVENTMASK            = (SDL_JOYAXISMOTIONMASK |
                                   SDL_JOYBALLMOTIONMASK |
                                   SDL_JOYHATMOTIONMASK |
                                   SDL_JOYBUTTONDOWNMASK |
                                   SDL_JOYBUTTONUPMASK),
    SDL_VIDEORESIZEMASK         = (1<<SDL_VIDEORESIZE),
    SDL_VIDEOEXPOSEMASK         = (1<<SDL_VIDEOEXPOSE),
    SDL_QUITMASK                = (1<<SDL_QUIT),
    SDL_SYSWMEVENTMASK          = (1<<SDL_SYSWMEVENT)
}

enum : uint { SDL_ALLEVENTS = 0xFFFFFFFF }

struct SDL_ActiveEvent
{
    Uint8 type;
    Uint8 gain;
    Uint8 state;
}

struct SDL_KeyboardEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 state;
    SDL_keysym keysym;
}

struct SDL_MouseMotionEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 state;
    Uint16 x, y;
    Sint16 xrel;
    Sint16 yrel;
}

struct SDL_MouseButtonEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 button;
    Uint8 state;
    Uint16 x, y;
}

struct SDL_JoyAxisEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 axis;
    Sint16 value;
}

struct SDL_JoyBallEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 ball;
    Sint16 xrel;
    Sint16 yrel;
}

struct SDL_JoyHatEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 hat;
    Uint8 value;
}

struct SDL_JoyButtonEvent
{
    Uint8 type;
    Uint8 which;
    Uint8 button;
    Uint8 state;
}

struct SDL_ResizeEvent
{
    Uint8 type;
    int w;
    int h;
}

struct SDL_ExposeEvent
{
    Uint8 type;
}

struct SDL_QuitEvent
{
    Uint8 type;
}

struct SDL_UserEvent
{
    Uint8 type;
    int code;
    void *data1;
    void *data2;
}

struct SDL_SysWMEvent
{
    Uint8 type;
    SDL_SysWMmsg *msg;
}

union SDL_Event
{
    Uint8 type;
    SDL_ActiveEvent active;
    SDL_KeyboardEvent key;
    SDL_MouseMotionEvent motion;
    SDL_MouseButtonEvent button;
    SDL_JoyAxisEvent jaxis;
    SDL_JoyBallEvent jball;
    SDL_JoyHatEvent jhat;
    SDL_JoyButtonEvent jbutton;
    SDL_ResizeEvent resize;
    SDL_ExposeEvent expose;
    SDL_QuitEvent quit;
    SDL_UserEvent user;
    SDL_SysWMEvent syswm;
}

alias int SDL_eventaction;
enum
{
    SDL_ADDEVENT,
    SDL_PEEKEVENT,
    SDL_GETEVENT
}

extern(C) alias int function(SDL_Event *event) SDL_EventFilter;

enum
{
    SDL_QUERY           = -1,
    SDL_IGNORE          = 0,
    SDL_DISABLE         = 0,
    SDL_ENABLE          = 1,
}

int SDL_QuitRequested()
{
    SDL_PumpEvents();
    return SDL_PeepEvents(null, 0, SDL_PEEKEVENT, SDL_QUITMASK);
}

extern(C) __gshared
{
    void function() SDL_PumpEvents;
    int function(SDL_Event*,int,SDL_eventaction,Uint32) SDL_PeepEvents;
    int function(SDL_Event*) SDL_PollEvent;
    int function(SDL_Event*) SDL_WaitEvent;
    int function(SDL_Event*) SDL_PushEvent;
    void function(SDL_EventFilter) SDL_SetEventFilter;
    SDL_EventFilter function() SDL_GetEventFilter;
    Uint8 function(Uint8,int) SDL_EventState;
}