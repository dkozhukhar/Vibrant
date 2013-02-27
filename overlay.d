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
            int up = y - round((height - 1.f) * clamp(status, 0.f, 1.f));
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

        void drawIntroductoryText()
        {
            _text.setAttr(0);
            _text.setColor(0xFF8080FF);
            _text.setFont(FontType.SMALL);

            int BX = 200;
            auto BY = 101 + 1 * 16;

            drawWindowBox(BX - 16, BY - 28, BX + 30 * 8 + 16, BY + 36 + 16 * 6, 0x8F8080FF);

            _text.drawString(BX, BY     , "      The Homeric wars.       ");
            _text.drawString(BX, BY + 16, "  In these times of trouble,  ");
            _text.drawString(BX, BY + 32, "  it was common for the best  ");
            _text.drawString(BX, BY + 48, "  warrior of a defeated tribe ");
            _text.drawString(BX, BY + 64, "    to face an humiliating    ");
            _text.drawString(BX, BY + 80, "  execution, fighting against ");
            _text.drawString(BX, BY + 96, "   members of his own house.  ");
        }

        void drawPauseScreen()
        {
            drawWindowBox(280, 222, 360, 262, 0xffffffff);
            _text.setAttr(0);
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

            _text.setAttr(0);
            _text.setColor(0xFFFFFFFF);
            _text.setFont(FontType.SMALL);

            _text.drawString(BX, BY,      "                   Vibrant v1.6");
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
                _text.setCursorPosition(BX, BY + 48);
                _text.outputString("       Keys");
                _text.setColor(clgrey);
                _text.setCursorPosition(BX, BY + 64);
                _text.outputString("   move: ARROWS");
                _text.setCursorPosition(BX, BY + 80);
                _text.outputString("   fire: CTRL, C");
                _text.setCursorPosition(BX, BY + 96);
                _text.outputString("   turbo: SHIFT, X");
                _text.setCursorPosition(BX, BY + 112);
                _text.outputString("   catch: SPACE, Z");
            }

            {
                BX = 101 + 27 * 8;
                BY = 101 + 4 * 16 - 4;
                _text.setColor(clwhite);
                _text.setCursorPosition(BX, BY + 48);
                _text.outputString("      Credits");
                _text.setColor(clgrey);
                _text.setCursorPosition(BX, BY + 64);                    
                _text.outputString("   code: ponce");
                _text.setCursorPosition(BX, BY + 80);
                _text.outputString("   music: DeciBeats");
                _text.setCursorPosition(BX + 8 * 10, BY + 96);
                _text.outputString("aka Evil");
            }
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
            _text.setAttr(0);
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