/*
 * Copyright (c) 2004-2008 Derelict Developers
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
 * * Neither the names 'Derelict', 'DerelictGL', nor the names of its contributors
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
module derelict.opengl.wgl;

version(Windows)
{
    private
    {
        import derelict.opengl.gltypes;
        import derelict.util.wintypes;
        import derelict.util.loader;
        import derelict.util.exception;
        import derelict.util.wrapper;
    }

    //------------------------------------------------------------------------------

    extern(Windows)
    {
        // WGL functions
        alias BOOL function(void*,void*) pfwglCopyContext;
        alias void* function(void*) pfwglCreateContext;
        alias void* function(void*,int) pfwglCreateLayerContext;
        alias BOOL function(void*) pfwglDeleteContext;
        alias BOOL function(void*,int,int,UINT,LAYERPLANEDESCRIPTOR*) pfwglDescribeLayerPlane;
        alias void* function() pfwglGetCurrentContext;
        alias void* function() pfwglGetCurrentDC;
        alias int function(void*,int,int,int,COLORREF*) pfwglGetLayerPaletteEntries;
        alias FARPROC function(const(char*)) pfwglGetProcAddress;
        alias BOOL function(void*,void*) pfwglMakeCurrent;
        alias BOOL function(void*,int,BOOL) pfwglRealizeLayerPalette;
        alias int function(void*,int,int,int,COLORREF*) pfwglSetLayerPaletteEntries;
        alias BOOL function(void*,void*) pfwglShareLists;
        alias BOOL function(void*,UINT) pfwglSwapLayerBuffers;
        alias BOOL function(void*,DWORD,DWORD,DWORD) pfwglUseFontBitmapsA;
        alias BOOL function(void*,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,GLYPHMETRICSFLOAT*) pfwglUseFontOutlinesA;
        alias BOOL function(void*,DWORD,DWORD,DWORD) pfwglUseFontBitmapsW;
        alias BOOL function(void*,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,GLYPHMETRICSFLOAT*) pfwglUseFontOutlinesW;
        pfwglCopyContext            wglCopyContext;
        pfwglCreateContext          wglCreateContext;
        pfwglCreateLayerContext     wglCreateLayerContext;
        pfwglDeleteContext          wglDeleteContext;
        pfwglDescribeLayerPlane     wglDescribeLayerPlane;
        pfwglGetCurrentContext      wglGetCurrentContext;
        pfwglGetCurrentDC           wglGetCurrentDC;
        pfwglGetLayerPaletteEntries wglGetLayerPaletteEntries;
        pfwglGetProcAddress         wglGetProcAddress;
        pfwglMakeCurrent            wglMakeCurrent;
        pfwglRealizeLayerPalette    wglRealizeLayerPalette;
        pfwglSetLayerPaletteEntries wglSetLayerPaletteEntries;
        pfwglShareLists             wglShareLists;
        pfwglSwapLayerBuffers       wglSwapLayerBuffers;
        pfwglUseFontBitmapsA        wglUseFontBitmapsA;
        pfwglUseFontOutlinesA       wglUseFontOutlinesA;
        pfwglUseFontBitmapsW        wglUseFontBitmapsW;
        pfwglUseFontOutlinesW       wglUseFontOutlinesW;

        alias wglUseFontBitmapsA    wglUseFontBitmaps;
        alias wglUseFontOutlinesA   wglUseFontOutlines;
    } // extern(Windows)



    package void loadPlatformGL(SharedLib lib)
    {
        bindFunc(wglCopyContext)("wglCopyContext", lib);
        bindFunc(wglCreateContext)("wglCreateContext", lib);
        bindFunc(wglCreateLayerContext)("wglCreateLayerContext", lib);
        bindFunc(wglDeleteContext)("wglDeleteContext", lib);
        bindFunc(wglDescribeLayerPlane)("wglDescribeLayerPlane", lib);
        bindFunc(wglGetCurrentContext)("wglGetCurrentContext", lib);
        bindFunc(wglGetCurrentDC)("wglGetCurrentDC", lib);
        bindFunc(wglGetLayerPaletteEntries)("wglGetLayerPaletteEntries", lib);
        bindFunc(wglGetProcAddress)("wglGetProcAddress", lib);
        bindFunc(wglMakeCurrent)("wglMakeCurrent", lib);
        bindFunc(wglRealizeLayerPalette)("wglRealizeLayerPalette", lib);
        bindFunc(wglSetLayerPaletteEntries)("wglSetLayerPaletteEntries", lib);
        bindFunc(wglShareLists)("wglShareLists", lib);
        bindFunc(wglSwapLayerBuffers)("wglSwapLayerBuffers", lib);
        bindFunc(wglUseFontBitmapsA)("wglUseFontBitmapsA", lib);
        bindFunc(wglUseFontOutlinesA)("wglUseFontOutlinesA", lib);
        bindFunc(wglUseFontBitmapsW)("wglUseFontBitmapsW", lib);
        bindFunc(wglUseFontOutlinesW)("wglUseFontOutlinesW", lib);
    }

    package void wglBindFunc(void **ptr, string funcName, SharedLib lib)
    {
        void *func = wglGetProcAddress(toCString(funcName));
        if(!func)
            Derelict_HandleMissingProc(lib.name, funcName);
        else
            *ptr = func;
    }

} // version(Windows)
