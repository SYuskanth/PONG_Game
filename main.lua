Push = require 'push'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_HEIGHT = 243
VIRTUAL_WIDTH = 432

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')

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

    Player1Y = 30
    Player2Y = VIRTUAL_HEIGHT - 50

    -- ball position
    BallX = VIRTUAL_WIDTH / 2 - 2
    BallY = VIRTUAL_HEIGHT / 2 - 2
    -- faster speed so it's visible
    BallDX = math.random(2) == 1 and 100 or -100
    BallDY = math.random(-60, 60)

    GameState = 'start'
end

function love.update(dt)
    -- Player 1 movement
    if love.keyboard.isDown('w') then
        Player1Y = math.max(0, Player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        Player1Y = math.min(VIRTUAL_HEIGHT - 20, Player1Y + PADDLE_SPEED * dt)
    end

    -- Player 2 movement
    if love.keyboard.isDown('up') then
        Player2Y = math.max(0, Player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        Player2Y = math.min(VIRTUAL_HEIGHT - 20, Player2Y + PADDLE_SPEED * dt)
    end

    -- Ball movement only if playing
    if GameState == 'play' then
        BallX = BallX + BallDX * dt
        BallY = BallY + BallDY * dt
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if GameState == 'start' then
            GameState = 'play'
        else
            GameState = 'start'
            -- reset ball position and speed
            BallX = VIRTUAL_WIDTH / 2 - 2
            BallY = VIRTUAL_HEIGHT / 2 - 2
            BallDX = math.random(2) == 1 and -100 or 100
            BallDY = math.random(-60, 60)
        end
    end
end

function love.draw()
    Push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- title
    love.graphics.setFont(SmallFont)
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')

    -- paddles
    love.graphics.rectangle('fill', 10, Player1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, Player2Y, 5, 20)

    -- ball (moving)
    love.graphics.rectangle('fill', BallX, BallY, 4, 4)

    -- scores
    love.graphics.setFont(ScoreFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    Push:finish()
end
