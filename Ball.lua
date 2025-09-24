Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    
    -- A table of nice colors for the ball to cycle through
    self.colors = {
        {217/255, 87/255, 99/255, 1},   -- red
        {95/255, 211/255, 142/255, 1},  -- green
        {86/255, 153/255, 227/255, 1},  -- blue
        {230/255, 210/255, 120/255, 1}, -- yellow
        {134/255, 124/255, 220/255, 1}  -- purple
    }
    
    -- Start with a random color
    self.color = self.colors[math.random(#self.colors)]
    
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-60, 60)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- I noticed you had two 'reset' functions in your original file. 
-- I've merged them into this single function.
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    
    -- Get a new random color on reset
    self.color = self.colors[math.random(#self.colors)]
    
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

function Ball:render()
    -- Set the ball's current color before drawing
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    -- Reset color to white so it doesn't affect other drawings
    love.graphics.setColor(1, 1, 1, 1)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    
    -- When the ball collides, it takes the color of the paddle it hit!
    self.color = paddle.color
    
    return true
end
