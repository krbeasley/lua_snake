Food_Item = {}
Food_Item.__index = Food_Item

local function locateFreeCell()
    math.randomseed(os.time())

    local map = Map
    local x = math.random(1, map.size)
    local y = math.random(1, map.size)

    return {
        x = x,
        y = y,
    }
end

function Food_Item:new()
    -- Find an empty cell in the board
    local freeCell = locateFreeCell()
    local this = {
        x = freeCell.x,
        y = freeCell.y,
    }
    setmetatable(this, self)
    return this
end