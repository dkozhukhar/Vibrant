module sdl.mixer;

//import math.all;
import std.string;

import derelict.sdl.sdl, derelict.sdl.mixer;

import misc.singleton;
import sdl.state;
import math.all;




final class SDLMixer
{
	mixin Singleton;

	private
	{
		Chunk[Mix_Chunk *] m_chunkPool;

		bool m_initialized = false;
		SDL m_SDL;

		this(int numChannels = 16)
		{
			DerelictSDLMixer.load();
			m_SDL = SDL.instance;
			m_SDL.subSystemInit(SDL_INIT_AUDIO);

			int res = Mix_OpenAudio(44100, AUDIO_S16SYS, 2, 1024);

			if (res == -1) throw new SDLError("Mix_OpenAudio failed");

			m_initialized = true;

			Mix_AllocateChannels(numChannels);

			m_channels.length = numChannels;

			for (int i = 0; i < m_channels.length; ++i)
			{
				m_channels[i] = new Channel(this, i);
			}
		}

		~this()
		{
			if (m_initialized) Mix_CloseAudio();
            // DerelictSDLMixer.unload();
		}

		Channel[] m_channels;
	}

	alias extern(C) void function () finishCallback;

	public
	{
		Channel channel(int i)
		{
			return m_channels[i];
		}

		Chunk createChunk(string wavFile)
		{
			Chunk chunk = new Chunk(this, wavFile);
			m_chunkPool[chunk.handle] = chunk;

			return chunk;
		}

		void hookMusicFinished(finishCallback hook)
		{
			Mix_HookMusicFinished(hook);
		}
	}
}

final class Chunk
{
	private
	{
		Mix_Chunk *m_handle;
		SDLMixer m_SDLMixer;
	}

	package
	{
		this(SDLMixer mixer, string filename)
		{
			m_SDLMixer = mixer;
			m_handle = Mix_LoadWAV(filename);
			if (m_handle is null) throw new SDLError(format("Unable to load the %s", filename));
		}
	}

	public
	{
		// play on a free channel
		void play(float volume)
		{
			int vol = cast(int)round(clamp(volume, 0.0f, 1.0f)) * 127;
			if (vol <= 0) return;

			Mix_VolumeChunk(m_handle, vol);
			int index = Mix_PlayChannel(-1, m_handle, 0);

		}

		Mix_Chunk * handle()
		{
			return m_handle;
		}

		void playPosition(float volume, float distance, float angle)
		{
			int vol = cast(int)round(clampf(volume * exp(-distance * 0.03), 0.0f, 1.0f) * 127);
			if (vol <= 0) return;
			/*
			int dist = round(clamp(volume, 0.0f, 1.0f) * 255);
			if (dist <= 0) dist = 0;
			if (dist >= 255) dist = 255;
			*/
			Mix_VolumeChunk(m_handle, vol);
			int index = Mix_PlayChannel(-1, m_handle, 0);
			if (index != -1)
			{

				void panLaw(float x, out float left, out float right)
				{
					x *= 0.5f;
					if (x < -0.5f) x = -0.5f;
					if (x > 0.5f) x = 0.5f;
					right = 1.0f - sqr(x - 0.5f);
					left = 1.0f - sqr(x + 0.5f);
				}

				float l, r;
				panLaw(sin(angle), l, r);

				int left = cast(int)round(127 * l);
				int right = cast(int)round(127 * r);

                //				Mix_SetPanning(index, cast(ubyte)left, cast(ubyte)right);

                //			Mix_SetDistance(index, cast(ubyte)dist);
			}
		}

	}

}

final class Music
{
	private
	{
		Mix_Music *m_handle;
	}

	public
	{
		this(string filename)
		{
			m_handle = Mix_LoadMUS(toStringz(filename));
			if (m_handle is null) 
            {
                string msg = format("Unable to load the music %s", filename);
                throw new SDLError(msg);			
            }
		}

		~this()
		{
			if (m_handle !is null) 
			{
				Mix_FreeMusic(m_handle);
			}
		}

		void play(bool loop)
		{
			Mix_PlayMusic(m_handle, loop ? -1 : 1);
		}

        void stop()
        {
            Mix_HaltMusic();
        }

		void playFadeIn(bool loop, int ms)
		{
			Mix_FadeInMusic(m_handle, loop ? -1 : 1, ms);
		}

		static float setVolume(float v)
		{
			int vi = cast(int)round(clamp(v, 0.0f,1.0f) * MIX_MAX_VOLUME);
			Mix_VolumeMusic(vi);
			return v;
		}

	}
}

final class Channel
{
	private
	{
		SDLMixer m_SDLMixer;
		int m_index;
	}

	package
	{
		this(SDLMixer m, int index)
		{
			m_SDLMixer = m;
			m_index = index;
		}
	}

	public
	{
		void unregisterAllEffects()
		{
			Mix_UnregisterAllEffects(m_index);
		}

		float pan(float x)
		{

			vec2f panLaw(float x)
			{
				x *= 0.5f;
				if (x < -0.5f) x = -0.5f;
				if (x > 0.5f) x = 0.5f;
				float r_gain = 1.0f - sqr(x - 0.5f);
				float l_gain = 1.0f - sqr(x + 0.5f);
				return vec2f(l_gain, r_gain);
			}

			vec2f volume = panLaw(x);

			int left = cast(int)round(127 * volume.x);
			int right = cast(int)round(127 * volume.y);

			Mix_SetPanning(m_index, cast(ubyte)left, cast(ubyte)right);
			return x;
		}

		float volume(float v)
		{
			float v2 = clamp(v, 0.0f, 1.0f);
			Mix_Volume(m_index, cast(int)round(v2 * 127));

			return v;
		}

	}

}
