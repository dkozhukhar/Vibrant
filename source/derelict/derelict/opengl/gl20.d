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
module derelict.opengl.gl20;

private
{
    import derelict.util.loader;
    import derelict.util.exception;
    import derelict.opengl.gltypes;
    version(Windows)
        import derelict.opengl.wgl;
}

package void loadGL20(SharedLib lib)
{
    version(Windows)
    {
        wglBindFunc(cast(void**)&glBlendEquationSeparate, "glBlendEquationSeparate", lib);
        wglBindFunc(cast(void**)&glDrawBuffers, "glDrawBuffers", lib);
        wglBindFunc(cast(void**)&glStencilOpSeparate, "glStencilOpSeparate", lib);
        wglBindFunc(cast(void**)&glStencilFuncSeparate, "glStencilFuncSeparate", lib);
        wglBindFunc(cast(void**)&glStencilMaskSeparate, "glStencilMaskSeparate", lib);
        wglBindFunc(cast(void**)&glAttachShader, "glAttachShader", lib);
        wglBindFunc(cast(void**)&glBindAttribLocation, "glBindAttribLocation", lib);
        wglBindFunc(cast(void**)&glCompileShader, "glCompileShader", lib);
        wglBindFunc(cast(void**)&glCreateProgram, "glCreateProgram", lib);
        wglBindFunc(cast(void**)&glCreateShader, "glCreateShader", lib);
        wglBindFunc(cast(void**)&glDeleteProgram, "glDeleteProgram", lib);
        wglBindFunc(cast(void**)&glDeleteShader, "glDeleteShader", lib);
        wglBindFunc(cast(void**)&glDetachShader, "glDetachShader", lib);
        wglBindFunc(cast(void**)&glDisableVertexAttribArray, "glDisableVertexAttribArray", lib);
        wglBindFunc(cast(void**)&glEnableVertexAttribArray, "glEnableVertexAttribArray", lib);
        wglBindFunc(cast(void**)&glGetActiveAttrib, "glGetActiveAttrib", lib);
        wglBindFunc(cast(void**)&glGetActiveUniform, "glGetActiveUniform", lib);
        wglBindFunc(cast(void**)&glGetAttachedShaders, "glGetAttachedShaders", lib);
        wglBindFunc(cast(void**)&glGetAttribLocation, "glGetAttribLocation", lib);
        wglBindFunc(cast(void**)&glGetProgramiv, "glGetProgramiv", lib);
        wglBindFunc(cast(void**)&glGetProgramInfoLog, "glGetProgramInfoLog", lib);
        wglBindFunc(cast(void**)&glGetShaderiv, "glGetShaderiv", lib);
        wglBindFunc(cast(void**)&glGetShaderInfoLog, "glGetShaderInfoLog", lib);
        wglBindFunc(cast(void**)&glGetShaderSource, "glGetShaderSource", lib);
        wglBindFunc(cast(void**)&glGetUniformLocation, "glGetUniformLocation", lib);
        wglBindFunc(cast(void**)&glGetUniformfv, "glGetUniformfv", lib);
        wglBindFunc(cast(void**)&glGetUniformiv, "glGetUniformiv", lib);
        wglBindFunc(cast(void**)&glGetVertexAttribdv, "glGetVertexAttribdv", lib);
        wglBindFunc(cast(void**)&glGetVertexAttribfv, "glGetVertexAttribfv", lib);
        wglBindFunc(cast(void**)&glGetVertexAttribiv, "glGetVertexAttribiv", lib);
        wglBindFunc(cast(void**)&glGetVertexAttribPointerv, "glGetVertexAttribPointerv", lib);
        wglBindFunc(cast(void**)&glIsProgram, "glIsProgram", lib);
        wglBindFunc(cast(void**)&glIsShader, "glIsShader", lib);
        wglBindFunc(cast(void**)&glLinkProgram, "glLinkProgram", lib);
        wglBindFunc(cast(void**)&glShaderSource, "glShaderSource", lib);
        wglBindFunc(cast(void**)&glUseProgram, "glUseProgram", lib);
        wglBindFunc(cast(void**)&glUniform1f, "glUniform1f", lib);
        wglBindFunc(cast(void**)&glUniform2f, "glUniform2f", lib);
        wglBindFunc(cast(void**)&glUniform3f, "glUniform3f", lib);
        wglBindFunc(cast(void**)&glUniform4f, "glUniform4f", lib);
        wglBindFunc(cast(void**)&glUniform1i, "glUniform1i", lib);
        wglBindFunc(cast(void**)&glUniform2i, "glUniform2i", lib);
        wglBindFunc(cast(void**)&glUniform3i, "glUniform3i", lib);
        wglBindFunc(cast(void**)&glUniform4i, "glUniform4i", lib);
        wglBindFunc(cast(void**)&glUniform1fv, "glUniform1fv", lib);
        wglBindFunc(cast(void**)&glUniform2fv, "glUniform2fv", lib);
        wglBindFunc(cast(void**)&glUniform3fv, "glUniform3fv", lib);
        wglBindFunc(cast(void**)&glUniform4fv, "glUniform4fv", lib);
        wglBindFunc(cast(void**)&glUniform1iv, "glUniform1iv", lib);
        wglBindFunc(cast(void**)&glUniform2iv, "glUniform2iv", lib);
        wglBindFunc(cast(void**)&glUniform3iv, "glUniform3iv", lib);
        wglBindFunc(cast(void**)&glUniform4iv, "glUniform4iv", lib);
        wglBindFunc(cast(void**)&glUniformMatrix2fv, "glUniformMatrix2fv", lib);
        wglBindFunc(cast(void**)&glUniformMatrix3fv, "glUniformMatrix3fv", lib);
        wglBindFunc(cast(void**)&glUniformMatrix4fv, "glUniformMatrix4fv", lib);
        wglBindFunc(cast(void**)&glValidateProgram, "glValidateProgram", lib);
        wglBindFunc(cast(void**)&glVertexAttrib1d, "glVertexAttrib1d", lib);
        wglBindFunc(cast(void**)&glVertexAttrib1dv, "glVertexAttrib1dv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib1f, "glVertexAttrib1f", lib);
        wglBindFunc(cast(void**)&glVertexAttrib1fv, "glVertexAttrib1fv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib1s, "glVertexAttrib1s", lib);
        wglBindFunc(cast(void**)&glVertexAttrib1sv, "glVertexAttrib1sv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib2d, "glVertexAttrib2d", lib);
        wglBindFunc(cast(void**)&glVertexAttrib2dv, "glVertexAttrib2dv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib2f, "glVertexAttrib2f", lib);
        wglBindFunc(cast(void**)&glVertexAttrib2fv, "glVertexAttrib2fv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib2s, "glVertexAttrib2s", lib);
        wglBindFunc(cast(void**)&glVertexAttrib2sv, "glVertexAttrib2sv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib3d, "glVertexAttrib3d", lib);
        wglBindFunc(cast(void**)&glVertexAttrib3dv, "glVertexAttrib3dv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib3f, "glVertexAttrib3f", lib);
        wglBindFunc(cast(void**)&glVertexAttrib3fv, "glVertexAttrib3fv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib3s, "glVertexAttrib3s", lib);
        wglBindFunc(cast(void**)&glVertexAttrib3sv, "glVertexAttrib3sv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Nbv, "glVertexAttrib4Nbv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Niv, "glVertexAttrib4Niv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Nsv, "glVertexAttrib4Nsv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Nub, "glVertexAttrib4Nub", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Nubv, "glVertexAttrib4Nubv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Nuiv, "glVertexAttrib4Nuiv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4Nusv, "glVertexAttrib4Nusv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4bv, "glVertexAttrib4bv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4d, "glVertexAttrib4d", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4dv, "glVertexAttrib4dv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4f, "glVertexAttrib4f", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4fv, "glVertexAttrib4fv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4iv, "glVertexAttrib4iv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4s, "glVertexAttrib4s", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4sv, "glVertexAttrib4sv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4ubv, "glVertexAttrib4ubv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4uiv, "glVertexAttrib4uiv", lib);
        wglBindFunc(cast(void**)&glVertexAttrib4usv, "glVertexAttrib4usv", lib);
        wglBindFunc(cast(void**)&glVertexAttribPointer, "glVertexAttribPointer", lib);
    }
    else
    {
        bindFunc(glBlendEquationSeparate)("glBlendEquationSeparate", lib);
        bindFunc(glDrawBuffers)("glDrawBuffers", lib);
        bindFunc(glStencilOpSeparate)("glStencilOpSeparate", lib);
        bindFunc(glStencilFuncSeparate)("glStencilFuncSeparate", lib);
        bindFunc(glStencilMaskSeparate)("glStencilMaskSeparate", lib);
        bindFunc(glAttachShader)("glAttachShader", lib);
        bindFunc(glBindAttribLocation)("glBindAttribLocation", lib);
        bindFunc(glCompileShader)("glCompileShader", lib);
        bindFunc(glCreateProgram)("glCreateProgram", lib);
        bindFunc(glCreateShader)("glCreateShader", lib);
        bindFunc(glDeleteProgram)("glDeleteProgram", lib);
        bindFunc(glDeleteShader)("glDeleteShader", lib);
        bindFunc(glDetachShader)("glDetachShader", lib);
        bindFunc(glDisableVertexAttribArray)("glDisableVertexAttribArray", lib);
        bindFunc(glEnableVertexAttribArray)("glEnableVertexAttribArray", lib);
        bindFunc(glGetActiveAttrib)("glGetActiveAttrib", lib);
        bindFunc(glGetActiveUniform)("glGetActiveUniform", lib);
        bindFunc(glGetAttachedShaders)("glGetAttachedShaders", lib);
        bindFunc(glGetAttribLocation)("glGetAttribLocation", lib);
        bindFunc(glGetProgramiv)("glGetProgramiv", lib);
        bindFunc(glGetProgramInfoLog)("glGetProgramInfoLog", lib);
        bindFunc(glGetShaderiv)("glGetShaderiv", lib);
        bindFunc(glGetShaderInfoLog)("glGetShaderInfoLog", lib);
        bindFunc(glGetShaderSource)("glGetShaderSource", lib);
        bindFunc(glGetUniformLocation)("glGetUniformLocation", lib);
        bindFunc(glGetUniformfv)("glGetUniformfv", lib);
        bindFunc(glGetUniformiv)("glGetUniformiv", lib);
        bindFunc(glGetVertexAttribdv)("glGetVertexAttribdv", lib);
        bindFunc(glGetVertexAttribfv)("glGetVertexAttribfv", lib);
        bindFunc(glGetVertexAttribiv)("glGetVertexAttribiv", lib);
        bindFunc(glGetVertexAttribPointerv)("glGetVertexAttribPointerv", lib);
        bindFunc(glIsProgram)("glIsProgram", lib);
        bindFunc(glIsShader)("glIsShader", lib);
        bindFunc(glLinkProgram)("glLinkProgram", lib);
        bindFunc(glShaderSource)("glShaderSource", lib);
        bindFunc(glUseProgram)("glUseProgram", lib);
        bindFunc(glUniform1f)("glUniform1f", lib);
        bindFunc(glUniform2f)("glUniform2f", lib);
        bindFunc(glUniform3f)("glUniform3f", lib);
        bindFunc(glUniform4f)("glUniform4f", lib);
        bindFunc(glUniform1i)("glUniform1i", lib);
        bindFunc(glUniform2i)("glUniform2i", lib);
        bindFunc(glUniform3i)("glUniform3i", lib);
        bindFunc(glUniform4i)("glUniform4i", lib);
        bindFunc(glUniform1fv)("glUniform1fv", lib);
        bindFunc(glUniform2fv)("glUniform2fv", lib);
        bindFunc(glUniform3fv)("glUniform3fv", lib);
        bindFunc(glUniform4fv)("glUniform4fv", lib);
        bindFunc(glUniform1iv)("glUniform1iv", lib);
        bindFunc(glUniform2iv)("glUniform2iv", lib);
        bindFunc(glUniform3iv)("glUniform3iv", lib);
        bindFunc(glUniform4iv)("glUniform4iv", lib);
        bindFunc(glUniformMatrix2fv)("glUniformMatrix2fv", lib);
        bindFunc(glUniformMatrix3fv)("glUniformMatrix3fv", lib);
        bindFunc(glUniformMatrix4fv)("glUniformMatrix4fv", lib);
        bindFunc(glValidateProgram)("glValidateProgram", lib);
        bindFunc(glVertexAttrib1d)("glVertexAttrib1d", lib);
        bindFunc(glVertexAttrib1dv)("glVertexAttrib1dv", lib);
        bindFunc(glVertexAttrib1f)("glVertexAttrib1f", lib);
        bindFunc(glVertexAttrib1fv)("glVertexAttrib1fv", lib);
        bindFunc(glVertexAttrib1s)("glVertexAttrib1s", lib);
        bindFunc(glVertexAttrib1sv)("glVertexAttrib1sv", lib);
        bindFunc(glVertexAttrib2d)("glVertexAttrib2d", lib);
        bindFunc(glVertexAttrib2dv)("glVertexAttrib2dv", lib);
        bindFunc(glVertexAttrib2f)("glVertexAttrib2f", lib);
        bindFunc(glVertexAttrib2fv)("glVertexAttrib2fv", lib);
        bindFunc(glVertexAttrib2s)("glVertexAttrib2s", lib);
        bindFunc(glVertexAttrib2sv)("glVertexAttrib2sv", lib);
        bindFunc(glVertexAttrib3d)("glVertexAttrib3d", lib);
        bindFunc(glVertexAttrib3dv)("glVertexAttrib3dv", lib);
        bindFunc(glVertexAttrib3f)("glVertexAttrib3f", lib);
        bindFunc(glVertexAttrib3fv)("glVertexAttrib3fv", lib);
        bindFunc(glVertexAttrib3s)("glVertexAttrib3s", lib);
        bindFunc(glVertexAttrib3sv)("glVertexAttrib3sv", lib);
        bindFunc(glVertexAttrib4Nbv)("glVertexAttrib4Nbv", lib);
        bindFunc(glVertexAttrib4Niv)("glVertexAttrib4Niv", lib);
        bindFunc(glVertexAttrib4Nsv)("glVertexAttrib4Nsv", lib);
        bindFunc(glVertexAttrib4Nub)("glVertexAttrib4Nub", lib);
        bindFunc(glVertexAttrib4Nubv)("glVertexAttrib4Nubv", lib);
        bindFunc(glVertexAttrib4Nuiv)("glVertexAttrib4Nuiv", lib);
        bindFunc(glVertexAttrib4Nusv)("glVertexAttrib4Nusv", lib);
        bindFunc(glVertexAttrib4bv)("glVertexAttrib4bv", lib);
        bindFunc(glVertexAttrib4d)("glVertexAttrib4d", lib);
        bindFunc(glVertexAttrib4dv)("glVertexAttrib4dv", lib);
        bindFunc(glVertexAttrib4f)("glVertexAttrib4f", lib);
        bindFunc(glVertexAttrib4fv)("glVertexAttrib4fv", lib);
        bindFunc(glVertexAttrib4iv)("glVertexAttrib4iv", lib);
        bindFunc(glVertexAttrib4s)("glVertexAttrib4s", lib);
        bindFunc(glVertexAttrib4sv)("glVertexAttrib4sv", lib);
        bindFunc(glVertexAttrib4ubv)("glVertexAttrib4ubv", lib);
        bindFunc(glVertexAttrib4uiv)("glVertexAttrib4uiv", lib);
        bindFunc(glVertexAttrib4usv)("glVertexAttrib4usv", lib);
        bindFunc(glVertexAttribPointer)("glVertexAttribPointer", lib);

    }
}

enum : GLenum
{
    GL_BLEND_EQUATION_RGB              = 0x8009,
    GL_VERTEX_ATTRIB_ARRAY_ENABLED     = 0x8622,
    GL_VERTEX_ATTRIB_ARRAY_SIZE        = 0x8623,
    GL_VERTEX_ATTRIB_ARRAY_STRIDE      = 0x8624,
    GL_VERTEX_ATTRIB_ARRAY_TYPE        = 0x8625,
    GL_CURRENT_VERTEX_ATTRIB           = 0x8626,
    GL_VERTEX_PROGRAM_POINT_SIZE       = 0x8642,
    GL_VERTEX_PROGRAM_TWO_SIDE         = 0x8643,
    GL_VERTEX_ATTRIB_ARRAY_POINTER     = 0x8645,
    GL_STENCIL_BACK_FUNC               = 0x8800,
    GL_STENCIL_BACK_FAIL               = 0x8801,
    GL_STENCIL_BACK_PASS_DEPTH_FAIL    = 0x8802,
    GL_STENCIL_BACK_PASS_DEPTH_PASS    = 0x8803,
    GL_MAX_DRAW_BUFFERS                = 0x8824,
    GL_DRAW_BUFFER0                    = 0x8825,
    GL_DRAW_BUFFER1                    = 0x8826,
    GL_DRAW_BUFFER2                    = 0x8827,
    GL_DRAW_BUFFER3                    = 0x8828,
    GL_DRAW_BUFFER4                    = 0x8829,
    GL_DRAW_BUFFER5                    = 0x882A,
    GL_DRAW_BUFFER6                    = 0x882B,
    GL_DRAW_BUFFER7                    = 0x882C,
    GL_DRAW_BUFFER8                    = 0x882D,
    GL_DRAW_BUFFER9                    = 0x882E,
    GL_DRAW_BUFFER10                   = 0x882F,
    GL_DRAW_BUFFER11                   = 0x8830,
    GL_DRAW_BUFFER12                   = 0x8831,
    GL_DRAW_BUFFER13                   = 0x8832,
    GL_DRAW_BUFFER14                   = 0x8833,
    GL_DRAW_BUFFER15                   = 0x8834,
    GL_BLEND_EQUATION_ALPHA            = 0x883D,
    GL_POINT_SPRITE                    = 0x8861,
    GL_COORD_REPLACE                   = 0x8862,
    GL_MAX_VERTEX_ATTRIBS              = 0x8869,
    GL_VERTEX_ATTRIB_ARRAY_NORMALIZED  = 0x886A,
    GL_MAX_TEXTURE_COORDS              = 0x8871,
    GL_MAX_TEXTURE_IMAGE_UNITS         = 0x8872,
    GL_FRAGMENT_SHADER                 = 0x8B30,
    GL_VERTEX_SHADER                   = 0x8B31,
    GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49,
    GL_MAX_VERTEX_UNIFORM_COMPONENTS   = 0x8B4A,
    GL_MAX_VARYING_FLOATS              = 0x8B4B,
    GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS  = 0x8B4C,
    GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS= 0x8B4D,
    GL_SHADER_TYPE                     = 0x8B4F,
    GL_FLOAT_VEC2                      = 0x8B50,
    GL_FLOAT_VEC3                      = 0x8B51,
    GL_FLOAT_VEC4                      = 0x8B52,
    GL_INT_VEC2                        = 0x8B53,
    GL_INT_VEC3                        = 0x8B54,
    GL_INT_VEC4                        = 0x8B55,
    GL_BOOL                            = 0x8B56,
    GL_BOOL_VEC2                       = 0x8B57,
    GL_BOOL_VEC3                       = 0x8B58,
    GL_BOOL_VEC4                       = 0x8B59,
    GL_FLOAT_MAT2                      = 0x8B5A,
    GL_FLOAT_MAT3                      = 0x8B5B,
    GL_FLOAT_MAT4                      = 0x8B5C,
    GL_SAMPLER_1D                      = 0x8B5D,
    GL_SAMPLER_2D                      = 0x8B5E,
    GL_SAMPLER_3D                      = 0x8B5F,
    GL_SAMPLER_CUBE                    = 0x8B60,
    GL_SAMPLER_1D_SHADOW               = 0x8B61,
    GL_SAMPLER_2D_SHADOW               = 0x8B62,
    GL_DELETE_STATUS                   = 0x8B80,
    GL_COMPILE_STATUS                  = 0x8B81,
    GL_LINK_STATUS                     = 0x8B82,
    GL_VALIDATE_STATUS                 = 0x8B83,
    GL_INFO_LOG_LENGTH                 = 0x8B84,
    GL_ATTACHED_SHADERS                = 0x8B85,
    GL_ACTIVE_UNIFORMS                 = 0x8B86,
    GL_ACTIVE_UNIFORM_MAX_LENGTH       = 0x8B87,
    GL_SHADER_SOURCE_LENGTH            = 0x8B88,
    GL_ACTIVE_ATTRIBUTES               = 0x8B89,
    GL_ACTIVE_ATTRIBUTE_MAX_LENGTH     = 0x8B8A,
    GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B,
    GL_SHADING_LANGUAGE_VERSION        = 0x8B8C,
    GL_CURRENT_PROGRAM                 = 0x8B8D,
    GL_POINT_SPRITE_COORD_ORIGIN       = 0x8CA0,
    GL_LOWER_LEFT                      = 0x8CA1,
    GL_UPPER_LEFT                      = 0x8CA2,
    GL_STENCIL_BACK_REF                = 0x8CA3,
    GL_STENCIL_BACK_VALUE_MASK         = 0x8CA4,
    GL_STENCIL_BACK_WRITEMASK          = 0x8CA5,
}

extern(System):

alias GLvoid function(GLenum, GLenum) pfglBlendEquationSeparate;
alias GLvoid function(GLsizei, GLenum*) pfglDrawBuffers;
alias GLvoid function(GLenum, GLenum, GLenum, GLenum) pfglStencilOpSeparate;
alias GLvoid function(GLenum, GLenum, GLint, GLuint) pfglStencilFuncSeparate;
alias GLvoid function(GLenum, GLuint) pfglStencilMaskSeparate;
alias GLvoid function(GLuint, GLuint) pfglAttachShader;
alias GLvoid function(GLuint, GLuint, GLchar*) pfglBindAttribLocation;
alias GLvoid function(GLuint) pfglCompileShader;
alias GLuint function() pfglCreateProgram;
alias GLuint function(GLenum) pfglCreateShader;
alias GLvoid function(GLuint) pfglDeleteProgram;
alias GLvoid function(GLuint) pfglDeleteShader;
alias GLvoid function(GLuint, GLuint) pfglDetachShader;
alias GLvoid function(GLuint) pfglDisableVertexAttribArray;
alias GLvoid function(GLuint) pfglEnableVertexAttribArray;
alias GLvoid function(GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*) pfglGetActiveAttrib;
alias GLvoid function(GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*) pfglGetActiveUniform;
alias GLvoid function(GLuint, GLsizei, GLsizei*, GLuint*) pfglGetAttachedShaders;
alias GLint function(GLuint, GLchar*) pfglGetAttribLocation;
alias GLvoid function(GLuint, GLenum, GLint*) pfglGetProgramiv;
alias GLvoid function(GLuint, GLsizei, GLsizei*, GLchar*) pfglGetProgramInfoLog;
alias GLvoid function(GLuint, GLenum, GLint *) pfglGetShaderiv;
alias GLvoid function(GLuint, GLsizei, GLsizei*, GLchar*) pfglGetShaderInfoLog;
alias GLvoid function(GLuint, GLsizei, GLsizei*, GLchar*) pfglGetShaderSource;
alias GLint function(GLuint, GLchar*) pfglGetUniformLocation;
alias GLvoid function(GLuint, GLint, GLfloat*) pfglGetUniformfv;
alias GLvoid function(GLuint, GLint, GLint*) pfglGetUniformiv;
alias GLvoid function(GLuint, GLenum, GLdouble*) pfglGetVertexAttribdv;
alias GLvoid function(GLuint, GLenum, GLfloat*) pfglGetVertexAttribfv;
alias GLvoid function(GLuint, GLenum, GLint*) pfglGetVertexAttribiv;
alias GLvoid function(GLuint, GLenum, GLvoid**) pfglGetVertexAttribPointerv;
alias GLboolean function(GLuint) pfglIsProgram;
alias GLboolean function(GLuint) pfglIsShader;
alias GLvoid function(GLuint) pfglLinkProgram;
alias GLvoid function(GLuint, GLsizei, const(GLchar)**, GLint*) pfglShaderSource;
alias GLvoid function(GLuint) pfglUseProgram;
alias GLvoid function(GLint, GLfloat) pfglUniform1f;
alias GLvoid function(GLint, GLfloat, GLfloat) pfglUniform2f;
alias GLvoid function(GLint, GLfloat, GLfloat, GLfloat) pfglUniform3f;
alias GLvoid function(GLint, GLfloat, GLfloat, GLfloat, GLfloat) pfglUniform4f;
alias GLvoid function(GLint, GLint) pfglUniform1i;
alias GLvoid function(GLint, GLint, GLint) pfglUniform2i;
alias GLvoid function(GLint, GLint, GLint, GLint) pfglUniform3i;
alias GLvoid function(GLint, GLint, GLint, GLint, GLint) pfglUniform4i;
alias GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform1fv;
alias GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform2fv;
alias GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform3fv;
alias GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform4fv;
alias GLvoid function(GLint, GLsizei, GLint*) pfglUniform1iv;
alias GLvoid function(GLint, GLsizei, GLint*) pfglUniform2iv;
alias GLvoid function(GLint, GLsizei, GLint*) pfglUniform3iv;
alias GLvoid function(GLint, GLsizei, GLint*) pfglUniform4iv;
alias GLvoid function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix2fv;
alias GLvoid function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix3fv;
alias GLvoid function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix4fv;
alias GLvoid function(GLuint) pfglValidateProgram;
alias GLvoid function(GLuint, GLdouble) pfglVertexAttrib1d;
alias GLvoid function(GLuint, GLdouble*) pfglVertexAttrib1dv;
alias GLvoid function(GLuint, GLfloat) pfglVertexAttrib1f;
alias GLvoid function(GLuint, GLfloat*) pfglVertexAttrib1fv;
alias GLvoid function(GLuint, GLshort) pfglVertexAttrib1s;
alias GLvoid function(GLuint, GLshort*) pfglVertexAttrib1sv;
alias GLvoid function(GLuint, GLdouble, GLdouble) pfglVertexAttrib2d;
alias GLvoid function(GLuint, GLdouble*) pfglVertexAttrib2dv;
alias GLvoid function(GLuint, GLfloat, GLfloat) pfglVertexAttrib2f;
alias GLvoid function(GLuint, GLfloat*) pfglVertexAttrib2fv;
alias GLvoid function(GLuint, GLshort, GLshort) pfglVertexAttrib2s;
alias GLvoid function(GLuint, GLshort*) pfglVertexAttrib2sv;
alias GLvoid function(GLuint, GLdouble, GLdouble, GLdouble) pfglVertexAttrib3d;
alias GLvoid function(GLuint, GLdouble*) pfglVertexAttrib3dv;
alias GLvoid function(GLuint, GLfloat, GLfloat, GLfloat) pfglVertexAttrib3f;
alias GLvoid function(GLuint, GLfloat*) pfglVertexAttrib3fv;
alias GLvoid function(GLuint, GLshort, GLshort, GLshort) pfglVertexAttrib3s;
alias GLvoid function(GLuint, GLshort*) pfglVertexAttrib3sv;
alias GLvoid function(GLuint, GLbyte*) pfglVertexAttrib4Nbv;
alias GLvoid function(GLuint, GLint*) pfglVertexAttrib4Niv;
alias GLvoid function(GLuint, GLshort*) pfglVertexAttrib4Nsv;
alias GLvoid function(GLuint, GLubyte, GLubyte, GLubyte, GLubyte) pfglVertexAttrib4Nub;
alias GLvoid function(GLuint, GLubyte*) pfglVertexAttrib4Nubv;
alias GLvoid function(GLuint, GLuint*) pfglVertexAttrib4Nuiv;
alias GLvoid function(GLuint, GLushort*) pfglVertexAttrib4Nusv;
alias GLvoid function(GLuint, GLbyte*) pfglVertexAttrib4bv;
alias GLvoid function(GLuint, GLdouble, GLdouble, GLdouble, GLdouble) pfglVertexAttrib4d;
alias GLvoid function(GLuint, GLdouble*) pfglVertexAttrib4dv;
alias GLvoid function(GLuint, GLfloat, GLfloat, GLfloat, GLfloat) pfglVertexAttrib4f;
alias GLvoid function(GLuint, GLfloat*) pfglVertexAttrib4fv;
alias GLvoid function(GLuint, GLint*) pfglVertexAttrib4iv;
alias GLvoid function(GLuint, GLshort, GLshort, GLshort, GLshort) pfglVertexAttrib4s;
alias GLvoid function(GLuint, GLshort*) pfglVertexAttrib4sv;
alias GLvoid function(GLuint, GLubyte*) pfglVertexAttrib4ubv;
alias GLvoid function(GLuint, GLuint*) pfglVertexAttrib4uiv;
alias GLvoid function(GLuint, GLushort*) pfglVertexAttrib4usv;
alias GLvoid function(GLuint, GLint, GLenum, GLboolean, GLsizei, GLvoid*) pfglVertexAttribPointer;

pfglBlendEquationSeparate       glBlendEquationSeparate;
pfglDrawBuffers                 glDrawBuffers;
pfglStencilOpSeparate           glStencilOpSeparate;
pfglStencilFuncSeparate         glStencilFuncSeparate;
pfglStencilMaskSeparate         glStencilMaskSeparate;
pfglAttachShader                glAttachShader;
pfglBindAttribLocation          glBindAttribLocation;
pfglCompileShader               glCompileShader;
pfglCreateProgram               glCreateProgram;
pfglCreateShader                glCreateShader;
pfglDeleteProgram               glDeleteProgram;
pfglDeleteShader                glDeleteShader;
pfglDetachShader                glDetachShader;
pfglDisableVertexAttribArray    glDisableVertexAttribArray;
pfglEnableVertexAttribArray     glEnableVertexAttribArray;
pfglGetActiveAttrib             glGetActiveAttrib;
pfglGetActiveUniform            glGetActiveUniform;
pfglGetAttachedShaders          glGetAttachedShaders;
pfglGetAttribLocation           glGetAttribLocation;
pfglGetProgramiv                glGetProgramiv;
pfglGetProgramInfoLog           glGetProgramInfoLog;
pfglGetShaderiv                 glGetShaderiv;
pfglGetShaderInfoLog            glGetShaderInfoLog;
pfglGetShaderSource             glGetShaderSource;
pfglGetUniformLocation          glGetUniformLocation;
pfglGetUniformfv                glGetUniformfv;
pfglGetUniformiv                glGetUniformiv;
pfglGetVertexAttribdv           glGetVertexAttribdv;
pfglGetVertexAttribfv           glGetVertexAttribfv;
pfglGetVertexAttribiv           glGetVertexAttribiv;
pfglGetVertexAttribPointerv     glGetVertexAttribPointerv;
pfglIsProgram                   glIsProgram;
pfglIsShader                    glIsShader;
pfglLinkProgram                 glLinkProgram;
pfglShaderSource                glShaderSource;
pfglUseProgram                  glUseProgram;
pfglUniform1f                   glUniform1f;
pfglUniform2f                   glUniform2f;
pfglUniform3f                   glUniform3f;
pfglUniform4f                   glUniform4f;
pfglUniform1i                   glUniform1i;
pfglUniform2i                   glUniform2i;
pfglUniform3i                   glUniform3i;
pfglUniform4i                   glUniform4i;
pfglUniform1fv                  glUniform1fv;
pfglUniform2fv                  glUniform2fv;
pfglUniform3fv                  glUniform3fv;
pfglUniform4fv                  glUniform4fv;
pfglUniform1iv                  glUniform1iv;
pfglUniform2iv                  glUniform2iv;
pfglUniform3iv                  glUniform3iv;
pfglUniform4iv                  glUniform4iv;
pfglUniformMatrix2fv            glUniformMatrix2fv;
pfglUniformMatrix3fv            glUniformMatrix3fv;
pfglUniformMatrix4fv            glUniformMatrix4fv;
pfglValidateProgram             glValidateProgram;
pfglVertexAttrib1d              glVertexAttrib1d;
pfglVertexAttrib1dv             glVertexAttrib1dv;
pfglVertexAttrib1f              glVertexAttrib1f;
pfglVertexAttrib1fv             glVertexAttrib1fv;
pfglVertexAttrib1s              glVertexAttrib1s;
pfglVertexAttrib1sv             glVertexAttrib1sv;
pfglVertexAttrib2d              glVertexAttrib2d;
pfglVertexAttrib2dv             glVertexAttrib2dv;
pfglVertexAttrib2f              glVertexAttrib2f;
pfglVertexAttrib2fv             glVertexAttrib2fv;
pfglVertexAttrib2s              glVertexAttrib2s;
pfglVertexAttrib2sv             glVertexAttrib2sv;
pfglVertexAttrib3d              glVertexAttrib3d;
pfglVertexAttrib3dv             glVertexAttrib3dv;
pfglVertexAttrib3f              glVertexAttrib3f;
pfglVertexAttrib3fv             glVertexAttrib3fv;
pfglVertexAttrib3s              glVertexAttrib3s;
pfglVertexAttrib3sv             glVertexAttrib3sv;
pfglVertexAttrib4Nbv            glVertexAttrib4Nbv;
pfglVertexAttrib4Niv            glVertexAttrib4Niv;
pfglVertexAttrib4Nsv            glVertexAttrib4Nsv;
pfglVertexAttrib4Nub            glVertexAttrib4Nub;
pfglVertexAttrib4Nubv           glVertexAttrib4Nubv;
pfglVertexAttrib4Nuiv           glVertexAttrib4Nuiv;
pfglVertexAttrib4Nusv           glVertexAttrib4Nusv;
pfglVertexAttrib4bv             glVertexAttrib4bv;
pfglVertexAttrib4d              glVertexAttrib4d;
pfglVertexAttrib4dv             glVertexAttrib4dv;
pfglVertexAttrib4f              glVertexAttrib4f;
pfglVertexAttrib4fv             glVertexAttrib4fv;
pfglVertexAttrib4iv             glVertexAttrib4iv;
pfglVertexAttrib4s              glVertexAttrib4s;
pfglVertexAttrib4sv             glVertexAttrib4sv;
pfglVertexAttrib4ubv            glVertexAttrib4ubv;
pfglVertexAttrib4uiv            glVertexAttrib4uiv;
pfglVertexAttrib4usv            glVertexAttrib4usv;
pfglVertexAttribPointer         glVertexAttribPointer;
