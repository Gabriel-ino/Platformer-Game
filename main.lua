
function love.load()

    CALL_ABOUT = false
    TITLE = "Boy's Platformer"
    sprites = {
        playerSheet = love.graphics.newImage("sprites/playerSheet.png"),
        enemySheet = love.graphics.newImage("sprites/enemySheet.png"),
        background = love.graphics.newImage("sprites/background.png"),
        arrows = love.graphics.newImage("sprites/arrows.png"),

    }
    require("aboutScreen")

    love.window.setTitle(TITLE)
    love.window.setMode(1000, 768)

    saveData = {}
    saveData.currentLevel = 1

    if love.filesystem.getInfo("save.lua") then
        local data = love.filesystem.load("save.lua")
        data()
    end
    if saveData.currentLevel == 4 then
        saveData.currentLevel = 1
    end

    require("menu")
    require("timer")
    anim8 = require("libs/anim8/anim8")
    sti = require("libs/Simple-Tiled-Implementation/sti")
    spawnPlatforms = require("spawnPlatforms")
    wf = require("libs/windfield/windfield")
    cameraFile = require("libs/hump/camera")
    gameState = 0
    require("drawLife")

    cam = cameraFile()

    buttons = {}
    table.insert(buttons, newButton(
        "New Game",
        function()
            saveData.currentLevel = 1
            gameState = 1
        end
    ))
    table.insert(buttons, newButton(
        "Load Game",
        function()
            gameState = 1
            print("Loading")
        
        end
    ))

    table.insert(buttons, newButton(
        "About Game",
        function() CALL_ABOUT = true end
    ))

    table.insert(buttons, newButton(
        "Exit",
        function() love.event.quit(0) end
    ))

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())
    player_animations = {
        idle = anim8.newAnimation(grid("1-15", 1), 0.05),
        jump = anim8.newAnimation(grid("1-7", 2), 0.05),
        run = anim8.newAnimation(grid("1-15", 3), 0.05),
    }
    enemy_animation = {
        animation = anim8.newAnimation(enemyGrid("1-2", 1), 0.03)
    }
    life = {
        lifeImage = anim8.newAnimation(grid("1-1", 1), 0.05)
    }


    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass("Platform")
    world:addCollisionClass("Player")
    world:addCollisionClass("Danger")

    require("player")
    require("enemy")
    require("libs/show")

    newFont = love.graphics.newFont(30)
    titleFont = love.graphics.newFont(50)

    dangerZone = world:newRectangleCollider(-500, 800, 5000, 50, {
        collision_class = "Danger",
    })
    dangerZone:setType("static")
    
    platforms = {}

    sounds = {
        jump = love.audio.newSource("audio/jump.wav", "static"),
        background_music = love.audio.newSource("audio/music.mp3", "stream"),
        passed = love.audio.newSource("audio/passed.wav", "static"),
        failed = love.audio.newSource("audio/failed.wav", "static")
    }



    flagX = 0
    flagY = 0

    sounds.background_music:setLooping(true)
    sounds.background_music:play()

    loadMap("level"..saveData.currentLevel)


end

function love.update(dt)
    if gameState == 1 then
        setTimer(dt)
        world:update(dt)
        gameMap:update(dt)
        playerUpdate(dt)
        enemyUpdate(dt)
    elseif gameState == 0 then

    end
    
    local px, py = player:getPosition()
    cam:lookAt(px, love.graphics.getHeight()/2)

    local colliders = world:queryCircleArea(flagX, flagY, 10, {"Player"})

    if #colliders > 0 then
        sounds.passed:play()
        saveData.currentLevel = saveData.currentLevel + 1
        loadMap("level"..saveData.currentLevel)
        TIMER  = 99
    end

end


function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    print("Draw")
    if gameState == 1 then
        cam:attach()
            gameMap:drawLayer(gameMap.layers["Camada de Tiles 1"])
            --world:draw()
            drawPlayer()
            drawEnemies()
        cam:detach()
        love.graphics.print("Time: "..math.ceil(TIMER), 0, 0)
        love.graphics.print("Level: "..saveData.currentLevel, love.graphics.getWidth() - 140, 0)
        drawLife()
    elseif gameState == 0 and CALL_ABOUT then
        aboutScreen()

    elseif gameState == 0 then
        love.graphics.setFont(newFont)
        menu(buttons)
    
    end
end

function love.keypressed(key)
    if key == "up" or key == "w" then
        if player.isJumping == false then
            player:applyLinearImpulse(0, -4000)
            player.animation = player_animations.jump
            sounds.jump:play()
        end

    end

    if key == "m" then
        sounds.background_music:pause()
    end
    if key == "p" then
        sounds.background_music:play()
    end
    if CALL_ABOUT and key == "q" then
        CALL_ABOUT = false
        menu(buttons)
    end


end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {
            "Platform", 
            "Danger"
        })
      
    end

end

function loadMap(mapName)
    destroyAll()
    print(love.filesystem.getInfo("maps/"..mapName..".lua"))
    if love.filesystem.getInfo("maps/"..mapName..".lua") ~= nil then

        love.filesystem.write("save.lua", table.show(saveData, "saveData"))
        gameMap = sti("maps/"..mapName..".lua")
        print(gameMap)
        for i, obj in pairs(gameMap.layers["Start"].objects) do
            playerStartX = obj.x
            playerStartY = obj.y
        end
        player:setPosition(playerStartX, playerStartY)
        for index, object in pairs(gameMap.layers["Plataformas"].objects) do
            spawnPlatforms.spawnPlatform(object.x, object.y, object.width, object.height)
        end
        for index, object in pairs(gameMap.layers["Inimigo"].objects) do
            spawnEnemy(object.x, object.y)
        end
        for index, object in pairs(gameMap.layers["Flag"].objects) do
            flagX = object.x
            flagY = object.y
        end
    else
        gameState = 0
    end

end

function destroyAll()
    local i = #platforms
    while i > 0 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i - 1 
    end

    local e = #enemies
    while e > 0 do
        if enemies[e] ~= nil then
            enemies[e]:destroy()
        end
        table.remove(enemies, e)
        e = e - 1
    end

end

