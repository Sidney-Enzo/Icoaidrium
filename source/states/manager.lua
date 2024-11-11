local manager = {}

function manager:enter()
    gamestate.switch(states.editor)
end

function manager:draw()

end

function manager:update(deltaTime)

end

return manager