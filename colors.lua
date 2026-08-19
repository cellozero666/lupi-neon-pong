local M = {}

local TARGETS = {
  white = { 31, 31, 31 },
  magenta = { 31, 0, 31 },
  green = { 0, 31, 0 },
  gray = { 18, 18, 18 },
}

local function decode(v)
  local r = v % 32
  local g = math.floor(v / 32) % 32
  local b = math.floor(v / 1024) % 32
  return r, g, b
end

local function find(target)
  local tr, tg, tb = target[1], target[2], target[3]
  for i = 1, #Palette do
    local r, g, b = decode(Palette[i])
    if math.abs(r - tr) <= 1 and math.abs(g - tg) <= 1 and math.abs(b - tb) <= 1 then
      return i - 1
    end
  end
  return nil
end

for name, target in pairs(TARGETS) do
  M[name] = find(target) or 0
end

M.bg = 0

return M