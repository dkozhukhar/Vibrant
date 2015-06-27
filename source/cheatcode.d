module cheatcode;

import std.string;
import game;
import vutils;
import players;
import sound;
import globals;
import camera;

final class CheatcodeManager
{
    public
    {
        enum Cheat { MAXENCE, NEXT, LEVELMAX };
    }

    private
    {
        const string[Cheat.max + 1] cheatcodeString =
        [
            "next",
            "levelmax",
        ];

        string m_current;
        Game m_game;

        void executeCheat(Cheat cheat)
        {
            m_game.soundManager.playSound(0.5f, SOUND.CATCH_POWERUP);
            switch(cheat)
            {
                debug
                {
                case Cheat.LEVELMAX:
                    for (int i = 0; i < 30; ++i)
                        m_game.initenemies;
                    break;
                }

                case Cheat.NEXT:
                default:
                    m_game.initenemies;
                    break;
            }

        }
    }

    public
    {
        this(Game game)
        {
            m_current = "";
            m_game = game;
        }

        void keyTyped(wchar c)
        {
            char ch = cast(char)c;
            m_current = m_current ~ ch;
            bool stillPossible = false;
            for (Cheat i = Cheat.min; i <= Cheat.max; ++i)
            {
                int pos = cast(int)( indexOf(cheatcodeString[i], m_current) );
                if (pos == 0)
                {
                    if (icmp(m_current, cheatcodeString[i]) == 0)
                    {
                        executeCheat(i);
                        m_current = "";
                    }
                    stillPossible = true;
                }
            }
            if (!stillPossible) m_current = "";
        }
    }
}
