module gl.texture1d;

import gl.texture;
import gl.state;

import derelict.opengl.gl;
//import derelict.opengl.gl20;
import math.common;

// not up to date
final class Texture1D : Texture
{
    public
    {
        this(IFormat iFormat, bool useCompression, bool sRGB)
        {
            super(GL_TEXTURE_1D, iFormat, false, useCompression, sRGB);

        }

        void setImage(int level, int width, Format format, Type type, void * data, bool mipmapped)
        {
            bind();

            {
                if ((this.width == width))
                {
                    if (data !is null) setSubImage(0, 0, width, format, type, data);
                }
                else
                {
                    // realloc

                    if (m_wrapInPOT)
                    {
                        // alloc more
                        glTexImage1D(m_target, level, m_iFormat, nextPow2(width), 0, Format_toGL[format], Type_toGL[type], null);
                        if (data !is null) setSubImage(0, 0, width, format, type, data);
                    }
                    else
                    {
                        glTexImage1D(m_target, level, m_iFormat, width, 0, Format_toGL[format], Type_toGL[type], data);
                    }

                    if (mipmapped) generateMipmaps();
                }
            }

            GL.check();
            m_width = width;
            m_height = 1;
            m_depth = 1;
        }

        void setSubImage(int level, int x, int width, Format format, Type type, void * data)
        {
            bind();
            glTexSubImage1D(m_target,
                         level,
                         x,
                         width,
                         Format_toGL[format],
                         Type_toGL[type],
                         data);
            GL.check();
        }

    }

}


