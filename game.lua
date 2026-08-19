require "palette"
require "sprites"

math.randomseed(os.time())

local const = require "const"
local colors = require "colors"
local input = require "input"
local logo = require "scenes.logo"
local menu = require "scenes.menu"
local play = require "scenes.play"

local ctx = { const = const, colors = colors }

local CurrentScene = logo.new(ctx)

local function change(result)
  if result then
    input.reset()
    if result.action == "play" then
      CurrentScene = play.new(ctx, result.mode)
    elseif result.action == "menu" then
      CurrentScene = menu.new(ctx)
    end
  end
end

function update(frame)
  for i = 1, #Palette do
    ui.palset(i - 1, Palette[i])
  end

  input.claimP1Pad()
  change(CurrentScene.update(frame, ctx))

  ui.cls(colors.bg)
  ui.clip(0, 0, const.W, const.H)
  ui.camera()
  CurrentScene.draw(frame, ctx)
end