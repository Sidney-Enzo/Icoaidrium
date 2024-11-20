local tools = {}

local function floodFill(grid, startX, startY, replaceValue)
    local targetValue = grid[startY][startX]
    -- Check if the starting point is already the replacement color
    if targetValue == replaceValue then return end

    -- Queue to store the points to be processed
    local queue = {}

    -- Add the starting point to the queue
    table.insert(queue, {x = startX, y = startY})

    -- Process each point in the queue
    while #queue > 0 do
        -- Get the current point from the queue
        local point = table.remove(queue, 1)
        local x, y = point.x, point.y

        -- Make sure the point is within bounds and has the target color
        if x >= 1 and x <= #grid[1] and y >= 1 and y <= #grid and grid[y][x] == targetValue then
            -- Fill the current point with the replacement color
            grid[y][x] = replaceValue

            -- Add the neighboring points to the queue (left, right, up, down)
            table.insert(queue, {x = x - 1, y = y}) -- left
            table.insert(queue, {x = x + 1, y = y}) -- right
            table.insert(queue, {x = x, y = y - 1}) -- up
            table.insert(queue, {x = x, y = y + 1}) -- down
        end
    end
    collectgarbage("collect")
end

local function createChunk(x, y, size)
    local newChunk = {
        position = {x = x, y = y},
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
function tools.pencil(x, y, canUndo)
    -- its all like in an big array
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position.x and y >= chunk.position.y and x < chunk.position.x + chunkSize*meta.map.gridSize and y < chunk.position.y + chunkSize*meta.map.gridSize then
            -- in the chunk
            local blockX = (x - chunk.position.x)/meta.map.gridSize + 1
            local blockY = (y - chunk.position.y)/meta.map.gridSize + 1
            if chunk.blocks[blockY][blockX] == spriteSelected then
                return
            end
            -- print("Block x ", (x - chunk.position[1])/meta.map.gridSize + 1, "Block y ", (y - chunk.position[2])/meta.map.gridSize + 1)
            if canUndo then -- prevent create another undo object when undo call it
                undoRedo:newUndoObject(tools.erase, x, y, false)
            else
                undoRedo:newRedoObject(tools.erase, x, y, true)
            end
            chunk.blocks[blockY][blockX] = spriteSelected or 1
            -- print("block created")
            return
        end
    end
    -- chunk does not exist
    local newChunk = createChunk(math.multiply(x, chunkSize*meta.map.gridSize), math.multiply(y, chunkSize*meta.map.gridSize), chunkSize)
    newChunk.blocks[(y - newChunk.position.y)/meta.map.gridSize + 1][(x - newChunk.position.x)/meta.map.gridSize + 1] = spriteSelected or 1
    table.insert(meta.map.chunks, newChunk)
    undoRedo:newUndoObject(tools.erase, x, y, false)
    -- print("block created")
end

function tools.erase(x, y, canUndo)
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position.x and y >= chunk.position.y and x < chunk.position.x + chunkSize*meta.map.gridSize and y < chunk.position.y + chunkSize*meta.map.gridSize then
            -- in the chunk
            local blockX = (x - chunk.position.x)/meta.map.gridSize + 1
            local blockY = (y - chunk.position.y)/meta.map.gridSize + 1
            if chunk.blocks[blockY][blockX] == 0 then -- block already does not exist
                return
            end
            if canUndo then -- prevent create another undo object when undo call it
                undoRedo:newUndoObject(tools.pencil, x, y, false)
            else
                undoRedo:newRedoObject(tools.pencil, x, y, true)
            end 
            chunk.blocks[blockY][blockX] = 0
            return
        end
    end
end

function tools.bucket(x, y)
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position.x and y >= chunk.position.y and x < chunk.position.x + chunkSize*meta.map.gridSize and y < chunk.position.y + chunkSize*meta.map.gridSize then
            -- in the chunk
            local blockX = (x - chunk.position.x)/meta.map.gridSize + 1
            local blockY = (y - chunk.position.y)/meta.map.gridSize + 1
            floodFill(chunk.blocks, blockX, blockY, spriteSelected)
            return
        end
    end
    -- chunk does not exist
    local newChunk = createChunk(math.multiply(x, chunkSize*meta.map.gridSize), math.multiply(y, chunkSize*meta.map.gridSize), chunkSize)
    local blockX = (x - newChunk.position.x)/meta.map.gridSize + 1
    local blockY = (y - newChunk.position.y)/meta.map.gridSize + 1
    floodFill(newChunk.blocks, blockX, blockY, spriteSelected)
    table.insert(meta.map.chunks, newChunk)
end

function tools.blockPicker(x, y)
    for _, chunk in ipairs(meta.map.chunks) do
        if x >= chunk.position.x and y >= chunk.position.y and x < chunk.position.x + chunkSize*meta.map.gridSize and y < chunk.position.y + chunkSize*meta.map.gridSize then
            -- in the chunk
            local blockX = (x - chunk.position.x)/meta.map.gridSize + 1
            local blockY = (y - chunk.position.y)/meta.map.gridSize + 1
            spriteSelected = chunk.blocks[blockY][blockX]
        end
    end
end

function tools.changePrimary(name)
    assert(type(tools[name]) == 'function', name .. " isn't a tool of tools")
    tools.secondary = tools.primary
    tools.secondaryName = tools.primaryName
    tools.primary = tools[name]
    tools.primaryName = name
end

function tools.switch()
    tools.secondary, tools.primary = tools.primary, tools.secondary
    tools.secondaryName, tools.primaryName = tools.primaryName, tools.secondaryName
end

tools.primary = tools.pencil
tools.secondary = tools.erase
tools.primaryName = "pencil"
tools.secondaryName = "erase"
return tools