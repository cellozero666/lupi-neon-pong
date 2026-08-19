local M = {}

local function noop() end

if sfx then
  M.music = function(name) sfx.music(name) end
  M.stopMusic = function() sfx.music(-1) end
  M.fx = function(sample, note, pan) sfx.fx(sample, note, pan) end
  M.volume = function(v) sfx.volume(v) end
else
  M.music = noop
  M.stopMusic = noop
  M.fx = noop
  M.volume = noop
end

M.SAMPLES = { open = 1, start = 2, hit = 3 }
M.TRACKS = { theme = "audio/main_theme", win = "audio/win", loose = "audio/loose" }

return M
