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
module derelict.sdl.video;

private
{
    import derelict.sdl.types;
    import derelict.sdl.mutex;
    import derelict.sdl.rwops;
}

enum : Uint8
{
    SDL_ALPHA_OPAQUE            = 255,
    SDL_ALPHA_TRANSPARENT       = 0,
}

struct SDL_Rect
{
    Sint16 x, y;
    Uint16 w, h;
}

struct SDL_Color
{
    Uint8 r;
    Uint8 g;
    Uint8 b;
    Uint8 unused;
}
alias SDL_Color SDL_Colour;

struct SDL_Palette
{
    int ncolors;
    SDL_Color *colors;
}

struct SDL_PixelFormat
{
    SDL_Palette *palette;
    Uint8 BitsPerPixel;
    Uint8 BytesPerPixel;
    Uint8 Rloss;
    Uint8 Gloss;
    Uint8 Bloss;
    Uint8 Aloss;
    Uint8 Rshift;
    Uint8 Gshift;
    Uint8 Bshift;
    Uint8 Ashift;
    Uint32 Rmask;
    Uint32 Gmask;
    Uint32 Bmask;
    Uint32 Amask;
    Uint32 colorkey;
    Uint8 alpha;
}

struct SDL_Surface
{
    Uint32 flags;
    SDL_PixelFormat *format;
    int w, h;
    Uint16 pitch;
    void *pixels;
    int offset;
    void *hwdata;
    SDL_Rect clip_rect;
    Uint32 unused1;
    Uint32 locked;
    void *map;
    uint format_version;
    int refcount;
}

enum : Uint32
{
    SDL_SWSURFACE                  = 0x00000000,
    SDL_HWSURFACE                  = 0x00000001,
    SDL_ASYNCBLIT                  = 0x00000004,
    SDL_ANYFORMAT                  = 0x10000000,
    SDL_HWPALETTE                  = 0x20000000,
    SDL_DOUBLEBUF                  = 0x40000000,
    SDL_FULLSCREEN                 = 0x80000000,
    SDL_OPENGL                     = 0x00000002,
    SDL_OPENGLBLIT                 = 0x0000000A,
    SDL_RESIZABLE                  = 0x00000010,
    SDL_NOFRAME                    = 0x00000020,
    SDL_HWACCEL                    = 0x00000100,
    SDL_SRCCOLORKEY                = 0x00001000,
    SDL_RLEACCELOK                 = 0x00002000,
    SDL_RLEACCEL                   = 0x00004000,
    SDL_SRCALPHA                   = 0x00010000,
    SDL_PREALLOC                   = 0x01000000,
}

struct SDL_VideoInfo
{
    Uint32 flags;
    Uint32 video_mem;
    SDL_PixelFormat *vfmt;
    int current_w;
    int current_h;
}

enum : Uint32
{
    SDL_YV12_OVERLAY               = 0x32315659,
    SDL_IYUV_OVERLAY               = 0x56555949,
    SDL_YUY2_OVERLAY               = 0x32595559,
    SDL_UYVY_OVERLAY               = 0x59565955,
    SDL_YUYU_OVERLAY               = 0x55595659,
}

struct SDL_Overlay
{
    Uint32 format;
    int w, h;
    int planes;
    Uint16 *pitches;
    Uint8 **pixels;
    void *hwfuncs;
    void *hwdata;
    Uint32 flags;
}

alias int SDL_GLattr;
enum
{
    SDL_GL_RED_SIZE,
    SDL_GL_GREEN_SIZE,
    SDL_GL_BLUE_SIZE,
    SDL_GL_ALPHA_SIZE,
    SDL_GL_BUFFER_SIZE,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_DEPTH_SIZE,
    SDL_GL_STENCIL_SIZE,
    SDL_GL_ACCUM_RED_SIZE,
    SDL_GL_ACCUM_GREEN_SIZE,
    SDL_GL_ACCUM_BLUE_SIZE,
    SDL_GL_ACCUM_ALPHA_SIZE,
    SDL_GL_STEREO,
    SDL_GL_MULTISAMPLEBUFFERS,
    SDL_GL_MULTISAMPLESAMPLES,
    SDL_GL_ACCELERATED_VISUAL,
    SDL_GL_SWAP_CONTROL
}

enum : Uint8
{
    SDL_LOGPAL          = 0x01,
    SDL_PHYSPAL         = 0x02,
}

alias int SDL_GrabMode;
enum
{
    SDL_GRAB_QUERY = -1,
    SDL_GRAB_OFF = 0,
    SDL_GRAB_ON = 1,
    SDL_GRAB_FULLSCREEN
}

bool SDL_MUSTLOCK(SDL_Surface* surface)
{
    return cast(bool)(surface.offset ||
        ((surface.flags & (SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_RLEACCEL)) != 0));
}

SDL_Surface* SDL_LoadBMP(const(char) *file)
{
    return SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1);
}

int SDL_SaveBMP(SDL_Surface *surfave, const(char) *file)
{
    return SDL_SaveBMP_RW(surfave, SDL_RWFromFile(file,"wb"), 1);
}

extern(C) __gshared nothrow @nogc
{
    int function(char*,Uint32) SDL_VideoInit;
    void function() SDL_VideoQuit;
    char* function(char*,int) SDL_VideoDriverName;
    SDL_Surface* function() SDL_GetVideoSurface;
    SDL_VideoInfo* function() SDL_GetVideoInfo;
    int function(int,int,int,Uint32) SDL_VideoModeOK;
    SDL_Rect** function(SDL_PixelFormat*,Uint32) SDL_ListModes;
    SDL_Surface* function(int,int,int,Uint32) SDL_SetVideoMode;
    void function(SDL_Surface*,int,SDL_Rect*) SDL_UpdateRects;
    void function(SDL_Surface*,Sint32,Sint32,Uint32,Uint32) SDL_UpdateRect;
    int function(SDL_Surface*) SDL_Flip;
    int function(float,float,float) SDL_SetGamma;
    int function(Uint16*,Uint16*,Uint16*) SDL_SetGammaRamp;
    int function(Uint16*,Uint16*,Uint16*) SDL_GetGammaRamp;
    int function(SDL_Surface*,SDL_Color*,int,int) SDL_SetColors;
    int function(SDL_Surface*,int,SDL_Color*,int,int) SDL_SetPalette;
    Uint32 function(SDL_PixelFormat*,Uint8,Uint8,Uint8) SDL_MapRGB;
    Uint32 function(SDL_PixelFormat*,Uint8,Uint8,Uint8,Uint8) SDL_MapRGBA;
    void function(Uint32,SDL_PixelFormat*,Uint8*,Uint8*,Uint8*) SDL_GetRGB;
    void function(Uint32,SDL_PixelFormat*,Uint8*,Uint8*,Uint8*,Uint8*) SDL_GetRGBA;
    SDL_Surface* function(Uint32,int,int,int,Uint32,Uint32,Uint32,Uint32) SDL_CreateRGBSurface;
    SDL_Surface* function(void*,int,int,int,int,Uint32,Uint32,Uint32,Uint32) SDL_CreateRGBSurfaceFrom;
    void function(SDL_Surface*) SDL_FreeSurface;
    int function(SDL_Surface*) SDL_LockSurface;
    void function(SDL_Surface*) SDL_UnlockSurface;
    SDL_Surface* function(SDL_RWops*,int) SDL_LoadBMP_RW;
    int function(SDL_Surface*,SDL_RWops*,int) SDL_SaveBMP_RW;
    int function(SDL_Surface*,Uint32,Uint32) SDL_SetColorKey;
    int function(SDL_Surface*,Uint32,Uint8) SDL_SetAlpha;
    SDL_bool function(SDL_Surface*,SDL_Rect*) SDL_SetClipRect;
    void function(SDL_Surface*,SDL_Rect*) SDL_GetClipRect;
    SDL_Surface* function(SDL_Surface*,SDL_PixelFormat*,Uint32) SDL_ConvertSurface;
    int function(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*) SDL_UpperBlit;
    int function(SDL_Surface*,SDL_Rect*,SDL_Surface*,SDL_Rect*) SDL_LowerBlit;
    int function(SDL_Surface*,SDL_Rect*,Uint32) SDL_FillRect;
    SDL_Surface* function(SDL_Surface*) SDL_DisplayFormat;
    SDL_Surface* function(SDL_Surface*) SDL_DisplayFormatAlpha;
    SDL_Overlay* function(int,int,Uint32,SDL_Surface*) SDL_CreateYUVOverlay;
    int function(SDL_Overlay*) SDL_LockYUVOverlay;
    void function(SDL_Overlay*) SDL_UnlockYUVOverlay;
    int function(SDL_Overlay*,SDL_Rect*) SDL_DisplayYUVOverlay;
    void function(SDL_Overlay*) SDL_FreeYUVOverlay;
    int function(char*) SDL_GL_LoadLibrary;
    void* function(char*) SDL_GL_GetProcAddress;
    int function(SDL_GLattr,int) SDL_GL_SetAttribute;
    int function(SDL_GLattr,int*) SDL_GL_GetAttribute;
    void function() SDL_GL_SwapBuffers;
    void function(int,SDL_Rect*) SDL_GL_UpdateRects;
    void function() SDL_GL_Lock;
    void function() SDL_GL_Unlock;
    void function(const(char)*,const(char)*) SDL_WM_SetCaption;
    void function(const(char)**,const(char)**) SDL_WM_GetCaption;
    void function(SDL_Surface*,Uint8*) SDL_WM_SetIcon;
    int function() SDL_WM_IconifyWindow;
    int function(SDL_Surface*) SDL_WM_ToggleFullScreen;
    SDL_GrabMode function(SDL_GrabMode) SDL_WM_GrabInput;

    alias SDL_CreateRGBSurface SDL_AllocSurface;
    alias SDL_UpperBlit SDL_BlitSurface;
}