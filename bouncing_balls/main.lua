local ball = require("src.ball")
local spark = require("src.spark")
local textures = require("src.textures")
local sound = require("src.sound")
local MAX_BALLS = 100

local function parsePositiveInteger(s)
    if type(s) ~= "string" then
        return false
    end
    if not s:match("^%d+$") then
        return false
    end
    local n = tonumber(s)
    if n <= 0 or n > MAX_BALLS then
        return false
    end
    return true, n
end
function love.load(args)
    sound.load()
    love.graphics.setDefaultFilter("linear", "linear")
    local tex = textures.circular("assets/ball.png")
    spark.clear()
    local ballsQuantity = 10
    if #args > 0 then
        local ok, n = parsePositiveInteger(args[1])
        if ok then
            ballsQuantity = n
        end
    end
    Balls = {}
    for i = 1, ballsQuantity do
        local x = love.math.random(0, love.graphics.getWidth())
        local y = love.math.random(0, love.graphics.getHeight())
        local r = love.math.random(20, 40)
        local vx = love.math.random(-100, 100)
        local vy = love.math.random(-100, 100)
        table.insert(Balls, ball.new(x, y, r, vx, vy, tex))
    end
end

function love.keypressed(key)
    if key == "r" then
        love.event.quit("restart")
    end
end

function love.update(dt)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    for _, b in ipairs(Balls) do
        b:update(dt, w, h)
    end

    for i = 1, #Balls do
        for j = i + 1, #Balls do
            local hit, cx, cy, nx, ny, strength = Balls[i]:collide(Balls[j])
            if hit then
                local count = math.min(14, 4 + math.floor(strength / 25))
                spark.burst(cx, cy, nx, ny, count)
                sound.impact(strength)
            end
        end
    end

    spark.update(dt)
end

function love.draw()
    for _, b in ipairs(Balls) do
        b:draw()
    end
    spark.draw()
end
