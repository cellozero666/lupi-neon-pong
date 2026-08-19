local M = {}

function M.new()
  return { target = nil }
end

function M.update(state, p, ball, const, isRight, frame, rng)
  local toward = ball.active and (isRight and ball.vx > 0 or (not isRight and ball.vx < 0))
  local target
  if toward then
    if frame % const.AI_REACT == 0 then
      state.target = ball.y + const.BALL_SIZE / 2 - const.PADDLE_H / 2
        + (rng() * 2 - 1) * const.AI_ERROR
    end
    target = state.target
  else
    target = const.H / 2 - const.PADDLE_H / 2
  end

  local dy = target - p.y
  local step = const.AI_SPEED
  if dy > step then
    p.y = p.y + step
  elseif dy < -step then
    p.y = p.y - step
  else
    p.y = target
  end
  p.y = math.max(0, math.min(p.y, const.H - const.PADDLE_H))
end

return M