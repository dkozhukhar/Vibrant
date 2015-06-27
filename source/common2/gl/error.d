module gl.error;

import std.string;

class OpenGLError : object.Exception
{
    this(string s)
    {
        super(s);
    }
}

// FBO
class FBOError : OpenGLError
{
    this(string s)
    {
        super(s);
    }
}

// shaders

class ShaderError : OpenGLError
{
    this(string s)
    {
        super(s);
    }
}

final class CompileError : ShaderError
{
    this(string filename, string log)
    {
        super(format("CompileError : Cannot compile %s\nLOG :\n%s", filename, log));
    }
}

final class LinkError : ShaderError
{
    this(string filename)
    {
        super(format("LinkError : Cannot link shader (%s)", filename));
    }
}

final class NotFoundUniformError : ShaderError
{
    this(string name)
    {
        super(format("Not found uniform \"%s\"", name));
    }
}
