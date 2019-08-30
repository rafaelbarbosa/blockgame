GamePause = {}
require "entities.pause"

function GamePause:enter(from)
    self.from = from -- record previous state
end

function GamePause:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()

    local pause = Pause(W/2, H/2)
    pause:draw()
end

-- extending the example of Gamestate.push() above
function GamePause:keypressed(key)
    if key == 'p' then
        return Gamestate.pop() -- return to previous state
    end
end

return GamePause