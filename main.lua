function love.load()
    json = require 'libs/json'
    suit = require 'libs/suit'
    camera = require 'libs/camera'
    timer = require 'libs/timer'
    lip = require 'libs/lip'
    gamestate = require 'libs/gamestate'

    states = {
        loadscreen = require 'source/states/loadscreen',
        editor = require 'source/states/editor',
        manager = require 'source/states/manager',
        credits = require 'source/states/credits'
    }

    --it might be userfull if i want do it for mobile
    system = love.system.getOS()
    isMobile = system == 'iOS' or system == 'Android'

    -- i use so much these mathematitions so just cache it
    halfScreenW = love.graphics.getWidth()/2
    halfScreenH = love.graphics.getHeight()/2

    phoenixBIOS32 = love.graphics.setNewFont('assets/fonts/phoenixBIOS.ttf', 16)

    love.graphics.setDefaultFilter('nearest', 'nearest')
    gamestate.registerEvents({ 'update', 'textinput', 'textedited', 'keypressed', 'touchpressed', 'touchmoved', 'touchreleased', 'mousepressed', 'mousemoved', 'wheelmoved' })
    gamestate.switch(states.loadscreen)
end

function love.draw()
    suit.draw()
    gamestate.current():draw()
end

function love.update(deltaTime)

end

function love.textedited(t, s, l)
    suit.textedited(t, s, l)
end

function love.keypressed(k)
    if k == 'escape' then
        love.event.quit() -- easy exit
    end
    suit.keypressed(k)
end

function love.textinput(t)
    suit.textinput(t)
end

-- math expansion --
function math.sign(n)
    if n == 0 then 
        return 0
    end
    return n < 0 and -1 or 1
end

function math.multiply(n, s)
    return math.floor(n/s)*s
end

function math.clamp(min, v, max)
    return math.min(math.max(min, v), max)
end