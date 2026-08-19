package.path = "/g/?.lua;/g/?/?.lua;" .. package.path

package.preload["palette"] = function()
  Palette = { [1] = 0x0000, [2] = 0x7FFF, [3] = 0x7C1F, [4] = 0x03E0, [5] = 0x4812, [6] = 0x01A0, [7] = 0x4A52 }
  return Palette
end
package.preload["sprites"] = function()
  Sprites = {
    img = {
      ball = { path = "img/ball", width = 8, height = 8, ntiles = 1 },
      paddle_p1 = { path = "img/paddle_p1", width = 12, height = 48, ntiles = 1 },
      paddle_p2 = { path = "img/paddle_p2", width = 12, height = 48, ntiles = 1 },
    },
  }
  return Sprites
end

local keys = {}   -- keyboard = gamepad index 0
local ps4 = {}    -- DualShock 4 at gamepad index 1
local presses = {}
local ui = {}
function ui.palset() end
function ui.cls() end
function ui.clip() end
function ui.camera() end
function ui.spr() end
function ui.print() end
function ui.rectfill() end
function ui.log(m) print("[LUPINHO] " .. m) end
function ui.btn(id, pad)
  if pad == 1 then return ps4[id] == true end
  return keys[id] == true
end
_G.ui = ui

local BTN_Z, UP, DOWN, LEFT, RIGHT, BTN_F, BTN_G = 4, 2, 3, 0, 1, 12, 13

math.randomseed(12345)
dofile("/g/game.lua")

local function padPress(id)
  ps4[id] = true
end
local function padRelease(id)
  ps4[id] = false
end
local function keyPress(id)
  keys[id] = true
end
local function keyRelease(id)
  keys[id] = false
end

local frames = 12000
local mode = os.getenv("MODE") or "cpu"

local p1dir = 1
local confirmHeld = false
for f = 1, frames do
  -- menu: use ONLY the PS4 (index 1), never the keyboard, to verify pad priority
  if mode == "pvp" then
    if f == 5 then padPress(DOWN) end
    if f == 8 then padRelease(DOWN) end
    if f == 12 then padPress(BTN_Z) end
    if f == 20 then padRelease(BTN_Z) end
  else
    if f == 5 then padPress(BTN_Z) end
    if f == 12 then padRelease(BTN_Z) end
  end

  -- in-game: alternate P1 D-pad up/down on the PS4
  if f > 60 and f < 300 then padPress(UP) else padRelease(UP) end
  if f > 500 and f < 800 then padPress(DOWN) else padRelease(DOWN) end
  if f > 1100 and f < 1400 then padPress(UP) else padRelease(UP) end
  if f > 1600 and f < 1900 then padPress(DOWN) else padRelease(DOWN) end

  -- P2 keyboard G/H in pvp mode
  if mode == "pvp" then
    if f > 2000 and f < 2300 then keyPress(BTN_F) else keyRelease(BTN_F) end
    if f > 2600 and f < 2900 then keyPress(BTN_G) else keyRelease(BTN_G) end
    if f > 3200 and f < 3500 then keyPress(BTN_F) else keyRelease(BTN_F) end
  end

  local ok, err = pcall(function() update(f) end)
  if not ok then
    print("ERROR at frame " .. f .. " in mode " .. mode .. ": " .. tostring(err))
    os.exit(1)
  end
  if f % 1000 == 0 then print("[" .. mode .. "] frame " .. f .. " ok") end
end
print("ALL " .. frames .. " FRAMES OK in mode " .. mode .. " with PS4 at pad index 1")