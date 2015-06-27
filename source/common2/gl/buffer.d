module gl.buffer;

import derelict.opengl.gl;
//import derelict.opengl.gl20;
import derelict.opengl.extension.arb.vertex_buffer_object;
import gl.state;

class GLBuffer
{
    public
    {
        enum Target
        {
            ARRAY_BUFFER,
            ELEMENT_ARRAY_BUFFER,
            PIXEL_PACK_BUFFER,
            PIXEL_UNPACK_BUFFER
        }

        enum Storage
        {
            STATIC,   // data does not change over time
            DYNAMIC,  // data change over time and is used several times per frame
            STREAM    // data used exactly one time per frame
        };

        enum Usage
        {
            READ,
            COPY,
            DRAW
        };

        this(Target target, Storage storage, Usage usage)
        {
            m_state = GL;
            m_storage = storage;
            m_usage = usage;

            m_target = target;

            glGenBuffersARB(1, &m_handle);

            GL.check;            
        }

        ~this()
        {
            glDeleteBuffersARB(1, &m_handle);
            GL.check;
        }

        void setData(int size, void * data)
        {
            bind();
            GLenum usage = getGLConstantForStorageAndUsage(m_storage, m_usage);
            GLenum target = getGLConstantForTarget(m_target);

            // discard previous data
            if (!m_firstLoad)
            {
                glBufferDataARB(target, size, null, usage);
                glBufferSubDataARB(target, 0, size, data);
            //    glBufferData(target, size, data, usage);
            }
            else
            {
                glBufferDataARB(target, size, data, usage);
            }
            GL.check;

            m_firstLoad = false;
        }

        void setSubData(int offset, int size, void * data)
        {
            bind();
            GLenum target = getGLConstantForTarget(m_target);
            glBufferSubDataARB(target, offset, size, data);
            GL.check;
        }

        void bind()
        {
            //if (this !is binded)
            {
                glBindBufferARB(getGLConstantForTarget(m_target), m_handle);
                GL.check;
        //        binded = this;
            }
        }

        void unbind()
        {
        //    if (this is binded)
            {
                glBindBufferARB(getGLConstantForTarget(m_target), 0);
        //        binded = null;
            }
        }
    }

    private
    {
        GLuint m_handle;
        Target m_target;
    //    static GLBuffer binded = null;
        GLState m_state;
        Storage m_storage;
        Usage m_usage;
        bool m_firstLoad = true;

        final GLenum getGLConstantForTarget(Target target)
        {
            switch (target)
            {
                case Target.ARRAY_BUFFER         : return GL.ARRAY_BUFFER;
                case Target.ELEMENT_ARRAY_BUFFER : return GL.ELEMENT_ARRAY_BUFFER;
                case Target.PIXEL_PACK_BUFFER    : return GL.PIXEL_PACK_BUFFER;
                case Target.PIXEL_UNPACK_BUFFER  : return GL.PIXEL_UNPACK_BUFFER;
                default: assert(false);
            }
        }

        final GLenum getGLConstantForStorageAndUsage(Storage storage, Usage usage)
        {
            switch(storage)
            {
                case Storage.STATIC:
                    switch(usage)
                    {
                        case Usage.READ: return GL_STATIC_READ;
                        case Usage.COPY: return GL_STATIC_COPY;
                        case Usage.DRAW: return GL_STATIC_DRAW;
                        default: assert(false);
                    }
                case Storage.DYNAMIC:

                    switch(usage)
                    {
                        case Usage.READ: return GL_DYNAMIC_READ;
                        case Usage.COPY: return GL_DYNAMIC_COPY;
                        case Usage.DRAW: return GL_DYNAMIC_DRAW;
                        default: assert(false);
                    }

                case Storage.STREAM:

                    switch(usage)
                    {
                        case Usage.READ: return GL_STREAM_READ;
                        case Usage.COPY: return GL_STREAM_COPY;
                        case Usage.DRAW: return GL_STREAM_DRAW;
                        default: assert(false);
                    }
                default: assert(false);
            }
        }
    }
}
