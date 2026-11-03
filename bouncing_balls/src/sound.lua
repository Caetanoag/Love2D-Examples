local M = {}

local POOL_SIZE = 8
local COOLDOWN = 0.025

local pool = {}
local nextIdx = 1
local lastPlay = 0

local function makeImpact()
    local RATE = 44100
    local DURATION = 0.08
    local samples = math.floor(RATE * DURATION)
    local data = love.sound.newSoundData(samples, RATE, 16, 1)

    for i = 0, samples - 1 do
        local t = i / samples
        local env = math.exp(-t * 10)
        local noise = (love.math.random() * 2 - 1)
        local tone = math.sin(2 * math.pi * 100 * i / RATE)
        data:setSample(i, (noise * 0.7 + tone * 0.3) * env)
    end
    return data
end

function M.load()
    local data = makeImpact()
    for i = 1, POOL_SIZE do
        pool[i] = love.audio.newSource(data, "static")
    end
end

function M.impact(strength)
    local now = love.timer.getTime()
    if now - lastPlay < COOLDOWN then
        return
    end
    lastPlay = now

    local src = pool[nextIdx]
    nextIdx = (nextIdx % POOL_SIZE) + 1

    src:stop()
    src:setVolume(math.min(0.5, strength / 500))
    src:setPitch(0.8 + love.math.random() * 0.5)
    src:play()
end

return M
