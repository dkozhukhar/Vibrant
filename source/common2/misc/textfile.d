module misc.textfile;

import std.file;
import std.stdio;

string[] readTextFile(string filename)
{
    string[] res;

    auto fd = std.stdio.File(filename);
    scope(exit) fd.close();

    char[] buf;
    while (fd.readln(buf))
    {
        res ~= buf.idup;
    }

    return res;
}
