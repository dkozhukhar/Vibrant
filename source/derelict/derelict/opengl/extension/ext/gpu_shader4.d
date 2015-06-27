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
module derelict.opengl.extension.ext.gpu_shader4;

private
{
    import derelict.opengl.gltypes;
    import derelict.opengl.gl;
    import derelict.opengl.extension.loader;
    import derelict.util.wrapper;
}

private bool enabled = false;

struct EXTGpuShader4
{
    static bool load(string extString)
    {
        if(extString.findStr("GL_EXT_gpu_shader4") == -1)
            return false;

        if(!glBindExtFunc(cast(void**)&glBindFragDataLocationEXT, "glBindFragDataLocationEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetFragDataLocationEXT, "glGetFragDataLocationEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetUniformuivEXT, "glGetUniformuivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetVertexAttribIivEXT, "glGetVertexAttribIivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glGetVertexAttribIuivEXT, "glGetVertexAttribIuivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform1uiEXT, "glUniform1uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform1uivEXT, "glUniform1uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform2uiEXT, "glUniform2uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform2uivEXT, "glUniform2uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform3uiEXT, "glUniform3uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform3uivEXT, "glUniform3uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform4uiEXT, "glUniform4uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glUniform4uivEXT, "glUniform4uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI1iEXT, "glVertexAttribI1iEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI1ivEXT, "glVertexAttribI1ivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI1uiEXT, "glVertexAttribI1uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI1uivEXT, "glVertexAttribI1uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI2iEXT, "glVertexAttribI2iEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI2ivEXT, "glVertexAttribI2ivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI2uiEXT, "glVertexAttribI2uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI2uivEXT, "glVertexAttribI2uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI3iEXT, "glVertexAttribI3iEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI3ivEXT, "glVertexAttribI3ivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI3uiEXT, "glVertexAttribI3uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI3uivEXT, "glVertexAttribI3uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4bvEXT, "glVertexAttribI4bvEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4iEXT, "glVertexAttribI4iEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4ivEXT, "glVertexAttribI4ivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4svEXT, "glVertexAttribI4svEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4ubvEXT, "glVertexAttribI4ubvEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4uiEXT, "glVertexAttribI4uiEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4uivEXT, "glVertexAttribI4uivEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribI4usvEXT, "glVertexAttribI4usvEXT"))
            return false;
        if(!glBindExtFunc(cast(void**)&glVertexAttribIPointerEXT, "glVertexAttribIPointerEXT"))
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
        DerelictGL.registerExtensionLoader(&EXTGpuShader4.load);
    }
}

enum : GLenum
{
    GL_VERTEX_ATTRIB_ARRAY_INTEGER_EXT  = 0x88FD,
    GL_SAMPLER_1D_ARRAY_EXT             = 0x8DC0,
    GL_SAMPLER_2D_ARRAY_EXT             = 0x8DC1,
    GL_SAMPLER_BUFFER_EXT               = 0x8DC2,
    GL_SAMPLER_1D_ARRAY_SHADOW_EXT      = 0x8DC3,
    GL_SAMPLER_2D_ARRAY_SHADOW_EXT      = 0x8DC4,
    GL_SAMPLER_CUBE_SHADOW_EXT          = 0x8DC5,
    GL_UNSIGNED_INT_VEC2_EXT            = 0x8DC6,
    GL_UNSIGNED_INT_VEC3_EXT            = 0x8DC7,
    GL_UNSIGNED_INT_VEC4_EXT            = 0x8DC8,
    GL_INT_SAMPLER_1D_EXT               = 0x8DC9,
    GL_INT_SAMPLER_2D_EXT               = 0x8DCA,
    GL_INT_SAMPLER_3D_EXT               = 0x8DCB,
    GL_INT_SAMPLER_CUBE_EXT             = 0x8DCC,
    GL_INT_SAMPLER_2D_RECT_EXT          = 0x8DCD,
    GL_INT_SAMPLER_1D_ARRAY_EXT         = 0x8DCE,
    GL_INT_SAMPLER_2D_ARRAY_EXT         = 0x8DCF,
    GL_INT_SAMPLER_BUFFER_EXT           = 0x8DD0,
    GL_UNSIGNED_INT_SAMPLER_1D_EXT      = 0x8DD1,
    GL_UNSIGNED_INT_SAMPLER_2D_EXT      = 0x8DD2,
    GL_UNSIGNED_INT_SAMPLER_3D_EXT      = 0x8DD3,
    GL_UNSIGNED_INT_SAMPLER_CUBE_EXT    = 0x8DD4,
    GL_UNSIGNED_INT_SAMPLER_2D_RECT_EXT = 0x8DD5,
    GL_UNSIGNED_INT_SAMPLER_1D_ARRAY_EXT = 0x8DD6,
    GL_UNSIGNED_INT_SAMPLER_2D_ARRAY_EXT = 0x8DD7,
    GL_UNSIGNED_INT_SAMPLER_BUFFER_EXT  = 0x8DD8,
}

extern(System):

alias void function(GLuint,GLuint,GLchar*) pfglBindFragDataLocationEXT;
alias GLint function(GLuint,GLchar*) pfglGetFragDataLocationEXT;
alias void function(GLuint,GLint,GLuint*) pfglGetUniformuivEXT;
alias void function(GLuint,GLenum,GLint*) pfglGetVertexAttribIivEXT;
alias void function(GLuint,GLenum,GLuint*) pfglGetVertexAttribIuivEXT;
alias void function(GLint,GLuint) pfglUniform1uiEXT;
alias void function(GLint,GLsizei,GLuint*) pfglUniform1uivEXT;
alias void function(GLint,GLuint,GLuint) pfglUniform2uiEXT;
alias void function(GLint,GLsizei,GLuint*) pfglUniform2uivEXT;
alias void function(GLint,GLuint,GLuint,GLuint) pfglUniform3uiEXT;
alias void function(GLint,GLsizei,GLuint*) pfglUniform3uivEXT;
alias void function(GLint,GLuint,GLuint,GLuint,GLuint) pfglUniform4uiEXT;
alias void function(GLint,GLsizei,GLuint*) pfglUniform4uivEXT;
alias void function(GLuint,GLint) pfglVertexAttribI1iEXT;
alias void function(GLuint,GLint*) pfglVertexAttribI1ivEXT;
alias void function(GLuint,GLuint) pfglVertexAttribI1uiEXT;
alias void function(GLuint,GLuint*) pfglVertexAttribI1uivEXT;
alias void function(GLuint,GLint,GLint) pfglVertexAttribI2iEXT;
alias void function(GLuint,GLint*) pfglVertexAttribI2ivEXT;
alias void function(GLuint,GLuint,GLuint) pfglVertexAttribI2uiEXT;
alias void function(GLuint,GLuint*) pfglVertexAttribI2uivEXT;
alias void function(GLuint,GLint,GLint,GLint) pfglVertexAttribI3iEXT;
alias void function(GLuint,GLint*) pfglVertexAttribI3ivEXT;
alias void function(GLuint,GLuint,GLuint,GLuint) pfglVertexAttribI3uiEXT;
alias void function(GLuint,GLuint*) pfglVertexAttribI3uivEXT;
alias void function(GLuint,GLbyte*) pfglVertexAttribI4bvEXT;
alias void function(GLuint,GLint,GLint,GLint,GLint) pfglVertexAttribI4iEXT;
alias void function(GLuint,GLint*) pfglVertexAttribI4ivEXT;
alias void function(GLuint,GLshort*) pfglVertexAttribI4svEXT;
alias void function(GLuint,GLubyte*) pfglVertexAttribI4ubvEXT;
alias void function(GLuint,GLuint,GLuint,GLuint,GLuint) pfglVertexAttribI4uiEXT;
alias void function(GLuint,GLuint*) pfglVertexAttribI4uivEXT;
alias void function(GLuint,GLushort*) pfglVertexAttribI4usvEXT;
alias void function(GLuint,GLint,GLenum,GLenum,GLsizei,GLvoid*) pfglVertexAttribIPointerEXT;

pfglBindFragDataLocationEXT             glBindFragDataLocationEXT;
pfglGetFragDataLocationEXT              glGetFragDataLocationEXT;
pfglGetUniformuivEXT                    glGetUniformuivEXT;
pfglGetVertexAttribIivEXT               glGetVertexAttribIivEXT;
pfglGetVertexAttribIuivEXT              glGetVertexAttribIuivEXT;
pfglUniform1uiEXT                       glUniform1uiEXT;
pfglUniform1uivEXT                      glUniform1uivEXT;
pfglUniform2uiEXT                       glUniform2uiEXT;
pfglUniform2uivEXT                      glUniform2uivEXT;
pfglUniform3uiEXT                       glUniform3uiEXT;
pfglUniform3uivEXT                      glUniform3uivEXT;
pfglUniform4uiEXT                       glUniform4uiEXT;
pfglUniform4uivEXT                      glUniform4uivEXT;
pfglVertexAttribI1iEXT                  glVertexAttribI1iEXT;
pfglVertexAttribI1ivEXT                 glVertexAttribI1ivEXT;
pfglVertexAttribI1uiEXT                 glVertexAttribI1uiEXT;
pfglVertexAttribI1uivEXT                glVertexAttribI1uivEXT;
pfglVertexAttribI2iEXT                  glVertexAttribI2iEXT;
pfglVertexAttribI2ivEXT                 glVertexAttribI2ivEXT;
pfglVertexAttribI2uiEXT                 glVertexAttribI2uiEXT;
pfglVertexAttribI2uivEXT                glVertexAttribI2uivEXT;
pfglVertexAttribI3iEXT                  glVertexAttribI3iEXT;
pfglVertexAttribI3ivEXT                 glVertexAttribI3ivEXT;
pfglVertexAttribI3uiEXT                 glVertexAttribI3uiEXT;
pfglVertexAttribI3uivEXT                glVertexAttribI3uivEXT;
pfglVertexAttribI4bvEXT                 glVertexAttribI4bvEXT;
pfglVertexAttribI4iEXT                  glVertexAttribI4iEXT;
pfglVertexAttribI4ivEXT                 glVertexAttribI4ivEXT;
pfglVertexAttribI4svEXT                 glVertexAttribI4svEXT;
pfglVertexAttribI4ubvEXT                glVertexAttribI4ubvEXT;
pfglVertexAttribI4uiEXT                 glVertexAttribI4uiEXT;
pfglVertexAttribI4uivEXT                glVertexAttribI4uivEXT;
pfglVertexAttribI4usvEXT                glVertexAttribI4usvEXT;
pfglVertexAttribIPointerEXT             glVertexAttribIPointerEXT;