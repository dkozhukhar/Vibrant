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
module derelict.sdl.endian;

private
{
    import derelict.sdl.types;
    import derelict.sdl.rwops;
    import core.bitop;
}

Uint16 SDL_Swap16(Uint16 val)
{
    return cast(Uint16)((val<<8)|(val>>8));
}

Uint32 SDL_Swap32(Uint32 val)
{
    return bswap(val);
}

Uint64 SDL_Swap64(Uint64 val)
{
    Uint32 lo = cast(Uint32)(val & 0xFFFFFFFF);
    val >>= 32;
    Uint32 hi = cast(Uint32)(val & 0xFFFFFFFF);
    val = bswap(lo);
    val <<= 32;
    val |= bswap(hi);
    return val;
}

version(LittleEndian)
{
    Uint16 SDL_SwapLE16(Uint16 val)
    {
        return val;
    }

    Uint32 SDL_SwapLE32(Uint32 val)
    {
        return val;
    }

    Uint64 SDL_SwapLE64(Uint64 val)
    {
        return val;
    }

    Uint16 SDL_SwapBE16(Uint16 val)
    {
        return cast(Uint16)((val<<8)|(val>>8));
    }

    Uint32 SDL_SwapBE32(Uint32 val)
    {
        return bswap(val);
    }

    Uint64 SDL_SwapBE64(Uint64 val)
    {
        Uint32 lo = cast(Uint32)(val & 0xFFFFFFFF);
        val >>= 32;
        Uint32 hi = cast(Uint32)(val & 0xFFFFFFFF);
        val = bswap(lo);
        val <<= 32;
        val |= bswap(hi);
        return val;
    }
}
else
{
    Uint16 SDL_SwapLE16(Uint16 val)
    {
        return cast(Uint16)((val<<8)|(val>>8));
    }

    Uint32 SDL_SwapLE32(Uint32 val)
    {
        return bswap(val);
    }

    Uint64 SDL_SwapLE64(Uint64 val)
    {
        Uint32 lo = cast(Uint32)(val & 0xFFFFFFFF);
        val >>= 32;
        Uint32 hi = cast(Uint32)(val & 0xFFFFFFFF);
        val = bswap(lo);
        val <<= 32;
        val |= bswap(hi);
        return val;
    }

    Uint16 SDL_SwapBE16(Uint16 val)
    {
        return val;
    }

    Uint32 SDL_SwapBE32(Uint32 val)
    {
        return val;
    }

    Uint64 SDL_SwapBE64(Uint64 val)
    {
        return val;
    }
}
