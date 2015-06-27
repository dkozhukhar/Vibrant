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
module derelict.sdl.sdl;

private
{
    import derelict.util.loader;

    version(darwin)
        import derelict.sdl.macinit.SDLMain;
}

public
{
    import derelict.sdl.active;
    import derelict.sdl.audio;
    import derelict.sdl.byteorder;
    import derelict.sdl.cdrom;
    import derelict.sdl.cpuinfo;
    import derelict.sdl.endian;
    import derelict.sdl.error;
    import derelict.sdl.events;
    import derelict.sdl.joystick;
    import derelict.sdl.keyboard;
    import derelict.sdl.keysym;
    import derelict.sdl.loadso;
    import derelict.sdl.mouse;
    import derelict.sdl.mutex;
    import derelict.sdl.rwops;
    import derelict.sdl.sdlversion;
    import derelict.sdl.syswm;
    import derelict.sdl.thread;
    import derelict.sdl.timer;
    import derelict.sdl.types;
    import derelict.sdl.video;
}

enum : Uint32
{
    SDL_INIT_TIMER   = 0x00000001,
    SDL_INIT_AUDIO   = 0x00000010,
    SDL_INIT_VIDEO   = 0x00000020,
    SDL_INIT_CDROM   = 0x00000100,
    SDL_INIT_JOYSTICK  = 0x00000200,
    SDL_INIT_NOPARACHUTE = 0x00100000,
    SDL_INIT_EVENTTHREAD = 0x00200000,
    SDL_INIT_EVERYTHING = 0x0000FFFF,
}

extern(C)
{
    int function(Uint32) SDL_Init;
    int function(Uint32) SDL_InitSubSystem;
    int function(Uint32) SDL_QuitSubSystem;
    int function(Uint32) SDL_WasInit;
    void function() SDL_Quit;
}

private void load(SharedLib lib)
{
    // active.d
    bindFunc(SDL_GetAppState)("SDL_GetAppState", lib);
    // audio.d
    bindFunc(SDL_AudioInit)("SDL_AudioInit", lib);
    bindFunc(SDL_AudioQuit)("SDL_AudioQuit", lib);
    bindFunc(SDL_AudioDriverName)("SDL_AudioDriverName", lib);
    bindFunc(SDL_OpenAudio)("SDL_OpenAudio", lib);
    bindFunc(SDL_GetAudioStatus)("SDL_GetAudioStatus", lib);
    bindFunc(SDL_PauseAudio)("SDL_PauseAudio", lib);
    bindFunc(SDL_LoadWAV_RW)("SDL_LoadWAV_RW", lib);
    bindFunc(SDL_FreeWAV)("SDL_FreeWAV", lib);
    bindFunc(SDL_BuildAudioCVT)("SDL_BuildAudioCVT", lib);
    bindFunc(SDL_ConvertAudio)("SDL_ConvertAudio", lib);
    bindFunc(SDL_MixAudio)("SDL_MixAudio", lib);
    bindFunc(SDL_LockAudio)("SDL_LockAudio", lib);
    bindFunc(SDL_UnlockAudio)("SDL_UnlockAudio", lib);
    bindFunc(SDL_CloseAudio)("SDL_CloseAudio", lib);
    // cdrom.d
    bindFunc(SDL_CDNumDrives)("SDL_CDNumDrives", lib);
    bindFunc(SDL_CDName)("SDL_CDName", lib);
    bindFunc(SDL_CDOpen)("SDL_CDOpen", lib);
    bindFunc(SDL_CDStatus)("SDL_CDStatus", lib);
    bindFunc(SDL_CDPlayTracks)("SDL_CDPlayTracks", lib);
    bindFunc(SDL_CDPlay)("SDL_CDPlay", lib);
    bindFunc(SDL_CDPause)("SDL_CDPause", lib);
    bindFunc(SDL_CDResume)("SDL_CDResume", lib);
    bindFunc(SDL_CDStop)("SDL_CDStop", lib);
    bindFunc(SDL_CDEject)("SDL_CDEject", lib);
    bindFunc(SDL_CDClose)("SDL_CDClose", lib);
    // cpuinfo.d
    bindFunc(SDL_HasRDTSC)("SDL_HasRDTSC", lib);
    bindFunc(SDL_HasMMX)("SDL_HasMMX", lib);
    bindFunc(SDL_HasMMXExt)("SDL_HasMMXExt", lib);
    bindFunc(SDL_Has3DNow)("SDL_Has3DNow", lib);
    bindFunc(SDL_Has3DNowExt)("SDL_Has3DNowExt", lib);
    bindFunc(SDL_HasSSE)("SDL_HasSSE", lib);
    bindFunc(SDL_HasSSE2)("SDL_HasSSE2", lib);
    bindFunc(SDL_HasAltiVec)("SDL_HasAltiVec", lib);
    // error.d
    bindFunc(SDL_SetError)("SDL_SetError", lib);
    bindFunc(SDL_GetError)("SDL_GetError", lib);
    bindFunc(SDL_ClearError)("SDL_ClearError", lib);
    // events.d
    bindFunc(SDL_PumpEvents)("SDL_PumpEvents", lib);
    bindFunc(SDL_PeepEvents)("SDL_PeepEvents", lib);
    bindFunc(SDL_PollEvent)("SDL_PollEvent", lib);
    bindFunc(SDL_WaitEvent)("SDL_WaitEvent", lib);
    bindFunc(SDL_PushEvent)("SDL_PushEvent", lib);
    bindFunc(SDL_SetEventFilter)("SDL_SetEventFilter", lib);
    bindFunc(SDL_GetEventFilter)("SDL_GetEventFilter", lib);
    bindFunc(SDL_EventState)("SDL_EventState", lib);
    // joystick.d
    bindFunc(SDL_NumJoysticks)("SDL_NumJoysticks", lib);
    bindFunc(SDL_JoystickName)("SDL_JoystickName", lib);
    bindFunc(SDL_JoystickOpen)("SDL_JoystickOpen", lib);
    bindFunc(SDL_JoystickOpened)("SDL_JoystickOpened", lib);
    bindFunc(SDL_JoystickIndex)("SDL_JoystickIndex", lib);
    bindFunc(SDL_JoystickNumAxes)("SDL_JoystickNumAxes", lib);
    bindFunc(SDL_JoystickNumBalls)("SDL_JoystickNumBalls", lib);
    bindFunc(SDL_JoystickNumHats)("SDL_JoystickNumHats", lib);
    bindFunc(SDL_JoystickNumButtons)("SDL_JoystickNumButtons", lib);
    bindFunc(SDL_JoystickUpdate)("SDL_JoystickUpdate", lib);
    bindFunc(SDL_JoystickEventState)("SDL_JoystickEventState", lib);
    bindFunc(SDL_JoystickGetAxis)("SDL_JoystickGetAxis", lib);
    bindFunc(SDL_JoystickGetHat)("SDL_JoystickGetHat", lib);
    bindFunc(SDL_JoystickGetBall)("SDL_JoystickGetBall", lib);
    bindFunc(SDL_JoystickGetButton)("SDL_JoystickGetButton", lib);
    bindFunc(SDL_JoystickClose)("SDL_JoystickClose", lib);
    // keyboard.d
    bindFunc(SDL_EnableUNICODE)("SDL_EnableUNICODE", lib);
    bindFunc(SDL_EnableKeyRepeat)("SDL_EnableKeyRepeat", lib);
    bindFunc(SDL_GetKeyRepeat)("SDL_GetKeyRepeat", lib);
    bindFunc(SDL_GetKeyState)("SDL_GetKeyState", lib);
    bindFunc(SDL_GetModState)("SDL_GetModState", lib);
    bindFunc(SDL_SetModState)("SDL_SetModState", lib);
    bindFunc(SDL_GetKeyName)("SDL_GetKeyName", lib);
    // loadso.d
    bindFunc(SDL_LoadObject)("SDL_LoadObject", lib);
    bindFunc(SDL_LoadFunction)("SDL_LoadFunction", lib);
    bindFunc(SDL_UnloadObject)("SDL_UnloadObject", lib);
    // mouse.d
    bindFunc(SDL_GetMouseState)("SDL_GetMouseState", lib);
    bindFunc(SDL_GetRelativeMouseState)("SDL_GetRelativeMouseState", lib);
    bindFunc(SDL_WarpMouse)("SDL_WarpMouse", lib);
    bindFunc(SDL_CreateCursor)("SDL_CreateCursor", lib);
    bindFunc(SDL_SetCursor)("SDL_SetCursor", lib);
    bindFunc(SDL_GetCursor)("SDL_GetCursor", lib);
    bindFunc(SDL_FreeCursor)("SDL_FreeCursor", lib);
    bindFunc(SDL_ShowCursor)("SDL_ShowCursor", lib);
    // mutex.d
    bindFunc(SDL_CreateMutex)("SDL_CreateMutex", lib);
    bindFunc(SDL_mutexP)("SDL_mutexP", lib);
    bindFunc(SDL_mutexV)("SDL_mutexV", lib);
    bindFunc(SDL_DestroyMutex)("SDL_DestroyMutex", lib);
    bindFunc(SDL_CreateSemaphore)("SDL_CreateSemaphore", lib);
    bindFunc(SDL_DestroySemaphore)("SDL_DestroySemaphore", lib);
    bindFunc(SDL_SemWait)("SDL_SemWait", lib);
    bindFunc(SDL_SemTryWait)("SDL_SemTryWait", lib);
    bindFunc(SDL_SemWaitTimeout)("SDL_SemWaitTimeout", lib);
    bindFunc(SDL_SemPost)("SDL_SemPost", lib);
    bindFunc(SDL_SemValue)("SDL_SemValue", lib);
    bindFunc(SDL_CreateCond)("SDL_CreateCond", lib);
    bindFunc(SDL_DestroyCond)("SDL_DestroyCond", lib);
    bindFunc(SDL_CondSignal)("SDL_CondSignal", lib);
    bindFunc(SDL_CondBroadcast)("SDL_CondBroadcast", lib);
    bindFunc(SDL_CondWait)("SDL_CondWait", lib);
    bindFunc(SDL_CondWaitTimeout)("SDL_CondWaitTimeout", lib);
    // rwops.d
    bindFunc(SDL_RWFromFile)("SDL_RWFromFile", lib);
    bindFunc(SDL_RWFromFP)("SDL_RWFromFP", lib);
    bindFunc(SDL_RWFromMem)("SDL_RWFromMem", lib);
    bindFunc(SDL_RWFromConstMem)("SDL_RWFromConstMem", lib);
    bindFunc(SDL_AllocRW)("SDL_AllocRW", lib);
    bindFunc(SDL_FreeRW)("SDL_FreeRW", lib);
    bindFunc(SDL_ReadLE16)("SDL_ReadLE16", lib);
    bindFunc(SDL_ReadBE16)("SDL_ReadBE16", lib);
    bindFunc(SDL_ReadLE32)("SDL_ReadLE32", lib);
    bindFunc(SDL_ReadBE32)("SDL_ReadBE32", lib);
    bindFunc(SDL_ReadLE64)("SDL_ReadLE64", lib);
    bindFunc(SDL_ReadBE64)("SDL_ReadBE64", lib);
    bindFunc(SDL_WriteLE16)("SDL_WriteLE16", lib);
    bindFunc(SDL_WriteBE16)("SDL_WriteBE16", lib);
    bindFunc(SDL_WriteLE32)("SDL_WriteLE32", lib);
    bindFunc(SDL_WriteBE32)("SDL_WriteBE32", lib);
    bindFunc(SDL_WriteLE64)("SDL_WriteLE64", lib);
    bindFunc(SDL_WriteBE64)("SDL_WriteBE64", lib);
    // sdlversion.d
    bindFunc(SDL_Linked_Version)("SDL_Linked_Version", lib);
    // thread.d
    bindFunc(SDL_CreateThread)("SDL_CreateThread", lib);
    bindFunc(SDL_ThreadID)("SDL_ThreadID", lib);
    bindFunc(SDL_GetThreadID)("SDL_GetThreadID", lib);
    bindFunc(SDL_WaitThread)("SDL_WaitThread", lib);
    bindFunc(SDL_KillThread)("SDL_KillThread", lib);
    // timer.d
    bindFunc(SDL_GetTicks)("SDL_GetTicks", lib);
    bindFunc(SDL_Delay)("SDL_Delay", lib);
    bindFunc(SDL_SetTimer)("SDL_SetTimer", lib);
    bindFunc(SDL_AddTimer)("SDL_AddTimer", lib);
    bindFunc(SDL_RemoveTimer)("SDL_RemoveTimer", lib);
    // video.d
    bindFunc(SDL_VideoInit)("SDL_VideoInit", lib);
    bindFunc(SDL_VideoQuit)("SDL_VideoQuit", lib);
    bindFunc(SDL_VideoDriverName)("SDL_VideoDriverName", lib);
    bindFunc(SDL_GetVideoSurface)("SDL_GetVideoSurface", lib);
    bindFunc(SDL_GetVideoInfo)("SDL_GetVideoInfo", lib);
    bindFunc(SDL_VideoModeOK)("SDL_VideoModeOK", lib);
    bindFunc(SDL_ListModes)("SDL_ListModes", lib);
    bindFunc(SDL_SetVideoMode)("SDL_SetVideoMode", lib);
    bindFunc(SDL_UpdateRects)("SDL_UpdateRects", lib);
    bindFunc(SDL_UpdateRect)("SDL_UpdateRect", lib);
    bindFunc(SDL_Flip)("SDL_Flip", lib);
    bindFunc(SDL_SetGamma)("SDL_SetGamma", lib);
    bindFunc(SDL_SetGammaRamp)("SDL_SetGammaRamp", lib);
    bindFunc(SDL_GetGammaRamp)("SDL_GetGammaRamp", lib);
    bindFunc(SDL_SetColors)("SDL_SetColors", lib);
    bindFunc(SDL_SetPalette)("SDL_SetPalette", lib);
    bindFunc(SDL_MapRGB)("SDL_MapRGB", lib);
    bindFunc(SDL_MapRGBA)("SDL_MapRGBA", lib);
    bindFunc(SDL_GetRGB)("SDL_GetRGB", lib);
    bindFunc(SDL_GetRGBA)("SDL_GetRGBA", lib);
    bindFunc(SDL_CreateRGBSurface)("SDL_CreateRGBSurface", lib);
    bindFunc(SDL_CreateRGBSurfaceFrom)("SDL_CreateRGBSurfaceFrom", lib);
    bindFunc(SDL_FreeSurface)("SDL_FreeSurface", lib);
    bindFunc(SDL_LockSurface)("SDL_LockSurface", lib);
    bindFunc(SDL_UnlockSurface)("SDL_UnlockSurface", lib);
    bindFunc(SDL_LoadBMP_RW)("SDL_LoadBMP_RW", lib);
    bindFunc(SDL_SaveBMP_RW)("SDL_SaveBMP_RW", lib);
    bindFunc(SDL_SetColorKey)("SDL_SetColorKey", lib);
    bindFunc(SDL_SetAlpha)("SDL_SetAlpha", lib);
    bindFunc(SDL_SetClipRect)("SDL_SetClipRect", lib);
    bindFunc(SDL_GetClipRect)("SDL_GetClipRect", lib);
    bindFunc(SDL_ConvertSurface)("SDL_ConvertSurface", lib);
    bindFunc(SDL_UpperBlit)("SDL_UpperBlit", lib);
    bindFunc(SDL_LowerBlit)("SDL_LowerBlit", lib);
    bindFunc(SDL_FillRect)("SDL_FillRect", lib);
    bindFunc(SDL_DisplayFormat)("SDL_DisplayFormat", lib);
    bindFunc(SDL_DisplayFormatAlpha)("SDL_DisplayFormatAlpha", lib);
    bindFunc(SDL_CreateYUVOverlay)("SDL_CreateYUVOverlay", lib);
    bindFunc(SDL_LockYUVOverlay)("SDL_LockYUVOverlay", lib);
    bindFunc(SDL_UnlockYUVOverlay)("SDL_UnlockYUVOverlay", lib);
    bindFunc(SDL_DisplayYUVOverlay)("SDL_DisplayYUVOverlay", lib);
    bindFunc(SDL_FreeYUVOverlay)("SDL_FreeYUVOverlay", lib);
    bindFunc(SDL_GL_LoadLibrary)("SDL_GL_LoadLibrary", lib);
    bindFunc(SDL_GL_GetProcAddress)("SDL_GL_GetProcAddress", lib);
    bindFunc(SDL_GL_SetAttribute)("SDL_GL_SetAttribute", lib);
    bindFunc(SDL_GL_GetAttribute)("SDL_GL_GetAttribute", lib);
    bindFunc(SDL_GL_SwapBuffers)("SDL_GL_SwapBuffers", lib);
    bindFunc(SDL_GL_UpdateRects)("SDL_GL_UpdateRects", lib);
    bindFunc(SDL_GL_Lock)("SDL_GL_Lock", lib);
    bindFunc(SDL_GL_Unlock)("SDL_GL_Unlock", lib);
    bindFunc(SDL_WM_SetCaption)("SDL_WM_SetCaption", lib);
    bindFunc(SDL_WM_GetCaption)("SDL_WM_GetCaption", lib);
    bindFunc(SDL_WM_SetIcon)("SDL_WM_SetIcon", lib);
    bindFunc(SDL_WM_IconifyWindow)("SDL_WM_IconifyWindow", lib);
    bindFunc(SDL_WM_ToggleFullScreen)("SDL_WM_ToggleFullScreen", lib);
    bindFunc(SDL_WM_GrabInput)("SDL_WM_GrabInput", lib);
    // sdl.d
    bindFunc(SDL_Init)("SDL_Init", lib);
    bindFunc(SDL_InitSubSystem)("SDL_InitSubSystem", lib);
    bindFunc(SDL_QuitSubSystem)("SDL_QuitSubSystem", lib);
    bindFunc(SDL_WasInit)("SDL_WasInit", lib);
    bindFunc(SDL_Quit)("SDL_Quit", lib);

    // syswm.d
    version(Windows)
        bindFunc(SDL_GetWMInfo)("SDL_GetWMInfo", lib);

    version (darwin)
        macInit();
}

GenericLoader DerelictSDL;
static this() {
    DerelictSDL.setup(
        "sdl.dll",
        "libSDL.so, libSDL.so.0, libSDL-1.2.so, libSDL-1.2.so.0",
        "../Frameworks/SDL.framework/SDL, /Library/Frameworks/SDL.framework/SDL, /System/Library/Frameworks/SDL.framework/SDL",
        &load
    );
}
