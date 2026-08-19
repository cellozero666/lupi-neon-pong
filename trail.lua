local M = {}

function M.new(n)
  return { pts = {}, n = n or 6 }
end

function M.push(t, x, y)
  local pts = t.pts
  if #pts == 0 or pts[#pts][1] ~= x or pts[#pts][2] ~= y then
    pts[#pts + 1] = { x, y }
  end
  while #pts > t.n do
    table.remove(pts, 1)
  end
end

function M.clear(t)
  t.pts = {}
end

function M.drawBall(t, colors, radius)
  local pts = t.pts
  for i = 1, #pts - 1 do
    local r = radius - (#pts - i)
    if r > 0 then
      ui.circfill(pts[i][1], pts[i][2], r, colors.gray)
    end
  end
end

function M.drawPaddle(t, colors)
  local pts = t.pts
  if #pts < 2 then
    return
  end
  local cx = pts[#pts][1]
  local minY, maxY = pts[1][2], pts[1][2]
  for i = 1, #pts do
    local y = pts[i][2]
    if y < minY then minY = y end
    if y > maxY then maxY = y end
  end
  ui.rectfill(cx - 1, minY, cx + 2, maxY, colors.gray)
end

return M
