module gl.renderbuffer;

import derelict.opengl.gl;
import derelict.opengl.glext;
import gl.state;
import math.common;

final class RenderBuffer
{

    private
    {
        GLuint m_handle;
        static __gshared RenderBuffer current = null;
        GLState m_state;
        int m_width, m_height;
        bool m_wrapInPOT;
    }

    public
    {
        enum Format
        {
            RGB,
            RGBA,
            DEPTH,
            DEPTH16,
            DEPTH24,
            DEPTH32
        }
    }

    private
    {
        static const GLint[Format.max + 1] convert_format =
        [
            GL_RGB,
            GL_RGBA,
            GL_DEPTH_COMPONENT,
            GL_DEPTH_COMPONENT16,
            GL_DEPTH_COMPONENT24,
            GL_DEPTH_COMPONENT32
        ];
    }

    public
    {
        this(Format fmt, int width, int height, bool wrapInPOT = true)
        {
            m_state = GL;
            glGenRenderbuffersEXT( 1, &m_handle );
            GL.check;
            bind();
            m_wrapInPOT = wrapInPOT;

            if (wrapInPOT)
            {
                glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, convert_format[fmt], nextPow2(width), nextPow2(height));
            }
            else
            {
                glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, convert_format[fmt], width, height);
            }


            GL.check;

            m_width = width;
            m_height = height;
        }

        ~this()
        {
            if (current is this)
            {
                current = null;
            }
            glDeleteRenderbuffersEXT( 1, &m_handle );
            GL.check;
        }

        void bind()
        {
            if (current is this) return;
            glBindRenderbufferEXT( GL_RENDERBUFFER_EXT, m_handle );
            current = this;
            GL.check;
        }

        GLuint handle()
        {
            return m_handle;
        }

        int width()
        {
            return m_width;
        }

        int height()
        {
            return m_height;
        }

        int storageWidth()
        {
            if (m_wrapInPOT)
            {
                return nextPow2(m_width);
            }
            else
            {
                return m_width;
            }
        }

        int storageHeight()
        {
            if (m_wrapInPOT)
            {
                return nextPow2(m_height);
            }
            else
            {
                return m_height;
            }
        }
    }
}
