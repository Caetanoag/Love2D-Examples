local Pad = require("src.pad")
local Vector = require("src.vector")
local Ball = require("src.ball")
local AI = require("src.ai")
local KeysDown = require("src.input")
local PadLeftControls = {
    up = "w",
    down = "s"
}
local PadRightControls = {
    up = "up",
    down = "down"
}
local winner = nil
local winTimer = 0
local pointsToWin = 10
local gamemode = 'singleplayer' -- multiplayer or singleplayer
local state = 'menu'
local menuButtons = {{
    text = "2 Players"
}, {
    text = "1 Player - Easy"
}, {
    text = "1 Player - Medium"
}, {
    text = "1 Player - Hard"
}, {
    text = "Quit"
}}
local activeButton = 1

local INITIAL_DELAY = 0.35
local REPEAT_RATE = 0.10

local repeatState = {
    up = {
        nextFire = 0,
        wasHeld = false
    },
    down = {
        nextFire = 0,
        wasHeld = false
    }
}

local function menuRepeat(key, action)
    local held = KeysDown[key] or false
    local keyState = repeatState[key]
    local now = love.timer.getTime()

    if not held then
        keyState.wasHeld = false
        keyState.nextFire = 0
        return
    end

    if not keyState.wasHeld then
        keyState.wasHeld = true
        keyState.nextFire = now + INITIAL_DELAY
        action()
        return
    end

    if now >= keyState.nextFire then
        keyState.nextFire = now + REPEAT_RATE
        action()
    end
end

local function drawScore()
    love.graphics.setFont(BigFont)
    local y = love.graphics.getHeight() / 2 - BigFont:getHeight() / 2
    love.graphics.print(tostring(PadLeft.points), love.math.newTransform(20, y))
    love.graphics.printf(tostring(PadRight.points), 0, y, WindowWidth - 20, "right")
end
local function drawGame()
    PadLeft:draw()
    PadRight:draw()
    BouncingBall:draw()
    drawScore()
    love.graphics.line(WindowWidth / 2, 0, WindowWidth / 2, WindowHeight)
end
local function drawMenu()
    love.graphics.setFont(BigFont)
    local menuBigText = "Love2Pong"
    local textW = BigFont:getWidth(menuBigText)
    local textH = BigFont:getHeight()

    local y = textH + 20
    love.graphics.print(menuBigText, (WindowWidth - textW) / 2, y)

    love.graphics.setFont(MediumFont)
    for i = 1, #menuButtons do
        local text = menuButtons[i].text
        local bHeight = MediumFont:getHeight()
        local bWidth = MediumFont:getWidth(text)
        local bx = (WindowWidth - bWidth) / 2
        local by = y + (bHeight + 15) * (i + 1)
        love.graphics.print(text, bx, by)
        if (i == activeButton) then
            love.graphics.rectangle("line", bx - bWidth * 0.1, by, bWidth * 1.1 + bWidth * 0.1, bHeight * 1.1)
        end
    end
end
local function updateMenu()
    menuRepeat("up", function()
        activeButton = math.max(1, activeButton - 1)

    end)

    menuRepeat("down", function()
        activeButton = math.min(#menuButtons, activeButton + 1)

    end)

    if (KeysDown["return"]) then
        if (activeButton == 1) then
            gamemode = 'multiplayer'
            state = 'game'
        elseif (activeButton == 2) then
            gamemode = 'singleplayer'
            state = 'game'
            AIInstance:changeDifficulty("easy")
        elseif (activeButton == 3) then
            gamemode = 'singleplayer'
            state = 'game'
            AIInstance:changeDifficulty("medium")
        elseif (activeButton == 4) then
            gamemode = 'singleplayer'
            state = 'game'
            AIInstance:changeDifficulty("hard")
        elseif (activeButton == 5) then
            love.event.quit(0)
        end

    end
end
function love.load()
    love.window.setMode(800, 600)
    BigFont = love.graphics.newFont(32)
    MediumFont = love.graphics.newFont(20)
    WindowWidth, WindowHeight = love.graphics.getDimensions()
    PadDimensions = Vector.new(WindowWidth / 40, WindowHeight / 6)
    AIInstance = AI.new("easy")
    local margin = PadDimensions.x * 2.5

    PadLeft = Pad.new(Vector.new(margin, WindowHeight / 2), PadDimensions, 300, PadLeftControls)
    PadRight = Pad.new(Vector.new(WindowWidth - margin - PadDimensions.x, WindowHeight / 2), PadDimensions, 300,
        PadRightControls)

    BouncingBall = Ball.new(Vector.new(WindowWidth / 2, WindowHeight / 2), 300, 10)
end

function love.update(dt)
    if KeysDown["r"] then
        love.event.quit("restart")
    end
    if winner then
        winTimer = winTimer - dt
        if winTimer <= 0 then
            love.event.quit('restart')
        end
        return
    end
    if state == 'menu' then
        updateMenu()
    end
    if state == 'game' then
        PadLeft:update(dt, WindowWidth, WindowHeight)

        if gamemode == 'multiplayer' then
            PadRight:update(dt, WindowWidth, WindowHeight)
        else
            local aiDir = AIInstance:update(PadRight, BouncingBall, WindowWidth, WindowHeight, dt)
            PadRight:update(dt, WindowWidth, WindowHeight, aiDir)
        end

        BouncingBall:update(dt, WindowHeight, PadLeft, PadRight)

        if PadLeft.points >= pointsToWin then
            winner = 'left'
            winTimer = 2
        elseif PadRight.points >= pointsToWin then
            winner = 'right'
            winTimer = 2
        end
    end
end
function love.draw()
    if state == 'game' then
        drawGame()
    elseif state == 'menu' then
        drawMenu()
    end
    if winner then
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.setFont(BigFont)

        local msg = winner == "left" and "Player 1 Wins!" or "Player 2 Wins!"
        local score = PadLeft.points .. " - " .. PadRight.points

        local w = BigFont:getWidth(msg)
        local sw = BigFont:getWidth(score)
        local h = BigFont:getHeight()

        local y = (WindowHeight - h) / 2

        love.graphics.print(msg, (WindowWidth - w) / 2, y)
        love.graphics.print(score, (WindowWidth - sw) / 2, y + h + 10)
    end
end
