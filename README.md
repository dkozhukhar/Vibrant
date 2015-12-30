# Vibrant

Vibrant is an unique experience of fast-paced arena shooter action revolving around inertia and dog-fighting. You will meet with increasingly numerous enemies in a blissful techno trance until you meet your fate.

![Vibrant game screenshot](https://img.itch.io/aW1hZ2UvMjYyNTQvMTA2MjI4LnBuZw==/original/tafu0o.png)

You can find the game page here: http://gamesfrommars.fr/vibrant
or here: http://ponce.itch.io/vibrant

## Hot to build

It's very simple, especially on Windows.

- make sure you have DUB, the D package manager: https://code.dlang.org/download

- type `dub` in the root directory

- then the game will run but will crash because of not finding the right dynamic libraries. You need SDL2 and SDL_mixer 2.0+
  * on Windows, copy DLLs from `32-bit dependencies/` or `64-bit dependencies/` directory
  * on Ubuntu, you'll need to install SDL2 and SDL2_mixer
  * on Mac, copy the executable in the bundle, along with relevant SDL2 and SDL2_mixer bundles. This is a bit tricky, look how its done on OS X release: http://gamesfrommars.fr/vibrant

## License

The software is licensed under the Boost 1.0 software license.
The music's right are held by Nelson Rafael.
