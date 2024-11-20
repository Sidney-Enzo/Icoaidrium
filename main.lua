function love.graphics.getQuads(textureSource, ...)
    local function overload(quadSource, ...)
        if type(quadSource) == 'number' then
            return nil, quadSource, ...
        end

        return json.decode(love.filesystem.read(quadSource))
    end

    local texture = love.graphics.newImage(textureSource)
    local sparrow, quadWidth, quadHeight, quadPaddingX, quadPaddingY = overload(...)
    local quads = {}

    if sparrow then
        for _, quad in ipairs(sparrow.frames) do
            table.insert(quads, 
                love.graphics.newQuad(
                    quad.frame.x,
                    quad.frame.y,
                    quad.frame.w,
                    quad.frame.h,
                    texture
                )
            )
        end

        return texture, quads
    end

    for quadY = 0, texture:getHeight(), quadHeight + (quadPaddingY or 0) do
        for quadX = 0, texture:getWidth(), quadWidth + (quadPaddingX or 0) do
            table.insert(quads,
                love.graphics.newQuad(
                    quadX,
                    quadY,
                    quadWidth,
                    quadHeight,
                    texture
                )
            )
        end
    end
    
    return texture, quads
end

function love.load(args)
    json = require 'libs/json'
    slab = require 'libs/slab'
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
    slab.Initialize(args)
end

function love.draw()
    gamestate.current():draw()
    slab.Draw()
end

function love.update(deltaTime)
    slab.Update(deltaTime)
end

function love.keypressed(k)
    if k == 'escape' then
        love.event.quit() -- easy exit
    end
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