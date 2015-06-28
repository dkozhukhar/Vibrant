module gl.shaders;

import derelict.opengl.gl;
import derelict.opengl.gl20;
import misc.textfile;

import gl.texture, gl.textureunit;
import gl.state;
import gl.error;

import math.vec2, math.vec3, math.vec4, math.mat3, math.mat4;
import std.string;


// shader class
private final class Subshader
{
    private
    {
        GLuint handle;
        GLState m_state;
    }

    public
    {
        this(GLenum shaderType)
        {
            m_state = GL;
            handle = glCreateShader(shaderType);
            GL.check();
        }

        ~this()
        {
            glDeleteShader(handle);
            GL.check();
        }

        final GLuint getHandle()
        {
            return handle;
        }

        final bool compile()
        {
            glCompileShader(handle);
            if (glGetError() == 0) {
                GLint compiled;
                glGetShaderiv(handle, GL_COMPILE_STATUS, &compiled);
                return (compiled == GL_TRUE);
            } else
            {
                return false;
            }
        }

        final string getInfoLog()
        {
            GLint logLength;
            glGetShaderiv(handle, GL_INFO_LOG_LENGTH, &logLength);
            char[] log = new char[logLength];
            GLint dummy;
            glGetShaderInfoLog(handle,logLength,&dummy, log.ptr);
            GL.check();

            return log.idup;
        }


        final void load(string[] l)
        {
            int count = cast(int)(l.length);

            GLint[] lengths = new GLint[count];
            const(GLchar) * [] addresses;
            addresses.length = count;

            char[] EMPTY_LINE = "".dup;

            for (int i = 0; (i < count); i++ )
            {
                string s = l[i] ~ "\n";

                if (s is null)
                {
                    lengths[i] = cast(int)(EMPTY_LINE.length);
                    addresses[i] = EMPTY_LINE.ptr;
                } else
                {
                    lengths[i] = cast(int)(s.length);
                    addresses[i] = s.ptr;
                }
            }

            glShaderSource(handle,count,addresses.ptr,cast(GLint*) lengths);
            GL.check();
        }

        final void loadFromFile(string filename)
        {
            string[] l = readTextFile(filename);
            load(l);
        }
    }
}

final class Shader
{

    private
    {
        GLState m_state;
        GLuint handle = 0;
        Subshader fragmentShader, vertexShader;

        static __gshared Shader binded = null;
        static __gshared Shader used = null;

        final void attach(Subshader s)
        {
            glAttachShader(handle,s.getHandle());
            GL.check();
        }

        final bool link()
        {
            glLinkProgram(handle);
            GLint linked;
            glGetProgramiv(handle,GL_LINK_STATUS,&linked);
            return ( linked == GL_TRUE);
        }

        final void createProgram()
        {
            handle = glCreateProgram();
            //assert( glIsProgram(handle) );
            GL.check();
        }

        int getUniformLocation(string name)
        {
            return glGetUniformLocation(handle, cast(char*) name);
        }

        this(int handle) // to create the default shader
        {
            this.handle = handle;
            m_state = GL;            
        }

        final string getInfoLog()
        {
            GLint logLength;
            glGetProgramiv(handle, GL_INFO_LOG_LENGTH, &logLength);
            char[] log = new char[logLength];
            GLint dummy;
            glGetProgramInfoLog(handle, logLength, &dummy, log.ptr);
            GL.check();
            return log.idup;
        }

        static __gshared Shader fixedPipelineShader;

    }

    public
    {
        this(string vertexFile, string fragmentFile)
        {
            m_state = GL;
            createProgram();
            reload(vertexFile, fragmentFile);
        }

        ~this()
        {
            if (binded is this)
            {
                binded = null;
            }

            if (used is this)
            {
                used = null;
            }

//            delete vertexShader; // force deletion
//            delete fragmentShader; // why not ?
            glDeleteProgram(handle);

            GL.check();
        }

        // make sure you don't use it while you reload it
        void reload(string vertexFile, string fragmentFile)
        {
            if (used is this)
            {
                //useDefault();
                assert(false);
            }

            vertexShader = new Subshader(GL_VERTEX_SHADER);
            vertexShader.loadFromFile(vertexFile);

            if (!vertexShader.compile())
            {
                throw new CompileError(vertexFile, vertexShader.getInfoLog());
            }
            else
            {
                string log = vertexShader.getInfoLog();
            }

            fragmentShader = new Subshader(GL_FRAGMENT_SHADER);
            fragmentShader.loadFromFile(fragmentFile);

            if (!fragmentShader.compile())
            {
                throw new CompileError(fragmentFile, fragmentShader.getInfoLog());
            }
            else
            {
                string log = fragmentShader.getInfoLog();
            }

            attach(vertexShader);
            attach(fragmentShader);
            if (!link())
            {
                string log = getInfoLog();
                throw new LinkError(vertexFile ~ " + " ~ fragmentFile);
            }
            else
            {
                string log = getInfoLog();
            }
        }

        final void bind()
        {
            if (binded !is this)
            {
                binded = this;
                //TextureUnits.instance.unbindAll();

                glUseProgram(handle);
                GL.check();
            }
        }

        final void use()
        {
            bind();
            used = this;
        }

        final void unuse()
        {
            assert(used is this);
            assert(binded is this);
            if (binded is this)
            {
                binded = null;
                glUseProgram(0);
                GL.check();
            }
        }

        bool checkValidUniform(int loc, string name)
        {
            if (loc == -1)
            {
                return false;
            } else
            {
                return true;
            }
        }

        final void set1f (string name, float x)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform1f(loc, x);
            }
            GL.check();
        }

        final void set2f (string name, float x, float y)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform2f(loc, x, y);
            }
            GL.check();
        }

        final void set2f (string name, vec2f v)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform2fv(loc, 1, cast(GLfloat*) v.v);
            }
            GL.check();
        }

        final void set3f (string name, float x, float y, float z)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform3f(loc, x, y, z);
            }
            GL.check();
        }

        final void set3f (string name, vec3f v)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform3fv(loc, 1, cast(GLfloat*) v.v);
            }
            GL.check();
        }


        final void set4f (string name, float x, float y, float z, float w)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform4f(loc, x, y, z, w);
            }
            GL.check();
        }

        final void set4f (string name, vec4f v)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform4fv(loc, 1, cast(GLfloat*) v.v);
            }
            GL.check();
        }

        final void set1b (string name, bool b)
        {
            set1i(name, b ? 1 : 0);
        }

        final void set1i (string name, int x)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform1i(loc, x);
            }
            GL.check();
        }

        final void set2i (string name, int x, int y)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform2i(loc, x, y);
            }
            GL.check();
        }

        final void set2i (string name, vec2i v)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform2iv(loc, 1, v.ptr);
            }
            GL.check();
        }

        final void set3i (string name, int x, int y, int z)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform3i(loc, x, y, z);
            }
            GL.check();
        }

        final void set3i (string name, vec3i v)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform3iv(loc, 1, v.ptr);
            }
            GL.check();
        }

        final void set4i (string name, int x, int y, int z, int w)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform4i(loc, x, y, z, w);
            }
            GL.check();
        }

        final void set4i (string name, vec4i v)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniform4iv(loc, 1, v.ptr);
            }
            GL.check();
        }

        final void setMat4f (string name, mat4f m)
        {
            bind();
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                glUniformMatrix4fv(loc, 1, GL_TRUE, cast(GLfloat*) m.c);
            }
            GL.check();
        }

        final void setSampler(string name, Texture tex)//, int unit)
        {
            bind();
            GLint location = getUniformLocation(name);
            int loc = getUniformLocation(name);
            if (checkValidUniform(loc, name) )
            {
                int textureUnit = tex.use();
                glUniform1i(location, textureUnit);
            }
            GL.check();
        }

    }

}
