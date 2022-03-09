
function drawLife()
    local total_life = player.life
    love.graphics.print("Life: ", 0, 50)
    margin = 0
    for aux = 1, total_life, 1 do
        life.lifeImage:draw(sprites.playerSheet, aux * 90 - margin, 40, nil, 0.1)
        margin = margin + 40

    end
    margin = 0

end