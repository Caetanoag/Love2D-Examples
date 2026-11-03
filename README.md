# Love2D Examples

A collection of my Love2D development exercises.

## Examples

- [`bouncing_balls/`](bouncing_balls/) — Bouncing balls with collision physics,
  particle sparks, and procedural impact sounds.

## Running

Each subfolder is a standalone Love2D project. From the repository root:

    love bouncing_balls/

Or navigate into the project folder and run:

    cd bouncing_balls
    love .

## Requirements

- [LÖVE 11.5+](https://love2d.org)
- Arch Linux: `sudo pacman -S love`
- Any editor works; [VS Code](https://code.visualstudio.com/) with the
  Love2D extension is a common choice.

## Structure

Each example follows this layout:

    example_name/
    ├── assets/          # images, sounds, fonts
    ├── conf.lua         # window and module configuration
    ├── main.lua         # entry point (love.load / update / draw)
    └── src/             # game modules