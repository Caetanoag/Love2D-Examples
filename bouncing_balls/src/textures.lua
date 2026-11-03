local M = {}
local SIZE = 64

function M.circular(path)
    local img = love.graphics.newImage(path)
    local canvas = love.graphics.newCanvas(SIZE, SIZE)
    love.graphics.setCanvas({
        canvas,
        stencil = true
    })
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.stencil(function()
        love.graphics.circle("fill", SIZE / 2, SIZE / 2, SIZE / 2 - 0.5)
    end, "replace", 1)

    love.graphics.setStencilTest("greater", 0)
    love.graphics.draw(img, 0, 0, 0, SIZE / img:getWidth(), SIZE / img:getHeight())
    love.graphics.setStencilTest()

    love.graphics.setCanvas()
    return canvas
end

return M
