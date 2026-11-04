local AI = {}
AI.__index = AI

local DIFFICULTY = {
    easy = {
        reactionTime = 0.25,
        aimError = 45,
        predict = false,
        deadzone = 25,
        speedScale = 0.6
    },
    medium = {
        reactionTime = 0.12,
        aimError = 20,
        predict = true,
        deadzone = 15,
        speedScale = 0.85
    },
    hard = {
        reactionTime = 0.05,
        aimError = 5,
        predict = true,
        deadzone = 6,
        speedScale = 1.0
    }
}

function AI.new(level)
    local self = setmetatable({}, AI)
    local cfg = DIFFICULTY[level or "medium"]
    self.reactionTime = cfg.reactionTime
    self.aimError = cfg.aimError
    self.predict = cfg.predict
    self.deadzone = cfg.deadzone
    self.speedScale = cfg.speedScale

    self.timer = 0
    self.targetY = nil
    return self
end
function AI:changeDifficulty(newDiff)
    local cfg = DIFFICULTY[newDiff]
    if not cfg then
        error("Invalid Difficulty: " .. tostring(newDiff))
    end

    self.level = newDiff
    self.reactionTime = cfg.reactionTime
    self.aimError = cfg.aimError
    self.predict = cfg.predict
    self.deadzone = cfg.deadzone
    self.speedScale = cfg.speedScale

    self.timer = 0
    self.targetY = nil
end
function AI:update(pad, ball, w, h, dt)
    self.timer = self.timer + dt
    if self.timer >= self.reactionTime then
        self.timer = 0
        self.targetY = self:computeTarget(ball, pad)
    end

    if not self.targetY then
        return 0
    end

    local padCenterY = pad.position.y + pad.dimensions.y / 2
    local diff = self.targetY - padCenterY

    if diff > self.deadzone then
        return 1
    end
    if diff < -self.deadzone then
        return -1
    end
    return 0
end

function AI:computeTarget(ball, pad)
    local y = ball.position.y

    if self.predict and ball.velocity.x ~= 0 then
        local dx = pad.position.x - ball.position.x
        local t = math.abs(dx / ball.velocity.x)
        y = ball.position.y + ball.velocity.y * t
    end

    y = y + (love.math.random() - 0.5) * 2 * self.aimError
    return y
end

return AI
