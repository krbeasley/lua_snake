GameMap = {}
GameMap.__index = GameMap

local colors = require('src.colors')

local difficulties = {
    [1] = 15,
    [2] = 20,
    [3] = 30,
}

local function generateGrid(num)
    print("Generating grid with size: " .. num .. 'x' .. num)
    local rows_t = {}

    for i = 1, num, 1 do
        local cols_t = {}
        for j = 1, num, 1 do
            -- Push a new blank space to the table
            table.insert(cols_t, 0)
        end
        -- Push col table to rows table
        table.insert(rows_t, cols_t)
    end

    return rows_t
end

function GameMap:new(difficulty)
    difficulty = difficulty or 1

    local this = {
        -- 15x15 Grid
        grid = generateGrid(difficulties[difficulty]),
        size = difficulties[difficulty]
    }
    setmetatable(this, self)
    return this
end

function GameMap:update()
    for row=1, self.size, 1 do
        for col=1, self.size, 1 do
            local cell_val = 0

            -- draw the snake
            for _, p in pairs(Player.positions) do
                if p.x == col and p.y == row then
                    cell_val = cell_val + 2
                end
            end

            -- draw the food item
            if Food
            and Food.x == col
            and Food.y == row then
                cell_val = cell_val + 1
            end

            self.grid[row][col] = cell_val
        end
    end
end

function GameMap:draw()
    local padding = 25
    local h = love.graphics.getHeight() - (padding * 2) - 15
    local w = love.graphics.getWidth() - (padding * 2)

    -- Draw the cells
    for y_offset, row in ipairs(self.grid) do
        for x_offset, val in ipairs(row) do
            local cell_h = h / self.size
            local cell_w = w / self.size
            local fill = colors.bkg

            if val == 1 then
                fill = colors.food
            elseif val == 2 or val == 3 then
                fill = colors.snake
            elseif val >= 4 then
                fill = colors.death
            end

            love.graphics.setColor(fill.r, fill.g, fill.b)
            love.graphics.rectangle('fill', padding + ((x_offset - 1) * cell_w), padding + ((y_offset - 1) * cell_h) + 15, cell_w, cell_h)
        end
    end

    -- Draw the border
    love.graphics.setColor(colors.line.r, colors.line.g, colors.line.b)
    love.graphics.rectangle('line', padding, padding + 15, w, h)
end