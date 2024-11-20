local editor = {}
editor.id = ""

function passBlock()
    if spriteSelected < #sprites then
        spriteSelected = spriteSelected + 1
        print(spriteSelected)
    end
end

function backBlock()
    if spriteSelected > 1 then
        spriteSelected = spriteSelected - 1
        print(spriteSelected)
    end
end

function editor:enter()
    undoRedo = require 'source/modules/undoRedo'
    UI = require 'source/modules/UI'
    tools = require 'source/modules/tools'

    editorCamera = camera.new(nil, nil, 1, 0)
    editorCamera.speed = 0.25

    chunkSize = 4 -- blocks

    spriteSheet = love.graphics.newImage('assets/images/defaultTexture.png')
    sprites = { love.graphics.newQuad(0, 0, 32, 32, spriteSheet) }
    spriteSelected = 1

    buttonsTexture, buttonsQuads = love.graphics.getQuads("assets/images/themes/platinium.png", "assets/images/themes/platinium.json")
    buttonsCurrentQuads = {1, 5, 3, 7, 9, 11, 13}
    local mx, my = editorCamera:mousePosition()
    mouseGridX = math.multiply(mx, meta.map.gridSize)
    mouseGridY = math.multiply(my, meta.map.gridSize)
end

function editor:draw()
    editorCamera:attach()
    UI.drawBlocks()
    UI.showBlockOnMouse()
    UI.drawGrid()
    editorCamera:detach()
end

function editor:update(deltaTime)
    UI.menuBar()
    UI.displayInfo()
    if slab.IsVoidHovered() then
        if love.mouse.isDown(1) then 
            tools.primary(mouseGridX, mouseGridY, true)
        elseif love.mouse.isDown(2) then
            tools.secondary(mouseGridX, mouseGridY, true) 
        end
    end

    if love.keyboard.isDown('rctrl', 'z') then
        undoRedo:undo()
    elseif love.keyboard.isDown('rctrl', 'y') then
        undoRedo:redo()
    end

    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        passBlock()
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        backBlock()
    end
end

function editor:keypressed(k)
    if k == 'e' then
        tools.changePrimary('erase')
    elseif k == 'p' then
        tools.changePrimary('pencil')
    elseif k == 'b' then
        tools.changePrimary('bucket')
    elseif k == 'o' then
        tools.changePrimary('blockPicker')
    elseif k == 'k' then
        tools.switch()
    end
end

function editor:wheelmoved(x, y)
    editorCamera.scale = math.clamp(0.5, editorCamera.scale + math.sign(y)*editorCamera.speed, 3) -- zoom and zoom clamp
end

function editor:mousemoved(x, y, dx, dy)
    local mx, my = editorCamera:mousePosition()
    mouseGridX = math.multiply(mx, meta.map.gridSize)
    mouseGridY = math.multiply(my, meta.map.gridSize)
    -- mouse scroll --
    if love.mouse.isDown(3) then
        editorCamera.x = editorCamera.x - math.floor(dx/editorCamera.scale)
        editorCamera.y = editorCamera.y - math.floor(dy/editorCamera.scale)
    end
end

return editor