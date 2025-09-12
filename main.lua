Push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')
    math.randomseed(os.time())

    SmallFont = love.graphics.newFont('Press_Start_2P/PressStart2P-Regular.ttf', 8)
    ScoreFont = love.graphics.newFont('Press_Start_2P/PressStart2P-Regular.ttf', 32)
    love.graphics.setFont(SmallFont)

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    Player1Score = 0
    Player2Score = 0

    Player1 = Paddle(10, 30, 5, 20)
    Player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)
    Ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 1
    GameState = 'start'
end

function love.update(dt)
    if GameState == 'serve' then
        Ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            Ball.dx = math.random(140, 200)
        else
            Ball.dx = -math.random(140, 200)
        end

    elseif GameState == 'play' then
        -- paddle collisions
        if Ball:collides(Player1) then
            Ball.dx = -Ball.dx * 1.03
            Ball.x = Player1.x + 5
            Ball.dy = Ball.dy < 0 and -math.random(10, 150) or math.random(10, 150)
        end

        if Ball:collides(Player2) then
            Ball.dx = -Ball.dx * 1.03
            Ball.x = Player2.x - 4
            Ball.dy = Ball.dy < 0 and -math.random(10, 150) or math.random(10, 150)
        end

        -- wall bounce
        if Ball.y <= 0 then
            Ball.y = 0
            Ball.dy = -Ball.dy
        end

        if Ball.y >= VIRTUAL_HEIGHT - Ball.height then
            Ball.y = VIRTUAL_HEIGHT - Ball.height
            Ball.dy = -Ball.dy
        end

        -- scoring
        if Ball.x < 0 then
            Player2Score = Player2Score + 1
            servingPlayer = 1
            if Player2Score == 10 then
                winningPlayer = 2
                GameState = 'done'
            else
                Ball:reset()
                GameState = 'serve'
            end
        end

        if Ball.x > VIRTUAL_WIDTH then
            Player1Score = Player1Score + 1
            servingPlayer = 2
            if Player1Score == 10 then
                winningPlayer = 1
                GameState = 'done'
            else
                Ball:reset()
                GameState = 'serve'
            end
        end
    end

    -- player movement
    if love.keyboard.isDown('w') then
        Player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        Player1.dy = PADDLE_SPEED
    else
        Player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        Player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        Player2.dy = PADDLE_SPEED
    else
        Player2.dy = 0
    end

    if GameState == 'play' then
        Ball:update(dt)
    end

    Player1:update(dt)
    Player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if GameState == 'start' then
            GameState = 'serve'
        elseif GameState == 'serve' then
            GameState = 'play'
        elseif GameState == 'done' then
            Player1Score = 0
            Player2Score = 0
            Ball:reset()
            servingPlayer = winningPlayer == 1 and 2 or 1
            GameState = 'serve'
        end
    end
end

function love.draw()
    Push:start()
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    love.graphics.setFont(SmallFont)
    if GameState == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    elseif GameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
    elseif GameState == 'done' then
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Restart', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- scores
    love.graphics.setFont(ScoreFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- paddles & ball
    Player1:render()
    Player2:render()
    Ball:render()

    displayFPS()
    Push:finish()
end

function displayFPS()
    love.graphics.setFont(SmallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end
