local KeysDown = require("src.input")
local Vector = require("src.vector")
Pad = {}
Pad.__index = Pad

function Pad.new(position, dimensions, speed, controls)
    local p = setmetatable({
        position = position,
        dimensions = dimensions,
        speed = speed,
        controls = controls,
        points = 0
    }, Pad)
    return p
end
function Pad:move(vector, dt, w, h)
    local newPos = vector.Add(self.position, vector.Scale(vector, self.speed * dt))
    if newPos.x < 0 then
        newPos.x = 0
    elseif newPos.x + self.dimensions.x > w then
        newPos.x = w - self.dimensions.x
    end
    if newPos.y < 0 then
        newPos.y = 0
    elseif newPos.y + self.dimensions.y > h then
        newPos.y = h - self.dimensions.y
    end
    self.position = newPos
end

function Pad:update(dt, w, h, dirOverride)
    local moveVector = Vector.new(0, 0)

    if dirOverride ~= nil then
        moveVector.y = dirOverride
    else
        if KeysDown[self.controls.up] then
            moveVector.y = -1
        elseif KeysDown[self.controls.down] then
            moveVector.y = 1
        end
    end

    self:move(moveVector, dt, w, h)
end
function Pad:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.dimensions.x, self.dimensions.y)
end

return Pad
