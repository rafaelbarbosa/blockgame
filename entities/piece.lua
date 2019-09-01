--
-- Created by IntelliJ IDEA.
-- User: Rafael
-- Date: 18/11/2018
-- Time: 18:15
-- To change this template use File | Settings | File Templates.
--

Piece = Class{
	init = function(self,matrix,width, height,color, x,y,ghost)
	    self.matrix = matrix
	    self.color = color
	    self.width = width
	    self.height = height
	    self.x = x
		self.y = y
		self.ghost = ghost
	    self.spritesheet = love.graphics.newImage('assets/blocks.png')
		self.quad = love.graphics.newQuad(0, (color*32)-32, 32, 32, self.spritesheet:getDimensions())    
    end
}




function Piece:draw()
	if(self.ghost) then
		love.graphics.setColor( 1, 1, 1, 0.5)
	else
		love.graphics.setColor( 1, 1, 1, 1 )
	end
	for i=1,self.height do
    	for j=1,self.width do
      		if(self.matrix[i][j]> 0) then
        		love.graphics.draw(self.spritesheet, self.quad,((j*32)-32)+self.x,((i*32)-32)+self.y)
        	end
      	end
	end
end

function Piece:update(dt)


end

function Piece:getLocationInBoard()
	local x = self.x
	local y = self.y

	x = math.floor(x/32) + 1
	y = math.floor(y/32) + 1

	return x,y
end 

function Piece:getColor()
	return self.color
end 

function Piece:getSize()
	return self.width,self.height
end 

function Piece:moveDown()
	self.y = self.y + 32
end

function Piece:moveLeft()
	self.x = self.x - 32
end

function Piece:moveRight()
	self.x = self.x + 32
end


function Piece:rotateLeft()
	self.matrix = rotate_CCW_90(self.matrix)
	local nWidth = self.height
	self.height = self.width
	self.width = nWidth
end

--// matrix.rotr ( m1 )
-- Rotate Right, 90 degrees
function Piece:rotateRight()
	self.matrix = rotate_CW_90(self.matrix)
	local nWidth = self.height
	self.height = self.width
	self.width = nWidth
end
function Piece:getMatrix()
	return self.matrix
end

function Piece:getCWRotatedMatrix()
	return rotate_CW_90(self.matrix)
end
function Piece:getCCWRotatedMatrix()
	return rotate_CCW_90(self.matrix)
end


function transpose(m)
   local rotated = {}
   for c, m_1_c in ipairs(m[1]) do
      	local col = {m_1_c}
		for r = 2, #m do
			col[r] = m[r][c]
		end
		table.insert(rotated, col)
   end
   return rotated
end

function rotate_CCW_90(m)
   local rotated = {}
   for c, m_1_c in ipairs(m[1]) do
		local col = {m_1_c}
		for r = 2, #m do
			col[r] = m[r][c]
		end
		table.insert(rotated, 1, col)
   end
   return rotated
end

function rotate_180(m)
   return rotate_CCW_90(rotate_CCW_90(m))
end

function rotate_CW_90(m)
   return rotate_CCW_90(rotate_CCW_90(rotate_CCW_90(m)))
end