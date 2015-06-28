module gl.error;

import std.string;

class OpenGLException : Exception
{
    this(string s)
    {
        super(s);
    }
}

// FBO
class FBOException : OpenGLException
{
    this(string s)
    {
        super(s);
    }
}

// shaders

class ShaderException : OpenGLException
{
    this(string s)
    {
        super(s);
    }
}

final class CompileException : ShaderException
{
    this(string filename, string log)
    {
        super(format("CompileError : Cannot compile %s\nLOG :\n%s", filename, log));
    }
}

final class LinkException : ShaderException
{
    this(string filename)
    {
        super(format("LinkError : Cannot link shader (%s)", filename));
    }
}

final class NotFoundUniformError : ShaderException
{
    this(string name)
    {
        super(format("Not found uniform \"%s\"", name));
    }
}
