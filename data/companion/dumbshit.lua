luaDebugMode = true
function onCreatePost()
    for i = 0,3 do
        setProperty('playerStrums.members['..i..'].x', 435 + (112 * i))
        setProperty('opponentStrums.members['..i..'].x', 435 + (112 * i))
    end
end

function onSongStart()
    for i = 0, 3 do
        setProperty('opponentStrums.members['..i..'].alpha', 0.001)
    end
end

function onStepHit()
    if curStep == 552 then
        for i = 0, 3 do
            startTween('goToOp'..i, 'playerStrums.members['..i..']', {x = _G['defaultOpponentStrumX'..i]}, (stepCrochet/1000) * 23, {ease = 'quadInOut'})
            startTween('goToPl'..i, 'opponentStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i], alpha = 1}, (stepCrochet/1000) * 23, {ease = 'quadInOut'})
        end
    end
end