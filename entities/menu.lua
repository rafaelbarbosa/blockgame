Menu = Class{
    init = function(self,x, y, elements)
    	self.debug = false
    	self.x = x
        self.y = y
        self.elements = elements
        self.selectedElement = 1
        self.font = love.graphics.newFont("assets/NovaFlat-Regular.ttf", 32)
        self.texts = {}
        for i = 1, #self.elements do
            self.texts[i] = love.graphics.newText(self.font, self.elements[i].text)
        end
    end
}

function Menu:draw()
    for i = 1, #self.texts do
        if(self.selectedElement == i) then
            love.graphics.setColor(241/256,196/256,15/256)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.draw(self.texts[i], self.x , self.y + (42*i))
    end
end

function Menu:getSelectedElement()
    local element = self.elements[self.selectedElement]
    return element.key, element.text
end

function Menu:nextElement()
    self.selectedElement = self.selectedElement + 1
    if(self.selectedElement > #self.elements) then
        self.selectedElement = 1
    end
end
function Menu:previousElement()
    self.selectedElement = self.selectedElement - 1
    if(self.selectedElement < 1) then
        self.selectedElement = #self.elements
    end
end