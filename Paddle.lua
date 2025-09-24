Paddle = Class{}


function Paddle:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
 
    self.color = color or {1, 1, 1}
end

function Paddle:update(dt)

    self.y = self.y + self.dy * dt

    if self.y < 0 then
        self.y = 0
    elseif self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
    end
end

function Paddle:render()
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1, 1)
end
