module misc.inifile;

import std.stream, std.conv, std.string;
import misc.textfile;

class IniEntry
{
    private
    {
        string m_name, m_value;
    }

    public
    {
        this(string name, string value)
        {
            m_name = name;
            m_value = value;
        }

        string name()
        {
            return m_name;
        }

        string value()
        {
            return m_value;
        }

        string value(string v)
        {
            return m_value = v;
        }

        void output(OutputStream stream)
        {
            stream.writeLine(name ~ "=" ~ value);
        }
    }
}

class IniSection
{
    private
    {
        string m_name;
        IniEntry[] m_entries;
    }

    public
    {
        this(string name)
        {
            m_name = name;
        }

        string name()
        {
            return m_name;
        }

        IniEntry findEntry(string name)
        {
            for (int i = 0; i < m_entries.length; ++i)
            {
                if (m_entries[i].name == name) return m_entries[i];
            }

            return null;
        }

        IniEntry findOrCreateEntry(string name)
        {
            IniEntry res = findEntry(name);
            if (res is null)
            {
                m_entries ~= new IniEntry(name, "");
                return m_entries[m_entries.length - 1];
            }
            else
            {
                return res;
            }
        }

        void output(OutputStream stream)
        {
            stream.writeLine("[" ~ m_name ~ "]");

            for (int i = 0; i < m_entries.length; ++i)
            {
                m_entries[i].output(stream);
            }

            stream.writeLine("");
        }
    }
}

class IniFile
{
    private
    {
        IniSection[] m_sections;

        static const string FALSE = "false";
        static const string TRUE = "true";
    }

    public
    {
        // create empty (for saving)
        this()
        {
        }

        // create from a file (for loading settings)
        this(string path)
        {
            string[] lines = readTextFile(path);

            // parse lines (ignore errors)

            string sectionName = null;

            for (int i = 0; i < lines.length; ++i)
            {
                string line = strip(lines[i]);
                if ((line != "") && (line[0] != ';'))
                {
                    if ((line[0] == '[') && (line[$-1] == ']'))
                    {
                        sectionName = line[1..$-1];
                        IniSection currentSection = findOrCreateSection(strip(sectionName));
                    }
                    else
                    {
                        int pos = cast(int)(std.string.indexOf(line, "="));
                        if ((pos != -1) && (sectionName !is null))
                        {
                            string name = line[0..pos];
                            string value = line[pos + 1..$];
                            writeString(sectionName, name, value);
                        }
                    }
                }
            }
        }

        void save (string path)
        {
            try
            {
                auto file = new File(path, FileMode.OutNew);
                scope(exit) file.close();

                for (int i = 0; i < m_sections.length; ++i)
                {
                    m_sections[i].output(file);
                }
            }
            catch(StreamException e)
            {
            }
        }

        IniSection findSection(string name)
        {
            for (int i = 0; i < m_sections.length; ++i)
            {
                if (m_sections[i].name == name) return m_sections[i];
            }

            return null;
        }

        IniSection findOrCreateSection(string name)
        {
            IniSection res = findSection(name);
            if (res is null)
            {
                m_sections ~= new IniSection(name);
                return m_sections[m_sections.length - 1];
            }
            else
            {
                return res;
            }
        }

        string findValue(string section, string name)
        {
            auto s = findSection(section);
            if (s !is null)
            {
                auto entry = s.findEntry(name);
                if (entry !is null) return entry.value;
            }
            return null;
        }

        string readString(string section, string name, string defaultValue)
        {
            string res = findValue(section, name);
            if (res is null)
            {
                return defaultValue;
            }
            else
            {
                return res;
            }
        }

        int readInt(string section, string name, int defaultValue)
        {
            string s = findValue(section, name);
            if (s is null)
            {
                return defaultValue;
            }
            else
            {
                try
                {
                    return std.conv.to!int(s);
                }
                catch(ConvException e)
                {
                    return defaultValue;
                }
            }
        }

        bool readBool(string section, string name, bool defaultValue)
        {
            string s = findValue(section, name);

            if (s is null)
            {
                return defaultValue;
            }
            else
            {
                if (s == TRUE)
                {
                    return true;
                }
                else if (s == FALSE)
                {
                    return false;
                }
                else
                {
                    return defaultValue;
                }
            }
        }

        void writeString(string section, string name, string value)
        {
            auto s = findOrCreateSection(section);
            auto e = s.findOrCreateEntry(name);
            e.value = value;
        }

        void writeInt(string section, string name, int value)
        {
            writeString(section, name, to!string(value));
        }

        void writeBool(string section, string name, bool value)
        {
            string s = value ? TRUE : FALSE;
            writeString(section, name, s);
        }

    }
}
