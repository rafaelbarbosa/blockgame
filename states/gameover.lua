--
-- Created by IntelliJ IDEA.
-- User: Rafael
-- Date: 19/11/2018
-- Time: 21:35
-- To change this template use File | Settings | File Templates.
--
--
--


local gameover = {}

function gameover:enter()

end

function gameover:draw()
    love.graphics.print("you dead", 0, 0);
end


return gameover