local function CreateVector(x, y)
    return ({
        x = x,
        y = y
    })
end

local function AddVectors(v1, v2)
    return CreateVector(v1.x + v2.x, v1.y + v2.y)
end

local function ReverseVector(v)
    return CreateVector(-v.x, -v.y)
end

local function AddToVector(v1, scalarX, scalarY)
    return CreateVector(v1.x + scalarX, v1.y + scalarY)
end

local function ScaleVector(v, scalar)
    return CreateVector(v.x * scalar, v.y * scalar)
end

local function VectorMagnitude(v)
    return math.sqrt(v.x ^ 2 + v.y ^ 2)
end

local function NormalizeVector(v)
    local magnitude = VectorMagnitude(v)
    if magnitude == 0 then
        return CreateVector(0, 0)
    else
        return CreateVector(v.x / magnitude, v.y / magnitude)
    end
end

local function Dot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y
end

return {
    Create = CreateVector,
    Add = AddVectors,
    Reverse = ReverseVector,
    AddTo = AddToVector,
    Scale = ScaleVector,
    Magnitude = VectorMagnitude,
    Normalize = NormalizeVector,
    Dot = Dot
}
