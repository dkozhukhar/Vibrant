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
module derelict.sdl.sdlversion;

private import derelict.sdl.types;

enum : Uint8
{
    SDL_MAJOR_VERSION   = 1,
    SDL_MINOR_VERSION   = 2,
    SDL_PATCHLEVEL      = 13,
}

struct SDL_version
{
    Uint8 major;
    Uint8 minor;
    Uint8 patch;
}

void SDL_VERSION(SDL_version *X)
{
    X.major = SDL_MAJOR_VERSION;
    X.minor = SDL_MINOR_VERSION;
    X.patch = SDL_PATCHLEVEL;
}

uint SDL_VERSIONNUM(Uint8 major, Uint8 minor, Uint8 patch)
{
    return (major * 1000 + minor * 100 + patch);
}

const uint SDL_COMPILEDVERSION =  SDL_MAJOR_VERSION * 1000 +
                                  SDL_MINOR_VERSION * 100 + SDL_PATCHLEVEL;

bool SDL_VERSION_ATLEAST(Uint8 major, Uint8 minor, Uint8 patch)
{
    return cast(bool)(SDL_COMPILEDVERSION >= SDL_VERSIONNUM(major,minor,patch));
}

extern(C)
{
    SDL_version* function() SDL_Linked_Version;
}