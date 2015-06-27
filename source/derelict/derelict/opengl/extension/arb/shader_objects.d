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
module derelict.opengl.extension.arb.shader_objects;

private
{
    import derelict.opengl.gltypes;
    import derelict.opengl.gl;
    import derelict.opengl.extension.loader;
    import derelict.util.wrapper;
}

private __gshared bool enabled = false;

struct ARBShaderObjects
{
    static bool load(string extString)
    {
        if(extString.findStr("GL_ARB_shader_objects") == -1)
            return false;
        if(!glBindExtFunc(cast(void**)&glDeleteObjectARB, "glDeleteObjectARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetHandleARB, "glGetHandleARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glDetachObjectARB, "glDetachObjectARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glCreateShaderObjectARB, "glCreateShaderObjectARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glShaderSourceARB, "glShaderSourceARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glCompileShaderARB, "glCompileShaderARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glCreateProgramObjectARB, "glCreateProgramObjectARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glAttachObjectARB, "glAttachObjectARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glLinkProgramARB, "glLinkProgramARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUseProgramObjectARB, "glUseProgramObjectARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glValidateProgramARB, "glValidateProgramARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform1fARB, "glUniform1fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform2fARB, "glUniform2fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform3fARB, "glUniform3fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform4fARB, "glUniform4fARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform1iARB, "glUniform1iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform2iARB, "glUniform2iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform3iARB, "glUniform3iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform4iARB, "glUniform4iARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform1fvARB, "glUniform1fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform2fvARB, "glUniform2fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform3fvARB, "glUniform3fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform4fvARB, "glUniform4fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform1ivARB, "glUniform1ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform2ivARB, "glUniform2ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform3ivARB, "glUniform3ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform4ivARB, "glUniform4ivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniformMatrix2fvARB, "glUniformMatrix2fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniformMatrix3fvARB, "glUniformMatrix3fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniformMatrix4fvARB, "glUniformMatrix4fvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetObjectParameterfvARB, "glGetObjectParameterfvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetObjectParameterivARB, "glGetObjectParameterivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetInfoLogARB, "glGetInfoLogARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetAttachedObjectsARB, "glGetAttachedObjectsARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetUniformLocationARB, "glGetUniformLocationARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetActiveUniformARB, "glGetActiveUniformARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetUniformfvARB, "glGetUniformfvARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetUniformivARB, "glGetUniformivARB"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetShaderSourceARB, "glGetShaderSourceARB"))
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
    shared static this()
    {
        DerelictGL.registerExtensionLoader(&ARBShaderObjects.load);
    }
}

enum : GLenum
{
    GL_PROGRAM_OBJECT_ARB                  = 0x8B40,
    GL_SHADER_OBJECT_ARB                   = 0x8B48,
    GL_OBJECT_TYPE_ARB                     = 0x8B4E,
    GL_OBJECT_SUBTYPE_ARB                  = 0x8B4F,
    GL_FLOAT_VEC2_ARB                      = 0x8B50,
    GL_FLOAT_VEC3_ARB                      = 0x8B51,
    GL_FLOAT_VEC4_ARB                      = 0x8B52,
    GL_INT_VEC2_ARB                        = 0x8B53,
    GL_INT_VEC3_ARB                        = 0x8B54,
    GL_INT_VEC4_ARB                        = 0x8B55,
    GL_BOOL_ARB                            = 0x8B56,
    GL_BOOL_VEC2_ARB                       = 0x8B57,
    GL_BOOL_VEC3_ARB                       = 0x8B58,
    GL_BOOL_VEC4_ARB                       = 0x8B59,
    GL_FLOAT_MAT2_ARB                      = 0x8B5A,
    GL_FLOAT_MAT3_ARB                      = 0x8B5B,
    GL_FLOAT_MAT4_ARB                      = 0x8B5C,
    GL_SAMPLER_1D_ARB                      = 0x8B5D,
    GL_SAMPLER_2D_ARB                      = 0x8B5E,
    GL_SAMPLER_3D_ARB                      = 0x8B5F,
    GL_SAMPLER_CUBE_ARB                    = 0x8B60,
    GL_SAMPLER_1D_SHADOW_ARB               = 0x8B61,
    GL_SAMPLER_2D_SHADOW_ARB               = 0x8B62,
    GL_SAMPLER_2D_RECT_ARB                 = 0x8B63,
    GL_SAMPLER_2D_RECT_SHADOW_ARB          = 0x8B64,
    GL_OBJECT_DELETE_STATUS_ARB            = 0x8B80,
    GL_OBJECT_COMPILE_STATUS_ARB           = 0x8B81,
    GL_OBJECT_LINK_STATUS_ARB              = 0x8B82,
    GL_OBJECT_VALIDATE_STATUS_ARB          = 0x8B83,
    GL_OBJECT_INFO_LOG_LENGTH_ARB          = 0x8B84,
    GL_OBJECT_ATTACHED_OBJECTS_ARB         = 0x8B85,
    GL_OBJECT_ACTIVE_UNIFORMS_ARB          = 0x8B86,
    GL_OBJECT_ACTIVE_UNIFORM_MAX_LENGTH_ARB = 0x8B87,
    GL_OBJECT_SHADER_SOURCE_LENGTH_ARB     = 0x8B88,
}

alias char GLcharARB;
alias uint GLhandleARB;

extern(System):

alias void function(GLhandleARB) pfglDeleteObjectARB;
alias GLhandleARB function(GLenum) pfglGetHandleARB;
alias void function(GLhandleARB, GLhandleARB) pfglDetachObjectARB;
alias GLhandleARB function(GLenum) pfglCreateShaderObjectARB;
alias void function(GLhandleARB, GLsizei, const(GLcharARB)**, GLint*) pfglShaderSourceARB;
alias void function(GLhandleARB) pfglCompileShaderARB;
alias GLhandleARB function() pfglCreateProgramObjectARB;
alias void function(GLhandleARB, GLhandleARB) pfglAttachObjectARB;
alias void function(GLhandleARB) pfglLinkProgramARB;
alias void function(GLhandleARB) pfglUseProgramObjectARB;
alias void function(GLhandleARB) pfglValidateProgramARB;
alias void function(GLint, GLfloat) pfglUniform1fARB;
alias void function(GLint, GLfloat, GLfloat) pfglUniform2fARB;
alias void function(GLint, GLfloat, GLfloat, GLfloat) pfglUniform3fARB;
alias void function(GLint, GLfloat, GLfloat, GLfloat, GLfloat) pfglUniform4fARB;
alias void function(GLint, GLint) pfglUniform1iARB;
alias void function(GLint, GLint, GLint) pfglUniform2iARB;
alias void function(GLint, GLint, GLint, GLint) pfglUniform3iARB;
alias void function(GLint, GLint, GLint, GLint, GLint) pfglUniform4iARB;
alias void function(GLint, GLsizei, GLfloat*) pfglUniform1fvARB;
alias void function(GLint, GLsizei, GLfloat*) pfglUniform2fvARB;
alias void function(GLint, GLsizei, GLfloat*) pfglUniform3fvARB;
alias void function(GLint, GLsizei, GLfloat*) pfglUniform4fvARB;
alias void function(GLint, GLsizei, GLint*) pfglUniform1ivARB;
alias void function(GLint, GLsizei, GLint*) pfglUniform2ivARB;
alias void function(GLint, GLsizei, GLint*) pfglUniform3ivARB;
alias void function(GLint, GLsizei, GLint*) pfglUniform4ivARB;
alias void function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix2fvARB;
alias void function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix3fvARB;
alias void function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix4fvARB;
alias void function(GLhandleARB, GLenum, GLfloat*) pfglGetObjectParameterfvARB;
alias void function(GLhandleARB, GLenum, GLint*) pfglGetObjectParameterivARB;
alias void function(GLhandleARB, GLsizei, GLsizei*, GLcharARB*) pfglGetInfoLogARB;
alias void function(GLhandleARB, GLsizei, GLsizei*, GLhandleARB*) pfglGetAttachedObjectsARB;
alias GLint function(GLhandleARB, GLcharARB*) pfglGetUniformLocationARB;
alias void function(GLhandleARB, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLcharARB*) pfglGetActiveUniformARB;
alias void function(GLhandleARB, GLint, GLfloat*) pfglGetUniformfvARB;
alias void function(GLhandleARB, GLint, GLint*) pfglGetUniformivARB;
alias void function(GLhandleARB, GLsizei, GLsizei*, GLcharARB*) pfglGetShaderSourceARB;

__gshared nothrow @nogc
{
pfglDeleteObjectARB                     glDeleteObjectARB;
pfglGetHandleARB                        glGetHandleARB;
pfglDetachObjectARB                     glDetachObjectARB;
pfglCreateShaderObjectARB               glCreateShaderObjectARB;
pfglShaderSourceARB                     glShaderSourceARB;
pfglCompileShaderARB                    glCompileShaderARB;
pfglCreateProgramObjectARB              glCreateProgramObjectARB;
pfglAttachObjectARB                     glAttachObjectARB;
pfglLinkProgramARB                      glLinkProgramARB;
pfglUseProgramObjectARB                 glUseProgramObjectARB;
pfglValidateProgramARB                  glValidateProgramARB;
pfglUniform1fARB                        glUniform1fARB;
pfglUniform2fARB                        glUniform2fARB;
pfglUniform3fARB                        glUniform3fARB;
pfglUniform4fARB                        glUniform4fARB;
pfglUniform1iARB                        glUniform1iARB;
pfglUniform2iARB                        glUniform2iARB;
pfglUniform3iARB                        glUniform3iARB;
pfglUniform4iARB                        glUniform4iARB;
pfglUniform1fvARB                       glUniform1fvARB;
pfglUniform2fvARB                       glUniform2fvARB;
pfglUniform3fvARB                       glUniform3fvARB;
pfglUniform4fvARB                       glUniform4fvARB;
pfglUniform1ivARB                       glUniform1ivARB;
pfglUniform2ivARB                       glUniform2ivARB;
pfglUniform3ivARB                       glUniform3ivARB;
pfglUniform4ivARB                       glUniform4ivARB;
pfglUniformMatrix2fvARB                 glUniformMatrix2fvARB;
pfglUniformMatrix3fvARB                 glUniformMatrix3fvARB;
pfglUniformMatrix4fvARB                 glUniformMatrix4fvARB;
pfglGetObjectParameterfvARB             glGetObjectParameterfvARB;
pfglGetObjectParameterivARB             glGetObjectParameterivARB;
pfglGetInfoLogARB                       glGetInfoLogARB;
pfglGetAttachedObjectsARB               glGetAttachedObjectsARB;
pfglGetUniformLocationARB               glGetUniformLocationARB;
pfglGetActiveUniformARB                 glGetActiveUniformARB;
pfglGetUniformfvARB                     glGetUniformfvARB;
pfglGetUniformivARB                     glGetUniformivARB;
pfglGetShaderSourceARB                  glGetShaderSourceARB;
}