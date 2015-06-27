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
module derelict.opengl.glx;


version(linux)
{

private
{
    import derelict.opengl.gltypes;
    import derelict.util.loader;
    import derelict.util.xtypes;
}

struct __GLXcontextRec {}
struct __GLXFBConfigRec {}

alias uint GLXContentID;
alias uint GLXPixmap;
alias uint GLXDrawable;
alias uint GLXPbuffer;
alias uint GLXWindow;
alias uint GLXFBConfigID;

alias __GLXcontextRec *GLXContext;      // __GLXcontextRec type is opaque
alias __GLXFBConfigRec *GLXFBConfig;    // __GLXFBConfigRec type is opaque

/*
 * GLX Events
 */

struct GLXPbufferClobberEvent
{
    int         event_type;
    int         draw_type;
    uint        serial;
    Bool        send_event;
    Display*    display;
    GLXDrawable drawable;
    uint        buffer_mask;
    uint        aux_buffer;
    int         x, y;
    int         width, height;
    int         count;
}

union GLXEvent
{
    GLXPbufferClobberEvent glxpbufferclobber;
    int[24] pad;
}

// Function pointer variables

extern (C):

alias XVisualInfo*            function(Display*,int,int*)
                            pfglXChooseVisual;
alias void                    function(Display*,GLXContext,GLXContext,uint)
                            pfglXCopyContext;
alias GLXContext              function(Display*,XVisualInfo*,GLXContext,Bool)
                            pfglXCreateContext;
alias GLXPixmap               function(Display*,XVisualInfo*,Pixmap)
                            pfglXCreateGLXPixmap;
alias void                    function(Display*,GLXContext)
                            pfglXDestroyContext;
alias void                    function(Display*,GLXPixmap)
                            pfglXDestroyGLXPixmap;
alias int                     function(Display*,XVisualInfo*,int,int*)
                            pfglXGetConfig;
alias GLXContext              function()
                            pfglXGetCurrentContext;
alias GLXDrawable             function()
                            pfglXGetCurrentDrawable;
alias Bool                    function(Display*,GLXContext)
                            pfglXIsDirect;
alias Bool                    function(Display*,GLXDrawable,GLXContext)
                            pfglXMakeCurrent;
alias Bool                    function(Display*,int*,int*)
                            pfglXQueryExtension;
alias Bool                    function(Display*,int*,int*)
                            pfglXQueryVersion;
alias void                    function(Display*,GLXDrawable)
                            pfglXSwapBuffers;
alias void                    function(Font,int,int,int)
                            pfglXUseXFont;
alias void                    function()
                            pfglXWaitGL;
alias void                    function()
                            pfglXWaitX;
alias const char*             function(Display*,int)
                            pfglXGetClientString;
alias const char*             function(Display*,int,int)
                            pfglXQueryServerString;
alias const char*             function(Display*,int)
                            pfglXQueryExtensionsString;

/* GLX 1.3 */

alias GLXFBConfig*            function(Display*,int,int*)
                            pfglXGetFBConfigs;
alias GLXFBConfig*            function(Display*,int,int*,int*)
                            pfglXChooseFBConfig;
alias int                     function(Display*,GLXFBConfig,int,int*)
                            pfglXGetFBConfigAttrib;
alias XVisualInfo*            function(Display*,GLXFBConfig)
                            pfglXGetVisualFromFBConfig;
alias GLXWindow               function(Display*,GLXFBConfig,Window,int*)
                            pfglXCreateWindow;
alias void                    function(Display*,GLXWindow)
                            pfglXDestroyWindow;
alias GLXPixmap               function(Display*,GLXFBConfig,Pixmap,int*)
                            pfglXCreatePixmap;
alias void                    function(Display*,GLXPixmap)
                            pfglXDestroyPixmap;
alias GLXPbuffer              function(Display*,GLXFBConfig,int*)
                            pfglXCreatePbuffer;
alias void                    function(Display*,GLXPbuffer)
                            pfglXDestroyPbuffer;
alias void                    function(Display*,GLXDrawable,int,uint*)
                            pfglXQueryDrawable;
alias GLXContext              function(Display*,GLXFBConfig,int,GLXContext,Bool)
                            pfglXCreateNewContext;
alias Bool                    function(Display*,GLXDrawable,GLXDrawable,GLXContext)
                            pfglXMakeContextCurrent;
alias GLXDrawable             function()
                            pfglXGetCurrentReadDrawable;
alias Display*                function()
                            pfglXGetCurrentDisplay;
alias int                     function(Display*,GLXContext,int,int*)
                            pfglXQueryContext;
alias void                    function(Display*,GLXDrawable,uint)
                            pfglXSelectEvent;
alias void                    function(Display*,GLXDrawable,uint*)
                            pfglXGetSelectedEvent;

/* GLX 1.4+ */
alias void*                   function(GLchar*)
                            pfglXGetProcAddress;

/* GLX extensions -- legacy */

/*
GLXContextID            function(const GLXContext)
                            pfglXGetContextIDEXT;
GLXContext              function(Display*,GLXContextID)
                            pfglXImportContextEXT;
void                    function(Display*,GLXContext)
                            pfglXFreeContextEXT;
int                     function(Display*,GLXContext,int,int*)
                            pfglXQueryContextInfoEXT;
Display*                function()
                            pfglXGetCurrentDisplayEXT;
void function()         function(const GLubyte*)
                            pfglXGetProcAddressARB;
*/

/+

// All extensions are disabled in the current version
// until further testing is done and need is established.

void*                   function(GLsizei,GLfloat,GLfloat,GLfloat)
                            glXAllocateMemoryNV;
void                    function(GLvoid*)
                            glXFreeMemoryNV;
void*                   function(GLsizei,GLfloat,GLfloat,GLfloat)
                            PFNGLXALLOCATEMEMORYNVPROC;
void                    function(GLvoid*)
                            PFNGLXFREEMEMORYNVPROC;

/* Mesa specific? */

// work in progress

/* GLX_ARB specific? */

Bool                    function(Display*, GLXPbuffer,int)
                            glXBindTexImageARB;
Bool                    function(Display*, GLXPbuffer,int)
                            glXReleaseTexImageARB;
Bool                    function(Display*,GLXDrawable,int*)
                            glXDrawableAttribARB;

+/

pfglXChooseVisual           glXChooseVisual;
pfglXCopyContext            glXCopyContext;
pfglXCreateContext          glXCreateContext;
pfglXCreateGLXPixmap        glXCreateGLXPixmap;
pfglXDestroyContext         glXDestroyContext;
pfglXDestroyGLXPixmap       glXDestroyGLXPixmap;
pfglXGetConfig              glXGetConfig;
pfglXGetCurrentContext      glXGetCurrentContext;
pfglXGetCurrentDrawable     glXGetCurrentDrawable;
pfglXIsDirect               glXIsDirect;
pfglXMakeCurrent            glXMakeCurrent;
pfglXQueryExtension         glXQueryExtension;
pfglXQueryVersion           glXQueryVersion;
pfglXSwapBuffers            glXSwapBuffers;
pfglXUseXFont               glXUseXFont;
pfglXWaitGL                 glXWaitGL;
pfglXWaitX                  glXWaitX;
pfglXGetClientString        glXGetClientString;
pfglXQueryServerString      glXQueryServerString;
pfglXQueryExtensionsString  glXQueryExtensionsString;

pfglXGetFBConfigs           glXGetFBConfigs;
pfglXChooseFBConfig         glXChooseFBConfig;
pfglXGetFBConfigAttrib      glXGetFBConfigAttrib;
pfglXGetVisualFromFBConfig  glXGetVisualFromFBConfig;
pfglXCreateWindow           glXCreateWindow;
pfglXDestroyWindow          glXDestroyWindow;
pfglXCreatePixmap           glXCreatePixmap;
pfglXDestroyPixmap          glXDestroyPixmap;
pfglXCreatePbuffer          glXCreatePbuffer;
pfglXDestroyPbuffer         glXDestroyPbuffer;
pfglXQueryDrawable          glXQueryDrawable;
pfglXCreateNewContext       glXCreateNewContext;
pfglXMakeContextCurrent     glXMakeContextCurrent;
pfglXGetCurrentReadDrawable glXGetCurrentReadDrawable;
pfglXGetCurrentDisplay      glXGetCurrentDisplay;
pfglXQueryContext           glXQueryContext;
pfglXSelectEvent            glXSelectEvent;
pfglXGetSelectedEvent       glXGetSelectedEvent;

pfglXGetProcAddress         glXGetProcAddress;

package void loadPlatformGL(SharedLib lib)
{
    bindFunc(glXChooseVisual)("glXChooseVisual", lib);
    bindFunc(glXCopyContext)("glXCopyContext", lib);
    bindFunc(glXCreateContext)("glXCreateContext", lib);
    bindFunc(glXCreateGLXPixmap)("glXCreateGLXPixmap", lib);
    bindFunc(glXDestroyContext)("glXDestroyContext", lib);
    bindFunc(glXDestroyGLXPixmap)("glXDestroyGLXPixmap", lib);
    bindFunc(glXGetConfig)("glXGetConfig", lib);
    bindFunc(glXGetCurrentContext)("glXGetCurrentContext", lib);
    bindFunc(glXGetCurrentDrawable)("glXGetCurrentDrawable", lib);
    bindFunc(glXIsDirect)("glXIsDirect", lib);
    bindFunc(glXMakeCurrent)("glXMakeCurrent", lib);
    bindFunc(glXQueryExtension)("glXQueryExtension", lib);
    bindFunc(glXQueryVersion)("glXQueryVersion", lib);
    bindFunc(glXSwapBuffers)("glXSwapBuffers", lib);
    bindFunc(glXUseXFont)("glXUseXFont", lib);
    bindFunc(glXWaitGL)("glXWaitGL", lib);
    bindFunc(glXWaitX)("glXWaitX", lib);
    bindFunc(glXGetClientString)("glXGetClientString", lib);
    bindFunc(glXQueryServerString)("glXQueryServerString", lib);
    bindFunc(glXQueryExtensionsString)("glXQueryExtensionsString", lib);

    bindFunc(glXGetFBConfigs)("glXGetFBConfigs", lib);
    bindFunc(glXChooseFBConfig)("glXChooseFBConfig", lib);
    bindFunc(glXGetFBConfigAttrib)("glXGetFBConfigAttrib", lib);
    bindFunc(glXGetVisualFromFBConfig)("glXGetVisualFromFBConfig", lib);
    bindFunc(glXCreateWindow)("glXCreateWindow", lib);
    bindFunc(glXDestroyWindow)("glXDestroyWindow", lib);
    bindFunc(glXCreatePixmap)("glXCreatePixmap", lib);
    bindFunc(glXDestroyPixmap)("glXDestroyPixmap", lib);
    bindFunc(glXCreatePbuffer)("glXCreatePbuffer", lib);
    bindFunc(glXDestroyPbuffer)("glXDestroyPbuffer", lib);
    bindFunc(glXQueryDrawable)("glXQueryDrawable", lib);
    bindFunc(glXCreateNewContext)("glXCreateNewContext", lib);
    bindFunc(glXMakeContextCurrent)("glXMakeContextCurrent", lib);
    bindFunc(glXGetCurrentReadDrawable)("glXGetCurrentReadDrawable", lib);
    bindFunc(glXGetCurrentDisplay)("glXGetCurrentDisplay", lib);
    bindFunc(glXQueryContext)("glXQueryContext", lib);
    bindFunc(glXSelectEvent)("glXSelectEvent", lib);
    bindFunc(glXGetSelectedEvent)("glXGetSelectedEvent", lib);

    bindFunc(glXGetProcAddress)("glXGetProcAddressARB", lib);
}

}   // version(linux)
