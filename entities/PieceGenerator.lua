PieceGenerator = Class{
    init = function(self)

    end
}

function PieceGenerator:generate()
	local pieceIndex = math.random(7)
	local color = math.random(1,6)

	-- ##
	--  ##
	if pieceIndex == 1 then
		return Piece(
    	{
        	{0,1,1},
        	{1,1,0},
        	{0,0,0},
    	},
    	3, 3,color, 32*4,32,false
    	)
	end
	--  ##
	-- ##
	if pieceIndex == 2 then
		return Piece(
    	{
        	{1,1,0},
        	{0,1,1},
        	{0,0,0},
    	},
    	3, 3,color, 32*4,32,false
    	)
	end

	--   #
	-- ###
	if pieceIndex == 3 then
		return Piece(
    	{
        	{0,0,1},
        	{1,1,1},
        	{0,0,0},
    	},
    	3,3,color, 32*4,32,false
    	)
	end
	-- #  
	-- ###
	if pieceIndex == 4 then
		return Piece(
    	{
        	{1,0,0},
        	{1,1,1},
        	{0,0,0},
    	},
    	3, 3,color, 32*4,32,false
    	)
	end

	--  #  
	-- ###
	if pieceIndex == 5 then
		return Piece(
    	{		
        	{0,1,0},
        	{1,1,1},
        	{0,0,0},
    	},
    	3, 3, color, 32*4,32,false
    	)
	end	

	-- ##  
	-- ##
	if pieceIndex == 6 then
		return Piece(
    	{    		
    		{1,1},
    		{1,1},	
    	},
    	2, 2,color, 32*4,32,false
    	)
	end

    -- ####
	if pieceIndex == 7 then
		return Piece(
    	{
    		{0,0,0,0},
    		{1,1,1,1},
    		{0,0,0,0},
        	{0,0,0,0}
    	},
    	4, 4,color, 32*4,32,false
    	)
	end


end





