module misc.image;

import math.common;
import math.random;
import misc.colors;

import core.stdc.stdlib;

import sdl.sdlimage;

version(useDevIL)
{
    import misc.devilimage;
}
import std.stdio;
import std.c.string;

final class Image
{
    private
    {
        uint[] m_data;
        int m_width, m_height;

        this(int width, int height, uint[] data)
        {
            m_width  = width;
            m_height = height;
            m_data = data;
        }

        public int clippingFlag(int x, int y)
        {
            int r = 0;
            if (x < 0) r |= 8;
            if (x >= width) r |= 4;
            if (y < 0) r |= 2;
            if (y >= height) r |= 1;
            return r;
        }
    }

    public
    {
        this(int width, int height)
        {
            m_width = width;
            m_height = height;
            uint* pData = cast(uint*) malloc(width * height * uint.sizeof);
            m_data = pData[0..width * height]; // never freed since Image are long-time resources and the OS will reclaim memory :)
        }

        version(useDevIL)
        {
            this(DevilImage image)
            {
                this(image.width, image.height); // allocate some space
                memcpy(m_data.ptr, image.data(), uint.sizeof * m_data.length);
            }
        }

        this(SDLImage image)
        {
            this(image.width, image.height); // allocate some space
            // lock and copy
            image.lock();
            memcpy(m_data.ptr, image.data(), uint.sizeof * m_data.length);
            //moveDWords(image.data(), m_data.ptr, m_data.length);
            image.unlock();
        }

        version(useDevIL)
        {
            this(string filename)
            {
                scope di = new DevilImage(filename);
                this(di);
            }


            void save(string filename)
            {
                scope DevilImage devilImage = new DevilImage();
                devilImage.setData(m_width, m_height, ptr());
                devilImage.saveImage(filename);
            }
        }

        final int width()
        {
            return m_width;
        }

        final int height()
        {
            return m_height;
        }

        final uint * ptr()
        {
            return m_data.ptr;
        }

        uint[] data() { return m_data; }

        uint getPixel(int x, int y)
        {
            if (x < 0) x = 0;
            if (y < 0) y = 0;
            if (x >= width) x = width - 1;
            if (y >= height) y = height - 1;

            return m_data[x + y * m_width];
        }

        void get4Pixel(int x, int y, ref uint a, ref uint b, ref uint c, ref uint d) // to speed up sample function
        {
            if (x < 0) x = 0;
            if (y < 0) y = 0;
            if (x > width - 2) x = width - 2;
            if (y > height - 2) y = height - 2;
            uint * p = m_data.ptr + (x + y * m_width);
            a = *p;
            b = *(p + 1);
            c = *(p + m_width);
            d = *(p + m_width + 1);
        }

        uint sample(float x, float y)  // linear interpolation
        {
            float nx = fract(x) * width;
            float ny = fract(y) * height;
            int i = cast(int)nx;
            int j = cast(int)ny;
            float s = nx - i;
            float t = ny - j;

            uint a, b, c, d;
            get4Pixel(i, j, a, b, c, d);

            uint si = cast(uint)(s * 256.0);
            uint ti = cast(uint)(t * 256.0);

            uint ab = colorMix(a, b, 256 - si, si);
            uint cd = colorMix(a, b, 256 - si, si);

            return colorMix(ab, cd, 256 - ti, ti);
        }

        uint getPixel_unchecked(uint x, uint y)
        {
            return m_data[x + y * m_width];
        }

        void drawPixel(uint x, uint y, uint c)
        {
            if ((x >= m_width) || (y >= m_height)) return;
            m_data[x + y * m_width] = c;
        }

        // blend destination pixel with c, using the alpha value
        void blendPixel(uint x, uint y, uint c, int alpha, int alphaAlpha)
        {
            if ((x >= m_width) || (y >= m_height)) return;
            m_data[x + y * m_width] = colorMix(c, m_data[x + y * m_width], alpha, 256 - alpha, alphaAlpha, 256 - alphaAlpha);
        }

        void drawPixel_unchecked(uint x, uint y, uint c)
        {
            m_data[x + y * m_width] = c;
        }

        final bool xvalid(int x)
        {
            return ((x > 0) && (x < width));
        }

        final bool yvalid(int y)
        {
            return ((y > 0) && (y < height));
        }

    /*    final int randX()
        {
            return randRange(width);
        }

        final int randY()
        {
            return randRange(height);
        }
    */
        final void fill(uint c)
        {
            m_data[] = c; // plus rapide que setDWords
        }

        final uint * pixelAddress(int x, int y)
        {
            return m_data.ptr + (y * m_width + x);
        }

        void drawHLine(int x1, int x2, int y, int c)
        {
            if (!yvalid(y)) return;
            if (x1 > x2) swap(x1, x2);

            if (x1 < 0)
            {
                x1 = 0;
                if (x2 < 0) x2 = 0;
            }
            if (x2 >= width)
            {
                x2 = width-1;
                if (x1 >= width) x1 = width - 1;
            }

            uint * p = pixelAddress(x1, y);

            for (int i = x1; i <= x2; i++)
            {
                *p++ = c;
            }

        }

        void drawVLine(int x, int y1, int y2, int c)
        {
            if (!xvalid(x)) return;
            if (y1 > y2) swap(y1, y2);

            if (y1 < 0)
            {
                y1 = 0;
                if (y2 < 0) y2 = 0;
            }
            if (y2 >= height)
            {
                y2 = height-1;
                if (y1 >= height) y1 = height-1;
            }

            uint * p = pixelAddress(x, y1);

            for (int i = y1; i <= y2; i++)
            {
                *p = c;
                p += width;
            }
        }

        void drawBox(int x1,int y1,int x2,int y2, int c)
        {
            drawHLine(x1,x2,y1,c);
            drawHLine(x1,x2,y2,c);
            drawVLine(x1,y1,y2,c);
            drawVLine(x2,y1,y2,c);
        }

        void drawFilledBox(int x1,int y1,int x2,int y2, int c)
        {
            if (x1 > x2) swap(x1, x2);
            if (y1 > y2) swap(y1, y2);

            if (x1 < 0) x1 = 0;
            if (x2 >= width) x2 = width - 1;
            if (y1 < 0) y1 = 0;
            if (y2 >= height) y2 = height - 1;

            for (int i = y1; i <= y2; i++)
            {
                drawHLine(x1,x2,i,c);
            }
        }

        void drawCircle(int x, int y, int r, int c) {
            if (r < 0) return;
            if (r == 0) drawPixel(x,y,c);
            else drawEllipse(x,y,r,r,c);
        }

        void drawFilledCircle(int x, int y, int r, int c) {
            if (r < 0) return;
            if (r == 0) drawPixel(x,y,c);
            else drawFilledEllipse(x,y,r,r,c);
        }

        void drawEllipse (int mx, int my, int a, int b, int c) // Bresenham ellipse
        {
            drawPixel(mx + a, my,c);
            drawPixel(mx - a, my,c);
            int mx1 = mx - a;
            int my1 = my;
            int mx2 = mx + a;
            int my2 = my;
            int aq = a * a;
            int bq = b * b;
            int dx = aq << 1;
            int dy = bq << 1;
            int r = a * bq;
            int rx = r << 1;
            int ry = 0;
            int x = a;
            while (x > 0) {
                if (r > 0) {
                    my1++;
                    my2--;
                    ry += dx;
                    r -= ry;
                }
                if (r <= 0)
                {
                    x--;
                    mx1++;
                    mx2--;
                    rx -= dy;
                    r += rx;
                }
                drawPixel(mx1,my1,c);
                drawPixel(mx1,my2,c);
                drawPixel(mx2,my1,c);
                drawPixel(mx2,my2,c);
            }
        }

        void drawFilledEllipse (int mx, int my, int a, int b, int c) // Bresenham filled ellipse
        {
            drawHLine(mx - a, mx + a, my, c);
            int mx1 = mx - a;
            int my1 = my;
            int mx2 = mx + a;
            int my2 = my;
            int aq = a * a;
            int bq = b * b;
            int dx = aq << 1;
            int dy = bq << 1;
            int r = a * bq;
            int rx = r << 1;
            int ry = 0;
            int x = a;
            while (x > 0) {
                if (r > 0) {
                    my1++;
                    my2--;
                    ry += dx;
                    r -= ry;
                }
                if (r <= 0)
                {
                    x--;
                    mx1++;
                    mx2--;
                    rx -= dy;
                    r += rx;
                }
                drawHLine(mx1,mx2,my1,c);
                drawHLine(mx1,mx2,my2,c);
            }
        }

        void drawLine(int x1, int y1, int x2, int y2, int c) // full Bresenham line algorithm
        {
            int x, y, s1, s2, e, deltax, deltay, c1, c2, dx, dy;
            c1 = clippingFlag(x1,y1);
            c2 = clippingFlag(x2,y2);
            if ((c1 & c2) != 0) return; // line outside buffer limits
            dx = x2-x1;
            dy = y2-y1;
            if (c1 != 0) { // clipping stuff
                if ((c1 & 8) != 0) { y1 = y1 + cast(int)(dy*(-x1)/cast(double)dx); x1 = 0; }
                if ((c1 & 4) != 0) { y1 = y1 + cast(int)(dy*(width-1-x1)/cast(double)dx); x1 = width-1; }
                if ((c1 & 2) != 0) { x1 = x1 + cast(int)(dx*(-y1)/cast(double)dy); y1 = 0 ; }
                if ((c1 & 1) != 0) { x1 = x1 + cast(int)(dx*(height-1-y1)/cast(double)dy); y1 = height-1; }
                if ((clippingFlag(x1,y1) & c2) != 0) return;
            } else if (c2 != 0) {
                if ((c2 & 8) != 0) { y2 = y2 + cast(int)(dy*(-x2)/cast(double)dx); x2 = 0; }
                if ((c2 & 4) != 0) { y2 = y2 + cast(int)(dy*(width-1-x2)/cast(double)dx); x2 = width-1; }
                if ((c2 & 2) != 0) { x2 = x2 + cast(int)(dx*(-y2)/cast(double)dy); y2 = 0; }
                if ((c2 & 1) != 0) { x2 = x2 + cast(int)(dx*(height-1-y2)/cast(double)dy); y2 = height-1; }
                if ((clippingFlag(x2,y2) & c1) != 0) return;
            }

            x = x1;
            y = y1;
            s1 = (x1 > x2 ? -1 : 1);
            s2 = (y1 > y2 ? -1 : 1);
            deltay = std.math.abs(y2-y1);
            deltax = std.math.abs(x2-x1);

            if (deltax == 0) {
                if (deltay == 0) {
                    drawPixel(x,y1,c);
                } else {
                    drawVLine(x,y1,y2,c);
                }
                return;
            }

            if (deltay == 0) {
                drawHLine(x1,x2,y,c);
                return;
            }

            if (deltax <  deltay)
            {
                e = 2*(deltax-deltay);
                for (int i = deltay; i > 0; i--) {
                    drawPixel(x,y,c);
                    while(e >= 0) {
                        x += s1;
                        e -= (2 * deltay);
                    }
                    y += s2;
                    e += (2 * deltax);
                }
            } else {
                e = 2*(deltay-deltax);
                for (int i = deltax; i > 0; i--) {
                    drawPixel(x,y,c);
                    while(e >= 0) {
                        y += s2;
                        e -= (2 * deltax);
                    }
                    x += s1;
                    e += (2 * deltay);
                }

            }
        }

        void drawTriangle(int x1,int y1,int x2,int y2,int x3,int y3, int c)
        {
            auto flags = clippingFlag(x1, y1) & clippingFlag(x2, y2) & clippingFlag(x3, y3);
            if (0 == flags)
            {
                if (x2 < x1)
                {
                    swap(x1, x2);
                    swap(y1, y2);
                }
                if (x3 < x1)
                {
                    swap(x1, x3);
                    swap(y1, y3);
                }
                if (x3 < x2)
                {
                    swap(x2, x3);
                    swap(y2, y3);
                }
                int dx12 = x2 - x1, dx13 = x3 - x1, dx23 = x3 - x2;
                int dy12 = y2 - y1, dy13 = y3 - y1, dy23 = y3 - y2;

                alias float fp_number;

                fp_number py123 = y1 + cast(fp_number)0.5, py13 = y1 + cast(fp_number)0.5;
                fp_number c1, c2, c3;

                if (dx12 != 0) c2 = dy12 / cast(fp_number)dx12;
                if (dx23 != 0) c3 = dy23 / cast(fp_number)dx23;
                if (dx13 != 0) c1 = dy13 / cast(fp_number)dx13; else
                {
                    drawVLine(x1, max(y1, max(y2, y3)), min(y1, min(y2, y3)), c);
                    c1 = 0;
                }

                for (int i = x1; i < x2; i++)
                {
                    py13 += c1;
                    py123 += c2;
                    drawVLine(i, cast(int)py123, cast(int)py13, c);
                }
                py123 = y2 + cast(fp_number)0.5;
                py13 = py13 + c1;
                drawVLine(x2, cast(int)py123, cast(int)py13, c);
                for (int i = x2 + 1; i < x3; i++)
                {
                    py13 += c1;
                    py123 += c3;
                    drawVLine(i, cast(int)py123, cast(int) py13, c);
                }
                drawPixel(x3, y3, c);
            }
        }

        void drawImage(Image img, int x,int y)
        {
            for (int j = 0; j < img.height; j++)
                for (int i = 0; i < img.width; i++)
                {
                    drawPixel(x + i, y + j, img.getPixel(i,j));
                }
        }

        void blendImage(Image img, int x, int y)
        {
            for (int j = 0; j < img.height; j++)
                for (int i = 0; i < img.width; i++)
                {
                    uint csrc = img.getPixel(i,j);
                    int alpha = Avalue(csrc);
                    blendPixel(x + i, y + j, csrc, alpha, 0);
                }
        }




        void blur(int attenuate) // effet de flou sur le buffer, noir sur les bords
        {

            int p = 0;
            for (int i = 0; i < width; i++) {
                m_data[p++] = 0; // noir
            }
            for (int j = 1; j < height-1; j++)
            {
                m_data[p++] = 0;
                for (int i = 1; i < width-1; i++)
                {
                    uint e1 = m_data[p-width], e2 = m_data[p-1], e3 = m_data[p],
                        e4 = m_data[p+1], e5 = m_data[p+width];


                    uint ret;

                    version(D_InlineAsm_X86)
                    {
                           asm
                         {
                             movd MM0, e4;
                             movd MM1, e2;
                             movd MM2, e5;
                             movd MM3, e1;
                             movd MM5, e3;
                             pxor MM4, MM4;

                             punpcklbw MM0, MM4;
                            punpcklbw MM1, MM4;
                            punpcklbw MM2, MM4;
                            punpcklbw MM3, MM4;
                            punpcklbw MM5, MM4;

                            paddusw MM5, MM5;
                            paddusw MM5, MM5;
                            paddusw MM0, MM3;
                            paddusw MM0, MM1;
                            paddusw MM0, MM2;
                            paddusw MM0, MM5;

                            psraw MM0, 3;
                            packuswb MM0, MM0;

                            movd ret, MM0;

                         }
                    } else
                    {
                        int r1 = (e1 >> 24) & 255, g1 = (e1 >> 16) & 255, b1 = (e1 >> 8) & 255, a1 = e1 & 255;
                        int r2 = (e2 >> 24) & 255, g2 = (e2 >> 16) & 255, b2 = (e2 >> 8) & 255, a2 = e2 & 255;
                        int r3 = (e3 >> 24) & 255, g3 = (e3 >> 16) & 255, b3 = (e3 >> 8) & 255, a3 = e3 & 255;
                        int r4 = (e4 >> 24) & 255, g4 = (e4 >> 16) & 255, b4 = (e4 >> 8) & 255, a4 = e4 & 255;
                        int r5 = (e5 >> 24) & 255, g5 = (e5 >> 16) & 255, b5 = (e5 >> 8) & 255, a5 = e5 & 255;

                        int r = ((r1 + r2 + (r3 << 2) + r4 + r5) >> 3) + attenuate;
                        int g = ((g1 + g2 + (g3 << 2) + g4 + g5) >> 3) + attenuate;
                        int b = ((b1 + b2 + (b3 << 2) + b4 + b5) >> 3) + attenuate;
                        int a = ((a1 + a2 + (a3 << 2) + a4 + a5) >> 3) + attenuate;
                        if (r < 0) r = 0;
                        if (g < 0) g = 0;
                        if (b < 0) b = 0;
                        if (a < 0) a = 0;
                        if (r > 255) r = 255;
                        if (g > 255) g = 255;
                        if (b > 255) b = 255;
                        if (a > 255) a = 255;
                        ret = (r << 24) + (g << 16) + (b << 8) + a;
                    }


                    m_data[p++] = ret;

                }
                m_data[p++] = 0;
            }
            version(D_InlineAsm_X86)
            {
                asm
                {
                    emms;
                }
            }

            for (int i = 0; i < width; i++) {
                m_data[p++] = 0; // noir
            }

        }

        void smooth(ref uint e1, ref uint e2, ref uint e3, int threshold)
        {
            int r1 = (e1 >> 24) & 255, g1 = (e1 >> 16) & 255, b1 = (e1 >> 8) & 255, a1 = e1 & 255;
            int r2 = (e2 >> 24) & 255, g2 = (e2 >> 16) & 255, b2 = (e2 >> 8) & 255, a2 = e2 & 255;
            int r3 = (e3 >> 24) & 255, g3 = (e3 >> 16) & 255, b3 = (e3 >> 8) & 255, a3 = e3 & 255;

            int d1 = std.math.abs(r1 - r2) + std.math.abs(g1 - g2) + std.math.abs(b1 - b2);
            int d2 = std.math.abs(r3 - r2) + std.math.abs(g3 - g2) + std.math.abs(b3 - b2);
            if ((d1 + d2) > threshold)
            {
                    e2 = colorAvg(colorAvg(e1, e2), colorAvg(e3, e2));
            }
        }

        void fakeCSAA(int threshold) // faux antialisaing (blur selectif)
        {
            for (int j = 0; j < height; j++)
            {
                for (int i = 1; i < width-1; i++)
                {
                    uint * p = pixelAddress(i,j);
                    smooth(*(p-1), *p, *(p+1), threshold);
                }
            }

            for (int j = 1; j < height-1; j++)
            {
                for (int i = 0; i < width; i++)
                {
                    uint * p = pixelAddress(i,j);
                    smooth(*(p-width), *p, *(p+width), threshold);
                }
            }
        }

        void smooth(ref uint e1, ref uint e2, int threshold)
        {
            int r1 = (e1 >> 24) & 255, g1 = (e1 >> 16) & 255, b1 = (e1 >> 8) & 255;
            int r2 = (e2 >> 24) & 255, g2 = (e2 >> 16) & 255, b2 = (e2 >> 8) & 255;

            int d1 = (r1 - r2)*(r1 - r2) + (g1 - g2)*(g1 - g2) + (b1 - b2)*(b1 - b2);
            if (d1 > threshold)
            {
                    e1 = colorAvg(e1, e2);
            }
        }

        void fire(int threshold) // faux antialising (blur selectif)
        {
            for (int j = 0; j < height-1; j++)
            {
                for (int i = 0; i < width; i++)
                {
                    uint * p = pixelAddress(i,j);
                    smooth(*p, *(p+width), threshold);
                }
            }
        }
    }
}





