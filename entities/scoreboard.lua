Scoreboard = Class{
    init = function(self,x,y)
        self.x = x
        self.y = y
        self.score = 0
        self.font = love.graphics.newFont("assets/NovaFlat-Regular.ttf",32)
        self.text = love.graphics.newText(self.font,string.format("%09d",0))
    end
}

function Scoreboard:updateScore(score)
    self.score = score
    self.text:set(string.format("%09d",score))
end

function Scoreboard:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.text,self.x, self.y)
end