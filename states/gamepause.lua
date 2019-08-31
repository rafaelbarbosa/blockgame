GamePause = {}
require "entities.pause"

function GamePause:init()
    -- create an instance of baton to handle player input
    -- this will be useful for a more feature complete pause screen that has options like exit game or return to game
    self.input = baton.new {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            action = {'key:space', 'button:enter'},
            exit = {'key:escape'},
            pause = {'key:p'}
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
    }
    --instantiate the pause text and set it in the middle of the screen
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    self.pause = Pause(W/2, H/2)
end

function GamePause:enter(from)
    -- record previous state
    self.from = from
    
    -- set the cooldown to 0. this cooldown is used to check if some time has passed since entering this state
    -- this prevents issues like the user keeping the pause action pressed and leaving the state immediatly
    self.cooldown = 0 
end

function GamePause:draw()
    -- draw previous screen
    self.from:draw()

    -- get the screen width and height to position the overlay in the correct place
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()

    -- draw a semi transparent overlay to fade the game in the background
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill",0,0,W,H)

    -- draw the pause text
    self.pause:draw()
end

function GamePause:update(dt)
    -- update baton input
    self.input:update()

    -- check if we've entered the state more than 200ms ago and unlock user input
    if self.cooldown > 0.2 then
        --check if the user has pressed either exit or pause and return to the game
        if self.input:pressed "exit" or self.input:pressed 'pause' then
            return Gamestate.pop() 
        end
    else
        -- we haven't been in the state for more than 200ms, increment the cooldown with the delta time
        self.cooldown = self.cooldown + dt
    end
end

return GamePause