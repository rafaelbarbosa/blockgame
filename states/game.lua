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
require "entities.piecedrawer"
Camera = require "hump.camera"

local game = {}

function game:enter()
    camera = Camera(1024/2, 768/2)
    camera.scale = love.graphics.getHeight()/768
    self.score=0
    game.input = baton.new {
            controls = {
                rotateLeft = {'key:z'},
                rotateRight = {'key:x'},
                left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
                right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
                up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
                down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
                action = {'key:space', 'button:a'},
                exit = {'key:escape'},
                debug = {'key:t'},
            },
            pairs = {
                move = {'left', 'right', 'up', 'down'}
            },
            joystick = love.joystick.getJoysticks()[1],
        }

    board = Board(10,24)
    pieceDrawer = PieceDrawer()
    
    piece = pieceDrawer:getNextPiece()
    ghostPiece = piece:clone()
    ghostPiece.ghost=true
    game.cooldown = 0.2
    game.timer = 0

end


function game:draw()
    camera:attach()
    
    board:draw()
    piece:draw()
    pieceDrawer:draw()
    ghostPiece:draw()
    camera:detach()

end

function game:update(dt)

 

    self.input:update()
        
    local x, y = self.input:get 'move'
    if x < 0 and self.cooldown < 0 and board:canPieceMoveLeft(piece) then
        piece:moveLeft()
        ghostPiece:moveLeft()
        self.cooldown = 0.2
    end
    if x > 0 and self.cooldown < 0 and board:canPieceMoveRight(piece) then
        piece:moveRight()
        ghostPiece:moveRight()
        self.cooldown = 0.2
    end

    
    

     if self.input:pressed 'rotateLeft' and self.cooldown < 0 then
        piece:rotateLeft()
        ghostPiece:rotateLeft()
        self.cooldown = 0.2
    end
    if self.input:pressed 'rotateRight' and self.cooldown < 0 then
        piece:rotateRight()
        ghostPiece:rotateRight()
        self.cooldown = 0.2
    end

    self:updateGhostPieceHeight()
    if y > 0 and self.cooldown < 0 and board:canPieceMoveDown(piece) then
        piece.y = ghostPiece.y
        self.cooldown = 0.2
        self.timer = 0
    end


    

    self.cooldown = self.cooldown - dt
    self.timer = self.timer + dt
    if self.timer > 1 and board:canPieceMoveDown(piece) then
        piece:moveDown()
        self.timer = 0
    end

   
    if board:canPieceMoveDown(piece) == false then
        board:addPieceToBoard(piece)
        self.score = self.score + board:removeCompleteRows() * 10000
        piece = pieceDrawer:getNextPiece()
        ghostPiece = piece:clone()
        ghostPiece.ghost=true
    end
    board:update(dt)
    
end
function game:updateGhostPieceHeight()
    local gX, gY = 	ghostPiece:getLocationInBoard()
    local gMatrix = ghostPiece:getMatrix()
    local gPieceWidth,_ = ghostPiece:getSize()

    local gColumnHeight = {}

    
    
    for col = 1, gPieceWidth do
        local cHeight = 0
        for row = 1,#gMatrix do
            if gMatrix[row][col] == 1 then 
                cHeight = row 
            end
        end
        gColumnHeight[col] = cHeight
    end
    local minHeightOfPiece = 24
    for i = 1, gPieceWidth do
        if((gX+i)-1>0 and (gX+i)-1<11) then
            local heightOfColumn = board:getHeightOfColumn((gX+i)-1);
            local cHeightOfPiece = heightOfColumn - (gColumnHeight[i])
            if cHeightOfPiece < minHeightOfPiece then
                minHeightOfPiece = cHeightOfPiece
            end
        end
    end 

    ghostPiece.y = (minHeightOfPiece)*32
end


return game
