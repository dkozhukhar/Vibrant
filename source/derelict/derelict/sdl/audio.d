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
module derelict.sdl.audio;

private import derelict.sdl.types;
private import derelict.sdl.rwops;

struct SDL_AudioSpec
{
    int freq;
    Uint16 format;
    Uint8 channels;
    Uint8 silence;
    Uint16 samples;
    Uint16 padding;
    Uint32 size;
    extern(C) void function(void *userdata, Uint8 *stream, int len) callback;
    void *userdata;
}

enum : Uint16
{
    AUDIO_U8           = 0x0008,
    AUDIO_S8           = 0x8008,
    AUDIO_U16LSB       = 0x0010,
    AUDIO_S16LSB       = 0x8010,
    AUDIO_U16MSB       = 0x1010,
    AUDIO_S16MSB       = 0x9010,
    AUDIO_U16          = AUDIO_U16LSB,
    AUDIO_S16          = AUDIO_S16LSB,
}

version(LittleEndian)
{
    enum : Uint16
    {
        AUDIO_U16SYS   = AUDIO_U16LSB,
        AUDIO_S16SYS   = AUDIO_S16LSB,
    }
}
else
{
    enum : Uint16
    {
        AUDIO_U16SYS   = AUDIO_U16MSB,
        AUDIO_S16SYS   = AUDIO_S16MSB,
    }
}

struct SDL_AudioCVT
{
    int needed;
    Uint16 src_format;
    Uint16 dst_format;
    double rate_incr;
    Uint8 *buf;
    int len;
    int len_cvt;
    int len_mult;
    double len_ratio;
    void function(SDL_AudioCVT *cvt, Uint16 format)[10] filters;
    int filter_index;
}

alias int SDL_audiostatus;
enum
{
    SDL_AUDIO_STOPPED       = 0,
    SDL_AUDIO_PLAYING,
    SDL_AUDIO_PAUSED
}

enum { SDL_MIX_MAXVOLUME = 128 }

SDL_AudioSpec* SDL_LoadWAV(char *file, SDL_AudioSpec *spec, Uint8 **buf, Uint32 *len)
{
    return SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb".ptr), 1, spec, buf, len);
}

extern(C)
{
    int function(char*) SDL_AudioInit;
    void function() SDL_AudioQuit;
    char* function(char*,int) SDL_AudioDriverName;
    int function(SDL_AudioSpec*,SDL_AudioSpec*) SDL_OpenAudio;
    SDL_audiostatus function() SDL_GetAudioStatus;
    void function(int) SDL_PauseAudio;
    SDL_AudioSpec* function(SDL_RWops*,int,SDL_AudioSpec*,Uint8**,Uint32*) SDL_LoadWAV_RW;
    void function(Uint8*) SDL_FreeWAV;
    int function(SDL_AudioCVT*,Uint16,Uint8,int,Uint16,Uint8,int) SDL_BuildAudioCVT;
    int function(SDL_AudioCVT*) SDL_ConvertAudio;
    void function(Uint8*,Uint8*,Uint32,int) SDL_MixAudio;
    void function() SDL_LockAudio;
    void function() SDL_UnlockAudio;
    void function() SDL_CloseAudio;
}