module postprocessing;

import math.all;
import gl.all;
import misc.logger;
import sdl.all;
import globals;
import camera;


// Handle the post-processing

final class PostProcessing
{
    private
    {
        box2i m_viewport;

        Shader m_finalShader;

        Texture2D m_mainBuffer;

        Texture2D m_motionBuffer, m_HUDBuffer;

        FBO m_defaultFBO;


        mat4f oldViewTransform;

        bool firstFrame = true;

        Shader m_motionShader; // motion blur shader
        FBO m_motionFBO;
    }

    public
    {
        this(FBO defaultFBO, Texture2D mainBuffer, box2i viewport, Texture2D HUDBuffer)
        {
            m_viewport = viewport;
            m_mainBuffer = mainBuffer;
            m_defaultFBO = defaultFBO;

            m_finalShader = new Shader("data/final.vs", "data/final.fs");

            m_HUDBuffer = HUDBuffer;
        }


        void render(mat4f viewTransform, vec3f globalColor)
        {
            float ratio = m_viewport.width / cast(float)(m_viewport.height);


            GL.disable(GL.DEPTH_TEST, GL.ALPHA_TEST, GL.CULL_FACE, GL.BLEND);
            GL.viewport = box2i(0, 0, m_viewport.width, m_viewport.height);



        /*    mat4d modelViewMatrix = mat4d.scale(vec3d(2.f * invzoomfactor / SCREENY / ratio, 2.f * invzoomfactor / SCREENY,1.f))
                                    * mat4d.rotateZ(-cam.angle)
                                    * mat4d.translate(vec3d(-cam.pos.to!(double), 0.f));

        *///    viewTransform = modelViewMatrix;//mat4d.translate(vec3d(-cam.pos.to!(double), 0.f));

        viewTransform  = mat4f.identity;
            if (firstFrame)
            {
                oldViewTransform = viewTransform;
                firstFrame = false;
            }

            mat4f viewTransformInv = viewTransform.inversed();


            GL.projectionMatrix = mat4f.scale(vec3f(1 / ratio, 1, 1));
            GL.modelviewMatrix = mat4f.identity;

            m_mainBuffer.generateMipmaps();

            m_defaultFBO.use();
         //   m_defaultFBO.setDrawBuffers(0);

            GL.viewport = m_viewport;

            m_finalShader.use();
            m_finalShader.setSampler("tex", m_mainBuffer);
            m_finalShader.set3f("globalColor", globalColor);

            {
                GL.begin(GL.QUADS);
                    auto smin = m_mainBuffer.smin;
                    auto tmin = m_mainBuffer.tmin;
                    auto smax = m_mainBuffer.smax;
                    auto tmax = m_mainBuffer.tmax;

                    GL.texCoord(0, smin, tmin);
                    GL.vertex(-ratio,-1);
                    GL.texCoord(0, smax, tmin);
                    GL.vertex(+ratio,-1);
                    GL.texCoord(0, smax, tmax);
                    GL.vertex(+ratio,+1);
                    GL.texCoord(0, smin, tmax);
                    GL.vertex(-ratio,+1);
                GL.end();
            }

            m_finalShader.unuse();



        }
    }
}

