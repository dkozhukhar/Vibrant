module gl.texture2d;

import core.stdc.stdlib;

import gl.texture;
import gl.state;
import derelict.opengl.gl;
import gfm.math;

final class Texture2D : Texture
{
    public
    {
        this(int width, int height, IFormat iFormat, bool hasMipmaps, bool useCompression, bool sRGB)
        {
            super(GL_TEXTURE_2D, iFormat, hasMipmaps, useCompression, sRGB);



            m_width = width;
            m_height = height;
            m_depth = 1;

            int maxMips = getMaxMipmapLevel();

            bind();

            int w = storageWidth(0);
            int h = storageHeight(0);
            int d = storageDepth(0);


            // fills with black

            int[] data;

            int* pdata = cast(int*)malloc(w * h * 4 * int.sizeof);
            scope(exit) free(pdata);
            data = pdata[0..w*h*4];
            data[] = 0;

            Type type;
            Format fmt;
            getRelatedFormatAndType(iFormat, fmt, type);

            // create relevant mipmap levels
            for (int level = 0; level <= maxMips; ++level)
            {
                glTexImage2D(GL_TEXTURE_2D, level, m_iFormat, storageWidth(level), storageHeight(level), 0,
                             Format_toGL[fmt], Type_toGL[type], data.ptr);
            }

            for (int level = 0; level <= maxMips; ++level)
            {
                glTexSubImage2D(GL_TEXTURE_2D, level, 0, 0, storageWidth(level), storageHeight(level), Format_toGL[fmt], Type_toGL[type], data.ptr);
            }

            if (hasMipmaps)    generateMipmaps();

            GL.check;
        }
    /*
        void setImage(int level, int width, int height, Format format, Type type, void * data, bool mipmapped)
        {
            bind();
            m_width = width;
            m_height = height;
            m_depth = 1;


            if (m_wrapInPOT)
            {
                // alloc more
                glTexImage2D(m_target, level, m_iFormat, nextPow2(width), nextPow2(height), 0, Format_toGL[format], Type_toGL[type], null);

                if (data !is null) setSubImage(0, 0, 0, width, height, format, type, data);
            }
            else
            {
                glTexImage2D(m_target, level, m_iFormat, width, height, 0, Format_toGL[format], Type_toGL[type], data);
            }

            if (mipmapped) generateMipmaps();

            GL.check();
        }
        */

        void setSubImage(int level, int x, int y, int width, int height, Format format, Type type, void * data)
        {
            bind();
            glTexSubImage2D(m_target,
                         level,
                         x,
                         y,
                         width,
                         height,
                         Format_toGL[format],
                         Type_toGL[type],
                         data);
            GL.check();
        }

        void copyTexImage(int level, int x, int y, int width, int height)
        {
            bind();
            glCopyTexImage2D(m_target, level, m_iFormat, x, y, width, height, 0);
            GL.check();
        }

        void copyTexSubImage(int level, int xoffset, int yoffset, int x, int y, int width, int height)
        {
            bind();
            glCopyTexSubImage2D(m_target, level, xoffset, yoffset, x, y, width, height);
            GL.check();
        }

        box2i rect()
        {
            return box2i(0, 0, m_width, m_height);
        }

        double ratio()
        {
            return m_width / cast(double)m_height;
        }
    }
}
