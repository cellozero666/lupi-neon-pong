local M = {}

function M.new(x, y, color, spr)
  return { x = x, y = y, color = color, spr = spr, flash = 0 }
end

function M.move(p, dy, const)
  p.y = p.y + dy * const.PADDLE_SPEED
  p.y = math.max(0, math.min(p.y, const.H - const.PADDLE_H))
end

function M.draw(p, const, colors)
  ui.spr(p.spr, p.x, p.y)
  if p.flash > 0 then
    local w, h = const.PADDLE_W, const.PADDLE_H
    ui.rectfill(p.x, p.y, p.x + w, p.y + 1, colors.white)
    ui.rectfill(p.x, p.y, p.x + 1, p.y + h, colors.white)
    ui.rectfill(p.x, p.y + h - 1, p.x + w, p.y + h, colors.white)
    ui.rectfill(p.x + w - 1, p.y, p.x + w, p.y + h, colors.white)
  end
end

return M