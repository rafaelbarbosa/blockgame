--
-- Created by IntelliJ IDEA.
-- User: Rafael
-- Date: 19/11/2018
-- Time: 21:35
-- To change this template use File | Settings | File Templates.
--
--
--

require "entities.menu"

local gameover = {}

function gameover:init()

    self.input = baton.new {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            action = {'key:space', 'key:return'},
        },
        pairs = {
            move = {'left','right','up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
    }

    self.menu = Menu(100,200,
    {
        {key = "restart", text="Restart"},
        {key = "exit", text="Exit"}
    })
    
end

function gameover:enter(from)
    self.from = from
    self.cooldown = 0
end

function gameover:draw()
    -- draw previous screen
    self.from:draw()

    -- get the screen width and height to position the overlay in the correct place
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()

    -- draw a semi transparent overlay to fade the game in the background
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill",0,0,W,H)

    -- draw the pause text
    self.menu:draw()

end
function gameover:update(dt)
    self.input:update()
    

    local x, y = self.input:get 'move'
    if(y > 0 and self.cooldown > 0.2 ) then
        self.menu:nextElement()
        self.cooldown = 0
    end
    if(y < 0 and self.cooldown > 0.2 ) then
        self.menu:previousElement()
        self.cooldown = 0
    end

    if self.input:pressed 'action' then
        local key, text = self.menu:getSelectedElement()
    
        if key == "restart" then 
            return Gamestate.switch(self.from) 
        end
        if key == "exit" then
            love.event.quit()
        end
        self.cooldown = 0
    end

    self.cooldown = self.cooldown + dt

end


return gameover