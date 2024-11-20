local UI = {} -- modules like this are made expecif files, for exemple, this one is for 'editor.lua'

function UI.drawBlocks()
    for i, chunk in ipairs(meta.map.chunks) do
        for y, row in ipairs(chunk.blocks) do
            for x, block in ipairs(row) do
                if block > 0 then
                    love.graphics.draw(spriteSheet, sprites[block], chunk.position.x + (x - 1)*meta.map.gridSize, chunk.position.y + (y - 1)*meta.map.gridSize)
                end
            end
        end
    end
end

function UI.showBlockOnMouse()
    love.graphics.setColor(1, 1, 1, 0.8)
    if spriteSelected > 0 then
        love.graphics.draw(spriteSheet, sprites[spriteSelected], mouseGridX, mouseGridY) -- display current block on hand
    end
    love.graphics.setColor(1, 1, 1)
end

function UI.drawGrid()
    x0, y0 = editorCamera:worldCoords(0, 0)
    x0, y0 = math.multiply(x0, meta.map.gridSize), math.multiply(y0, meta.map.gridSize) -- screen 0 on grid
    x1, y1 = editorCamera:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    x1, y1 = math.multiply(x1, meta.map.gridSize), math.multiply(y1, meta.map.gridSize) -- screen size on grid
    love.graphics.setColor(meta.settings.theme.gridColor)
    for y = y0, y1, meta.map.gridSize do -- rows
        for x = x0, x1, meta.map.gridSize do -- cols
            love.graphics.rectangle('line', x, y, meta.map.gridSize, meta.map.gridSize)
        end
    end
    -- love.graphics.setColor(0, 0, 1)
    -- for i, chunk in ipairs(meta.map.chunks) do
    --     love.graphics.rectangle('line', chunk.position.x, chunk.position.y, meta.map.gridSize*chunkSize, meta.map.gridSize*chunkSize)
    -- end
    -- love.graphics.setColor(1, 1, 1)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('line', mouseGridX, mouseGridY, meta.map.gridSize, meta.map.gridSize)
    love.graphics.setColor(1, 1, 1, 1)
end


function UI.displayInfo()
    if slab.BeginWindow('Informations', {Title = "information", X = 0, Y = 32, AllowMove = false, AllowFocus = false}) then
        slab.Text("Map name: " .. meta.map.name)
        slab.Text("Grid size: " .. meta.map.gridSize)
        slab.Text("Sprite: " .. spriteSelected)
        slab.SameLine()
        local qx, qy, qw, qh = sprites[spriteSelected]:getViewport()
        slab.Image('block on hand', {Image = spriteSheet, SubX = qx, SubY = qy, SubW = qw, SubH = qh})
        slab.Text("Primary tool: " .. tools.primaryName)
        slab.Text("Secondary tool: " .. tools.secondaryName)
        slab.Text("Zoom: " .. editorCamera.scale)
        slab.Text("Camera, X: " .. editorCamera.x .. "; Y: " .. editorCamera.y)
        slab.Text("FPS: " .. love.timer.getFPS())
        slab.EndWindow()
    end
end

function UI.menuBar()
    if slab.BeginWindow('menuBar', {X = 0, Y = 0, W = love.graphics.getWidth() - 2, H = 25, AllowMove = false, AllowResize = false, AutoSizeWindow = false}) then
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[1]]:getViewport()
        slab.Image('ButtonP', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            if tools.primaryName ~= 'pencil' then -- avoid same tool in both hands
                tools.changePrimary('pencil')
            end
            buttonsCurrentQuads[1] = 2
        else
            buttonsCurrentQuads[1] = 1
        end
        slab.SameLine()
        
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[2]]:getViewport()
        slab.Image('ButtonE', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            if tools.primaryName ~= 'erase' then
                tools.changePrimary('erase')
            end
            buttonsCurrentQuads[2] = 6
        else
            buttonsCurrentQuads[2] = 5
        end
        slab.SameLine()
        
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[3]]:getViewport()
        slab.Image('ButtonB', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            if tools.primaryName ~= 'bucket' then
                tools.changePrimary('bucket')
            end
            buttonsCurrentQuads[3] = 4
        else
            buttonsCurrentQuads[3] = 3
        end
        slab.SameLine()
        
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[4]]:getViewport()
        slab.Image('ButtonO', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            if tools.primaryName ~= 'blockPicker' then
                tools.changePrimary('blockPicker')
            end
            buttonsCurrentQuads[4] = 8
        else
            buttonsCurrentQuads[4] = 7
        end
        slab.SameLine()
        
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[5]]:getViewport()
        slab.Image('ButtonK', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            tools.switch()
            buttonsCurrentQuads[5] = 10
        else
            buttonsCurrentQuads[5] = 9
        end
        slab.SameLine()
        
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[6]]:getViewport()
        slab.Image('ButtonA', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            backBlock()
            buttonsCurrentQuads[6] = 12
        else
            buttonsCurrentQuads[6] = 11
        end
        slab.SameLine()
        
        local qx, qy, qw, qh = buttonsQuads[buttonsCurrentQuads[7]]:getViewport()
        slab.Image('ButtonD', {Image = buttonsTexture, ReturnOnClick = true, SubX = qx, SubY = qy, SubW = qw, SubH = qh, W = 25, H = 25})
        if slab.IsControlClicked() then
            passBlock()
            buttonsCurrentQuads[7] = 14
        else
            buttonsCurrentQuads[7] = 13
        end
        slab.EndWindow()
    end
end

return UI