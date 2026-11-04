KeysDown = {}

function love.keypressed(key)
    KeysDown[key] = true
end
function love.keyreleased(key)
    KeysDown[key] = false
end

return KeysDown
