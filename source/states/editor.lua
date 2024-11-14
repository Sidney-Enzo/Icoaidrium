local editor = {}
editor.id = ""

function createChunk(x, y, size)
    local newChunk = {
        position = { x, y },
        blocks = {},
        objects = {}
    }
    -- fill chunk with null blocks
    for y = 1, size, 1 do
        newChunk.blocks[y] = {}
        for x = 1, size, 1 do
            table.insert(newChunk.blocks[y], 0) -- no block
        end
    end
    return newChunk
end

-- handler blocks --
function createBlock(id, x, y, canUndo)
    -- its all like in an big array
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position[1] and y >= chunk.position[2] and x < chunk.position[1] + chunkSize*meta.map.gridSize and y < chunk.position[2] + chunkSize*meta.map.gridSize then
            -- in the chunk
            local blockX = (x - chunk.position[1])/meta.map.gridSize + 1
            local blockY = (y - chunk.position[2])/meta.map.gridSize + 1
            if chunk.blocks[blockY][blockX] == id then
                return
            end
            -- print("Block x ", (x - chunk.position[1])/meta.map.gridSize + 1, "Block y ", (y - chunk.position[2])/meta.map.gridSize + 1)
            if canUndo then -- prevent create another undo object when undo call it
                undoRedo:newUndoObject(deleteBlock, x, y, false)
            else
                undoRedo:newRedoObject(deleteBlock, x, y, true)
            end
            chunk.blocks[blockY][blockX] = id or 1
            print("block created")
            return
        end
    end
    -- chunk does not exist
    local newChunk = createChunk(math.multiply(x, chunkSize*meta.map.gridSize), math.multiply(y, chunkSize*meta.map.gridSize), chunkSize)
    newChunk.blocks[(y - newChunk.position[2])/meta.map.gridSize + 1][(x - newChunk.position[1])/meta.map.gridSize + 1] = id or 1
    table.insert(meta.map.chunks, newChunk)
    undoRedo:newUndoObject(deleteBlock, x, y, false)
    print("block created")
end

function deleteBlock(x, y, canUndo)
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position[1] and y >= chunk.position[2] and x < chunk.position[1] + chunkSize*meta.map.gridSize and y < chunk.position[2] + chunkSize*meta.map.gridSize then
            -- in the chunk
            local blockX = (x - chunk.position[1])/meta.map.gridSize + 1
            local blockY = (y - chunk.position[2])/meta.map.gridSize + 1
            if chunk.blocks[blockY][blockX] == 0 then -- block already does not exist
                return
            end
            if canUndo then -- prevent create another undo object when undo call it
                undoRedo:newUndoObject(createBlock, chunk.blocks[blockY][blockX], x, y, false)
            else
                undoRedo:newRedoObject(createBlock, chunk.blocks[blockY][blockX], x, y, true)
            end 
            chunk.blocks[blockY][blockX] = 0
            return
        end
    end
end

-- gmestate api --
function editor:enter()
    undoRedo = require 'source/modules/undoRedo'
    UI = require 'source/modules/UI'

    editorCamera = camera.new(nil, nil, 1, 0)
    editorCamera.speed = 0.25
    editorCamera.targetZoom = 1

    chunkSize = 4

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
        createBlock(spriteSelected, mouseGridX, mouseGridY, true)
    elseif love.mouse.isDown(2) then
        deleteBlock(mouseGridX, mouseGridY, true) 
    end
    if love.keyboard.isDown('rctrl', 'z') then
        undoRedo:undo()
    elseif love.keyboard.isDown('rctrl', 'y') then
        undoRedo:redo()
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