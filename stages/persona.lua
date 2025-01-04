local path = '../TweakAssets/stages/Tweakmas/First Edition/persona/'

local scale = 1.7
local movement = 30.0

luaDebugMode = true
function onCreate()
    setProperty('cameraSpeed', 1000)

    makeLuaSprite('backie', path..'bg')
    setGraphicSize('backie', screenWidth * scale, screenHeight * scale)
    addLuaSprite('backie')

    makeLuaSprite('overlay', path..'overlay')
    setGraphicSize('overlay', screenWidth * scale, screenHeight * scale)
    setBlendMode('overlay', 'ADD')

    makeLuaSprite('topbar') makeGraphic('topbar', screenWidth + 2, 80, '000000')
    setObjectCamera('topbar', 'camHUD')
    addLuaSprite('topbar')

    makeLuaSprite('botbar', nil, 0, screenHeight - 80) makeGraphic('botbar', screenWidth + 2, 80, '000000')
    setObjectCamera('botbar', 'camHUD')
    addLuaSprite('botbar')

    makeLuaSprite('date', path..'date')
    setObjectCamera('date', 'camOther')
end

function onCreatePost()
    addLuaSprite('overlay', true)
    addLuaSprite('date', true)

    bfPos = {getProperty('boyfriend.x'), getProperty('boyfriend.y')}
    dadPos = {getProperty('dad.x'), getProperty('dad.y')}
end

function onCountdownTick()
    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then doBFTween(0, movement / 2) end
    if getProperty('dad.animation.curAnim.name') == 'idle' then doDadTween(0, movement / 2) end
end

function onBeatHit()
    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then doBFTween(0, movement / 2) end
    if getProperty('dad.animation.curAnim.name') == 'idle' then doDadTween(0, movement / 2) end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
	if noteData == 0 then doBFTween(-movement, 0)
	elseif noteData == 1 then doBFTween(0, movement)
	elseif noteData == 2 then doBFTween(0, -movement)
	elseif noteData == 3 then doBFTween(movement, 0) end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
	if noteData == 0 then doDadTween(-movement, 0)
	elseif noteData == 1 then doDadTween(0, movement)
	elseif noteData == 2 then doDadTween(0, -movement)
	elseif noteData == 3 then doDadTween(movement, 0) end
    end
end

function doBFTween(changeX, changeY)
    setProperty('boyfriend.x', bfPos[1] + changeX)
    setProperty('boyfriend.y', bfPos[2] + changeY)

    startTween('bfTween', 'boyfriend', {x = bfPos[1], y = bfPos[2]}, 0.1, {ease = 'quadOut'})
end

function doDadTween(changeX, changeY)
    setProperty('dad.x', dadPos[1] + changeX)
    setProperty('dad.y', dadPos[2] + changeY)

    startTween('dadTween', 'dad', {x = dadPos[1], y = dadPos[2]}, 0.1, {ease = 'quadOut'})
end

function onUpdate()
    callMethod('camGame.scroll.setPosition', {getProperty('backie.x') + (getProperty('backie.width') / 2), getProperty('backie.y') + (getProperty('backie.height') / 2)})
    callMethod('camFollow.setPosition', {getProperty('backie.x') + (getProperty('backie.width') / 2), getProperty('backie.y') + (getProperty('backie.height') / 2)})
    setProperty('isCameraOnForcedPos', true)
end

function onCountdownTick() setProperty('cameraSpeed', 1) end