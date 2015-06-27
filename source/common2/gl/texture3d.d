module gl.texture3d;

import gl.texture;
import gl.state;
import derelict.opengl.gl;
import math.common;

// not up to date
final class Texture3D : Texture
{
    public
    {

        this(IFormat iFormat, bool useCompression, bool sRGB)
        {
            assert(!useCompression, "cannot compress 3D texture");
            super(GL_TEXTURE_3D, iFormat, false, useCompression, sRGB);

        }

        void setImage(int level, int width, int height, int depth, Format format, Type type, void * data, bool mipmapped)
        {

            bind();

            if ((this.width == width) && (this.height == height) && (this.depth == depth))
            {
                if (data !is null) setSubImage(0, 0, 0, 0, width, height, depth, format, type, data);
            }
            else
            {
                if (m_wrapInPOT)
                {
                    // alloc more
                    glTexImage3D(m_target, level, m_iFormat, nextPow2(width), nextPow2(height), nextPow2(depth), 0, Format_toGL[format], Type_toGL[type], data);
                    if (data !is null) setSubImage(0, 0, 0, 0, width, height, depth, format, type, data);
                }
                else
                {
                    glTexImage3D(m_target, level, m_iFormat, width, height, depth, 0, Format_toGL[format], Type_toGL[type], data);
                }


            }

            if (mipmapped) generateMipmaps();

            GL.check();
            m_width = width;
            m_height = height;
            m_depth = depth;
        }


        void setSubImage(int level, int x, int y, int z, int width, int height, int depth, Format format, Type type, void * data)
        {

            bind();
            glTexSubImage3D(m_target,
                         level,
                         x,
                         y,
                         z,
                         width,
                         height,
                         depth,
                         Format_toGL[format],
                         Type_toGL[type],
                         data);
            GL.check();
        }
    }
}
