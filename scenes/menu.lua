local paddle = require "paddle"
local ball = require "ball"
local input = require "input"
local audio = require "audio"

local sprP1 = Sprites.img.paddle_p1
local sprP2 = Sprites.img.paddle_p2
local sprBall = Sprites.img.ball

local OPTIONS = {
  { label = "1P VS CPU", mode = "cpu" },
  { label = "2P LOCAL", mode = "pvp" },
}

local function new(ctx)
  local const, colors = ctx.const, ctx.colors
  local sel = 1
  audio.stopMusic()

  return {
    name = "menu",
    update = function(f, c)
      if input.p1Up() then sel = sel - 1 end
      if input.p1Down() then sel = sel + 1 end
      sel = (sel - 1) % #OPTIONS + 1
      if input.p1Confirm() then
        audio.fx(audio.SAMPLES.start, 60)
        return { action = "play", mode = OPTIONS[sel].mode }
      end
      return nil
    end,
    draw = function(f, c)
      local t = "NEON PONG"
      ui.print(t, const.W / 2 - #t * 3 + 2, 42, colors.gray)
      ui.print(t, const.W / 2 - #t * 3, 40, colors.white)

      ui.spr(sprP1, 60, 96)
      ui.spr(sprBall, 236, 130)
      ui.spr(sprP2, 408, 96)

      for i, opt in ipairs(OPTIONS) do
        local y = 150 + (i - 1) * 24
        local color = (i == sel) and colors.magenta or colors.gray
        local marker = (i == sel) and "> " or "  "
        ui.print(marker .. opt.label, const.W / 2 - 40, y, color)
      end

      local h = "DPAD SELECT  CONFIRM: X(PS) / B(SNES)"
      ui.print(h, const.W / 2 - #h * 3, 220, colors.gray)
    end,
  }
end

return { new = new }