module cheatcode;

import std.string;
import game;
import players;
import sound;
import globals;
import camera;

final class CheatcodeManager
{
    public
    {
        enum Cheat { MAXENCE, NEXT, KISS, LOL, JOY, KEK };
    }

    private
    {
        static immutable string[Cheat.max + 1] cheatcodeString =
        [
            "maxence",
            "next",
            "kiss",
            "lol",
            "joy",
            "kek",
        ];

        string m_current;
        Game m_game;

        void executeCheat(Cheat cheat)
        {

            m_game.soundManager.playSound(0.5f, SOUND.CATCH_POWERUP);
            switch(cheat)
            {
                case Cheat.KISS:
                    for (int i = 0; i < 30; ++i)
                        m_game.initenemies;
                    break;

                case Cheat.NEXT:
                    m_game.initenemies;
                    break;

                case Cheat.LOL:
                    player.invincibility += 1e+20f;
                    break;

                case Cheat.JOY:
                    player.energygain *= 5;
                    break;

                case Cheat.KEK:
                    player.weaponclass += 10;
                    break;

                default:
                    break;
            }

        }
    }

    public
    {
        this(Game game)
        {
            m_current = "";
            m_current.reserve(128);
            m_game = game;
        }

        void keyTyped(dchar c)
        {
            if (c > 255)
                return;
            char ch = cast(char)c;
            m_current ~= ch;
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
            if (!stillPossible) m_current.length = 0;
        }
    }
}
