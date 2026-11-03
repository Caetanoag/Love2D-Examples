local LIFETIME_MIN = 0.20
local LIFETIME_MAX = 0.45
local SPEED_MIN = 60
local SPEED_MAX = 200
local MAX_SPARKS = 400
local DRAG = 2.5

local sparks = {}

local function burst(x, y, nx, ny, count)
    count = count or 6
    local baseAngle = math.atan(ny, nx)
    for _ = 1, count do
        if #sparks >= MAX_SPARKS then
            return
        end
        local angle = baseAngle + (love.math.random() - 0.5) * math.pi
        local speed = SPEED_MIN + love.math.random() * (SPEED_MAX - SPEED_MIN)
        local life = LIFETIME_MIN + love.math.random() * (LIFETIME_MAX - LIFETIME_MIN)
        table.insert(sparks, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            life = life,
            maxLife = life
        })
    end
end

local function update(dt)
    local k = math.exp(-DRAG * dt)
    for i = #sparks, 1, -1 do
        local s = sparks[i]
        s.vx = s.vx * k
        s.vy = s.vy * k
        s.x = s.x + s.vx * dt
        s.y = s.y + s.vy * dt
        s.life = s.life - dt
        if s.life <= 0 then
            sparks[i] = sparks[#sparks]
            sparks[#sparks] = nil
        end
    end
end

local function draw()
    love.graphics.setLineWidth(2)
    for _, s in ipairs(sparks) do
        local t = s.life / s.maxLife
        love.graphics.setColor(1, 0.5 + 0.5 * t, 0.1 + 0.2 * t, t)

        love.graphics.line(s.x, s.y, s.x - s.vx * 0.02, s.y - s.vy * 0.02)
    end
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

local function clear()
    sparks = {}
end

return {
    burst = burst,
    update = update,
    draw = draw,
    clear = clear
}
