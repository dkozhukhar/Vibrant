module gl.state;

import std.stdio, std.string, std.c.stdio;

import derelict.opengl.gl, derelict.opengl.glu, derelict.opengl.glext;

import derelict.opengl.extension.arb.color_buffer_float;
import derelict.opengl.extension.arb.vertex_buffer_object;
import derelict.opengl.extension.arb.half_float_pixel;
import derelict.opengl.extension.ext.blend_minmax;
import derelict.util.exception;

import math.box2;
import math.vec2;
import math.vec3;
import math.vec4;
import math.mat3;
import math.mat4;
import std.string;

import gl.error;
import gl.textureunit;

// Global GL state
// because globals rules

GLState GL;

enum OpenGLVersion
{
    Version11,
    Version12,
    Version13,
    Version14,
    Version15,
    Version20,
    Version21
}


// wrapper to opengl state variables (not all)


final class GLState
{
    public
    {
        static const FALSE = GL_FALSE;
        static const TRUE = GL_TRUE;

        static const FASTEST = GL_FASTEST;
        static const NICEST = GL_NICEST;
        static const DONT_CARE = GL_DONT_CARE;

        static const GREATER = GL_GREATER;
        static const LESS = GL_LESS;
        static const LEQUAL = GL_LEQUAL;
        static const ALWAYS = GL_ALWAYS;
        static const NEVER = GL_NEVER;

        static const LINE_SMOOTH = GL_LINE_SMOOTH;
        static const POLYGON_SMOOTH = GL_POLYGON_SMOOTH;
        static const POINT_SMOOTH = GL_POINT_SMOOTH;
        static const BLEND = GL_BLEND;
        static const FOG = GL_FOG;
        //static const CULL = GL_CULL;
        static const LIGHTING = GL_LIGHTING;
        static const NORMALIZE = GL_NORMALIZE;

        static const CULL_FACE = GL_CULL_FACE;
        static const DEPTH_TEST = GL_DEPTH_TEST;
        static const STENCIL_TEST = GL_STENCIL_TEST;
        static const ALPHA_TEST = GL_ALPHA_TEST;
        static const POINT_SPRITE = GL_POINT_SPRITE;

        static const AUTO_NORMAL = GL_AUTO_NORMAL;
        static const DITHER = GL_DITHER;


        static const POINTS = GL_POINTS;

        static const LINES = GL_LINES;
        static const LINE_STRIP = GL_LINE_STRIP;

        static const TRIANGLES = GL_TRIANGLES;
        static const TRIANGLE_STRIP = GL_TRIANGLE_STRIP;
        static const TRIANGLE_FAN = GL_TRIANGLE_FAN;

        static const QUADS = GL_QUADS;
        static const QUAD_STRIP = GL_QUAD_STRIP;

        static const PERSPECTIVE_CORRECTION_HINT = GL_PERSPECTIVE_CORRECTION_HINT;
        static const GENERATE_MIPMAP_HINT = GL_GENERATE_MIPMAP_HINT;
        static const POINT_SMOOTH_HINT = GL_POINT_SMOOTH_HINT;
        static const LINE_SMOOTH_HINT = GL_LINE_SMOOTH_HINT;
        static const POLYGON_SMOOTH_HINT = GL_POLYGON_SMOOTH_HINT;
    
        static const TEXTURE_1D = GL_TEXTURE_1D;
        static const TEXTURE_2D = GL_TEXTURE_2D;
        static const TEXTURE_3D = GL_TEXTURE_3D;

        static const BACK = GL_BACK;
        static const FRONT = GL_FRONT;
        static const FRONT_AND_BACK = GL_FRONT_AND_BACK;
        static const COORD_REPLACE = GL_COORD_REPLACE;

        static const MODELVIEW_MATRIX = GL_MODELVIEW_MATRIX;
        static const PROJECTION_MATRIX = GL_PROJECTION_MATRIX;

        static const ARRAY_BUFFER = GL_ARRAY_BUFFER_ARB;
        static const ELEMENT_ARRAY_BUFFER = GL_ELEMENT_ARRAY_BUFFER_ARB;
        static const PIXEL_PACK_BUFFER = GL_PIXEL_PACK_BUFFER_ARB;
        static const PIXEL_UNPACK_BUFFER = GL_PIXEL_UNPACK_BUFFER_ARB;


        static const BYTE           = GL_BYTE;
        static const UNSIGNED_BYTE  = GL_UNSIGNED_BYTE;
        static const SHORT          = GL_SHORT;
        static const UNSIGNED_SHORT = GL_UNSIGNED_SHORT;
        static const INT            = GL_INT;
        static const UNSIGNED_INT   = GL_UNSIGNED_INT;
        static const HALF           = GL_HALF_FLOAT_ARB;
        static const FLOAT          = GL_FLOAT;
        static const DOUBLE         = GL_DOUBLE;



        enum CullMode
        {
            POINT,
            LINE,
            FILL,
            NONE // CULL
        };

        enum BlendMode
        {
            ADD,
            SUB,
            SUBR,
            MIN,
            MAX
        };

        enum BlendFactor
        {
            ZERO,
            ONE,
            DST_COLOR,
            SRC_COLOR,
            ONE_MINUS_DST_COLOR,
            ONE_MINUS_SRC_COLOR,
            SRC_ALPHA,
            ONE_MINUS_SRC_ALPHA,
            DST_ALPHA,
            ONE_MINUS_DST_ALPHA,
            SRC_ALPHA_SATURATE
        }
/*
        enum Buffer
        {
            COLOR = 1,
            DEPTH = 2,
            STENCIL = 4,
            ALL = COLOR | DEPTH | STENCIL
        }
*/


    }

    private {

        static const GLint[CullMode.max + 1] cullMode_toGL = [
            GL_POINT,
            GL_LINE,
            GL_FILL,
            0 // unused
        ];

        static const GLint[BlendMode.max + 1] blendMode_toGL =
        [
            GL_FUNC_ADD,
            GL_FUNC_SUBTRACT,
            GL_FUNC_REVERSE_SUBTRACT,
            GL_MIN,
            GL_MAX,
        ];

        static const GLint[BlendFactor.max + 1] blendFactor_toGL =
        [
            GL_ZERO,
            GL_ONE,
            GL_DST_COLOR,
            GL_SRC_COLOR,
            GL_ONE_MINUS_DST_COLOR,
            GL_ONE_MINUS_SRC_COLOR,
            GL_SRC_ALPHA,
            GL_ONE_MINUS_SRC_ALPHA,
            GL_DST_ALPHA,
            GL_ONE_MINUS_DST_ALPHA,
            GL_SRC_ALPHA_SATURATE
        ];

        GLVersion version_toDerelict(OpenGLVersion ver)
        {
            switch(ver)
            {
                case OpenGLVersion.Version11: return GLVersion.Version11;
                case OpenGLVersion.Version12: return GLVersion.Version12;
                case OpenGLVersion.Version13: return GLVersion.Version13;
                case OpenGLVersion.Version14: return GLVersion.Version14;
                case OpenGLVersion.Version15: return GLVersion.Version15;
                case OpenGLVersion.Version20: return GLVersion.Version20;
                case OpenGLVersion.Version21: return GLVersion.Version21;
                default: assert(false, "oups");
            }
        }

        private bool glBool(bool b)
        {
            return b ? GL_TRUE : GL_FALSE;
        }

        TextureUnits m_textureUnits;

    }

    public
    {
        this(OpenGLVersion ver)
        {
            GLVersion requiredGLVersion = version_toDerelict(ver);

            try
            {
                DerelictGL.load();
                DerelictGLU.load();
            }
            catch(DerelictException e)
            {
                throw new OpenGLError("Cannot load OpenGL");
            }

            try
            {
                DerelictGL.loadVersions(requiredGLVersion);
            }
            catch(DerelictException e)
            {
                throw new OpenGLError("Cannot load the right version of OpenGL. Upgrade!");
            }


            int extLoaded = DerelictGL.loadExtensions();

            m_textureUnits = new TextureUnits();
        }

        ~this()
        {
            m_textureUnits.unbindAll();

            DerelictGL.load();
            GL.check();
            DerelictGLU.unload();
        }

        TextureUnits textureUnits()
        {
            return m_textureUnits;
        }

        void enable(GLint feature0)
        {   
            glEnable(feature0);
            GL.check;
        }

        void enable(GLint feature0, GLint feature1)
        {
            glEnable(feature0);
            glEnable(feature1);
            GL.check;
        }

        void disable(GLint feature0)
        {
            glDisable(feature0);
            GL.check;
        }

        void disable(GLint feature0, GLint feature1)
        {
            glDisable(feature0);
            glDisable(feature1);
            GL.check;
        }

        void disable(GLint feature0, GLint feature1, GLint feature2)
        {
            glDisable(feature0);
            glDisable(feature1);
            glDisable(feature2);
            GL.check;
        }

        void disable(GLint feature0, GLint feature1, GLint feature2, GLint feature3)
        {
            glDisable(feature0);
            glDisable(feature1);
            glDisable(feature2);
            glDisable(feature3);
            GL.check;
        }

        void disable(GLint feature0, GLint feature1, GLint feature2, GLint feature3, GLint feature4)
        {
            glDisable(feature0);
            glDisable(feature1);
            glDisable(feature2);
            glDisable(feature3);
            glDisable(feature4);
            GL.check;
        }

        void disable(GLint feature0, GLint feature1, GLint feature2, GLint feature3, GLint feature4, GLint feature5)
        {
            glDisable(feature0);
            glDisable(feature1);
            glDisable(feature2);
            glDisable(feature3);
            glDisable(feature4);
            glDisable(feature5);
            GL.check;
        }

        GLint matrixMode(GLint mm)
        {
            glMatrixMode(mm);
            return mm;
        }

        void loadIdentity()
        {
            glLoadIdentity();
        }

        void loadMatrix(mat4f m)
        {
            if (glLoadTransposeMatrixf is null)
            {
                mat4f tr = m.transposed();
                glLoadMatrixf(tr.ptr);
            } else
            {
                glLoadTransposeMatrixf(m.ptr);
            }
        }

        void loadMatrix(mat4d m)
        {
            if (glLoadTransposeMatrixd is null)
            {
                mat4d tr = m.transposed();
                glLoadMatrixd(tr.ptr);
            } else
            {
                glLoadTransposeMatrixd(m.ptr);
            }
        }

        void multMatrix(mat4f m)
        {
            if (glMultTransposeMatrixf is null)
            {
                mat4f tr = m.transposed();
                glMultMatrixf(tr.ptr);
            } else
            {
                glMultTransposeMatrixf(m.ptr);
            }
        }

        void multMatrix(mat4d m)
        {
            if (glMultTransposeMatrixd is null)
            {
                mat4d tr = m.transposed();
                glMultMatrixd(tr.ptr);
            } else
            {
                glMultTransposeMatrixd(m.ptr);
            }
        }

        void lookAt(vec3f eye, vec3f target, vec3f up)
        {
            gluLookAt(eye.x, eye.y, eye.z, target.x, target.y, target.z, up.x, up.y, up.z);
        }

        // get projection matrix in double format
        mat4d projectionMatrix()
        {
            mat4d m;
            glGetDoublev(GL_PROJECTION_MATRIX, m.ptr);
            m.transpose();
            return m;
        }

        // get modelview matrix in double format
        mat4d modelviewMatrix()
        {
            mat4d m;
            glGetDoublev(GL_MODELVIEW_MATRIX, m.ptr);
            m.transpose();
            return m;
        }

        // set projection matrix
        mat4f projectionMatrix(mat4f m)
        {
            glMatrixMode(GL_PROJECTION);
            loadMatrix(m);
            return m;
        }

        // set modelview matrix
        mat4f modelviewMatrix(mat4f m)
        {
            glMatrixMode(GL_MODELVIEW);
            loadMatrix(m);
            return m;
        }

        // set projection matrix
        mat4d projectionMatrix(mat4d m)
        {
            glMatrixMode(GL_PROJECTION);
            loadMatrix(m);
            return m;
        }

        // set modelview matrix
        mat4d modelviewMatrix(mat4d m)
        {
            glMatrixMode(GL_MODELVIEW);
            loadMatrix(m);
            return m;
        }



        string errorString(GLint r)
        {
            if (gluErrorString !is null)
            {
                char* errStringZ = cast(char*) gluErrorString(r);
                return fromStringz(errStringZ).idup;
            } else
            {
                switch(r)
                {
                    case GL_NO_ERROR:
                        return "GL_NO_ERROR";

                    case GL_INVALID_ENUM:
                        /*An unacceptable value is specified for an enumerated argument.
                        The offending command is ignored
                        and has no other side effect than to set the error flag.*/
                        return "GL_INVALID_ENUM";

                    case GL_INVALID_VALUE:
                        /*A numeric argument is out of range.
                        The offending command is ignored
                        and has no other side effect than to set the error flag.*/
                        return "GL_INVALID_VALUE";

                    case GL_INVALID_OPERATION:
                        /* The specified operation is not allowed in the current state.
                        The offending command is ignored
                        and has no other side effect than to set the error flag.*/
                        return "GL_INVALID_OPERATION";

                    case GL_STACK_OVERFLOW:
                        /*This command would cause a stack overflow.
                        The offending command is ignored
                        and has no other side effect than to set the error flag.*/
                        return "GL_STACK_OVERFLOW";

                    case GL_STACK_UNDERFLOW:
                        /*This command would cause a stack underflow.
                        The offending command is ignored
                        and has no other side effect than to set the error flag.*/
                        return "GL_STACK_UNDERFLOW";

                    case GL_OUT_OF_MEMORY:
                        /*There is not enough memory left to execute the command.
                        The state of the GL is undefined,
                        except for the state of the error flags,
                        after this error is recorded.*/
                        return "GL_OUT_OF_MEMORY";

                    default:
                        return "Unknown OpenGL error";
                }
            }
        }


        // just a check, halt on error (dangerous !)
        void check()
        {
            version(Release)
            {
                // do nothing in release mode !
            }
            else
            {
                GLint r = glGetError();
                if (r != GL_NO_ERROR)
                {
                    assert(false);
                }
            }
        }

        // ditto but affects control flow
        void signal()
        {
            GLint r = glGetError();
            if (r != GL_NO_ERROR)
            {
                string err = "GLstate.signal: " ~ errorString(r);
                throw new OpenGLError(err);
            }
        }

        // just check, but log error content
        bool test()
        {
            GLint r = glGetError();
            if (r != GL_NO_ERROR)
            {
                string err = "GLstate.test: " ~ errorString(r);
                return false;
            }
            else
            {
                return true;
            }
        }

        void cullFace(int mode)
        {
            glCullFace(mode);
            GL.check();
        }

        float pointSize(float newSize)
        {
            if (glPointSize !is null) glPointSize(newSize);
            GL.check;
            return newSize;
        }

        float lineWidth(float newWidth)
        {
            glLineWidth(newWidth);
            GL.check;
            return newWidth;
        }

        vec4f clearColor(vec4f c)
        {
            glClearColor(c.x, c.y, c.z, c.w);
            return c;
        }

        vec3f color(vec3f c)
        {
            glColor3fv(c.ptr);
            return c;
        }

        vec4f color(vec4f c)
        {
            glColor4fv(c.ptr);
            return c;
        }

        uint color(uint c)
        {
            glColor4ubv(cast(ubyte*)&c);
            return c;
        }

        float clearDepth(float depth)
        {
            glClearDepth(depth);
            return depth;
        }

        void blend(BlendMode op, BlendFactor src, BlendFactor dst)
        {
            glBlendFunc( blendFactor_toGL[src], blendFactor_toGL[dst]);

            GLint m = blendMode_toGL[op];

            if(glBlendEquation is null)
            {
                glBlendEquationEXT(m);
            }
            else
            {
                glBlendEquation(m);
            }
            check;
        }

        void blend(BlendMode RGBOperation, BlendFactor srcRGBFactor, BlendFactor dstRGBFactor,
                             BlendMode AlphaOperation, BlendFactor srcAlphaFactor, BlendFactor dstAlphaFactor )
        {
            if ((glBlendEquationSeparate !is null) && (glBlendFuncSeparate !is null))
            {
                glBlendEquationSeparate(blendMode_toGL[RGBOperation], blendMode_toGL[AlphaOperation]);
                glBlendFuncSeparate( blendFactor_toGL[srcRGBFactor],
                                     blendFactor_toGL[dstRGBFactor],
                                     blendFactor_toGL[srcAlphaFactor],
                                     blendFactor_toGL[dstAlphaFactor] );
            } else
            {
                // try to approximate the desired blend
                glBlendFunc( blendFactor_toGL[srcRGBFactor], blendFactor_toGL[dstRGBFactor]);
                glBlendEquation( blendMode_toGL[RGBOperation] );
            }
        }

        deprecated void setViewport(int x, int y, int width, int height)
        {
            glViewport(x,y,width,height);
            GL.check();
        }

        void viewport(box2i view)
        {
            glViewport(view.xmin, view.ymin, view.width, view.height);
            GL.check();
        }

        void clear(bool color = true, bool depth = false, bool stencil = false)
        {
            GLint mask = 0;
            if (color) mask |= GL_COLOR_BUFFER_BIT;
            if (stencil) mask |= GL_STENCIL_BUFFER_BIT;
            if (depth) mask |= GL_DEPTH_BUFFER_BIT;
            glClear(mask);
            GL.check();
        }

        void clampColors(bool clampVertexColor, bool clampFragmentColor, bool clampReadColor)
        {
            if (glClampColorARB !is null)
            {
                glClampColorARB(GL_CLAMP_VERTEX_COLOR_ARB, glBool(clampVertexColor));
                glClampColorARB(GL_CLAMP_FRAGMENT_COLOR_ARB, glBool(clampFragmentColor));
                glClampColorARB(GL_CLAMP_READ_COLOR_ARB, glBool(clampReadColor));
            }
            GL.check();
        }


        void alphaFunc(int func, float f)
        {
            glAlphaFunc(func, f);
            GL.check();
        }

        void depthFunc(int func)
        {
            glDepthFunc(func);
            GL.check();
        }

        void depthMask(bool write)
        {
            glDepthMask( write ? GL_FALSE : GL_TRUE);
        }

        void stencilMask(int mask)
        {
            glStencilMask(mask);
        }

        void colorMask(bool r, bool g, bool b, bool a)
        {
            glColorMask(r ? GL_TRUE : GL_FALSE,
                        g ? GL_TRUE : GL_FALSE,
                        b ? GL_TRUE : GL_FALSE,
                        a ? GL_TRUE : GL_FALSE);
        }

        void texEnvi(int target, int pname, int param)
        {
            glTexEnvi(target, pname, param);
            GL.check;
        }


        void vertex(float x, float y) { glVertex2f(x, y); }
        void vertex(float x, float y, float z) { glVertex3f(x, y, z); }

        void vertex(vec2f[] vs)    {    foreach(v; vs) glVertex2fv(v.ptr);    }
        void vertex(vec3f[] vs)    {    foreach(v; vs) glVertex3fv(v.ptr);    }
        void vertex(vec4f[] vs)    {    foreach(v; vs) glVertex4fv(v.ptr);    }

        void vertex(vec2f v0)    {    glVertex2fv(v0.ptr);    }
        void vertex(vec3f v0)    {    glVertex3fv(v0.ptr);    }
        void vertex(vec4f v0)    {    glVertex4fv(v0.ptr);    }

        void normal(float x, float y, float z) {    glNormal3f(x, y, z); }
        void normal(vec3f nml)        {    glNormal3fv(nml.ptr);    }

        void texCoord(int n, float x, float y) { glMultiTexCoord2f(GL_TEXTURE0 + n, x, y); }
        void texCoord(int n, float x, float y, float z) {    glMultiTexCoord3f(GL_TEXTURE0 + n, x, y, z); }
        void texCoord(int n, vec2f tc)        {    glMultiTexCoord2fv(GL_TEXTURE0 + n, tc.ptr);    }
        void texCoord(int n, vec3f tc)        {    glMultiTexCoord3fv(GL_TEXTURE0 + n, tc.ptr);    }

        void translate(float x, float y, float z){    glTranslatef(x, y, z); }
        void translate(vec3f v)                    {    glTranslatef(v.x, v.y, v.z);    }

        void scale(float x, float y, float z)    {    glScalef(x, y, z); }
        void scale(vec3f v)                        {    glScalef(v.x, v.y, v.z);    }

        void rotate(float angle, float x, float y, float z)  {    glRotatef(angle, x, y, z); }
        void rotate(vec4f v)                                    {    glRotatef(v.x, v.y, v.z, v.z);    }


        void hint(int a, int b)
        {
            glHint(a, b);
            GL.check;
        }

        void getDoublev(int e, double* ptr)
        {
            glGetDoublev(e, ptr);
        }

        void begin(int a)
        {
            glBegin(a);
        }

        void end()
        {
            glEnd();
        }

        void pushAttrib(int attribs)
        {
            glPushAttrib(attribs);
        }

        void popAttrib()
        {
            glPopAttrib();
        }

        void pushMatrix()
        {
            glPushMatrix();
        }

        void popMatrix()
        {
            glPopMatrix();
        }

        void project(double objX, double objY, double objZ, double* model, double* proj, int* view, double* winX, double* winY, double* winZ)
        {
            gluProject(objX, objY, objZ, model, proj, view, winX, winY, winZ);
        }
    }
}


