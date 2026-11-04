local vector = require "src.vector"
local Ball = {}
local baseAcceleration = vector.new(40, 40)

Ball.__index = Ball
local function randomBallVelocity(speed)
    local dirX = love.math.random() < 0.5 and -1 or 1

    local angle = love.math.random(math.rad(20), math.rad(60))

    local dirY = love.math.random() < 0.5 and -1 or 1

    return vector.new(math.cos(angle) * speed * dirX, math.sin(angle) * speed * dirY)
end

function Ball.new(position, speed, radius)
    local b = {
        position = position,
        velocity = randomBallVelocity(speed),
        radius = radius,
        acceleration = vector.new(baseAcceleration.x, baseAcceleration.y),
        speed = speed
    }
    return setmetatable(b, Ball)
end

function Ball:bounce(pad, fromLeft, dt)
    local padLeftX = pad.position.x
    local padRightX = pad.position.x + pad.dimensions.x
    local padTop = pad.position.y
    local padBottom = pad.position.y + pad.dimensions.y
    local ballLeft = self.position.x - self.radius
    local ballRight = self.position.x + self.radius
    local ballTop = self.position.y - self.radius
    local ballBottom = self.position.y + self.radius

    local vertical = ballBottom >= padTop and ballTop <= padBottom
    local hit
    if fromLeft then
        hit = self.velocity.x < 0 and ballLeft <= padRightX and ballRight >= padLeftX
    else
        hit = self.velocity.x > 0 and ballRight >= padLeftX and ballLeft <= padRightX
    end

    if vertical and hit then
        local padCenterY = pad.position.y + pad.dimensions.y / 2
        local offset = (self.position.y - padCenterY) / (pad.dimensions.y / 2)
        offset = math.max(-1, math.min(1, offset))

        local currentSpeed = math.sqrt(self.velocity.x ^ 2 + self.velocity.y ^ 2)
        local newSpeed = currentSpeed + (self.acceleration.x or 0)
        newSpeed = math.min(newSpeed, 900)

        local maxAngle = math.rad(60)
        local angle = offset * maxAngle

        local dirX = fromLeft and 1 or -1
        self.velocity.x = math.cos(angle) * newSpeed * dirX
        self.velocity.y = math.sin(angle) * newSpeed

        if fromLeft then
            self.position.x = padRightX + self.radius
        else
            self.position.x = padLeftX - self.radius
        end
    end
end
function Ball:returnToCenter()
    local width, height = love.graphics.getDimensions()
    self.position = vector.new(width / 2, height / 2)
    self.velocity = vector.new(-self.velocity.x, -self.velocity.y)
end
function Ball:bounceOffWalls(h)
    if self.position.y - self.radius < 0 then
        self.position.y = self.radius
        self.velocity.y = math.abs(self.velocity.y) + self.acceleration.y
    elseif self.position.y + self.radius > h then
        self.position.y = h - self.radius
        self.velocity.y = -math.abs(self.velocity.y) - self.acceleration.y
    end
end
function Ball:exitScreen(padLeft, padRight)
    if self.position.x + self.radius < padLeft.position.x then
        padRight.points = padRight.points + 1
        self.acceleration = vector.new(baseAcceleration.x, baseAcceleration.y)
        self.velocity = randomBallVelocity(self.speed)
        return "left"
    elseif self.position.x - self.radius > padRight.position.x + padRight.dimensions.x then
        padLeft.points = padLeft.points + 1
        self.acceleration = vector.new(baseAcceleration.x, baseAcceleration.y)
        self.velocity = randomBallVelocity(self.speed)
        return "right"
    end
    return nil
end

function Ball:update(dt, h, padLeft, PadRight)
    self.position = vector.Add(self.position, vector.Scale(self.velocity, dt))
    self:bounceOffWalls(h)
    self:bounce(padLeft, true, dt)
    self:bounce(PadRight, false, dt)
    local exit = self:exitScreen(padLeft, PadRight)
    if exit then
        self:returnToCenter()
        if exit == "left" then
            self.velocity = randomBallVelocity(self.speed)
        else
            self.velocity = randomBallVelocity(self.speed)
        end

    end
end
function Ball:draw()
    love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
end

return Ball
