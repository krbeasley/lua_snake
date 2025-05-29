-- Lua Snake
-- Simple 2D snake game to help learn more about Lua and Game Dev

local colors = require('src.colors')

-- Track the current key
local curr_key = nil

function love.load()
    require("src.classes.snake")
    require("src.classes.gamemap")
    require("src.classes.food_item")

    -- Initialize the game object
    Game = {
        title = "Lua Snake",
        version = "1.0.0",
        difficulty = 1,
        game_over = false,
        idle = false,
        playing = false,
        debug = false,
        running = true,
        score = 0,
    }

    -- Initialize the window
    love.window.setTitle(Game.title .. " - " .. Game.version)
    love.window.setMode(600, 600)

    -- Initialize the map
    Map = GameMap:new()

    -- Initialize the player
    Player = Snake:new()

    -- Initialize the snake food
    Food = Food_Item:new()

    print(tostring(GameMap))
    print(tostring(Player))

    Game.idle = true
end

local update_timer = 0
function love.update(dt)
    Map:update()

    -- Update the game logic when the player is playing AND not paused
    if Game.playing
    and not Game.idle
    and not Game.game_over then
        -- Update the game status
        if Food == nil and Player.is_hungry then
            -- Create a new food item
            Food = Food_Item:new()
        end

        -- Check for collisions
        for y, row in ipairs(Map.grid) do
            for x, cell in ipairs(row) do
                -- snake ate food_item
                if cell == 3 then
                    Food = nil
                    Player:grow()
                    Game.score = Game.score + 1
                -- snake ate self
                elseif cell == 4 then
                    Game.game_over = true
                end
            end
        end

        -- Update the player at a non-continuous rate
        if update_timer >= 30 then
            update_timer = 0
            Player:update()
        else
            update_timer = update_timer + 1
        end
    end
end

function love.keypressed(key)
    curr_key = key
    if key == 'q' then love.event.quit() end

    if not Game.game_over then
        -- Main Menu Keybinds
        if Game.idle and not Game.playing then
            if key == 'space' or key == 'escape' then
                Game.idle = false
                Game.playing = true
            end
        -- Pause Menu
        elseif Game.idle and Game.playing then
            if key == 'space' then
                Game.idle = false
                Game.playing = true
            end
        -- Main Game
        elseif not Game.idle and Game.playing then
            if key == 'escape' then
                Game.idle = true
            elseif key == 'up' or key == 'left'
            or key == 'right' or key == 'down' then
                Player:rotate(key)
            end
        end
    else
        -- Game Over keybinds
        if key == 'space' then
            Game.idle = true
            Game.playing = false
            Game.game_over = false
            Game.score = 0

            Food = nil

            Player = nil
            Player = Snake:new()

            Map = nil
            Map = GameMap:new()
        end
    end
end

function love.keyreleased(key)
    curr_key = nil
end

function love.draw()
    -- Draw the game board, player, and food_item regardless
    if Map then
        Map:draw()
    end

    love.graphics.setColor(colors.text.r, colors.text.g, colors.text.b)
    love.graphics.printf("Score: " .. Game.score, 0, 10, love.graphics.getWidth(), 'center')

    -- Draw full screen main menu
    if Game.idle and not Game.playing then
        love.graphics.setColor(colors.bkg.r, colors.bkg.g, colors.bkg.b)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw small window
        local w = 400
        local h = 300
        local x = (love.graphics.getWidth() / 2) - (w / 2)
        local y = (love.graphics.getHeight() / 2) - (h / 2)

        love.graphics.setColor(colors.line.r, colors.line.g, colors.line.b)
        love.graphics.rectangle('line', x, y, w, h)

        love.graphics.setColor(colors.text.r, colors.text.g, colors.text.b)
        love.graphics.printf(Game.title, x, y + 10, w, "center")
        love.graphics.printf("Main Menu", x, y + 110, w, "center")
        love.graphics.printf("Press [ SPACE ] to begin.", x, y + 130, w, "center")

        love.graphics.printf("A game by Kyle Beasley", x, y + h - 20, w, "center")
    end

    -- Draw full screen paused menu
    if Game.idle and Game.playing then
        love.graphics.setColor(colors.bkg.r, colors.bkg.g, colors.bkg.b)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw small window
        local w = 400
        local h = 300
        local x = (love.graphics.getWidth() / 2) - (w / 2)
        local y = (love.graphics.getHeight() / 2) - (h / 2)
        
        love.graphics.setColor(colors.line.r, colors.line.g, colors.line.b)
        love.graphics.rectangle('line', x, y, w, h)

        love.graphics.setColor(colors.text.r, colors.text.g, colors.text.b)
        love.graphics.printf("Paused", x, y + 110, w, "center")
        love.graphics.printf("Press [ SPACE ] to resume.", x, y + 130, w, "center")
    end

    if Game.game_over then
        love.graphics.setColor(colors.bkg.r, colors.bkg.g, colors.bkg.b)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw small window
        local w = 400
        local h = 300
        local x = (love.graphics.getWidth() / 2) - (w / 2)
        local y = (love.graphics.getHeight() / 2) - (h / 2)
        
        love.graphics.setColor(colors.line.r, colors.line.g, colors.line.b)
        love.graphics.rectangle('line', x, y, w, h)

        love.graphics.setColor(colors.text.r, colors.text.g, colors.text.b)
        love.graphics.printf("Game Over", x, y + 100, w, "center")
        love.graphics.printf("Score: " .. Game.score, x, y + 110, w, "center")
        love.graphics.printf("Press [ SPACE ] to return to Main Menu.", x, y + 140, w, "center")
    end

    -- Draw debug window
    if Game.debug then
        local w = 180
        local h = 80
        local x = 0
        local y = love.graphics.getHeight() - h

        love.graphics.setColor(0,0,0,.5)
        love.graphics.rectangle('fill', x, y, w, h)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('line', x, y, w, h)

        love.graphics.print("Idle:" .. tostring(Game.idle), 1, love.graphics.getHeight() - (h), 0, .75)
        love.graphics.print("Playing:" .. tostring(Game.playing), 1, love.graphics.getHeight() - (h - 10), 0, .75)
        love.graphics.print("Length:" .. tostring(Player.length), 1, love.graphics.getHeight() - (h - 20), 0, .75)
        love.graphics.print("Input:" .. tostring(curr_key), 1, love.graphics.getHeight() - (h - 30), 0, .75)
    end
end