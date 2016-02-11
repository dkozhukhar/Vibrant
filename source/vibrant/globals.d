module globals;

import palettes;

/* contains some globals */

const int SCREENX = 960,
          SCREENY = 540,
          NUMBER_OF_IA = 30,
      ENERGYMAX = 1023,
      TURBO_COST = 5,
      BULLET_COST = 150;

const float RELOADTIME = 12 / 60.0f;
const float TURBO_FACTOR = 3.5f;

const BASE_ENERGY_GAIN = 1.92f;

const TURNSPEED = 0.0462;
const BULLET_SIZE = 2.0;
const LIFEREGEN = 0.0004;
const BULLET_DAMAGE = 0.38;
const COLLISION_DAMAGE_FACTOR = 0.08;
const DRAG_DISTANCE = 145;
const SPEED_MAX = 100;
const PARTICUL_FACTOR = 15;
const PLAYER_BASE_VELOCITY = 0.13;
const MAX_INVINCIBILITY = 16;
///const BULLET_BASE_SPEED = 1.0f;
const BULLET_BASE_SPEED = 5.0f;
const DAMAGE_MULTIPLIER = 1.6f;

const SHIP_MIN_SIZE = 7.0f;
///const SHIP_MAX_SIZE = 12.0f;
const SHIP_MAX_SIZE = 36.0f;

const OUT_OF_SIGHT = 240000;
const OUT_OF_SIGHT_SQUARED = 240000.0f * 240000.0f;


const string[] TIPS =
[
  "Tip: Hit SPACE to capture a powerup.",
  "Tip: Hit SPACE to capture ennemies.",
  "Tip: You can play with a joypad.",
  "Tip: You can give traps away.",
  "Tip: Blast bullets are guided.",
  "Tip: Borders can give you energy.",
  "Tip: Borders deplete your energy.",
  "Tip: Borders break captures.",
  "Tip: Borders terminate invicibility.",
  "Tip: Don't get too fat.",
  "Tip: No, inertia won't be removed.",
  "Tip: Blue bullets inflict 2x damage.",
  "Tip: Take a look at our other products!",
  "Tip: Visit our website to get updates.",  
  "Tip: Enemies get smarter and smarter.",
  "Tip: WASD + mouse are alternate keys.",
  "Tip: You get 2 safe seconds on respawn.",
  "Tip: Press P for pausing.",
  "Tip: It's OK to loose often."
];

__gshared float bullettimeTime = 0;
__gshared int level = 0;
__gshared bool lastTimeButton2WasOff = true;



