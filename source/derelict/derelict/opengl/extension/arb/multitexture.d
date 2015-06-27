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
module derelict.opengl.extension.arb.multitexture;

private
{
    import derelict.opengl.gltypes;
    import derelict.opengl.gl;
    import derelict.opengl.extension.loader;
    import derelict.util.wrapper;
}

private bool enabled = false;

struct ARBMultitexture
{
    static bool load(string extString)
    {
        if(extString.findStr("GL_ARB_multitexture") == -1)
            return false;

        if(!glBindExtFunc(cast(void**)&glActiveTextureARB, "glActiveTextureARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glClientActiveTextureARB, "glClientActiveTextureARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1dARB, "glMultiTexCoord1dARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1dvARB, "glMultiTexCoord1dvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1fARB, "glMultiTexCoord1fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1fvARB, "glMultiTexCoord1fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1iARB, "glMultiTexCoord1iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1ivARB, "glMultiTexCoord1ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1sARB, "glMultiTexCoord1sARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord1svARB, "glMultiTexCoord1svARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2dARB, "glMultiTexCoord2dARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2dvARB, "glMultiTexCoord2dvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2fARB, "glMultiTexCoord2fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2fvARB, "glMultiTexCoord2fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2iARB, "glMultiTexCoord2iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2ivARB, "glMultiTexCoord2ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2sARB, "glMultiTexCoord2sARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord2svARB, "glMultiTexCoord2svARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3dARB, "glMultiTexCoord3dARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3dvARB, "glMultiTexCoord3dvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3fARB, "glMultiTexCoord3fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3fvARB, "glMultiTexCoord3fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3iARB, "glMultiTexCoord3iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3ivARB, "glMultiTexCoord3ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3sARB, "glMultiTexCoord3sARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord3svARB, "glMultiTexCoord3svARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4dARB, "glMultiTexCoord4dARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4dvARB, "glMultiTexCoord4dvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4fARB, "glMultiTexCoord4fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4fvARB, "glMultiTexCoord4fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4iARB, "glMultiTexCoord4iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4ivARB, "glMultiTexCoord4ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4sARB, "glMultiTexCoord4sARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glMultiTexCoord4svARB, "glMultiTexCoord4svARB"))
            return false;

        enabled = true;
        return true;
    }

    static bool isEnabled()
    {
        return enabled;
    }
}

version(DerelictGL_NoExtensionLoaders)
{
}
else
{
    static this()
    {
        DerelictGL.registerExtensionLoader(&ARBMultitexture.load);
    }
}

enum : GLenum
{
    GL_TEXTURE0_ARB                   = 0x84C0,
    GL_TEXTURE1_ARB                   = 0x84C1,
    GL_TEXTURE2_ARB                   = 0x84C2,
    GL_TEXTURE3_ARB                   = 0x84C3,
    GL_TEXTURE4_ARB                   = 0x84C4,
    GL_TEXTURE5_ARB                   = 0x84C5,
    GL_TEXTURE6_ARB                   = 0x84C6,
    GL_TEXTURE7_ARB                   = 0x84C7,
    GL_TEXTURE8_ARB                   = 0x84C8,
    GL_TEXTURE9_ARB                   = 0x84C9,
    GL_TEXTURE10_ARB                  = 0x84CA,
    GL_TEXTURE11_ARB                  = 0x84CB,
    GL_TEXTURE12_ARB                  = 0x84CC,
    GL_TEXTURE13_ARB                  = 0x84CD,
    GL_TEXTURE14_ARB                  = 0x84CE,
    GL_TEXTURE15_ARB                  = 0x84CF,
    GL_TEXTURE16_ARB                  = 0x84D0,
    GL_TEXTURE17_ARB                  = 0x84D1,
    GL_TEXTURE18_ARB                  = 0x84D2,
    GL_TEXTURE19_ARB                  = 0x84D3,
    GL_TEXTURE20_ARB                  = 0x84D4,
    GL_TEXTURE21_ARB                  = 0x84D5,
    GL_TEXTURE22_ARB                  = 0x84D6,
    GL_TEXTURE23_ARB                  = 0x84D7,
    GL_TEXTURE24_ARB                  = 0x84D8,
    GL_TEXTURE25_ARB                  = 0x84D9,
    GL_TEXTURE26_ARB                  = 0x84DA,
    GL_TEXTURE27_ARB                  = 0x84DB,
    GL_TEXTURE28_ARB                  = 0x84DC,
    GL_TEXTURE29_ARB                  = 0x84DD,
    GL_TEXTURE30_ARB                  = 0x84DE,
    GL_TEXTURE31_ARB                  = 0x84DF,
    GL_ACTIVE_TEXTURE_ARB             = 0x84E0,
    GL_CLIENT_ACTIVE_TEXTURE_ARB      = 0x84E1,
    GL_MAX_TEXTURE_UNITS_ARB          = 0x84E2,
}

extern(System):

alias void function(GLenum) pfglActiveTextureARB;
alias void function(GLenum) pfglClientActiveTextureARB;
alias void function(GLenum, GLdouble) pfglMultiTexCoord1dARB;
alias void function(GLenum, GLdouble*) pfglMultiTexCoord1dvARB;
alias void function(GLenum, GLfloat) pfglMultiTexCoord1fARB;
alias void function(GLenum, GLfloat*) pfglMultiTexCoord1fvARB;
alias void function(GLenum, GLint) pfglMultiTexCoord1iARB;
alias void function(GLenum, GLint*) pfglMultiTexCoord1ivARB;
alias void function(GLenum, GLshort) pfglMultiTexCoord1sARB;
alias void function(GLenum, GLshort*) pfglMultiTexCoord1svARB;
alias void function(GLenum, GLdouble, GLdouble) pfglMultiTexCoord2dARB;
alias void function(GLenum, GLdouble*) pfglMultiTexCoord2dvARB;
alias void function(GLenum, GLfloat, GLfloat) pfglMultiTexCoord2fARB;
alias void function(GLenum, GLfloat*) pfglMultiTexCoord2fvARB;
alias void function(GLenum, GLint, GLint) pfglMultiTexCoord2iARB;
alias void function(GLenum, GLint*) pfglMultiTexCoord2ivARB;
alias void function(GLenum, GLshort, GLshort) pfglMultiTexCoord2sARB;
alias void function(GLenum, GLshort*) pfglMultiTexCoord2svARB;
alias void function(GLenum, GLdouble, GLdouble, GLdouble) pfglMultiTexCoord3dARB;
alias void function(GLenum, GLdouble*) pfglMultiTexCoord3dvARB;
alias void function(GLenum, GLfloat, GLfloat, GLfloat) pfglMultiTexCoord3fARB;
alias void function(GLenum, GLfloat*) pfglMultiTexCoord3fvARB;
alias void function(GLenum, GLint, GLint, GLint) pfglMultiTexCoord3iARB;
alias void function(GLenum, GLint*) pfglMultiTexCoord3ivARB;
alias void function(GLenum, GLshort, GLshort, GLshort) pfglMultiTexCoord3sARB;
alias void function(GLenum, GLshort*) pfglMultiTexCoord3svARB;
alias void function(GLenum, GLdouble, GLdouble, GLdouble, GLdouble) pfglMultiTexCoord4dARB;
alias void function(GLenum, GLdouble*) pfglMultiTexCoord4dvARB;
alias void function(GLenum, GLfloat, GLfloat, GLfloat, GLfloat) pfglMultiTexCoord4fARB;
alias void function(GLenum, GLfloat*) pfglMultiTexCoord4fvARB;
alias void function(GLenum, GLint, GLint, GLint, GLint) pfglMultiTexCoord4iARB;
alias void function(GLenum, GLint*) pfglMultiTexCoord4ivARB;
alias void function(GLenum, GLshort, GLshort, GLshort, GLshort) pfglMultiTexCoord4sARB;
alias void function(GLenum, GLshort*) pfglMultiTexCoord4svARB;

pfglActiveTextureARB            glActiveTextureARB;
pfglClientActiveTextureARB      glClientActiveTextureARB;
pfglMultiTexCoord1dARB          glMultiTexCoord1dARB;
pfglMultiTexCoord1dvARB         glMultiTexCoord1dvARB;
pfglMultiTexCoord1fARB          glMultiTexCoord1fARB;
pfglMultiTexCoord1fvARB         glMultiTexCoord1fvARB;
pfglMultiTexCoord1iARB          glMultiTexCoord1iARB;
pfglMultiTexCoord1ivARB         glMultiTexCoord1ivARB;
pfglMultiTexCoord1sARB          glMultiTexCoord1sARB;
pfglMultiTexCoord1svARB         glMultiTexCoord1svARB;
pfglMultiTexCoord2dARB          glMultiTexCoord2dARB;
pfglMultiTexCoord2dvARB         glMultiTexCoord2dvARB;
pfglMultiTexCoord2fARB          glMultiTexCoord2fARB;
pfglMultiTexCoord2fvARB         glMultiTexCoord2fvARB;
pfglMultiTexCoord2iARB          glMultiTexCoord2iARB;
pfglMultiTexCoord2ivARB         glMultiTexCoord2ivARB;
pfglMultiTexCoord2sARB          glMultiTexCoord2sARB;
pfglMultiTexCoord2svARB         glMultiTexCoord2svARB;
pfglMultiTexCoord3dARB          glMultiTexCoord3dARB;
pfglMultiTexCoord3dvARB         glMultiTexCoord3dvARB;
pfglMultiTexCoord3fARB          glMultiTexCoord3fARB;
pfglMultiTexCoord3fvARB         glMultiTexCoord3fvARB;
pfglMultiTexCoord3iARB          glMultiTexCoord3iARB;
pfglMultiTexCoord3ivARB         glMultiTexCoord3ivARB;
pfglMultiTexCoord3sARB          glMultiTexCoord3sARB;
pfglMultiTexCoord3svARB         glMultiTexCoord3svARB;
pfglMultiTexCoord4dARB          glMultiTexCoord4dARB;
pfglMultiTexCoord4dvARB         glMultiTexCoord4dvARB;
pfglMultiTexCoord4fARB          glMultiTexCoord4fARB;
pfglMultiTexCoord4fvARB         glMultiTexCoord4fvARB;
pfglMultiTexCoord4iARB          glMultiTexCoord4iARB;
pfglMultiTexCoord4ivARB         glMultiTexCoord4ivARB;
pfglMultiTexCoord4sARB          glMultiTexCoord4sARB;
pfglMultiTexCoord4svARB         glMultiTexCoord4svARB;
