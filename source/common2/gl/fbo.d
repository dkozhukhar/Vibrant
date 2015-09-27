module gl.fbo;

import derelict.opengl3.gl3;
import derelict.opengl3.deprecatedConstants;
import derelict.opengl3.deprecatedFunctions;


import gl.error;
import gl.renderbuffer;
import gl.texture;
import gl.texture1d;
import gl.texture2d;
import gl.texture3d;
import gl.textureunit;
import gl.state;

/**
 * Wrapper around OpenGL FBO
 */
final class FBO
{
    public
    {
        enum Component { NONE = 0,
                         RED = 1,
                         GREEN = 2,
                         BLUE = 4,
                         ALPHA = 8,
                         COLORS = 15,
                         DEPTH = 16,
                         COLORS_AND_DEPTH = 31,
                         ALL =  31}; // no stencil support now
    }

    private
    {

        final class Attachment
        {

            private
            {
                FBO m_fbo;
                Texture m_tex = null;
                RenderBuffer m_rb = null;
                GLint m_type = -1;
                GLint m_target = -1;
                GLint m_level = -1;
                GLint m_offset = -1;
            }

            public
            {
                this(FBO fbo, GLint type)
                {
                    m_fbo = fbo;
                    m_type = type;
                }

                bool assigned()
                {
                    return (m_tex !is null) || (m_rb !is null);
                }

                bool isTexture()
                {
                    return (m_target == GL_TEXTURE_1D)
                        || (m_target == GL_TEXTURE_2D)
                        || (m_target == GL_TEXTURE_3D); // does not support other types :|
                }

                void attach()
                {
                    if (assigned())
                    {
                        m_fbo.bind();
                        switch(m_target)
                        {
                            case GL_TEXTURE_1D:
                                glFramebufferTexture1DEXT(GL_FRAMEBUFFER_EXT, m_type, GL_TEXTURE_1D, m_tex.handle, m_level);
                                break;

                            case GL_TEXTURE_2D:
                                glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, m_type, GL_TEXTURE_2D, m_tex.handle, m_level);
                                break;

                            case GL_TEXTURE_3D:
                                glFramebufferTexture3DEXT(GL_FRAMEBUFFER_EXT, m_type, GL_TEXTURE_3D, m_tex.handle, m_level, m_offset);
                                break;

                           case GL_RENDERBUFFER_EXT:
                                glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, m_type, GL_RENDERBUFFER_EXT, m_rb.handle);
                                break;

                           default:
                                   throw new FBOException("Trying to bind to an unknown target");
                        }

                    }


                    GL.check;

                    if (!GL.test())
                    {
                        throw new FBOException("Can't attach a texture/renderbuffer to a FBO");
                    }
                }

                final void setTarget(RenderBuffer rb)
                {
                    m_rb = rb;
                    m_tex = null;
                    m_target = GL_RENDERBUFFER_EXT;
                    attach();
                }

                final void setTarget(Texture1D t, int level)
                {
                    m_level = level;
                    m_tex = t;
                    m_rb = null;
                    m_target = GL_TEXTURE_1D;
                    attach();
                }

                final void setTarget(Texture2D t, int level)
                {
                    m_level = level;
                    m_tex = t;
                    m_rb = null;
                    m_target = GL_TEXTURE_2D;
                    attach();
                }


                final void setTarget(Texture3D t, int level, int offset) {

                    m_level = level;
                    m_offset = offset;
                    m_tex = t;
                    m_rb = null;
                    m_target = GL_TEXTURE_3D;
                    attach();
                }
            }
        }

        GLuint handle;
        GLState m_state;


        __gshared static FBO binded = null;
        __gshared static FBO current = null;

        bool m_main;
        Component m_toWrite;

        final void bind()
        {

            if (binded !is this)
            {

                // unbind any texture we may render in !!!
    /*
                if (!m_main)
                {
                    for (int i = 0; i < color.length; i++)
                    {
                        if (color[i].isTexture())
                        {

                            m_state.textureUnits.unbind(color[i].m_tex);
                        }
                    }
                }
    */
                // for ATI X1950: better unbind all textures or get crap
                m_state.textureUnits.unbindAll();

                GL.check;
                glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, handle);
                GL.check;
                binded = this;
            }
        }
    }

    public {

        Attachment[] color;
        Attachment stencil;
        Attachment depth;

        this(bool main)
        {
            m_state = GL;

            m_main = main;
            if (main)
            {
                handle = 0;
                color.length = 1;
                color[0] = new Attachment(this, GL_BACK);
                stencil = null;
                depth = null;
                setWrite(Component.RED | Component.GREEN | Component.BLUE | Component.ALPHA | Component.DEPTH);

            } else
            {
                glGenFramebuffersEXT(1, &handle);
                GL.check();
                color.length = maxColorAttachments();

                for (int i = 0; i < color.length; i++)
                {
                    color[i] = new Attachment(this, GL_COLOR_ATTACHMENT0_EXT + i);
                }

                stencil = new Attachment(this, GL_STENCIL_ATTACHMENT_EXT);
                depth = new Attachment(this, GL_DEPTH_ATTACHMENT_EXT);
                setWrite(Component.RED | Component.GREEN | Component.BLUE | Component.ALPHA);
            }
        }

        this()
        {
            this(false);
        }

        ~this()
        {
            if (binded is this)
            {
                binded = null;
            }

            if (current is this)
            {
                current = null;
            }

            if (handle != 0)
            {
                glDeleteFramebuffersEXT(1, &handle);
                GL.check();
            }
        }

        static final int maxColorAttachments()
        {
            int max;
            glGetIntegerv(GL_MAX_COLOR_ATTACHMENTS_EXT,&max);
            return max;
        }

        final void setWrite(Component toWrite)
        {
            m_toWrite = toWrite;
        }

        final void use()
        {
            //logAttachments();
            bind();





            if (this !is current)
            {
                current = this;
                glColorMask(cast(bool)(m_toWrite & Component.RED),
                            cast(bool)(m_toWrite & Component.GREEN),
                            cast(bool)(m_toWrite & Component.BLUE),
                            cast(bool)(m_toWrite & Component.ALPHA));
                glDepthMask(cast(bool)(m_toWrite & Component.DEPTH));

                glStencilMask(0);
            }
            // logAttachments();
            GL.check();
            check();
        }


        final bool check()
        {
            GLenum status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
            switch(status)
            {
                case GL_FRAMEBUFFER_COMPLETE_EXT:
                    return true;

                case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT:
                    assert(false);

                case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT:
                    assert(false);

                case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT:
                    assert(false);

                case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT:
                    assert(false);

                case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT:
                    assert(false);

                   case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT:
                    assert(false);

                case GL_FRAMEBUFFER_UNSUPPORTED_EXT:
                    assert(false);

                default:
                    assert(false);

            }
        }

        final GLenum getBuffer(int i)
        {
            if (m_main)
            {
                static auto const bufferLookup = [GL_BACK, GL_AUX0, GL_AUX1, GL_AUX2];
                return bufferLookup[i];
            } else
            {
                return ( GL_COLOR_ATTACHMENT0_EXT + i );
            }
        }


        final void setDrawBuffers(int[] drawBuffers) // pass here which color buffers to write (in general : 0..3)
        {
            assert(drawBuffers.length > 0);
            assert(drawBuffers.length < 16);

            GLenum[16] drawBuffersId;
            int drawBuffersCount = 0;

            drawBuffersCount = cast(int)(drawBuffers.length);

            for (int i = 0; i < drawBuffersCount; ++i)
            {
                drawBuffersId[i] = getBuffer(drawBuffers[i]);
            }

            // set draw buffers
            if (drawBuffersCount == 1)
            {
                glDrawBuffer(drawBuffersId[0]);
            }
            else
            {
                glDrawBuffers(drawBuffersCount, drawBuffersId.ptr);
            }
        }
    }
}
