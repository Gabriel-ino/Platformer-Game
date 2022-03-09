TIMER = 99

function setTimer(dt) 
    if TIMER > 0 then
        TIMER = TIMER - dt
    elseif TIMER <= 0 then
        TIMER = 0
    end 

end