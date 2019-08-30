local text = "Pause"

Pause = Class {
    init = function(self, width, height)
        self.width = width
        self.height = height
        self.font = love.graphics.newFont("assets/NovaFlat-Regular.ttf", 32)
        self.text = love.graphics.newText(self.font, text)
    end
}

function Pause:draw()
    love.graphics.setColor(1,1,1)
    local centerWidth = self.font:getWidth(text) / 2
    love.graphics.draw(self.text, self.width - centerWidth,
     self.height)
end