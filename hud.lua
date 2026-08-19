local M = {}

function M.drawCourt(const, colors)
  local y = 0
  while y < const.H do
    ui.rectfill(const.W / 2 - 1, y, const.W / 2, y + 14, colors.gray)
    y = y + 26
  end
end

function M.drawScores(scores, const, colors, p1c, p2c)
  local s1, s2 = tostring(scores.p1), tostring(scores.p2)
  ui.print(s1, const.W / 2 - 66, 14, colors.gray)
  ui.print(s1, const.W / 2 - 67, 13, p1c)
  ui.print(s2, const.W / 2 + 60, 14, colors.gray)
  ui.print(s2, const.W / 2 + 59, 13, p2c)
end

function M.drawModeLabel(label, const, colors)
  local x = const.W / 2 - #label * 3
  ui.print(label, x + 1, 33, colors.gray)
  ui.print(label, x, 32, colors.white)
end

function M.drawMessage(text, const, colors)
  local x = const.W / 2 - #text * 3
  ui.print(text, x + 1, 125, colors.gray)
  ui.print(text, x, 124, colors.white)
end

return M