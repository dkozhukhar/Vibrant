module overlay;

import misc.image;
import oldfonts;
import palettes;
import globals;
import sdl.all;
import math.all;
import std.string;

class Overlay
{
    const ATTR = TEXT_SHADOW;
    public
    {
        Image _mb; // framebuffer
        TextRenderer _text;

        this()
        {
            _mb = new Image(SCREENX, SCREENY);
            _text = new TextRenderer(_mb);

            _ui = new Image(new SDLImage("data/ui.png"));
        }
        
        void drawWindowBox(int x1, int y1, int x2, int y2, uint c)
        {
            _mb.drawBox(x1, y1, x2, y2, c);
            _mb.drawFilledBox(x1+1,y1+1,x2-1,y2-1, 0xE0000000);
        }

        void drawBar(int x, int y, int height, float status, uint c)
        {
            _mb.drawBox(x-4,y-height-1,x+4,y+2, clwhite);
            int up = y - cast(int)round((height - 1.f) * clamp(status, 0.f, 1.f));
            if (up >= y) return;
            _mb.drawLine(x-2,y,x-2,up, average(c,clblack));
            _mb.drawLine(x-1,y,x-1,up, average(average(c,clwhite),clwhite));
            _mb.drawLine(x,y,x,up, c);
            _mb.drawLine(x+1,y,x+1,up, average(c,clwhite));
            _mb.drawLine(x+1,y,x+1,up, average(average(c,clwhite),clwhite));
        }

        void clearBuffer()
        {
            _mb.data[] = _ui.data[];
        }

        void drawIntroductoryText(double t)
        {
            _text.setAttr(ATTR);
            _text.setColor(0xFF8080FF);
            _text.setFont(FontType.SMALL);

            int BX = 200;
            auto BY = 101 + 1 * 16;

            double h = 0;
            const START = 0.03;
            const STOP = 0.97;

            if (t < 0.03) h = 60 * (1 - t / 0.03);
            if (t > STOP) h = 60 * (t - STOP) / (1 - STOP);

            drawWindowBox(BX - 16, BY - 28 + cast(int)(0.5 + h), BX + 30 * 8 + 16, BY + 116 - cast(int)(0.5 + h), 0x8F8080FF);

            const char[][] test = 
            [
                "      The Homeric wars.       ",
                "  In these times of trouble,  ",
                "  it was common for the best  ",
                "  warrior of a defeated tribe ",
                "    to face an humiliating    ",
                "          execution.          "
            ];

            if (t > START && t < STOP)
            {
                for (int i = 0; i < 6; ++i)
                {
                    _text.drawString(BX, BY + 16 * i, test[i]);
                }
            }
        }

        void drawPauseScreen()
        {
            drawWindowBox(280, 222, 360, 262, 0xffffffff);
            _text.setAttr(ATTR);
            _text.setColor(clwhite);
            _text.setFont(FontType.SMALL);
            _text.setCursorPosition(320 - 8 * 3, 240);
            _text.outputString("Paused");
        }

        void drawHelpScreen(char[] tipOfTheMinute, bool showContinue)
        {
            // help screen

            drawWindowBox(130, 116, 510, 364, 0xffffffff);

            auto BX = 101 + 2 * 8;
            auto BY = 101 + 3 * 16;

            _text.setAttr(ATTR);
            _text.setColor(0xFFFFFFFF);
            _text.setFont(FontType.SMALL);

            _text.drawString(BX, BY,      "                   Vibrant v1.7");
            _text.setColor(0xffff7477);

            _text.drawString(BX, BY + 16, "               www.gamesfrommars.fr    ");

            {
                BY = 100 + 16 * 13;

                char[] tip = "Tip: " ~ tipOfTheMinute;

                _text.setCursorPosition(320 - 4 * tip.length, BY);
                _text.setColor(0xff7477ff);
                _text.outputString(tip);

                if (showContinue)
                {
                    char[] msg = "Now press FIRE to continue";
                    _text.setCursorPosition(320 - 4 * msg.length, BY + 20);
                    _text.setColor(clwhite);
                    _text.outputString(msg);
                }
            }

            {
                BX = 101 + 8 * 8;
                BY = 101 + 4 * 16 - 4;
                _text.setColor(clwhite);
                _text.setCursorPosition(BX, BY + 32);
                _text.outputString("               Controls");
                _text.setColor(clgrey);
                _text.setCursorPosition(BX, BY + 64);
                _text.outputString("   move:              strafe: ");
                _text.setCursorPosition(BX, BY + 80);
                _text.outputString("   fire:      ,       pause:  ");
                _text.setCursorPosition(BX, BY + 96);
                _text.outputString("   turbo:      ,      music:  ");
                _text.setCursorPosition(BX, BY + 112);
                _text.outputString("   catch:      ,    ");

                _text.setColor(0xffbfbf50);
                
                _text.setCursorPosition(BX, BY + 64);
                _text.outputString("          ARROWS              ALT");
                _text.setCursorPosition(BX, BY + 80);
                _text.outputString("          CTRL  C             P");
                _text.setCursorPosition(BX, BY + 96);
                _text.outputString("          SHIFT  X            M ");
                _text.setCursorPosition(BX, BY + 112);
                _text.outputString("          SPACE  Z  ");
            }

/*
            ALT strafe
                P pause
                M toggle music*/

        }

        char[] padZero(int n, int size, char[] pad)
        {
            char[] res = format("%s", n);
            while (res.length < size)
            {
                res = pad ~ res; // TODO : remove inefficiency
            }
            return res;
        }

        void drawStatus()
        {
            int x = 44;
            int by = 10;
            _text.setFont(FontType.LARGE);
            _text.setAttr(ATTR);
            _text.setColor(0xffff7477);
            _text.setCursorPosition(x, by);
            _text.outputString(padZero(level, 5, " "));                
        }
    }

    private
    {        
        Image _ui;        
    }
}
