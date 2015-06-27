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
module derelict.sdl.joystick;

private import derelict.sdl.types;

struct SDL_Joystick {}

enum : Uint8
{
    SDL_HAT_CENTERED            = 0x00,
    SDL_HAT_UP                  = 0x01,
    SDL_HAT_RIGHT               = 0x02,
    SDL_HAT_DOWN                = 0x04,
    SDL_HAT_LEFT                = 0x08,
    SDL_HAT_RIGHTUP             = SDL_HAT_RIGHT | SDL_HAT_UP,
    SDL_HAT_RIGHTDOWN           = SDL_HAT_RIGHT | SDL_HAT_DOWN,
    SDL_HAT_LEFTUP              = SDL_HAT_LEFT | SDL_HAT_UP,
    SDL_HAT_LEFTDOWN            = SDL_HAT_LEFT | SDL_HAT_DOWN,
}

extern(C)
{
    int function() SDL_NumJoysticks;
    char* function(int) SDL_JoystickName;
    SDL_Joystick* function(int) SDL_JoystickOpen;
    int function(int) SDL_JoystickOpened;
    int function(SDL_Joystick*) SDL_JoystickIndex;
    int function(SDL_Joystick*) SDL_JoystickNumAxes;
    int function(SDL_Joystick*) SDL_JoystickNumBalls;
    int function(SDL_Joystick*) SDL_JoystickNumHats;
    int function(SDL_Joystick*) SDL_JoystickNumButtons;
    void function() SDL_JoystickUpdate;
    int function(int) SDL_JoystickEventState;
    Sint16 function(SDL_Joystick*,int) SDL_JoystickGetAxis;
    Uint8 function(SDL_Joystick*,int) SDL_JoystickGetHat;
    int function(SDL_Joystick*,int,int*,int*) SDL_JoystickGetBall;
    Uint8 function(SDL_Joystick*,int) SDL_JoystickGetButton;
    void function(SDL_Joystick*) SDL_JoystickClose;
}