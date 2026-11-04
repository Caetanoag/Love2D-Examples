# Love2D Examples

A collection of my LÖVE (Love2D) development exercises. Each example is a
standalone project that can be run on its own.

## Examples

- [`bouncing_balls/`](bouncing_balls/) — Bouncing balls with collision physics,
  particle sparks, and procedural impact sounds. See the
  [guide](bouncing_balls/guide.md) for a detailed walkthrough.
- [`pong/`](pong/) — Pong with a menu, single-player matches against an AI with
  three difficulty levels, and local two-player mode.

## Running

Each subfolder is a standalone Love2D project. From the repository root:

    love bouncing_balls/
    love pong/

Or navigate into a project folder and run:

    cd pong
    love .

### Bouncing Balls

You can choose how many balls to start with by passing a number after the game
path:

    love bouncing_balls/ 25

- Default: **10 balls**
- Valid range: **1–100** (`MAX_BALLS` in `main.lua`)

### Pong

Run `love pong/` and pick a mode from the menu:

- **2 Players** — local multiplayer.
- **1 Player** — Easy, Medium, or Hard AI.
- **Quit**

First player to **10 points** wins, and the game restarts automatically after a
short delay.

## Controls

### Bouncing Balls

| Input | Action |
| ----- | ------ |
| `R` | Restart with a fresh random layout |
| Close window | Quit |

### Pong

| Input | Action |
| ----- | ------ |
| `W` / `S` | Move the left paddle |
| `Up` / `Down` | Move the right paddle (2 Players) or navigate the menu |
| `Enter` | Select a menu option |
| `R` | Restart the game |
| Close window | Quit |

## Requirements

- [LÖVE 11.5+](https://love2d.org)
- Arch Linux: `sudo pacman -S love`

## Structure

Each example follows a similar layout:

    example_name/
    ├── assets/          # images, sounds, fonts (if needed)
    ├── conf.lua         # window and module configuration
    ├── main.lua         # entry point (love.load / update / draw)
    └── src/             # game modules

Not every example uses every folder — `pong/`, for instance, has no assets and
draws everything with primitives.

| Project | Modules |
| ------- | ------- |
| `bouncing_balls/` | `ball`, `vector`, `spark`, `sound`, `textures` |
| `pong/` | `ball`, `pad`, `ai`, `input`, `vector` |

## License

[MIT](LICENSE)
