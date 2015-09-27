module bullettime;

import players;

final class BulletTime
{
    enum float MAX_BULLET_TIME = 20.0f;

    static
    {
        public
        {
            void enter(float time)
            {
                bullettimeTime += time;
                if (bullettimeTime > MAX_BULLET_TIME) bullettimeTime = MAX_BULLET_TIME;
            }

            void exit()
            {
                bullettimeTime = 0;
            }

            void progress(ref double dt)
            {
                BulletTime.decay(dt);
                bool playerNearDeath = ((player !is null) && (player.destroy == 0) && (player.isReallyReallyVulnerable));
                enabled = (bullettimeTime > 0) || playerNearDeath;

                if (enabled)
                {
                    dt *= 0.5f;
                }
            }

            bool isEnabled()
            {
                return enabled;
            }

            void decay(float dt)
            {
                bullettimeTime -= dt;
                if (bullettimeTime < 0) bullettimeTime = 0;
            }

            float remaining()
            {
                return bullettimeTime;
            }

            float fraction()
            {
                return remaining() / MAX_BULLET_TIME;
            }
        }

        __gshared private float bullettimeTime = 0.0f;
        private __gshared bool enabled = false;
    }
}
