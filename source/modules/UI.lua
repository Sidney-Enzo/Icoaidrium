local UI = {} -- modules like this are made expecif files, for exemple, this one is for 'editor.lua'

function UI.drawBlocks()
    for i, chunk in ipairs(meta.map.chunks) do
        -- love.graphics.rectangle('line', chunk.position[1], chunk.position[2], meta.map.gridSize*chunkSize, meta.map.gridSize*chunkSize)
        for y, row in ipairs(chunk.blocks) do
            for x, block in ipairs(row) do
                if block > 0 then
                    love.graphics.draw(sprites[block], chunk.position[1] + (x - 1)*meta.map.gridSize, chunk.position[2] + (y - 1)*meta.map.gridSize, 0, 1, 1, 0, 0)
                end
            end
        end
    end
end

function UI.showBlockOnMouse()
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.draw(sprites[spriteSelected], mouseGridX, mouseGridY, 0, 1, 1, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
end

function UI.drawGrid()
    x0, y0 = editorCamera:worldCoords(0, 0)
    x0, y0 = math.multiply(x0, meta.map.gridSize), math.multiply(y0, meta.map.gridSize)
    x1, y1 = editorCamera:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    x1, y1 = math.multiply(x1, meta.map.gridSize), math.multiply(y1, meta.map.gridSize)
    love.graphics.setColor(meta.settings.theme.gridColor)
    for y = y0, y1, meta.map.gridSize do -- rows
        for x = x0, x1, meta.map.gridSize do -- cols
            love.graphics.rectangle('line', x, y, meta.map.gridSize, meta.map.gridSize)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end


function UI.displayInfo()
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

return UI