
Board = Class{
    init = function(self,width, height)
    	self.debug = true
    	self.width = width
    	self.height = height
	    self.matrix = {}          -- create the matrix
	    for i=1,height do
	      self.matrix[i] = {}     -- create a new row
	      for j=1,width do
	        self.matrix[i][j] = 0
	      end
	    end
	    self.spritesheet = love.graphics.newImage('assets/blocks.png')
	    self.quads = {}
	    for i=1,18 do
	    	self.quads[i] = love.graphics.newQuad(0, (i*32)-32, 32, 32, self.spritesheet:getDimensions())
	    end
    end
}




function Board:draw()
	
	for i=1,self.height do
		if(self.debug) then
			love.graphics.setColor( 0, 1, 0, 1 )
      		love.graphics.line( 0, (i-1)*32 , self.width*32,(i-1)*32 )
      	end
      for j=1,self.width do
      	if(self.debug) then
      		love.graphics.setColor( 0, 1, 0, 1 )
      		love.graphics.line( j*32, 0 , j*32, self.height*32)
      	end
      	if(self.matrix[i][j]> 0) then
      		love.graphics.setColor( 1, 1, 1, 1 )
        	local blockQuad = self.quads[self.matrix[i][j]]
        	love.graphics.draw(self.spritesheet, blockQuad,(j*32)-32,(i*32)-32)
        end
      end
	end
end

function Board:canPieceMoveDown(piece)
	local pX,pY = piece:getLocationInBoard()
	local pMatrix = piece:getMatrix()
	local pWidth,pHeight = piece:getSize()

	-- check if the piece is at the bottom of the board
	for i=1,pHeight do
	    for j=1,pWidth do
	    	if(pMatrix[i][j] == 1 and i+pY > self.height) then
	    		return false
	    	end
	    	
	    	if( pMatrix[i][j] == 1 and pMatrix[i][j] + self.matrix[i+pY][j+pX-1] > 1) then
	    		return false
	    	end 
	    end
	end
	return true

end

function Board:canPieceMoveLeft(piece)
	local pX,pY = piece:getLocationInBoard()
	local pMatrix = piece:getMatrix()
	local pWidth,pHeight = piece:getSize()

	for i=1,pHeight do
	    for j=1,pWidth do
	    	if(pMatrix[i][j] == 1 and j+pX-2 < 1) then
	    		return false
	    	end
	    	if( pMatrix[i][j] == 1 and pMatrix[i][j] + self.matrix[i+pY-1][j+pX-2] > 1) then
	    		return false
	    	end 
	    end
	end
	
	
	return true

end
function Board:canPieceMoveRight(piece)
	local pX,pY = piece:getLocationInBoard()
	local pMatrix = piece:getMatrix()
	local pWidth,pHeight = piece:getSize()

	-- check if the piece is at the bottom of the board
	for i=1,pHeight do
	    for j=1,pWidth do
	    	if(pMatrix[i][j] == 1 and j+pX > self.width) then
	    		return false
	    	end
	    	
	    	if( pMatrix[i][j] == 1 and pMatrix[i][j] + self.matrix[i+pY-1][j+pX] > 1) then
	    		return false
	    	end 
	    end
	end
	return true

end

function Board:addPieceToBoard(piece)
	local pX,pY = piece:getLocationInBoard()
	local pMatrix = piece:getMatrix()
	local pWidth,pHeight = piece:getSize()
	local pColor = piece:getColor()

	for i=1,pHeight do
	    for j=1,pWidth do
	    	if(pMatrix[i][j] == 1) then 
	    		self.matrix[i+pY-1][j+pX-1] = self.matrix[i+pY-1][j+pX-1] + pMatrix[i][j]*pColor
	    	end
	    end
	end


end

function Board:update(dt)
	
	
end

function Board:removeCompleteRows()
	local i = self.height
	local numberOfLinesCleared = 0
	repeat
	

	  -- count the number of filled pieces in this row
	  local filledPieces = 0
      for j=1,self.width do
        if(self.matrix[i][j]> 0) then
        	filledPieces = filledPieces +1
        end
      end
      -- if the number of pieces in this row is equal to the width means that the row is complete
      -- so we remove the row, add to the score and pull the up pieces in upper row down.
      if(filledPieces == self.width) then
      	for k=i,2,-1 do
  			for l=1,self.width do
				self.matrix[k][l] = self.matrix[k-1][l]
			end
		  end
		  numberOfLinesCleared = numberOfLinesCleared + 1
		else
			i = i - 1
	   end
	  
	until i == 0
	return numberOfLinesCleared
end

