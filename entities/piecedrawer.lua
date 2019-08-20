require "entities.PieceGenerator"

PieceDrawer = Class{
    init = function(self)
        self.pieceGenerator = PieceGenerator()

        self.pieces = {}
        self.pieces[1] = self.pieceGenerator:generate()
        self.pieces[2] = self.pieceGenerator:generate()
        self.pieces[3] = self.pieceGenerator:generate()
        self.pieces[4] = self.pieceGenerator:generate()
        self.pieces[5] = self.pieceGenerator:generate()

        self:updatePiecePosition()
    end
}



function PieceDrawer:getNextPiece()
    local nextPiece = table.remove(self.pieces,1)
    self.pieces[#self.pieces+1] = self.pieceGenerator:generate()
    self:updatePiecePosition()
    nextPiece.x = 32*4
    nextPiece.y = 32
    return nextPiece
end

function PieceDrawer:updatePiecePosition()
    for i =1,#self.pieces do
        local nextPiece = self.pieces[i]
        nextPiece.x = 340
        nextPiece.y = (i -1) * (32 * 3) + 10
    end
end

function PieceDrawer:draw()
    for i =1,#self.pieces do
        local nextPiece = self.pieces[i]
        nextPiece:draw()
    end
end