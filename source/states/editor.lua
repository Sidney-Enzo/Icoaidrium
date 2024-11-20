local editor = {}
editor.id = ""

function editor:enter()
    undoRedo = require 'source/modules/undoRedo'
    UI = require 'source/modules/UI'
    tools = require 'source/modules/tools'

    editorCamera = camera.new(nil, nil, 1, 0)
    editorCamera.speed = 0.25
    editorCamera.targetZoom = 1

    chunkSize = 4 -- blocks

    sprites = { love.graphics.newImage('assets/images/defaultTexture.png') }
    spriteSelected = 1

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
    UI.displayInfo()
end

function editor:update(deltaTime)
    editorCamera.scale = editorCamera.targetZoom
    if love.mouse.isDown(1) then 
        tools.primary(mouseGridX, mouseGridY, true)
    elseif love.mouse.isDown(2) then
        tools.secondary(mouseGridX, mouseGridY, true) 
    end
    if love.keyboard.isDown('rctrl', 'z') then
        undoRedo:undo()
    elseif love.keyboard.isDown('rctrl', 'y') then
        undoRedo:redo()
    end
end

function editor:keypressed(k)
    if k == 'e' then
        tools.changePrimary("erase")
    elseif k == 'p' then
        tools.changePrimary("pencil")
    elseif k == 'b' then
        tools.changePrimary("bucket")
    elseif k == 'o' then
        tools.changePrimary("blockPicker")
    elseif k == 'k' then
        tools.switch()
    end
end

function editor:wheelmoved(x, y)
    editorCamera.targetZoom = math.clamp(0.5, editorCamera.targetZoom + math.sign(y)*editorCamera.speed, 3) -- zoom and zoom clamp
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