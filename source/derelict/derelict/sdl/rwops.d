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
module derelict.sdl.rwops;

private
{
    import derelict.sdl.types;

    version(Tango)
    {
        import tango.stdc.stdio;
    }
    else
    {
        import std.c.stdio;
    }
}

enum
{
    RW_SEEK_SET       = 0,
    RW_SEEK_CUR       = 1,
    RW_SEEK_END       = 2,
}

struct SDL_RWops
{
    extern(C)
    {
        int function(SDL_RWops *context, int offset, int whence) seek;
        int function(SDL_RWops *context, void *ptr, int size, int maxnum) read;
        int function(SDL_RWops *context, void *ptr, int size, int num) write;
        int function(SDL_RWops *context) close;
    }

    Uint32 type;
    union Hidden
    {
        version(Windows)
        {
            struct Win32io
            {
                int append;
                void *h;
            }
            Win32io win32io;
        }

        struct Stdio
        {
            int autoclose;
            FILE *fp;
        }
        Stdio stdio;

        struct Mem
        {
            Uint8 *base;
            Uint8 *here;
            Uint8 *stop;
        }
        Mem mem;

        struct Unknown
        {
            void *data1;
        }
        Unknown unknown;
    }
    Hidden hidden;
}

int SDL_RWseek(SDL_RWops *context, int offset, int whence)
{
    return context.seek(context, offset, whence);
}

int SDL_RWtell(SDL_RWops *context)
{
    return context.seek(context, 0, RW_SEEK_CUR);
}

int SDL_RWread(SDL_RWops *context, void *ptr, int size, int maxnum)
{
    return context.read(context, ptr, size, maxnum);
}

int SDL_RWwrite(SDL_RWops *context, void *ptr, int size, int num)
{
    return context.write(context, ptr, size, num);
}

int SDL_RWclose(SDL_RWops *context)
{
    return context.close(context);
}

extern(C)
__gshared nothrow @nogc
{
    SDL_RWops* function(const(char)*,const(char)*) SDL_RWFromFile;
    SDL_RWops* function(FILE*,int) SDL_RWFromFP;
    SDL_RWops* function(void*,int) SDL_RWFromMem;
    SDL_RWops* function(void*,int) SDL_RWFromConstMem;
    SDL_RWops* function() SDL_AllocRW;
    void function(SDL_RWops*) SDL_FreeRW;
    Uint16 function(SDL_RWops*) SDL_ReadLE16;
    Uint16 function(SDL_RWops*) SDL_ReadBE16;
    Uint32 function(SDL_RWops*) SDL_ReadLE32;
    Uint32 function(SDL_RWops*) SDL_ReadBE32;
    Uint64 function(SDL_RWops*) SDL_ReadLE64;
    Uint64 function(SDL_RWops*) SDL_ReadBE64;
    Uint16 function(SDL_RWops*,Uint16) SDL_WriteLE16;
    Uint16 function(SDL_RWops*,Uint16) SDL_WriteBE16;
    Uint32 function(SDL_RWops*,Uint32) SDL_WriteLE32;
    Uint32 function(SDL_RWops*,Uint32) SDL_WriteBE32;
    Uint64 function(SDL_RWops*,Uint64) SDL_WriteLE64;
    Uint64 function(SDL_RWops*,Uint64) SDL_WriteBE64;
}