local path = '../TweakAssets/stages/Tweakmas/First Edition/pikmin/'
local cameos = {'oramge', 'spouse_alert', 'nichimeme', 'DOGS'}

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg1', path..'actual_background', -1200, -700)
    setScrollFactor('bg1', 0.1, 0.1)
    addLuaSprite('bg1')

    makeLuaSprite('tree', path..'background_tree', -300, -500)
    setScrollFactor('tree', 0.7, 0.7)
    addLuaSprite('tree')

    makeLuaSprite('bg2', path..'background', 0, -200)
    setScrollFactor('bg2', 0.9, 0.9)
    addLuaSprite('bg2')

    makeLuaSprite('mdground', path..'middleground')
    addLuaSprite('mdground')

    makeAnimatedLuaSprite('brittany', path..'brittany', 1100, 920)
    addAnimationByPrefix('brittany', 'idle', 'idle_b0', 24, true)
    addLuaSprite('brittany')

    makeAnimatedLuaSprite('charlie', path..'charlie-pikmin', 1600, 860)
    addAnimationByPrefix('charlie', 'idle', 'idle_c0', 24, true)
    addLuaSprite('charlie')
end

function onCreatePost()
    makeLuaSprite('cam')
    addLuaSprite('cam', true)

    makeLuaSprite('foreground', path..'foreground', 200, 200)
    setScrollFactor('foreground', 1.2, 1.2)
    addLuaSprite('foreground', true)

    for i = 0,3 do
	setProperty('playerStrums.members['..i..'].x', 412 + (112 * i))
    end

    callMethod('healthBar.setColors', {0xFF0000, 0x00FF00})
    setProperty('iconP2.visible', false)

    setProperty('dad.visible', false)
    snapCamFollowToPos(1500, 1000, false)
end

function onSongStart() setProperty('camZooming', true) end

function onUpdatePost()
    setProperty('iconP1.x', getProperty('iconP1.x') - 45)
    for i = 0,3 do setPropertyFromGroup('opponentStrums', i, 'alpha', 0) end
end

function spawnCameo()
    if #cameos < 1 then return end

    local thisCam = cameos[getRandomInt(1, #cameos)]
    table.remove(cameos, #thisCam)
    local thisY = 700
    local facingRight = false

    if thisCam == 'DOGS' then
	thisY = thisY + 260
    elseif thisCam == 'spouse_alert' then
	thisY = thisY - 450
    elseif thisCam == 'nichimeme' then
	thisY = thisY - 175
	facingRight = true
    elseif thisCam == 'oramge' then
	thisY = thisY - 175
    end

    loadGraphic('cam', path..thisCam, false)
    updateHitbox('cam')
    setProperty('cam.y', thisY)
    if facingRight then
	setProperty('cam.x', -3000)
	startTween('rightCam', 'cam', {x = 5000}, 25, {onComplete = 'cameoInactive'})
    else
	setProperty('cam.x', 5000)
	startTween('leftCam', 'cam', {x = -3000}, 25, {onComplete = 'cameoInactive'})
    end

    function cameoInactive() cameoActive = false end

    runTimer('cam1', 4)
    runTimer('cam2', 12.5)

    function onTimerCompleted(tag)
	if tag == 'cam1' then
	    setProperty('isCameraOnForcedPos', true)
	    startTween('camZoom', 'game', {defaultCamZoom = 0.35}, 5, {ease = 'smoothStepInOut'})
	    startTween('camPos', 'camFollow', {x = 2300, y = 1000}, 5, {ease = 'smoothStepInOut'})
	elseif tag == 'cam2' then
	    startTween('camZoom', 'game', {defaultCamZoom = 0.6}, 5, {ease = 'smoothStepInOut'})
	    startTween('camPos', 'camFollow', {x = 1525, y = 1188}, 5, {ease = 'smoothStepInOut', onComplete = 'unforced'})
	    function unforced() setProperty('isCameraOnForcedPos', false) end
	end
    end
end

function onEvent(name, v1, v2)
    if name == 'Pikmin Events' then
	if v1 == 'cameo' then
	    spawnCameo()
	end
    end
end