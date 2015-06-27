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
module derelict.sdl.mutex;

private import derelict.sdl.types;

enum { SDL_MUTEX_TIMEOUT = 1 }

enum : Uint32 { SDL_MUTEX_MAXWAIT = (~(cast(Uint32)0)) }

struct SDL_mutex {}

struct SDL_sem {}

struct SDL_cond {}

int SDL_LockMutex(SDL_mutex *mutex)
{
    return SDL_mutexP(mutex);
}

int SDL_UnlockMutex(SDL_mutex *mutex)
{
    return SDL_mutexV(mutex);
}

extern(C)
{
    SDL_mutex* function() SDL_CreateMutex;
    int function(SDL_mutex*) SDL_mutexP;
    int function(SDL_mutex*) SDL_mutexV;
    void function(SDL_mutex*) SDL_DestroyMutex;
    SDL_sem* function(Uint32) SDL_CreateSemaphore;
    void function(SDL_sem*) SDL_DestroySemaphore;
    int function(SDL_sem*) SDL_SemWait;
    int function(SDL_sem*) SDL_SemTryWait;
    int function(SDL_sem*,Uint32) SDL_SemWaitTimeout;
    int function(SDL_sem*) SDL_SemPost;
    Uint32 function(SDL_sem*) SDL_SemValue;
    SDL_cond* function() SDL_CreateCond;
    void function(SDL_cond*) SDL_DestroyCond;
    int function(SDL_cond*) SDL_CondSignal;
    int function(SDL_cond*) SDL_CondBroadcast;
    int function(SDL_cond*,SDL_mutex*) SDL_CondWait;
    int function(SDL_cond*,SDL_mutex*,Uint32) SDL_CondWaitTimeout;
}