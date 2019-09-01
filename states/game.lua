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
require "entities.scoreboard"

Camera = require "hump.camera"
Gamestate = require "hump.gamestate"


local game = {}
local pause = require "states.gamepause"
local gameover = require "states.gameover"

function game:enter()
    self.camera = Camera(1024/2, 768/2)
    self.camera.scale = love.graphics.getHeight()/768
    self.score=0
    self.input = baton.new {
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
                pause = {'key:p'}
            },
            pairs = {
                move = {'left', 'right', 'up', 'down'}
            },
            joystick = love.joystick.getJoysticks()[1],
        }

    self.board = Board(10,24)
    self.pieceDrawer = PieceDrawer()
    
    self.piece = self.pieceDrawer:getNextPiece()
    self.ghostPiece = self.piece:clone()
    self.ghostPiece.ghost=true
    self.cooldown = 0.2
    self.timer = 0
    self.scoreboard = Scoreboard(11*32,23*32)
end


function game:draw()
    self.camera:attach()
    
    self.board:draw()
    self.piece:draw()
    self.pieceDrawer:draw()
    self.ghostPiece:draw()
    self.scoreboard:draw()
    self.camera:detach()

end

function game:update(dt)

    self.input:update()
        
    local x, y = self.input:get 'move'
    if x < 0 and self.cooldown < 0 and self.board:canPieceMoveLeft(self.piece) then
        self.piece:moveLeft()
        self.ghostPiece:moveLeft()
        self.cooldown = 0.2
    end
    if x > 0 and self.cooldown < 0 and self.board:canPieceMoveRight(self.piece) then
        self.piece:moveRight()
        self.ghostPiece:moveRight()
        self.cooldown = 0.2
    end

    if self.input:pressed 'pause' then
        if Gamestate.current() ~= pause then
            Gamestate.push(pause)
        end
    end
    
     if self.input:pressed 'rotateLeft' and self.cooldown < 0 then
        self.piece:rotateLeft()
        self.ghostPiece:rotateLeft()
        self.cooldown = 0.2
    end
    if self.input:pressed 'rotateRight' and self.cooldown < 0 then
        self.piece:rotateRight()
        self.ghostPiece:rotateRight()
        self.cooldown = 0.2
    end

    self:updateGhostPieceHeight()
    if y > 0 and self.cooldown < 0 and self.board:canPieceMoveDown(self.piece) then
        self.piece.y = self.ghostPiece.y
        self.cooldown = 0.2
        self.timer = 0
    end


    

    self.cooldown = self.cooldown - dt
    self.timer = self.timer + dt
    if self.timer > 1 and self.board:canPieceMoveDown(self.piece) then
        self.piece:moveDown()
        self.timer = 0
    end

   
    if self.board:canPieceMoveDown(self.piece) == false then
        self.board:addPieceToBoard(self.piece)
        self.score = self.score + self.board:removeCompleteRows() * 10000
        self.scoreboard:updateScore(self.score)
        self.piece = self.pieceDrawer:getNextPiece()
        self.ghostPiece = self.piece:clone()
        self.ghostPiece.ghost=true

        -- check if we can place the new piece on the starting place
        -- otherwise we lost so lets change to another state
        if self.board:canPieceBePlaced(self.piece) == false then
            Gamestate.switch(gameover)
        end

    end
    self.board:update(dt)
    
end
function game:updateGhostPieceHeight()
    local gX, gY = 	self.ghostPiece:getLocationInBoard()
    local gMatrix = self.ghostPiece:getMatrix()
    local gPieceWidth,_ = self.ghostPiece:getSize()

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
            local heightOfColumn = self.board:getHeightOfColumn((gX+i)-1);
            local cHeightOfPiece = heightOfColumn - (gColumnHeight[i])
            if cHeightOfPiece < minHeightOfPiece then
                minHeightOfPiece = cHeightOfPiece
            end
        end
    end 

    self.ghostPiece.y = (minHeightOfPiece)*32
end


return game
