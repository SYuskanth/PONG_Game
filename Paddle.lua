Paddle = Class{}

-- Add a 'color' parameter to the init function
function Paddle:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    -- Store the color, defaulting to white if not provided
    self.color = color or {1, 1, 1}
end

function Paddle:update(dt)
    -- move
    self.y = self.y + self.dy * dt

    -- clamp inside screen
    if self.y < 0 then
        self.y = 0
    elseif self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
    end
end

function Paddle:render()
    -- Set the color for this paddle before drawing
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    -- Reset the color to white so it doesn't affect other drawings
    love.graphics.setColor(1, 1, 1, 1)
end
