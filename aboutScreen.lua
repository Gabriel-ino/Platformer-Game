function aboutScreen()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    aboutFont = love.graphics.newFont(26)
    local margin = 16
    TEXT_MOVE = "Movement: "
    TEXT_X = (love.graphics.getWidth() - aboutFont:getWidth(TEXT_MOVE))/2
    TEXT_Y = love.graphics.getHeight() * 0.2
    RETURN_MENU = "Press Q to return to menu"
    RETURN_MENU_TEXT_X = (love.graphics.getWidth() - aboutFont:getWidth(RETURN_MENU))/2
    RETURN_MENU_TEXT_Y = love.graphics.getHeight() - 200

    love.graphics.print(TEXT_MOVE, TEXT_X, TEXT_Y)
    love.graphics.draw(sprites.arrows, love.graphics.getWidth()/2 - 70, love.graphics.getHeight() / 4 + 80, nil, 0.25)
    love.graphics.print(RETURN_MENU, RETURN_MENU_TEXT_X, RETURN_MENU_TEXT_Y)


end