local paddle = require "paddle"
local ball = require "ball"
local ai = require "ai"
local hud = require "hud"
local input = require "input"
local audio = require "audio"
local trail = require "trail"

local sprP1 = Sprites.img.paddle_p1
local sprP2 = Sprites.img.paddle_p2
local sprBall = Sprites.img.ball

local OVER_OPTS = { "REMATCH", "MAIN MENU" }

local function new(ctx, mode)
  local const, colors = ctx.const, ctx.colors

  local function buildMatch()
    audio.music(audio.TRACKS.theme)
    return {
      p1 = paddle.new(const.PADDLE_EDGE, const.H / 2 - const.PADDLE_H / 2, colors.magenta, sprP1),
      p2 = paddle.new(const.W - const.PADDLE_EDGE - const.PADDLE_W,
        const.H / 2 - const.PADDLE_H / 2, colors.green, sprP2),
      ball = ball.new(sprBall),
      scores = { p1 = 0, p2 = 0 },
      phase = "serve",
      serveTimer = const.SERVE_FRAMES,
      serveDir = math.random() < 0.5 and 1 or -1,
      aiState = mode == const.MODE_CPU and ai.new() or nil,
      over = false,
      winner = nil,
      lastScorer = nil,
      flash = 0,
      menuSel = 1,
      trails = {
        ball = trail.new(6),
        p1 = trail.new(6),
        p2 = trail.new(6),
      },
    }
  end

  local m = buildMatch()

  local function score(who)
    m.scores[who] = m.scores[who] + 1
    m.lastScorer = who
    m.flash = const.SCORE_FLASH
    m.serveDir = who == "p1" and 1 or -1
    m.phase = "serve"
    m.serveTimer = const.SERVE_FRAMES
    trail.clear(m.trails.ball)
    audio.play(audio.SFX.point)
    if m.scores[who] >= const.WIN_SCORE then
      m.over = true
      m.winner = who
      audio.stopMusic()
      if mode == const.MODE_CPU and who == "p2" then
        audio.music(audio.TRACKS.loose)
      else
        audio.music(audio.TRACKS.win)
      end
    end
  end

  return {
    name = "play",
    update = function(f, c)
      if m.p1.flash > 0 then m.p1.flash = m.p1.flash - 1 end
      if m.p2.flash > 0 then m.p2.flash = m.p2.flash - 1 end
      if m.flash > 0 then m.flash = m.flash - 1 end

      if m.over then
        if input.p1Up() then m.menuSel = m.menuSel - 1 end
        if input.p1Down() then m.menuSel = m.menuSel + 1 end
        m.menuSel = (m.menuSel - 1) % #OVER_OPTS + 1
        if input.p1Confirm() then
          if m.menuSel == 1 then
            m = buildMatch()
          else
            return { action = "menu" }
          end
        end
        return nil
      end

      local dy1 = 0
      if input.p1UpHeld() then dy1 = dy1 - 1 end
      if input.p1DownHeld() then dy1 = dy1 + 1 end
      paddle.move(m.p1, dy1, const)
      trail.push(m.trails.p1, m.p1.x + const.PADDLE_W / 2, m.p1.y + const.PADDLE_H / 2)

      local dy2 = 0
      if mode == const.MODE_PVP then
        if input.p2UpHeld() then dy2 = dy2 - 1 end
        if input.p2DownHeld() then dy2 = dy2 + 1 end
      else
        ai.update(m.aiState, m.p2, m.ball, const, true, f, math.random)
      end
      paddle.move(m.p2, dy2, const)
      trail.push(m.trails.p2, m.p2.x + const.PADDLE_W / 2, m.p2.y + const.PADDLE_H / 2)

      if m.phase == "serve" then
        m.serveTimer = m.serveTimer - 1
        if m.serveTimer <= 0 then
          ball.serve(m.ball, const, m.serveDir, math.random)
          m.phase = "rally"
        end
      else
        ball.update(m.ball, const)
        trail.push(m.trails.ball, m.ball.x + const.BALL_SIZE / 2, m.ball.y + const.BALL_SIZE / 2)
        if m.ball.vx < 0 and ball.hits(m.ball, const, m.p1) then
          ball.reflect(m.ball, const, m.p1, 1)
          m.p1.flash = const.HIT_FLASH
          audio.play(audio.SFX.hit)
        elseif m.ball.vx > 0 and ball.hits(m.ball, const, m.p2) then
          ball.reflect(m.ball, const, m.p2, -1)
          m.p2.flash = const.HIT_FLASH
          audio.play(audio.SFX.hit)
        end
        if m.ball.x < -const.BALL_SIZE then
          score("p2")
        elseif m.ball.x > const.W then
          score("p1")
        end
      end
      return nil
    end,
    draw = function(f, c)
      hud.drawCourt(const, colors)
      trail.drawPaddle(m.trails.p1, colors)
      trail.drawPaddle(m.trails.p2, colors)
      paddle.draw(m.p1, const, colors)
      paddle.draw(m.p2, const, colors)
      if m.phase == "rally" and m.ball.active then
        trail.drawBall(m.trails.ball, colors, const.BALL_SIZE / 2)
        ui.spr(m.ball.spr, m.ball.x, m.ball.y)
      end

      local p1c = (m.flash > 0 and m.lastScorer == "p1") and colors.white or colors.magenta
      local p2c = (m.flash > 0 and m.lastScorer == "p2") and colors.white or colors.green
      hud.drawScores(m.scores, const, colors, p1c, p2c)

      local label = (mode == const.MODE_CPU) and "1P VS CPU" or "2P LOCAL"
      hud.drawModeLabel(label, const, colors)

      if m.phase == "serve" and not m.over then
        local n = math.ceil(m.serveTimer / 25)
        local text = n >= 3 and "READY" or (n == 2 and "SET" or "GO")
        hud.drawMessage(text, const, colors)
      end

      if m.over then
        local who
        if mode == const.MODE_CPU then
          who = (m.winner == "p1") and "YOU WIN" or "CPU WINS"
        else
          who = (m.winner == "p1") and "PLAYER 1 WINS" or "PLAYER 2 WINS"
        end
        hud.drawMessage(who, const, colors)

        local scoreText = tostring(m.scores.p1) .. "  x  " .. tostring(m.scores.p2)
        local sx = const.W / 2 - #scoreText * 3
        ui.print(scoreText, sx + 1, 148, colors.gray)
        ui.print(scoreText, sx, 147, colors.white)

        for i, o in ipairs(OVER_OPTS) do
          local y = 185 + (i - 1) * 20
          local color = (i == m.menuSel) and colors.magenta or colors.gray
          local marker = (i == m.menuSel) and "> " or "  "
          ui.print(marker .. o, const.W / 2 - 32, y, color)
        end
      end
    end,
  }
end

return { new = new }