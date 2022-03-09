playerStartX = 360
playerStartY = 100

player = world:newRectangleCollider(playerStartX, playerStartY, 40, 100, {
    collision_class = "Player",
})
player:setFixedRotation(true)
player.speed = 240
player.animation = player_animations.idle
player.isMoving = false
player.direction = 1
player.isJumping = false
player.life = 5
player.gameOver = false

function playerUpdate(dt)
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 2, {
            "Platform",
        })
        if #colliders > 0 then
            player.isJumping = false
        else
            player.isJumping = true
    
        end
        local px, py = player:getPosition()
        player.isMoving = false
        if love.keyboard.isDown("right") then
            player:setX(px + player.speed * dt)
            player.isMoving = true
            player.direction = 1
        end
        if love.keyboard.isDown("left") then
            player:setX(px - player.speed * dt)
            player.isMoving = true
            player.direction = -1
        end
    
        if player:enter("Danger") then
            player:setPosition(playerStartX, playerStartY)
            player.life = player.life - 1
            if player.life == 0 then
                player.gameOver = true

            end
            if player.gameOver then
                sounds.failed:setVolume(0.3)
                sounds.failed:play()
                love.filesystem.remove("save.lua")
                love.graphics.clear()
                love.graphics.setColor(1, 1, 1)
                love.graphics.print("Loser", love.graphics.getWidth()/2, love.graphics.getHeight()/3)
                love.timer.sleep(3)

                love.event.quit(0)
            end
        end
    end
    if player.isJumping == false then
        if player.isMoving then
            player.animation = player_animations.run
        else
            player.animation = player_animations.idle
        end
    end
    
    player.animation:update(dt)
     
end

function drawPlayer()
    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)

end
