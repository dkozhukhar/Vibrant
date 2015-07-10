module gl.texture;

import std.string;
import derelict.opengl.gl;
import derelict.opengl.gl20;
import derelict.opengl.extension.arb.texture_float;
import derelict.opengl.extension.ext.framebuffer_object;
import derelict.opengl.extension.arb.half_float_pixel;
import derelict.opengl.extension.arb.depth_texture;



import gl.buffer;
import gl.state;
import std.stdio;
import gl.textureunit;
import gl.state;

import gfm.math;


// support DXT1 and DXT5 but not all combinations

class Texture
{

    public
    {
        enum Wrap
        {
            CLAMP,
            CLAMP_TO_EDGE,
            REPEAT,
            CLAMP_TO_BORDER,
            MIRRORED_REPEAT
        }

        // internal fornat of texture
        enum IFormat
        {
            I8,
            I16F,
            I32F,
            A8,
            A16F,
            A32F,
            L8,
            L16F,
            L32F,
            LA8,
            LA16F,
            LA32F,
            RGB8,
            RGB16F,
            RGB32F,
            RGBA8,
            RGBA16F,
            RGBA32F,
            DEPTH,
            DEPTH16,
            DEPTH24,
            DEPTH32,
        }

        // format of data used to write into texture

        enum Format
        {
            LUMINANCE,
            INTENSITY,
            ALPHA,
            LUMINANCE_ALPHA,
            RGB,
            RGBA,
            BGR,
            BGRA,
            DEPTH
        }

        enum Type
        {
            UBYTE,
            BYTE,
            USHORT,
            SHORT,
            UINT,
            INT,
            FLOAT,
            HALF
        }

        enum Filter
        {
            NEAREST,
            LINEAR,
            NEAREST_MIPMAP_NEAREST,
            NEAREST_MIPMAP_LINEAR,
            LINEAR_MIPMAP_NEAREST,
            LINEAR_MIPMAP_LINEAR
        }
    }

    private
    {        

        GLint translateIformat_toGL(IFormat fmt, bool compressed, bool sRGB)
        {
            GLint format;

            if (sRGB)
                assert(false);
            
            if (compressed)
            {
                assert(false);                
            }
            else
            {
                switch(fmt)
                {
                    case IFormat.I8: format = GL_INTENSITY; break;
                    case IFormat.I16F: format = GL_INTENSITY16F_ARB; break;
                    case IFormat.I32F: format = GL_INTENSITY32F_ARB; break;
                    case IFormat.A8: format = GL_ALPHA; break;
                    case IFormat.A16F: format = GL_ALPHA16F_ARB; break;
                    case IFormat.A32F: format = GL_ALPHA32F_ARB; break;
                    case IFormat.L8: format = GL_LUMINANCE; break;
                    case IFormat.L16F: format = GL_LUMINANCE16F_ARB; break;
                    case IFormat.L32F: format = GL_LUMINANCE32F_ARB; break;
                    case IFormat.LA8: format = GL_LUMINANCE_ALPHA; break;
                    case IFormat.LA16F: format = GL_LUMINANCE_ALPHA16F_ARB; break;
                    case IFormat.LA32F: format = GL_LUMINANCE_ALPHA32F_ARB; break;
                    case IFormat.RGB8: format = GL_RGB; break;
                    case IFormat.RGB16F: format = GL_RGB16F_ARB; break;
                    case IFormat.RGB32F: format = GL_RGB32F_ARB; break;
                    case IFormat.RGBA8: format = GL_RGBA; break;
                    case IFormat.RGBA16F: format = GL_RGBA16F_ARB; break;
                    case IFormat.RGBA32F: format = GL_RGBA32F_ARB; break;
                    case IFormat.DEPTH: format = GL_DEPTH_COMPONENT; break;
                    case IFormat.DEPTH16: format = GL_DEPTH_COMPONENT16_ARB; break;
                    case IFormat.DEPTH24: format = GL_DEPTH_COMPONENT24_ARB; break;
                    case IFormat.DEPTH32: format = GL_DEPTH_COMPONENT32_ARB; break;
                    default: assert(false);
                }
            }          

            return format;
        }
    }

    package
    {

        static const GLint[Format.max + 1] Format_toGL =
        [
            GL_LUMINANCE,
            GL_INTENSITY,
            GL_ALPHA,
            GL_LUMINANCE_ALPHA,
            GL_RGB,
            GL_RGBA,
            GL_BGR,
            GL_BGRA,
            GL_DEPTH_COMPONENT
        ];

        static const GLint[Type.max + 1] Type_toGL =
        [
            GL_UNSIGNED_BYTE,
            GL_BYTE,
            GL_UNSIGNED_SHORT,
            GL_SHORT,
            GL_UNSIGNED_INT,
            GL_INT,
            GL_FLOAT,
            GL_HALF_FLOAT_ARB
        ];

        static const GLint[Wrap.max + 1] Wrap_toGL =
        [
            GL_CLAMP,
            GL_CLAMP_TO_EDGE,
            GL_REPEAT,
            GL_CLAMP_TO_BORDER,
            GL_MIRRORED_REPEAT
        ];

        static const GLint[Texture.Filter.max + 1] Filter_toGL =
        [
            GL_NEAREST,
            GL_LINEAR,
            GL_NEAREST_MIPMAP_NEAREST,
            GL_NEAREST_MIPMAP_LINEAR,
            GL_LINEAR_MIPMAP_NEAREST,
            GL_LINEAR_MIPMAP_LINEAR
        ];


        void getRelatedFormatAndType(IFormat iFormat, out Format f, out Type t)
        {
            switch (iFormat)
            {
                case IFormat.I8:
                case IFormat.I16F:
                case IFormat.I32F:
                    f = Format.INTENSITY;
                    t = Type.FLOAT;
                    break;


                case IFormat.A8:
                case IFormat.A16F:
                case IFormat.A32F:
                    f = Format.ALPHA;
                    t = Type.FLOAT;
                    break;

                case IFormat.L8:
                case IFormat.L16F:
                case IFormat.L32F:
                    f = Format.LUMINANCE;
                    t = Type.FLOAT;
                    break;

                case IFormat.LA8:
                case IFormat.LA16F:
                case IFormat.LA32F:
                    f = Format.LUMINANCE_ALPHA;
                    t = Type.FLOAT;
                    break;

                case IFormat.RGB8:
                    f = Format.RGB;
                    t = Type.UBYTE;
                    break;

                case IFormat.RGB16F:
                case IFormat.RGB32F:
                    f = Format.RGB;
                    t = Type.FLOAT;
                    break;

                case IFormat.RGBA8:
                    f = Format.RGBA;
                    t = Type.UBYTE;
                    break;

                case IFormat.RGBA16F:
                case IFormat.RGBA32F:
                    f = Format.RGBA;
                    t = Type.FLOAT;
                    break;

                case IFormat.DEPTH:
                default:
                    f = Format.DEPTH;
                    t = Type.UBYTE;
                    break;
            }
        }

    }

    private
    {

        GLuint m_handle;

        GLint m_baseLevel;
        GLint m_maxLevel;

        GLState m_state;

        int m_numMipmaps;

        final int getParam(GLenum paramName)
        {

            int res;
            bind();
            glGetTexParameteriv(m_target, paramName, &res);
            GL.check();
            return res;

        }

        final int getLevelParam(GLenum paramName, int level)
        {
            int res;
            bind();
            glGetTexLevelParameteriv(m_target, level, paramName, &res);
            GL.check();
            return res;
        }


    }

    protected
    {
        final int bind()
        {
            return m_state.textureUnits.bind(this);
        }

        final int bind(int unit)
        {
            return m_state.textureUnits.bind(unit, this);
        }

        final bool isBound()
        {
            return m_state.textureUnits.isBound(this) != -1;
        }

        GLint m_iFormat;
        GLint m_width, m_height, m_depth;
        GLint m_target;
        bool m_wrapInPOT; // if false, the texture is wrapped into a power-of-two textures

        Filter m_minFilter, m_magFilter;
        int m_minLOD, m_maxLOD;
        bool m_hasMipmaps;

        Wrap m_wrapS, m_wrapT, m_wrapR;

        final int storageWidth(int level = 0)
        {
            if (m_wrapInPOT)
            {
                return std.algorithm.max(1, nextPowerOf2(m_width) >> level);
            }
            else
            {
                return width(level);
            }
        }

        final int storageHeight(int level = 0)
        {
            if (m_wrapInPOT)
            {
                return std.algorithm.max(1, nextPowerOf2(m_height) >> level);
            }
            else
            {
                return height(level);
            }
        }

        final int storageDepth(int level = 0)
        {
            if (m_wrapInPOT)
            {
                return std.algorithm.max(1, nextPowerOf2(m_depth) >> level);
            }
            else
            {
                return depth(level);
            }
        }
    }


    public {

        /**
         * If wrapInPOT is true, ther texture will be silently wrapped into a larger POT texture.
         */
        this(GLint target, IFormat iFormat, bool hasMipmaps, bool useCompression, bool sRGB, bool wrapInPOT = true)
        {
            assert(wrapInPOT);

            m_state = GL;
            m_target = target;
            m_iFormat = translateIformat_toGL(iFormat, useCompression, sRGB);
            glGenTextures(1, &m_handle);
            assert(m_handle != 0);

            minFilter = Filter.NEAREST;
            magFilter = Filter.NEAREST;
            wrapS = Wrap.CLAMP_TO_EDGE;
            wrapT = Wrap.CLAMP_TO_EDGE;
            wrapR = Wrap.CLAMP_TO_EDGE;
            m_minLOD = 0;
            m_maxLOD = 1000;
            m_hasMipmaps = hasMipmaps;

            glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
            m_width = m_height = m_depth = 0;
            m_wrapInPOT = wrapInPOT;
            m_numMipmaps = 1;
            GL.check();
        }

        ~this()
        {
            glDeleteTextures( 1, &m_handle);
            GL.check();
        }


        final int use()
        {
            int textureUnit = bind();
            GL.check();
            return textureUnit;
        }

        final int use(int unit)
        {
            int textureUnit = bind(unit);
            GL.check();
            return textureUnit;
        }

        final void unuse()
        {
            m_state.textureUnits.unbind(this);
        }

        /**
         * Return virtual width (the real texture could be in a larger POT texture
         */
        final int width(int level = 0)
        {
            return std.algorithm.max(1, m_width >> level);
        }

        /**
         * Return virtual height (the real texture could be in a larger POT texture
         */
        final int height(int level = 0)
        {
            return std.algorithm.max(1, m_height >> level);
        }

        /**
         * Return virtual depth (the real texture could be in a larger POT texture
         */
        final int depth(int level = 0)
        {
            return std.algorithm.max(1, m_depth >> level);
        }

        final GLint target()
        {
            return m_target;
        }

        final Wrap wrapS()
        {
            return m_wrapS;
        }

        final Wrap wrapT()
        {
            return m_wrapT;
        }

        final Wrap wrapR()
        {
            return m_wrapR;
        }

        final Wrap wrapS(Wrap w)
        {
            m_wrapS = w;
            if (isBound()) {
                bind(); // apply changes
            }

            return w;
        }

        final Wrap wrapT(Wrap w)
        {
            m_wrapT = w;
            if (isBound()) {
                bind(); // apply changes
            }
            return w;
        }

        final Wrap wrapR(Wrap w)
        {
            m_wrapR = w;
            if (isBound()) {
                bind(); // apply changes
            }
            return w;

        }

        final Filter minFilter()
        {
            return m_minFilter;
        }

        final Filter magFilter()
        {
            return m_magFilter;
        }

        final Filter minFilter(Filter f)
        {
            m_minFilter = f;

            if (isBound()) {
                bind(); // apply changes
            }
            return f;
        }

        final Filter magFilter(Filter f)
        {
            assert( (f == Filter.NEAREST) || (f == Filter.LINEAR) );
            m_magFilter = f;
            if (isBound()) {
                bind(); // apply changes
            }
            return f;
        }

        final int minLOD()
        {
            return m_minLOD;
        }

        final int maxLOD()
        {
            return m_maxLOD;
        }

        final int minLOD(int lod)
        {
            m_minLOD = lod;
            if (isBound()) {
                bind(); // apply changes
            }
            return lod;
        }

        final int maxLOD(int lod)
        {
            m_minLOD = lod;
            if (isBound()) {
                bind(); // apply changes
            }
            return lod;
        }

        final GLint handle()
        {
            return m_handle;
        }

        final void getImage(int level, Format format, Type type, void * pixels)
        {
            bind();
            glGetTexImage(m_target, level, Format_toGL[format], Type_toGL[type], pixels);
            GL.check();
        }

        final void generateMipmaps()
        {
            bind();
            glGenerateMipmapEXT(m_target);
            GL.check();
        }

        /**
         * Get the number of mipmaps level
         */
        final int getNumMipmapLevel()
        {
            if (!m_hasMipmaps) return 1;

            return getMaxMipmapLevel() + 1;
        }

        final int getMaxMipmapLevel()
        {
            if (!m_hasMipmaps) return 0;

            int res = 0;
            int w = storageWidth(0);
            int h = storageHeight(0);
            int d = storageDepth(0);

            while( (w > 1) || (h > 1) || (d > 1) )
            {
                res++;
                if (w > 1) w /= 2;
                if (h > 1) h /= 2;
                if (d > 1) d /= 2;
            }

            return res;
        }

/*
        final int baseLevel(int base)
        {
            bind();
            glTexParameteri(m_target, GL_TEXTURE_BASE_LEVEL, base);
            GL.check();
            return base;
        }

        final int maxLevel(int level)
        {
            bind();
            glTexParameteri(m_target, GL_TEXTURE_MAX_LEVEL, level);
            GL.check();
            return level;
        }
    */



        // get texture coord
        // needed because the texture can be wrapped in a POT texture
        final float smin(int level = 0)
        {
            return 0.0f;
        }

        final float tmin(int level = 0)
        {
            return 0.0f;
        }

        final float rmin(int level = 0)
        {
            return 0.0f;
        }



        final float smax(int level = 0)
        {
            if (m_wrapInPOT)
            {
                return cast(float)(width(level)) / storageWidth(level);
            }
            else
            {
                return 1.0f;
            }
        }

        final float tmax(int level = 0)
        {
            if (m_wrapInPOT)
            {
                return cast(float)(height(level)) / storageHeight(level);
            }
            else
            {
                return 1.0f;
            }
        }

        final float rmax(int level = 0)
        {
            if (m_wrapInPOT)
            {
                return cast(float)(depth(level)) / storageDepth(level);
            }
            else
            {
                return 1.0f;
            }
        }
    }
}
