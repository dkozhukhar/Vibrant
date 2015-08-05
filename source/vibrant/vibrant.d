module vibrant;


import std.stdio;
import std.file;
import std.string;
import std.path;
import sdl.all;
import std.conv;
import misc.all;
import vibrantprogram;

import std.c.stdlib;

import game;


class InvalidCommandLine : Exception
{
    this(string msg)
    {
        super(msg);
    }
}

T safeConvert(T)(string src, string errorMsg)
    if (is(T == int) || is(T == float))
{   
    try
    {
        T res = to!T(src);
        return res;
    } catch(ConvException e)
    {
        throw new InvalidCommandLine(format(errorMsg, src));
    }
}


int main(string[]args)
{
    string basePath = dirName(absolutePath(thisExePath())); 

    auto width = SDLApp.AUTO_DETECT;
    auto height = SDLApp.AUTO_DETECT;
    string sratio = "auto"; // auto-detect ratio from width and height
    bool fullscreen = true; // by default, fullscreen
    float gamma = 1.0f;
    bool music = true;
    bool vsync = true;
    int fsaa = 4;
    bool blur = true;

    version(darwin)
    {
        pragma(msg, "Building with Mac OS X fullscreen work-around");
        fullscreen = false;
    }

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
                        height = safeConvert!int(args[i+1], "integer or \"auto\" expected for height, not %s");
                    }
                    i += 2;
                    break;

                case "-a":
                case "-fsaa":
                    if (i + 1 == args.length) throw new InvalidCommandLine("Missing FSAA option");
                    fsaa = safeConvert!int(args[i+1], "integer expected for FSAA, not %s");
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
                    gamma = safeConvert!float(args[i+1], "float expected for gamma, not %s");
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

    double ratio = 16.0 / 9.0;

    {
        scope auto app = new VibrantProgram(basePath, width, height, ratio, fullscreen, fsaa, music, gamma, vsync, blur);
        app.run();
        app.close();
    }

    return 0;
}

