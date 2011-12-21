module vibrant;


import std.stdio;
import std.file;
import std.path;
import sdl.all;
import std.conv;
import misc.all;
import vibrantprogram;
import std.gc;

import std.c.stdlib;

import game;


class InvalidCommandLine : object.Exception
{
    this(string msg)
    {
        super(msg);
    }
}

T safeConvert(T)(string src, string errorMsg)
{
    static if(is(T : int))
    {
        alias std.conv.toInt conv;
    } else static if(is(T : float))
    {
        alias std.conv.toFloat conv;
    } else
    {
        static assert(false);
    }

    try
    {
        T res = conv(src);
        return res;
    } catch(ConvError)
    {
        throw new InvalidCommandLine(format(errorMsg, src));
    }
}


int mainProcedure(char[][] args)
{
    chdir(getDirName(args[0]));

    info("Command-line :");

    foreach(string s; args)
    {
        info(s);
    }

//    int fsaa = 4;

    auto width = SDLApp.AUTO_DETECT;
    auto height = SDLApp.AUTO_DETECT;
    string sratio = "auto"; // auto-detect ratio from width and height
    bool fullscreen = true; // by default, fullscreen
    float gamma = 1.f;
    bool music = true;
    bool vsync = true;
    int fsaa = 1;
    bool blur = true;

    // parse command-line arguments
    {
        int i = 1;

        while (i < args.length)
        {
            switch(args[i])
            {
                case "-width":
                case "-w":
                    if (i + 1 == args.length) throw new InvalidCommandLine("Missing width");
                    if (args[i+1] == "auto")
                    {
                        width = SDLApp.AUTO_DETECT;
                    }
                    else
                    {
                        width = safeConvert!(int)(args[i+1], "integer  or \"auto\" expected for width, not %s");
                    }
                    i += 2;
                    break;

                case "-height":
                case "-h":
                    if (i + 1 == args.length) throw new InvalidCommandLine("Missing height");
                    if (args[i+1] == "auto")
                    {
                        height = SDLApp.AUTO_DETECT;
                    }
                    else
                    {
                        height = safeConvert!(int)(args[i+1], "integer or \"auto\" expected for height, not %s");
                    }
                    i += 2;
                    break;

                case "-a":
                case "-fsaa":
                    if (i + 1 == args.length) throw new InvalidCommandLine("Missing FSAA option");
                    fsaa = safeConvert!(int)(args[i+1], "integer expected for FSAA, not %s");
                    i += 2;
                    break;

                case "-f":
                case "-fullscreen":
                    fullscreen = true;
                    i += 1;
                    break;

                case "-noblur":
                case "-no-blur":
                    blur = false;
                    i += 1;
                    break;

                case "-gamma":
                    if (i + 1 == args.length) throw new InvalidCommandLine("Missing gamma option");
                    gamma = safeConvert!(float)(args[i+1], "float expected for gamma, not %s");
                    i += 2;
                    break;

                case "-nf":
                case "-no-fullscreen":
                case "-nofullscreen":
                case "-windowed":
                    fullscreen = false;
                    i += 1;
                    break;


                default:
                    throw new InvalidCommandLine(format("Unknown argument : %s", args[i]));
            }
        }
    }


    if ((fsaa != 1)
     && (fsaa != 2)
     && (fsaa != 4)
     && (fsaa != 8)
     && (fsaa != 16))
        throw new InvalidCommandLine("No such FSAA option (should be 1, 2, 4, 8 or 16)");

    double ratio = 4.0 / 3.0;

    {
        scope auto app = new VibrantProgram(width, height, ratio, fullscreen, fsaa, music, gamma, vsync, blur);
        std.gc.fullCollect();
        std.gc.minimize();
        app.run();
        app.close();
    }

    return 0;
}

version(Windows)
{
    debug
    {
        int main(char[][] args)
        {
            try
            {
                return mainProcedure(args);
            }
            catch(InvalidCommandLine e)
            {
                return 1;
            }
        }
    }
    else
    {
        import std.string;
        import std.stream;
        import std.math;
        import std.c.stdlib;
        import std.c.windows.windows;
          import std.string;

        extern (C)
        {
            void gc_init();
            void gc_term();
            void _minit();
            void _moduleCtor();
        }


        extern (Windows) public int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
        {
            int result;
            gc_init();
            _minit();
            try
            {
                _moduleCtor();
                char exe[4096];
                GetModuleFileNameA(null, exe.ptr, 4096);
                char[][1] prog;
                prog[0] = std.string.toString(exe.ptr);
                result = mainProcedure(prog ~ std.string.split(std.string.toString(lpCmdLine)));
            }
            catch (Object o)
            {
                result = EXIT_FAILURE;
            }
            gc_term();
            return result;
        }
    }

}
else
{

    int main(char[][] args)
    {
        return mainProcedure(args);
    }
}
