local editor = {}
editor.id = ""

local function createChunk(x, y, size)
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

local function createBlock(id, x, y)
    -- its all like in an big array
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position[1] and y >= chunk.position[2] and x <= chunk.position[1] + chunkSize and y <= chunk.position[2] + chunkSize then
            -- in the chunk
            chunk.blocks[(y - chunk.position[2])/meta.map.gridSize + 1][(x - chunk.position[1])/meta.map.gridSize + 1] = id or 1
            return
        end
    end
    -- chunk does not exist
    local newChunk = createChunk(math.multiply(x, chunkSize*meta.map.gridSize), math.multiply(y, chunkSize*meta.map.gridSize), chunkSize)
    newChunk.blocks[(y - newChunk.position[2])/meta.map.gridSize + 1][(x - newChunk.position[1])/meta.map.gridSize + 1] = id or 1
    table.insert(meta.map.chunks, newChunk)
end

local function drawBlocks()
    for i, chunk in ipairs(meta.map.chunks) do
        --love.graphics.rectangle("line", chunk.position[1], chunk.position[2], meta.map.gridSize*chunkSize, meta.map.gridSize*chunkSize)
        for y, row in ipairs(chunk.blocks) do
            for x, block in ipairs(row) do
                if block > 0 then
                    love.graphics.draw(sprites[block], chunk.position[1] + (x - 1)*meta.map.gridSize, chunk.position[2] + (y - 1)*meta.map.gridSize, 0, 1, 1, 0, 0)
                end
            end
        end
    end
end

local function showBlockOnMouse()
    love.graphics.draw(sprites[spriteSelected], mouseGridX, mouseGridY, 0, 1, 1, 0, 0)
end

local function drawGrid()
    x0, y0 = editorCamera:worldCoords(0, 0)
    x0, y0 = math.multiply(x0, meta.map.gridSize), math.multiply(y0, meta.map.gridSize)
    x1, y1 = editorCamera:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    x1, y1 = math.multiply(x1, meta.map.gridSize), math.multiply(y1, meta.map.gridSize)
    love.graphics.setColor(meta.settings.theme.gridColor)
    for y = y0, y1, meta.map.gridSize do -- rows
        for x = x0, x1, meta.map.gridSize do -- cols
            love.graphics.rectangle("line", x, y, meta.map.gridSize, meta.map.gridSize)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local function displayInfo()
    -- this set each info text position so i dont have so set it manualy
    -- and i can change easly
    infosDisplay = {
        "Map name: " .. meta.map.name,
        "Grid size: " .. meta.map.gridSize,
        "Sprite: " .. spriteSelected,
        "Zoom: " .. editorCamera.scale,
        "Camera, x: " .. editorCamera.x .. " Y: " .. editorCamera.y,
        "FPS: " .. love.timer.getFPS()
    }
    love.graphics.setColor(1, 1, 1, 0.8)
    for i, info in ipairs(infosDisplay) do 
        love.graphics.print(info, 16, 32 + i*phoenixBIOS32:getHeight(" "), 0, 1, 1, 0, 0) -- automaticly set the y position based on text size and position in the list
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function editor:enter()
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
    drawBlocks()
    showBlockOnMouse()
    drawGrid()
    editorCamera:detach()
    displayInfo()
end

function editor:update(deltaTime)
    editorCamera.scale = editorCamera.targetZoom
    if love.mouse.isDown(1) then 
        createBlock(spriteSelected, mouseGridX, mouseGridY)
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