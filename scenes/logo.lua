local audio = require "audio"

local logo = Sprites.img.logo
local lw = logo and logo.width or 0
local lh = logo and logo.height or 0

local DURATION = 300

local function new(ctx)
  local const = ctx.const
  local t = 0
  audio.play(audio.SFX.open)
  return {
    name = "logo",
    update = function(f, c)
      t = t + 1
      if t >= DURATION then
        return { action = "menu" }
      end
      return nil
    end,
    draw = function(f, c)
      if logo then
        ui.spr(logo, math.floor((const.W - lw) / 2), math.floor((const.H - lh) / 2))
      end
    end,
  }
end

return { new = new }
