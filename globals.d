module globals;

import palettes;

/* contains some globals */

const int SCREENX = 640,
          SCREENY = 480,
          NUMBER_OF_IA = 30,
      ENERGYMAX = 1023,
      TURBO_COST = 5,
      BULLET_COST = 150;

const float RELOADTIME = 12 / 60.f;
const float TURBO_FACTOR = 3.5f;

const BASE_ENERGY_GAIN = 1.92f;

const TURNSPEED = 0.0462;
const BULLET_SIZE = 2.0;
const LIFEREGEN = 0.0004;
const BULLET_DAMAGE = 0.38;
const COLLISION_DAMAGE_FACTOR = 0.08;
const DRAG_DISTANCE = 145;
const SPEED_MAX = 100;
const PARTICUL_FACTOR = 10;
const PLAYER_BASE_VELOCITY = 0.13;
const MAX_INVINCIBILITY = 16;
const BULLET_BASE_SPEED = 1.f;
const DAMAGE_MULTIPLIER = 1.6f;


const char[][] TIPS =
[
  "Hit SPACE to capture a powerup.",
  "Hit SPACE to capture ennemies.",
  "You can play with a joypad.",
  "You can give traps away.",
  "Strafe is possible.",
  "Blast bullets are guided.",
  "Borders can give you energy.",
  "Borders deplete your energy.",
  "Borders break captures.",
  "Don't get too fat.",
  "No, we won't remove inertia.",
  "Blue bullets.",
  "Take a look at our other products!",
  "Visit our website to get updates.",  
  "Enemies get smarter and smarter.",
  "WASD + mouse are alternate keys.",
  "You get 2 safe seconds on respawn.",
  "Press P for pausing.",
  "It's OK to loose often."
];

float bullettimeTime = 0;
int level = 0;
bool lastTimeButton2WasOff = true;
float timeBeforeReborn = 0.f;

bool terminated = false;



