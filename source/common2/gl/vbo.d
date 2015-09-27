module gl.vbo;
/+
import gl.buffer;
import gl.state;
import derelict.opengl.gl;
import gfm.math;

// A vertex buffer
// T : the vertex format

final class VBO(T)
{
    // a vertex struct should be an integer multiple of 32 bytes
    static assert(T.sizeof > 0);
    static assert((T.sizeof & 31) == 0);

    public
    {
        enum Attribute
        {
            POSITION,
            COLOR,
            TEX_COORD,
            NORMAL,
    //        INDEX
        }

        enum Type
        {
            BYTE,
            UBYTE,
            SHORT,
            USHORT,
            INT,
            UINT,
            HALF,
            FLOAT,
            DOUBLE
        }
    }

    private
    {
        GLBuffer m_buffer;
        T[] m_vertices;
        int m_baseIndex;

        struct VertexFormatElement
        {
            Attribute attr;
            int n;
            Type type;
            int offset;

            void use()
            {
                switch (attr)
                {
                    case Attribute.POSITION:
                        glEnableClientState(GL_VERTEX_ARRAY);
                        glVertexPointer(n, typeToGL(type), T.sizeof, cast(GLvoid *) offset);
                        break;

                    case Attribute.COLOR:
                        glEnableClientState(GL_COLOR_ARRAY);
                        glColorPointer(n, typeToGL(type), T.sizeof, cast(GLvoid *) offset);
                        break;

                    case Attribute.TEX_COORD:
                        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
                        glTexCoordPointer(n, typeToGL(type), T.sizeof, cast(GLvoid *) offset);
                        break;

                    case Attribute.NORMAL:
                        glEnableClientState(GL_NORMAL_ARRAY);
                        assert(n == 3);
                        glNormalPointer(typeToGL(type), T.sizeof, cast(GLvoid *) offset);
                        break;

        /*            case Attribute.INDEX:
                        glIndexPointer( n, typeToGL(type), T.sizeof, offset);
                        break;
                        */
                    default: assert(false);
                }
                GL.check;
            }

            void unuse()
            {
                switch (attr)
                {
                    case Attribute.POSITION:
                        glDisableClientState(GL_VERTEX_ARRAY);

                    case Attribute.COLOR:
                        glDisableClientState( GL_COLOR_ARRAY );
                        break;

                    case Attribute.TEX_COORD:
                        glDisableClientState( GL_TEXTURE_COORD_ARRAY );
                        break;

                    case Attribute.NORMAL:
                        glDisableClientState( GL_NORMAL_ARRAY );
                        break;

                    default: assert(false);
                }
                GL.check;
            }
        }

        class VertexFormat
        {
            private
            {
                VertexFormatElement[] elements;
                int currentOffset = 0;
            }

            void add(Attribute attr, int n, Type type)
            {
                elements ~= VertexFormatElement(attr, n, type, currentOffset);
                currentOffset += n * getTypeSize(type);
            }

            void addDummyBytes(int nBytes)
            {
                currentOffset += nBytes;
            }

            void use()
            {
                for (int i = elements.length - 1; i >= 0; --i)
                {
                    elements[i].use;
                }
            }

            void unuse()
            {
                for (int i = 0; i < elements.length; ++i)
                {
                    elements[i].unuse;
                }
            }
        }

        VertexFormat m_format;
    }

    public
    {
        alias GLBuffer.Storage Storage;
        alias GLBuffer.Usage Usage;
        alias GLBuffer.Target Target;

        this(Storage storage, Usage usage = Usage.DRAW)
        {
            m_buffer = new GLBuffer(Target.ARRAY_BUFFER, storage, usage);

            m_format = new VertexFormat();
            m_baseIndex = 0;
            m_vertices.length = 10;
        }

        void addAttribute(Attribute attr, int n, Type type)
        {
            m_format.add(attr, n, type);
        }

        void addDummyBytes(int nBytes)
        {
            m_format.addDummyBytes(nBytes);
        }

        void clear()
        {
            m_baseIndex = 0;
        }

        void add(T v)
        {
            if (m_vertices.length <= m_baseIndex)
            {
                m_vertices.length = m_vertices.length * 2;
            }

            m_vertices[m_baseIndex
            ] = v;
            m_baseIndex++;
        }

        int length()
        {
            return m_baseIndex;
        }

        void update()
        {
            m_buffer.setData(T.sizeof * m_baseIndex, m_vertices.ptr );

            // invalidate
            //setData(VertexData.sizeof * data.length, storage, Usage.DRAW, null );
            //setSubData(0, VertexData.sizeof * data.length, data.ptr);
        }

        void draw(GLenum mode, int first, int count)
        {
            if (count == 0) return;
            m_buffer.bind();
            m_format.use;
            glDrawArrays(GL_POINTS, first, count);
            GL.check;
            m_format.unuse;
            m_buffer.unbind();
        }
    }

    private
    {
        static GLenum typeToGL(Type t)
        {
            switch(t)
            {
                case Type.BYTE   : return GL.BYTE;
                case Type.UBYTE  : return GL.UNSIGNED_BYTE;
                case Type.SHORT  : return GL.SHORT;
                case Type.USHORT : return GL.UNSIGNED_SHORT;
                case Type.INT    : return GL.INT;
                case Type.UINT   : return GL.UNSIGNED_INT;
                case Type.HALF   : return GL.HALF;
                case Type.FLOAT  : return GL.FLOAT;
                case Type.DOUBLE    : return GL.DOUBLE;
                default: assert(false);
            }
        }

        static int getTypeSize(Type t)
        {
            switch(t)
            {
                case Type.BYTE   :
                case Type.UBYTE  : return 1;

                case Type.HALF   :
                case Type.SHORT  :
                case Type.USHORT : return 2;

                case Type.INT    :
                case Type.UINT   :
                case Type.FLOAT  : return 4;

                case Type.DOUBLE    : return 8;
                default: assert(false);
            }
        }
    }
}

+/