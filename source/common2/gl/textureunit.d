module gl.textureunit;

import derelict.opengl3.gl3;
import derelict.opengl3.deprecatedConstants;
import derelict.opengl3.deprecatedFunctions;

import misc.singleton;
import gl.texture;
import gl.state;
import gl.textureunit;

import std.string;


// state of OpenGL texture units
final class TextureUnits
{
    private
    {
        Texture[] binded; // currently bound textures

        int[] usedSince; // queue to find last used texture

        int maxTextureUnits; // maximum texture units
        int fixedFunctionTextureUnits; // fixed-function texture units
        int m_activeTextureUnit = 0;

        Texture.Filter[] currentMinFilter;
        Texture.Filter[] currentMagFilter;
        Texture.Wrap[] currentWrapS, currentWrapT, currentWrapR;
        int[] currentMinLOD, currentMaxLOD;

        /**
         * Find the texture unit where texture is bound
         * Returns -1 if not bound
         */
        int find(Texture texture)
        {
            for (int i = 0; i < binded.length; ++i)
            {
                if (binded[i] is texture)
                {
                    return i;
                }
            }
            return -1;
        }

        void activatetextureUnit(int index)
        {
            if (index != m_activeTextureUnit)
            {
                glActiveTexture(GL_TEXTURE0 + index);
                m_activeTextureUnit = index;
            }
        }

        static final int getMaxTextureUnit()
        {
            GLint ntu;
            glGetIntegerv(GL_MAX_TEXTURE_UNITS, &ntu);
            return ntu;
        }

        static final int getMaxTextureImageUnit()
        {
            GLint ntu;
            glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, &ntu);
            return ntu;
        }

        void unbind(int i)
        {
            doBind(i, null);
        }

        void printInfo()
        {
            int oldActive = m_activeTextureUnit;
            for (int i = 0; i < maxTextureUnits; ++i)
            {
                activatetextureUnit(i);

                int texture1D, texture2D, texture3D;
                int texture1Dbinding, texture2Dbinding, texture3Dbinding, textureCubebinding;

                if (i < fixedFunctionTextureUnits)
                {
                    glGetIntegerv(GL_TEXTURE_1D, &texture1D);
                    glGetIntegerv(GL_TEXTURE_2D, &texture2D);
                    glGetIntegerv(GL_TEXTURE_3D, &texture3D);
                    glGetIntegerv(GL_TEXTURE_BINDING_1D, &texture1Dbinding);
                    glGetIntegerv(GL_TEXTURE_BINDING_2D, &texture2Dbinding);
                    glGetIntegerv(GL_TEXTURE_BINDING_3D, &texture3Dbinding);
                    glGetIntegerv(GL_TEXTURE_BINDING_CUBE_MAP, &textureCubebinding);
                }
                else
                {
                    glGetIntegerv(GL_TEXTURE_BINDING_1D, &texture1Dbinding);
                    glGetIntegerv(GL_TEXTURE_BINDING_2D, &texture2Dbinding);
                    glGetIntegerv(GL_TEXTURE_BINDING_3D, &texture3Dbinding);
                }

                GL.check;
            }
            activatetextureUnit(oldActive);
        }

        void doBind(int i, Texture texture)
        {
            usedSince[i] = 0; // mark as reused

            Texture oldOne = binded[i];
            Texture newOne = texture;

            // unbind old one
            if ((oldOne !is null) && (oldOne !is newOne))
            {
                int target = binded[i].target;
                binded[i] = null;
                activatetextureUnit(i);


                // for ATI
/*                if (i < fixedFunctionTextureUnits) */ glDisable(target);

                if (newOne is null) glBindTexture(target, 0);


                GL.check();
            }

            if (newOne !is null)
            {

                // increment sinceUsed of every other texture unit
                // but hey, don't wrap
                {
                    for (int j = 0; j < usedSince.length; ++j)
                    {
                        if (usedSince[j] != int.max) usedSince[j]++;
                        assert(usedSince[j] >= 0);
                    }
                    usedSince[i] = 0;
                }

                 // bind texture in OpenGL
                activatetextureUnit(i);

                // for ATI
                if (newOne !is oldOne)
                {

                    glBindTexture(newOne.target, newOne.handle);
                    /*if (i < fixedFunctionTextureUnits)*/  glEnable(newOne.target);
                }

                // apply filters

                bool changed = oldOne !is newOne;

                if (changed || (currentMinFilter[i] != newOne.minFilter))
                {
                    currentMinFilter[i] = newOne.minFilter;
                    glTexParameteri(newOne.target, GL_TEXTURE_MIN_FILTER, Texture.Filter_toGL[newOne.minFilter]);
                }

                if (changed || (currentMagFilter[i] != newOne.magFilter))
                {
                    currentMagFilter[i] = newOne.magFilter;
                    glTexParameteri(newOne.target, GL_TEXTURE_MAG_FILTER, Texture.Filter_toGL[newOne.magFilter]);
                }

                if (changed || (currentWrapS[i] != newOne.wrapS))
                {
                    currentWrapS[i] = newOne.wrapS;
                    glTexParameteri(newOne.target, GL_TEXTURE_WRAP_S, Texture.Wrap_toGL[newOne.wrapS]);
                }

                if (changed || (currentWrapT[i] != newOne.wrapT))
                {
                    currentWrapT[i] = newOne.wrapT;
                    glTexParameteri(newOne.target, GL_TEXTURE_WRAP_T, Texture.Wrap_toGL[newOne.wrapT]);
                }

                if (changed || (currentWrapR[i] != newOne.wrapR))
                {
                    currentWrapR[i] = newOne.wrapR;
                    glTexParameteri(newOne.target, GL_TEXTURE_WRAP_R, Texture.Wrap_toGL[newOne.wrapR]);
                }

                if (changed || (currentMinLOD[i] != newOne.minLOD))
                {
                    currentMinLOD[i] = newOne.minLOD;
                    glTexParameteri(newOne.target, GL_TEXTURE_MIN_LOD, newOne.minLOD);
                }

                if (changed || (currentMaxLOD[i] != newOne.maxLOD))
                {
                    currentMaxLOD[i] = newOne.maxLOD;
                    glTexParameteri(newOne.target, GL_TEXTURE_MAX_LOD, newOne.maxLOD);
                }

                binded[i] = newOne;

                GL.check();
            }

            GL.check();
        }
    }

    public
    {
        this()
        {
            fixedFunctionTextureUnits = 4;//getMaxTextureUnit();
            maxTextureUnits = 4;//getMaxTextureImageUnit();

            binded.length = maxTextureUnits;
            usedSince.length = maxTextureUnits;

            currentMinFilter.length = maxTextureUnits;
            currentMagFilter.length = maxTextureUnits;
            currentWrapS.length = maxTextureUnits;
            currentWrapT.length = maxTextureUnits;
            currentWrapR.length = maxTextureUnits;
            currentMinLOD.length = maxTextureUnits;
            currentMaxLOD.length = maxTextureUnits;


            for (int i = 0; i < maxTextureUnits; ++i)
            {
                binded[i] = null;
                usedSince[i] = int.max;
                currentMinFilter[i] = cast(Texture.Filter)(-1);
                currentMagFilter[i] = cast(Texture.Filter)(-1);
                currentWrapS[i] = cast(Texture.Wrap)(-1);
                currentWrapT[i] = cast(Texture.Wrap)(-1);
                currentWrapR[i] = cast(Texture.Wrap)(-1);
                currentMinLOD[i] = -10000;
                currentMaxLOD[i] = 10000;
            }
        }


        /**
         * Bind a texture and return in which texture unit it was bound
         * No rebind if already bounded to a texture unit
         */
        int bind(Texture texture)
        {
            int index = find(texture);

            if (index == -1)
            {
                // not found
                // evict least recently bounded texture
                // (works if shader do not use more than available texture unit)
                int findLongestUnused()
                {
                    int max = -1;
                    int bestCandidate = 0;
                    for (int i = 0; i < usedSince.length; ++i)
                    {
                        if (max < usedSince[i])
                        {
                            bestCandidate = i;
                            max = usedSince[i];
                        }
                    }

                    // we have a winner
                    return bestCandidate;
                }

                index = findLongestUnused();
            }

            doBind(index, texture);

            return index;
        }

        /**
         * Bind a texture to specified texture unit.
         */
        int bind(int index, Texture texture)
        {
            int oldIndex = find(texture);

            if ((oldIndex > 0) && (oldIndex != index)) unbind(texture);

            doBind(index, texture);
            return index;
        }

        // unbind all occurence of texture (should be 0 or 1)
        void unbind(Texture texture)
        {
            bool found = false;
            int foundIndex = -1;
            for (int i = 0; i < usedSince.length; ++i)
            {
                if (binded[i] is texture)
                {
                    if (found == true)
                    {
                        assert(false); // duplicate texture in texture units ?
                    }

                    unbind(i);

                    found = true;
                    foundIndex = i;
                }
            }
        }

        // unbind all textures !
        void unbindAll()
        {
            for (int i = 0; i < usedSince.length; ++i)
            {
                if (binded[i] !is null)
                {
                    unbind(i);
                }
            }
        }

        /**
         * Find the texture unit where texture is bound
         * Returns -1 if not bound
         */
        bool isBound(Texture texture)
        {
            return -1 != find(texture);
        }
    }
}

