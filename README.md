# Neon Pong

A fast, neon-on-black Pong duel for the [LUPI](https://lupi.api.br/docs/) console and the
[lupinho](https://github.com/lupi-org-br/lupinho) web simulator. Pure rally tension —
first to five.

This project is a **proof of concept** built following the
[lupi-game-skill](https://github.com/cellozero666/lupi-game-skill): a game-design and
platform skill that drives LUPI games through a design phase (concept, emotional canvas,
core loop, scope) before any gameplay code, and enforces LUPI-specific rules (palette,
`update(frame)` lifecycle, controller-first input, decoupled scene architecture).

## The game

Read the ball, position your paddle, and reflect. Every paddle hit re-aims the ball from
the contact point and speeds the rally up (up to a fair cap). Miss, and your opponent
scores. First to five wins.

- **1P vs CPU** — a CPU paddle with reaction delay and aim error.
- **2P LOCAL** — two players on one keyboard, or two physical gamepads.
- **Rally escalation** — speed ramps up on every hit, capped for fairness.
- **Serve countdown** — READY / SET / GO between points.
- **Feedback** — paddle hit flash, score flash, winner screen with rematch.
- **Motion trails** — small afterimage trails on the ball and paddles.
- **Audio (console only)** — logo jingle, menu confirm, looping theme, hit/point/win/lose
  cues. See [Audio](#audio).

## Controls

Controller takes priority over keyboard. P1 is always the first active pad.

| Action | Keyboard (lupinho) | Gamepad |
|---|---|---|
| Move P1 up / down | `W` / `S` | D-pad up / down |
| Move P2 up / down (2P mode) | `G` / `H` | 2nd pad D-pad |
| Confirm / advance menu | `J` / `K` / `L` / `M` (`K` = confirm) | Cross (`X` on PS4) / `B` (SNES) |
| Navigate menu | `W` / `S` | D-pad up / down |

## Running it

The game builds through the **lupinho-sdk** Docker container, which runs the
[lupi-codec](https://github.com/lupi-org-br/lupi-codec) asset pipeline (PNG → bitmaps,
palette, sprite manifest) and then the simulator.

```bash
# from the repo that holds tools/lupinho-sdk
cp -r neon-pong/. tools/lupinho-sdk/src/
cd tools/lupinho-sdk
make build    # first time only
make run      # serves on :3000
```

Open `http://localhost:3000/webgame/game.html`.

The `.lupi` package is produced from `src/`; the standalone lupinho player can load any
`.lupi` that contains `game.lua` at its root.

## Project structure

```
neon-pong/
├── game.lua          # entry point — update(frame) loop + scene switching
├── const.lua         # constants (sizes, speeds, timing)
├── colors.lua        # named colors -> palette indices
├── input.lua         # controller-first input (P1 = first active pad)
├── audio.lua         # sfx adapter (console-only, safe no-op in lupinho)
├── trail.lua         # motion trails for ball and paddles
├── ball.lua          # serve, bounce, angle-by-contact reflection
├── paddle.lua        # movement + hit flash
├── ai.lua            # CPU opponent (reaction delay + aim error)
├── hud.lua           # court, scores, mode label, messages
├── scenes/
│   ├── logo.lua      # 5s splash before the menu
│   ├── menu.lua      # mode selection (1P vs CPU / 2P local)
│   └── play.lua      # rally, scoring, win/rematch
├── img/              # sprites + palette (PNG)
├── audio/            # WAV cues (console-only, not shipped by the codec)
└── lupi.yaml         # release metadata
```

## Audio

`sfx.music` / `sfx.fx` / `sfx.volume` are **console-only** — lupinho has no audio
bindings. The game stays fully playable in the simulator: `audio.lua` wraps every call
with a silent fallback. The audio files live in `audio/` and the console runtime plays
them by name; the codec strips them from the `.lupi` package.

## Test it
https://cellozero666.itch.io/neon-pong-lupi 
Use joysticks, or W/S for movement, K to confirm selections

## License

Proof-of-concept example project.
