
Snake = {}
Snake.__index = Snake

function Snake:new()
    local this = {
        positions = {
            {x=3,y=3},
            {x=2,y=3},
            {x=1,y=3},
        },
        rotation = 0,
        is_hungry = true
    }
    setmetatable(this, self)
    return this
end

function Snake:rotate(direction)
    if direction == 'up' then
        self.rotation = 3
    elseif direction == 'right' then
        self.rotation = 0
    elseif direction == 'down' then
        self.rotation = 1
    elseif direction == 'left' then
        self.rotation = 2
    else
        error("Snake:rotate accepts up to one argument. Expected nil, 'up', 'right', 'down', or 'left'. Received: " .. tostring(direction))
    end
end

function Snake:findNewHeadPos()
    local new_head_pos = {
        x = self.positions[1].x + 1,
        y = self.positions[1].y,
    }

    -- Moving right
    if self.rotation == 0 then
        new_head_pos = {
            x = self.positions[1].x + 1,
            y = self.positions[1].y,
        }
    -- Moving down
    elseif self.rotation == 1 then
        new_head_pos = {
            x = self.positions[1].x,
            y = self.positions[1].y + 1,
        }
    -- Moving left
    elseif self.rotation == 2 then
        new_head_pos = {
            x = self.positions[1].x - 1,
            y = self.positions[1].y,
        }
    -- Moving up
    elseif self.rotation == 3 then
        new_head_pos = {
            x = self.positions[1].x,
            y = self.positions[1].y - 1,
        }
    else
        error('Snake was asked to rotate in a strange way. Rotation: ' .. tostring(self.rotation))
    end

    return new_head_pos
end

function Snake:wrap()
    if self.positions[1].x < 1 then
        self.positions[1].x = Map.size
    elseif self.positions[1].x > Map.size then
        self.positions[1].x = 1
    end

    if self.positions[1].y < 1 then
        self.positions[1].y = Map.size
    elseif self.positions[1].y > Map.size then
        self.positions[1].y = 1
    end
end

function Snake:update()
    -- drop the tail cell and shift the positions down
    table.remove(self.positions, #self.positions)

    -- scoot the head to the new spot
    local new_head_pos = self:findNewHeadPos()

    -- insert new head position at the front of the positions list
    table.insert(self.positions, 1, new_head_pos)

    -- wrap around the screen
    self:wrap()
end

function Snake:grow()
    local new_head_pos = self:findNewHeadPos()

    table.insert(self.positions, 1, new_head_pos)

    self:wrap()
end