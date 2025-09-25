Pong - Feature Updates
  

Click the File Named PongGame.exe file to play 
 

GitHub Link : https://github.com/SYuskanth/PONG_Game.git


1. Added Color to Paddles and Ball
To make the game more colorful and visually interesting.
In Paddle.lua:
We gave the paddle the ability to have a color.
●	In the Paddle:init() function:
function Paddle:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.color = color or {1, 1, 1}
end


●	In the Paddle:render() function:
function Paddle:render()
   
    love.graphics.setColor(unpack(self.color))

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1, 1)
end

Ball.lua:
We made the ball change colors dynamically.
●	In the Ball:init() function:
function Ball:init(x, y, width, height)
    -- ... (other init code) ...
    -- Added: A list of colors for the ball to use
    self.colors = {
        {217/255, 87/255, 99/255, 1},
        {95/255, 211/255, 142/255, 1},
        {255/255, 222/255, 59/255, 1},
        {66/255, 134/255, 244/255, 1}
    }
  
    self.color = self.colors[math.random(#self.colors)]
end

Why: To give the ball a random color when the game starts.

●	In the Ball:collides(paddle) function:
function Ball:collides(paddle)
    if --[[ ... collision checks ... ]] then
        self.color = paddle.color
        return true
    end
    return false
End

In main.lua:
We assigned the colors when creating the paddles.
●	In the love.load() function:
Player1 = Paddle(10, 30, 5, 20, {95/255, 211/255, 142/255, 1})
Player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20, {217/255, 87/255, 99/255, 1})

2. Added a Background Image
In main.lua:
●	In the love.load() function:
backgroundImage = love.graphics.newImage('background.png')


●	In the love.draw() function:
function love.draw()
    Push:start()
    love.graphics.draw(backgroundImage, 0, 0)
end


3. Added a Winning Celebration
New File: Celebration.lua:
A new file was created to handle all the logic for the confetti.
●	Celebration.lua (Full Code):
Celebration = Class{}

function Celebration:init()
    self.particles = {}
    self.colors = {
        {249/255, 87/255, 56/255, 1}, {255/255, 222/255, 59/255, 1},
        {76/255, 189/255, 137/255, 1}, {66/255, 134/255, 244/255, 1}
    }
end

function Celebration:start()
    for i = 1, 100 do
        table.insert(self.particles, {
            x = math.random(0, VIRTUAL_WIDTH), y = math.random(-VIRTUAL_HEIGHT, 0),
            dx = math.random(-80, 80), dy = math.random(100, 180),
            size = math.random(2, 5), color = self.colors[math.random(#self.colors)],
            life = math.random(3, 6), maxLife = 5
        })
    end
end

function Celebration:stop()
    self.particles = {}
end

function Celebration:update(dt)
    for i, p in ipairs(self.particles) do
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(self.particles, i)
        else
            p.x = p.x + p.dx * dt
            p.y = p.y + p.dy * dt
        end
    end
end

function Celebration:draw()
    for i, p in ipairs(self.particles) do
        love.graphics.setColor(p.color)
        love.graphics.rectangle('fill', p.x, p.y, p.size, p.size)
    end
end


In main.lua:
connected the new Celebration.lua file to main.lua
●	At the top of the file:
require 'Celebration'

●	In the love.load() function:
CelebrationParticles = Celebration()


●	In the love.update() function (in the scoring section):

if Player2Score == 10 then
    -- ...
    GameState = 'done'
  
    CelebrationParticles:start()
end

●	In the love.draw() function:
if GameState == 'done' then
    CelebrationParticles:draw()
end
