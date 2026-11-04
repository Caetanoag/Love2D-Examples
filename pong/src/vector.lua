local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local v = setmetatable({
        x = x,
        y = y
    }, Vector)
    return v
end
function Vector:Add(other)
    return Vector.new(self.x + other.x, self.y + other.y)
end
function Vector:Reverse()
    return Vector.new(-self.x, -self.y)
end
function Vector:AddTo(scalarX, scalarY)
    return Vector.new(self.x + scalarX, self.y + scalarY)
end
function Vector:Scale(scalar)
    return Vector.new(self.x * scalar, self.y * scalar)
end
function Vector:Magnitude()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end
function Vector:Normalize()
    local magnitude = self:Magnitude()
    if magnitude == 0 then
        return Vector.new(0, 0)
    else
        return Vector.new(self.x / magnitude, self.y / magnitude)
    end
end
function Vector:Dot(other)
    return self.x * other.x + self.y * other.y
end
return Vector
