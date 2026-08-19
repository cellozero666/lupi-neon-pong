local M = {}

local hasSfx = sfx ~= nil
local hasSfxFile = hasSfx and sfx.sfx ~= nil

local noop = function() end

M.music = hasSfx and function(name) sfx.music(name) end or noop
M.stopMusic = hasSfx and function() sfx.music(-1) end or noop
M.volume = hasSfx and function(v) sfx.volume(v) end or noop
M.fx = hasSfx and function(sample, note, pan) sfx.fx(sample, note, pan) end or noop

M.SAMPLES = { open = 1, start = 2, hit = 3, point = 4 }

M.SFX = {
  open = { file = "audio/open", sample = 1 },
  start = { file = "audio/start", sample = 2 },
  hit = { file = "audio/hit", sample = 3 },
  point = { file = "audio/point", sample = 4 },
}

if hasSfxFile then
  M.play = function(cue) sfx.sfx(cue.file) end
elseif hasSfx then
  M.play = function(cue) sfx.fx(cue.sample, 60) end
else
  M.play = noop
end

M.TRACKS = {
  theme = "audio/main_theme",
  win = "audio/win",
  loose = "audio/loose",
}

return M