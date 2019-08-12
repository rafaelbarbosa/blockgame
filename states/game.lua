--
-- Created by IntelliJ IDEA.
-- User: Rafael
-- Date: 05/11/2018
-- Time: 21:37
-- To change this template use File | Settings | File Templates.
--

require "entities.board"
require "entities.piece"
require "entities.PieceGenerator"


local game = {}

function game:enter()

    game.input = baton.new {
            controls = {
                rotateLeft = {'key:z'},
                rotateRight = {'key:x'},
                left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
                right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
                up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
                down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
                action = {'key:space', 'button:a'},
            },
            pairs = {
                move = {'left', 'right', 'up', 'down'}
            },
            joystick = love.joystick.getJoysticks()[1],
        }

	board = Board(10,24)
    pieceGenerator = PieceGenerator()
    piece = pieceGenerator:generate()
    game.cooldown = 0.2
    game.timer = 0

    --camera = Camera(0, 0,1)
    --camera.smoother = Camera.smooth.damped(10)
    --love.graphics.setBackgroundColor( 1,1,1 )

end


function game:draw()
    --camera:attach()
    
    board:draw()
    piece:draw()
    --camera:detach()

end

function game:update(dt)

 

    self.input:update()
        
    local x, y = self.input:get 'move'
    if x < 0 and self.cooldown < 0 and board:canPieceMoveLeft(piece) then
        piece:moveLeft()
        self.cooldown = 0.2
    end
    if x > 0 and self.cooldown < 0 and board:canPieceMoveRight(piece) then
        piece:moveRight()
        self.cooldown = 0.2
    end

    if y > 0 and self.cooldown < 0 and board:canPieceMoveDown(piece) then
        piece:moveDown()
        self.cooldown = 0.2
        self.timer = 0
    end
    

     if self.input:pressed 'rotateLeft' and self.cooldown < 0 then
        piece:rotateLeft()
        self.cooldown = 0.2
    end
    if self.input:pressed 'rotateRight' and self.cooldown < 0 then
        piece:rotateRight()
        self.cooldown = 0.2
    end
    

    self.cooldown = self.cooldown - dt
    self.timer = self.timer + dt
    if self.timer > 1 and board:canPieceMoveDown(piece) then
        piece:moveDown()
        self.timer = 0
    end
   
    if board:canPieceMoveDown(piece) == false then
        board:addPieceToBoard(piece)
        board:removeCompleteRows()
        piece = pieceGenerator:generate()

    end
    board:update(dt)
    
end


return game
