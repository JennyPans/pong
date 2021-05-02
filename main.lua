if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

io.stdout:setvbuf("no")

function newRectangle(x, y, w, h)
    return {
        x = x,
        y = y,
        w = w,
        h = h
    }
end

function newPad(x, y, w, h)
    local pad = newRectangle(x, y, w, h)
    pad.vy = 0
    pad.speed = 300
    pad.score = 0
    return pad
end

function newBall(x, y, w, h)
    local ball = newRectangle(x, y, w, h)
    ball.vx = 0
    ball.vy = 0
    return ball
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then love.event.quit() end
end

function love.load()
    font = love.graphics.newFont("DIMITRI_.ttf", 64)
    screen_width = 854
    screen_height = 480
    pad1 = newPad(20, (screen_height/2) - 40, 20, 80)
    pad1.score = 0
    pad2 = newPad(screen_width - 40, (screen_height/2) - 40, 20, 80)
    ball = newBall((screen_width / 2) - 10, (screen_height / 2) - 10, 20, 20)
    ball.vx = -300
    ball.vy = -300
    pong = love.audio.newSource("pong.ogg", "static")
end

function love.update(dt)
    pad1.vy = 0
    pad2.vy = 0
    if love.keyboard.isDown("s") then pad1.vy = pad1.speed end
    if love.keyboard.isDown("z") then pad1.vy = -pad1.speed end
    if love.keyboard.isDown("down") then pad2.vy = pad2.speed end
    if love.keyboard.isDown("up") then pad2.vy = -pad2.speed end
    pad1.y = pad1.y + pad1.vy * dt
    pad2.y = pad2.y + pad2.vy * dt
    if pad1.y < 0 then pad1.y = 0 end
    if pad1.y + pad1.h > screen_height then pad1.y = screen_height - pad1.h end
    if pad2.y < 0 then pad2.y = 0 end
    if pad2.y + pad2.h > screen_height then pad2.y = screen_height - pad2.h end
    ball.x = ball.x + (ball.vx * dt)
    ball.y = ball.y + (ball.vy * dt)
    if ball.x < 0 then
        ball.x = 0
        ball.vx = -ball.vx
        pad2.score = pad2.score + 1
        ball.x = (screen_width / 2) - 10
        ball.y = (screen_height / 2) - 10
        pong:play()
    end
    if ball.y < 0 then
        ball.y = 0
        ball.vy = -ball.vy
        pong:play()
    end
    if ball.x + ball.w > screen_width then
        ball.x = screen_width - ball.w
        ball.vx = -ball.vx
        pad1.score = pad1.score + 1
        ball.x = (screen_width / 2) - 10
        ball.y = (screen_height / 2) - 10
        pong:play()
    end
    if ball.y + ball.h > screen_height then
        ball.y = screen_height - ball.h
        ball.vy = -ball.vy
        pong:play()
    end
    if ball.x < pad1.x + pad1.w and ball.y + ball.h > pad1.y and ball.y < pad1.y + pad1.h then
        ball.x = pad1.x + pad1.w
        ball.vx = -ball.vx
        pong:play()
    end
    if ball.x + ball.w > pad2.x and ball.y + ball.h > pad2.y and ball.y < pad2.y + pad2.h then
        ball.x = pad2.x - ball.w
        ball.vx = -ball.vx
        pong:play()
    end
end

function love.draw()
    love.graphics.print(pad1.score, font, (screen_width/2) - 60, 30)
    love.graphics.print(pad2.score, font, (screen_width/2) + 20, 30)
    love.graphics.line(screen_width/2, 0, screen_width/2, screen_height)
    love.graphics.rectangle("fill", pad1.x, pad1.y, pad1.w, pad1.h)
    love.graphics.rectangle("fill", pad2.x, pad2.y, pad2.w, pad2.h)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.w, ball.h)
end