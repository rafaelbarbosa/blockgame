Pause = Class {
    init = function(self, isPaused, width, height)
        self.isPaused = isPaused
        self.width = width
        self.height = height
        self.font = love.graphics.newFont("assets/NovaFlat-Regular.ttf", 32)
        self.text = love.graphics.newText(self.font, "Pause")
    end
}

function Pause:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.text, self.width, self.height)
end