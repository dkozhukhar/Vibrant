module misc.textfile;

import std.file;
import std.stream;
import std.stdio;

string[] readTextFile(string filename)
{
    string[] res;

    try
    {
        auto fd = new std.stream.File(filename);
        scope(exit) fd.close();

        while(!fd.eof())
        {
            char[] line = fd.readLine();
            res ~= line.idup;
        }
    } catch(StreamException e)
    {
    }

    return res;     // empty
}
