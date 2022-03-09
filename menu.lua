BUTTON_HEIGHT = 64


function menu(options)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    local margin = 16
    local buttonWidth = (1/3) * windowWidth
    local totalHeight = (BUTTON_HEIGHT + margin) * #options

    local cursor_y = 0
    love.graphics.print(TITLE, titleFont,love.graphics.getWidth()/2 - titleFont:getWidth(TITLE) * 0.5, love.graphics.getHeight()/8)

    for i, button in ipairs(options) do 
        button.last = button.now
        local color = {0.4, 0.4, 0.5, 1}
        local bx = (windowWidth * 0.5) - (buttonWidth * 0.5)
        local by = (windowHeight * 0.5) - (totalHeight * 0.5) + cursor_y

        local mx, my = love.mouse.getPosition()

        local mouseOnButton = mx > bx and mx < bx + buttonWidth and
                              my > by and my < by + BUTTON_HEIGHT
                              
        if mouseOnButton then
            color = {0.8, 0.8, 0.9, 1}
        end

        button.now = love.mouse.isDown(1)

        if button.now and not button.last and mouseOnButton then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            buttonWidth,
            BUTTON_HEIGHT
        )
        love.graphics.setColor(1,1,1,1)

        local textWidth = newFont:getWidth(button.text)
        local textHeight = newFont:getHeight(button.text)

        love.graphics.print(
            button.text,
            newFont,
            (windowWidth * 0.5) - textWidth * 0.5,
            by + textHeight * 0.5
        )
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
end

function newButton(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end


