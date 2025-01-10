local path = '../TweakAssets/stages/Tweakmas/Second Edition/toon/'

local boppers = {}

local curPlayer
local targetChar = 'boyfriend'
local toSquish = 'orbyy'

luaDebugMode = true
function onCreate()
    addCharacterToList('HR_black', 1)

    makeLuaSprite('bg', path..'hrBG', -510, 160)
    setScrollFactor('bg', 0.6, 0.6)
    addLuaSprite('bg')

    makeLuaSprite('lights', path..'hrLIGHTS', -510, 160)
    setScrollFactor('lights', 0.6, 0.6)
    addLuaSprite('lights')

    makeLuaSprite('black', nil, -510, 160) makeGraphic('black', getProperty('bg.width'), getProperty('bg.height'), '000000')
    setProperty('black.alpha', 0.01)

    makeLuaSprite('fade') makeGraphic('fade', screenWidth + 2, screenHeight, '000000')
    setObjectCamera('fade', 'camOther')
    setProperty('fade.alpha', 0.01)
    addLuaSprite('fade')

    addBopper(-150, 520, 'yellow')
    addBopper(250, 520, 'pink')
    addBopper(800, 520, 'blue')
    addBopper(1200, 520, 'green')
end

local total = 1
function addBopper(bopX, bopY, colour)
    makeAnimatedLuaSprite('yur'..total, path..'hr_boppers', bopX, bopY)
    addAnimationByIndices('yur'..total, 'dance0', colour..'Dance0', {0,1,2,3,4,5,6,7,8,9,10,11,12,13}, 24, false)
    addAnimationByIndices('yur'..total, 'dance1', colour..'Dance0', {14,15,16,17,18,19,20,21,22,23,24,25,26}, 24, false)
    setProperty('yur'..total..'.alpha', 0.01)
    setScrollFactor('yur'..total, 0.7, 0.7)
    scaleObject('yur'..total, 0.8, 0.8, false)
    playAnim('yur'..total, 'dance0')
    addLuaSprite('yur'..total)
    table.insert(boppers, 'yur'..total)
    total = total + 1
end

function onCreatePost()
    ogOffs = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')

    setScrollFactor('dad', 0.9, 0.9)
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {-325, -100, -225, -100})
    for i = 0,3 do
	setProperty('playerStrums.members['..i..'].x', 412 + (112 * i))
    end

    createInstance('mortis', 'objects.Character', {getProperty('boyfriend.x') + 360, getProperty('boyfriend.y'), 'mortis_toon'})
    setProperty('mortis.flipX', not getProperty('mortis.flipX'))

    createInstance('kye', 'objects.Character', {getProperty('boyfriend.x') + 800, getProperty('boyfriend.y') + 10, 'kye_toon'})
    setProperty('kye.flipX', not getProperty('kye.flipX'))

    createInstance('orbyy', 'objects.Character', {getProperty('boyfriend.x') + 1050, getProperty('boyfriend.y') - 280, 'orbyy_toon'})
    setProperty('orbyy.flipX', not getProperty('orbyy.flipX'))

    addInstance('orbyy', true)
    addInstance('kye', true)
    addLuaSprite('black', true)
    addInstance('mortis', true)

    snapCamFollowToPos(825, 775, false)
end

function onBeatHit()
    if curBeat % 2 == 0 then doIdles()end

    local bopAnim = (curBeat % 2 == 0 and 'dance0' or 'dance1')
    for _, bopper in pairs(boppers) do
	    playAnim(bopper, bopAnim) end
end

function doIdles()
    local anim1 = getProperty('mortis.animation.curAnim.name')
    if not anim1:find('sing') and not anim1:find('squish') then callMethod('mortis.dance', {''}) end

    local anim2 = getProperty('kye.animation.curAnim.name')
    if not anim2:find('sing') and not anim2:find('squish') then callMethod('kye.dance', {''}) end

    local anim3 = getProperty('orbyy.animation.curAnim.name')
    if not anim3:find('sing') and not anim3:find('squish') then callMethod('orbyy.dance', {''}) end
end

function onMoveCamera(target)
    setProperty('defaultCamZoom', target == 'dad' and 1 or 0.95)
end

local animIndex = {{-1, 0}, {0, 1}, {0, -1}, {1, 0}}
function onUpdate()
    setProperty('camZooming', true)
    for i = 0,3 do setProperty('opponentStrums.members['..i..'].alpha', 0) end

    for i=0,7 do
	if getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'noAnimation', true)
	end
    end

    charCamX = getMidpointX(targetChar) + getProperty(targetChar..'.cameraPosition[0]') + 200
    charCamY = getMidpointY(targetChar) + getProperty(targetChar..'.cameraPosition[1]') - 100
    for i = 0, 3 do
	if mustHitSection and not getVar('playerSing') and targetChar ~= 'boyfriend' and stringStartsWith(getProperty(targetChar..'.animation.curAnim.name'), getProperty('singAnimations')[i+1]) then
	    setProperty('camFollow.x', charCamX + animIndex[i+1][1] * 15)
	    setProperty('camFollow.y', charCamY + animIndex[i+1][2] * 15)
	elseif mustHitSection and not getVar('playerSing') and targetChar ~= 'boyfriend' and stringStartsWith(getProperty(targetChar..'.animation.curAnim.name'), 'idle') then
	    setProperty('camFollow.x', charCamX) setProperty('camFollow.y', charCamY)
	end
    end

    if getProperty(toSquish..'.animation.curAnim.name') == 'squish' and getProperty(toSquish..'.animation.curAnim.finished') then
	setProperty(toSquish..'.animation.curAnim.paused', true)
    end
end

function onSpawnNote()
    for i = 0,7 do
	if not getPropertyFromGroup('notes', i, 'mustPress') then
	    setProperty('notes.members['..i..'].alpha', 0)
	end
    end
end

function onEvent(name, v1, v2)
    if name == 'Switch Player' then
	if v1 == 'dollie' then
	    targetChar = 'boyfriend'
	    setVar('playerSing', true)
	elseif v1 == 'mortis' then
	    targetChar = 'mortis'
	    setVar('playerSing', false)
	elseif v1 == 'kye' then
	    targetChar = 'kye'
	    setVar('playerSing', false)
	elseif v1 == 'orbyy' then
	    targetChar = 'orbyy'
	    setVar('playerSing', false)
	end

	curPlayer = v1
    end

    if name == 'Toon Town Events' then
	if v1 == 'squish' then
	    if v2 == 'dollie' then toSquish = 'boyfriend'
	    elseif v2 == 'kye' then toSquish = 'kye'
	    elseif v2 == 'orbyy' then toSquish = 'orbyy' end

	    playAnim(toSquish, 'squish', true) setProperty(toSquish..'.specialAnim', true)

	    runTimer('não acredito...', 0.35)
	    function onTimerCompleted(tag) if tag == 'não acredito...' then
		setProperty(toSquish..'.animation.curAnim.paused', true) end
	    end

	    triggerEvent('Screen Shake', '0.3, 0.005', '0.3, 0.005')
	    triggerEvent('Add Camera Zoom', 0.3, 0.3)

	    startTween('healthieTween', 'game', {health = math.max(getProperty('health') -0.9, 0.2)}, 0.15, {ease = 'expoOut'})
	elseif v1 == 'emotional' then
	    startTween('blackTween', 'black', {alpha = 1}, 1.2, {})
	elseif v1 == 'oh hi' then
     	    setProperty('boyfriend.visible', false)
	    setProperty('kye.visible', false)
	    setProperty('orbyy.visible', false)

	    setProperty('bg.alpha', 0.5)
	    setProperty('lights.alpha', 0.5)

	    for _, bopper in pairs(boppers) do
		setProperty(bopper..'.alpha', 1) end
            triggerEvent('Change Character', 'dad', 'HR_black')

	    startTween('unblack', 'black', {alpha = 0}, 0.1, {})
	elseif v1 == 'bye' then
	    startTween('bye', 'fade', {alpha = 1}, 1, {})
	end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if targetChar == 'boyfriend' then setVar('playerSing', true) else setVar('playerSing', false) end
    playAnim(targetChar, getProperty('singAnimations')[noteData+1], true)
    setProperty(targetChar..'.holdTimer', 0)
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', ogOffs)
end