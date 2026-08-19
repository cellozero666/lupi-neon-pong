local M = {}

local claims = { [1] = nil, [2] = nil }
local prev = {}

local ALL_BUTTONS = { UP, DOWN, LEFT, RIGHT, BTN_Z, BTN_E, BTN_Q, BTN_F, BTN_G }

function M.padActive(p)
  for _, b in ipairs(ALL_BUTTONS) do
    if ui.btn(b, p) ~= false then return true end
  end
  return false
end

function M.claimP1Pad()
  if claims[1] then return end
  for i = 1, 3 do
    if M.padActive(i) then
      claims[1] = i
      return
    end
  end
end

local function other(player)
  return player == 1 and 2 or 1
end

local function scan(player, btn)
  for i = 1, 3 do
    if claims[other(player)] ~= i and ui.btn(btn, i) ~= false then
      claims[player] = i
      return true
    end
  end
  return false
end

local function held(player, btn, kb)
  if scan(player, btn) then return true end
  if kb and ui.btn(btn) ~= false then return true end
  return false
end

local function edge(player, name, get)
  local now = get() or false
  local key = player .. ":" .. name
  local was = prev[key]
  prev[key] = now
  return now and not was
end

function M.p1UpHeld()
  return held(1, UP, true)
end

function M.p1DownHeld()
  return held(1, DOWN, true)
end

function M.p1Up()
  return edge(1, "up", function() return held(1, UP, true) end)
end

function M.p1Down()
  return edge(1, "down", function() return held(1, DOWN, true) end)
end

function M.p1Confirm()
  return edge(1, "z", function() return held(1, BTN_Z, true) end)
end

function M.p2UpHeld()
  return held(2, UP, false) or (ui.btn(BTN_F) ~= false)
end

function M.p2DownHeld()
  return held(2, DOWN, false) or (ui.btn(BTN_G) ~= false)
end

function M.p2Up()
  return edge(2, "up", function() return held(2, UP, false) or (ui.btn(BTN_F) ~= false) end)
end

function M.p2Down()
  return edge(2, "down", function() return held(2, DOWN, false) or (ui.btn(BTN_G) ~= false) end)
end

function M.reset()
  claims = { [1] = nil, [2] = nil }
end

return M