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
module derelict.sdl.mouse;

private
{
    import derelict.sdl.types;
    import derelict.sdl.video;
}

struct WMcursor {}

struct SDL_Cursor
{
    SDL_Rect area;
    Sint16 hot_x, hot_y;
    Uint8 *data;
    Uint8 *mask;
    Uint8[2] *save;
    WMcursor *wm_cursor;
}

enum : Uint8
{
    SDL_BUTTON_LEFT         = 1,
    SDL_BUTTON_MIDDLE       = 2,
    SDL_BUTTON_RIGHT        = 3,
    SDL_BUTTON_WHEELUP      = 4,
    SDL_BUTTON_WHEELDOWN    = 5,
    SDL_BUTTON_X1           = 6,
    SDL_BUTTON_X2           = 7,
    SDL_BUTTON_LMASK        = 1 << (SDL_BUTTON_LEFT-1),
    SDL_BUTTON_MMASK        = 1 << (SDL_BUTTON_MIDDLE-1),
    SDL_BUTTON_RMASK        = 1 << (SDL_BUTTON_RIGHT-1),
    SDL_BUTTON_X1MASK       = 1 << (SDL_BUTTON_X1-1),
    SDL_BUTTON_X2MASK       = 1 << (SDL_BUTTON_X2-1),
}

Uint8 SDL_BUTTON(Uint8 x)
{
    return cast(Uint8)(1 << (x - 1));
}

extern(C) __gshared
{
    Uint8 function(int*,int*) SDL_GetMouseState;
    Uint8 function(int*,int*) SDL_GetRelativeMouseState;
    void function(Uint16,Uint16) SDL_WarpMouse;
    SDL_Cursor* function(Uint8*,Uint8*,int,int,int,int) SDL_CreateCursor;
    void function(SDL_Cursor*) SDL_SetCursor;
    SDL_Cursor* function() SDL_GetCursor;
    void function(SDL_Cursor*) SDL_FreeCursor;
    int function(int) SDL_ShowCursor;
}
