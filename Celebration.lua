
Celebration = Class{}

function Celebration:init()
    -- Create a table to hold all our particles (the confetti pieces)
    self.particles = {}

    -- Define a palette of bright, fun colors for the confetti
    self.colors = {
        {249/255, 87/255, 56/255, 1},   -- Red-Orange
        {255/255, 222/255, 59/255, 1},  -- Yellow
        {76/255, 189/255, 137/255, 1},  -- Green
        {66/255, 134/255, 244/255, 1},  -- Blue
        {144/255, 19/255, 254/255, 1}   -- Purple
    }
end

function Celebration:start()
    -- Create 100 pieces of confetti when the celebration starts
    for i = 1, 100 do
        local particle = {
            -- Start at a random X position across the top of the screen
            x = math.random(0, VIRTUAL_WIDTH),
            -- Start at a random Y position just above the screen
            y = math.random(-VIRTUAL_HEIGHT, 0),
            -- Give it a slight horizontal drift
            dx = math.random(-80, 80),
            -- Give it a random falling speed
            dy = math.random(100, 180),
            -- Give it a random size
            size = math.random(2, 5),
            -- Pick a random color from our palette
            color = self.colors[math.random(#self.colors)],
            -- Set a lifespan in seconds
            life = math.random(3, 6),
            maxLife = 5
        }
        -- Add the newly created particle to our list
        table.insert(self.particles, particle)
    end
end

function Celebration:stop()
    -- Clear all particles to stop the effect
    self.particles = {}
end

function Celebration:update(dt)
    -- Loop through all the particles and update their position
    for i, p in ipairs(self.particles) do
        p.life = p.life - dt

        -- If the particle's life is over, remove it
        if p.life <= 0 then
            table.remove(self.particles, i)
        else
            -- Move the particle based on its speed
            p.x = p.x + p.dx * dt
            p.y = p.y + p.dy * dt
        end
    end
end

function Celebration:draw()
    -- Loop through all particles and draw them
    for i, p in ipairs(self.particles) do
        -- Set the particle's color
        love.graphics.setColor(p.color)
        -- Draw the particle as a square
        love.graphics.rectangle('fill', p.x, p.y, p.size, p.size)
    end
end

