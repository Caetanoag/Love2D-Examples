local vector = require("src.vector")
local Ball = {}
Ball.__index = Ball

function Ball.new(x, y, radius, vx, vy, texture)
    local b = setmetatable({
        position = vector.Create(x, y),
        radius = radius,
        velocity = vector.Create(vx, vy),
        texture = texture,
        rotation = love.math.random() * math.pi * 2,
        spin = (love.math.random() - 0.5) * 4
    }, Ball)
    b.mass = b.radius * b.radius
    return b
end
function Ball:update(dt, w, h)
    self.position = vector.Add(self.position, vector.Scale(self.velocity, dt))
    self.rotation = self.rotation + self.spin * dt
    self:bounce(w, h)
end

local ELASTICITY = 1.0

function Ball:collide(other)
    local delta = vector.Add(self.position, vector.Reverse(other.position))
    local dist = vector.Magnitude(delta)
    if dist == 0 or dist >= self.radius + other.radius then
        return false
    end

    local n = vector.Scale(delta, 1 / dist)
    local relV = vector.Add(self.velocity, vector.Reverse(other.velocity))
    local vn = relV.x * n.x + relV.y * n.y

    if vn >= 0 then
        return false
    end

    local inv1 = 1 / self.mass
    local inv2 = 1 / other.mass
    local invSum = inv1 + inv2
    local overlap = (self.radius + other.radius) - dist

    self.position = vector.Add(self.position, vector.Scale(n, overlap * inv1 / invSum))
    other.position = vector.Add(other.position, vector.Scale(n, -overlap * inv2 / invSum))

    local j = -(1 + ELASTICITY) * vn / invSum
    self.velocity = vector.Add(self.velocity, vector.Scale(n, j * inv1))
    other.velocity = vector.Add(other.velocity, vector.Scale(n, -j * inv2))

    local cx = self.position.x - n.x * self.radius
    local cy = self.position.y - n.y * self.radius
    return true, cx, cy, n.x, n.y, math.abs(vn)
end
function Ball:draw()
    local tex = self.texture
    local s = (self.radius * 2) / tex:getWidth()
    love.graphics.draw(tex, self.position.x, self.position.y, self.rotation, s, s, tex:getWidth() / 2,
        tex:getHeight() / 2)
end
function Ball:bounce(width, height)
    if self.position.x - self.radius < 0 or self.position.x + self.radius > width then
        self.velocity.x = -self.velocity.x
        self.position.x = math.max(self.radius, math.min(self.position.x, width - self.radius))

    end
    if self.position.y - self.radius < 0 or self.position.y + self.radius > height then
        self.velocity.y = -self.velocity.y
        self.position.y = math.max(self.radius, math.min(self.position.y, height - self.radius))

    end
end
return Ball
