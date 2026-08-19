local M = {}

function M.new(spr)
  return { x = 0, y = 0, vx = 0, vy = 0, speed = 0, active = false, spr = spr }
end

function M.centerY(b, const)
  return b.y + const.BALL_SIZE / 2
end

function M.serve(b, const, dir, rng)
  b.x = const.W / 2 - const.BALL_SIZE / 2
  b.y = const.H / 2 - const.BALL_SIZE / 2 + (rng() * 2 - 1) * 40
  b.speed = const.BALL_SPEED
  local rad = math.rad((rng() * 2 - 1) * const.BOUNCE_MAX_DEG * 0.5)
  b.vx = math.cos(rad) * b.speed * dir
  b.vy = math.sin(rad) * b.speed
  b.active = true
end

function M.update(b, const)
  b.x = b.x + b.vx
  b.y = b.y + b.vy
  if b.y < 0 then
    b.y = -b.y
    b.vy = -b.vy
  end
  local maxY = const.H - const.BALL_SIZE
  if b.y > maxY then
    b.y = 2 * maxY - b.y
    b.vy = -b.vy
  end
end

function M.hits(b, const, p)
  return b.x < p.x + const.PADDLE_W
     and b.x + const.BALL_SIZE > p.x
     and b.y < p.y + const.PADDLE_H
     and b.y + const.BALL_SIZE > p.y
end

function M.reflect(b, const, p, dir)
  local cy = p.y + const.PADDLE_H / 2
  local rel = (M.centerY(b, const) - cy) / (const.PADDLE_H / 2)
  rel = math.max(-1, math.min(1, rel))
  local rad = math.rad(rel * const.BOUNCE_MAX_DEG)
  b.speed = math.min(b.speed + const.BALL_ACCEL, const.BALL_SPEED_MAX)
  b.vx = math.cos(rad) * b.speed * dir
  b.vy = math.sin(rad) * b.speed
  if dir < 0 then
    b.x = p.x + const.PADDLE_W
  else
    b.x = p.x - const.BALL_SIZE
  end
end

return M