local loadscreen = {}

function loadscreen:enter()
    meta = json.decode(love.filesystem.read('source/helpers/metaTemplate.json')) -- we have map default settings and guit settings

    icosaidriumIcon = love.graphics.newImage('assets/images/icosaidriumIcon.png')
    alph = 1 --screen opacity

    loadscreenTimer = timer.new()
    loadscreenTimer:after(2.5, function()
        icosaidriumIcon:release()
        gamestate.switch(states.manager)
    end)
    loadscreenTimer:tween(2.5, _G, { alph = 0 }, 'in-linear')
end

function loadscreen:draw()
    love.graphics.setColor(1, 1, 1, alph)
    love.graphics.draw(icosaidriumIcon, halfScreenW, halfScreenH, 0, 2, 2, icosaidriumIcon:getWidth()/2, icosaidriumIcon:getHeight()/2)
    love.graphics.setColor(1, 1, 1, 1)
end

function loadscreen:update(deltaTime)
    loadscreenTimer:update(deltaTime)
end

return loadscreen