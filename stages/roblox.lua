local path = '../TweakAssets/stages/Tweakmas/Second Edition/blocktales/'

local multiplePlayers = false
local allPlayers = false

local targetChar = 'boyfriend'
local secondChar
setVar('onePlayer', false)

local healthGroup = {}
setVar('songPercent', 0)

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', path..'bg')
    addLuaSprite('bg')
end

function onCreatePost()
    for _, i in pairs({'iconP1', 'iconP2', 'scoreTxt', 'healthBar', 'timeBar'}) do
	setProperty(i..'.visible', false) end

    ogOffs = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')

    setTextFont('timeTxt', 'PressStart2P.ttf')
    setTextSize('timeTxt', 20)
    setProperty('timeTxt.x', 1021)
    setProperty('timeTxt.y', 649)

    createInstance('ito', 'objects.Character', {115, 25, 'ito'})
    setProperty('ito.flipX', not getProperty('ito.flipX'))

    createInstance('carrie', 'objects.Character', {150, 25, 'carrie'})
    setProperty('carrie.flipX', not getProperty('carrie.flipX'))

    createInstance('basil', 'objects.Character', {200, 25, 'basil'})
    setProperty('basil.flipX', not getProperty('basil.flipX'))

    addInstance('ito', true)
    addInstance('carrie', true)
    addInstance('basil', true)

    makeLuaSprite('clock', path..'clock', 1160, 585)
    setProperty('clock.antialiasing', true)
    scaleObject('clock', 1.2, 1.2)
    setObjectCamera('clock', 'camHUD')
    addLuaSprite('clock')

    runHaxeCode([[
	import objects.Bar;

	var newBar = new Bar(1200, 580, 'kingbarbg', function() return getVar('songPercent'), 0, 1);
	newBar.leftBar.loadGraphic(Paths.image('kingbar'));
	newBar.rightBar.loadGraphic(Paths.image('kingbar'));
	newBar.setColors(0xFFF8BB28, 0xFFCD0000);
	newBar.leftToRight = false;
	newBar.percent = 0;
	add(newBar);
	setVar('newBar', newBar);
    ]])

    makeLuaSprite('target', path..'targetAll', 1275, 610)
    setProperty('target.antialiasing', false)
    addLuaSprite('target', true)

    createInstance('iconBasil', 'objects.HealthIcon', {'basil', true})
    setProperty('iconBasil.x', getProperty('iconBasil.x') - 1)
    setProperty('iconBasil.y', getProperty('iconBasil.y') + 460)
    setProperty('iconBasil.flipX', true)
    scaleObject('iconBasil', 0.8, 0.8, false)
    setObjectCamera('iconBasil', 'camHUD')

    createInstance('iconCarrie', 'objects.HealthIcon', {'carrie', true})
    setProperty('iconCarrie.x', getProperty('iconCarrie.x') + 154)
    setProperty('iconCarrie.y', getProperty('iconBasil.y'))
    setProperty('iconCarrie.flipX', true)
    scaleObject('iconCarrie', 0.8, 0.8, false)
    setObjectCamera('iconCarrie', 'camHUD')

    createInstance('iconIto', 'objects.HealthIcon', {'ito', true})
    setProperty('iconIto.x', getProperty('iconCarrie.x') + 154)
    setProperty('iconIto.y', getProperty('iconBasil.y'))
    setProperty('iconIto.flipX', true)
    scaleObject('iconIto', 0.8, 0.8, false)
    setObjectCamera('iconIto', 'camHUD')

    createInstance('iconFlag', 'objects.HealthIcon', {'flag', true})
    setProperty('iconFlag.x', getProperty('iconIto.x') + 154)
    setProperty('iconFlag.y', getProperty('iconBasil.y'))
    setProperty('iconFlag.flipX', true)
    scaleObject('iconFlag', 0.8, 0.8, false)
    setObjectCamera('iconFlag', 'camHUD')

    for i = 0, 3 do
	makeLuaSprite('card'..i, path..'cards/'..i, (i*160) + 40, 570)
	scaleObject('card'..i, 1.2, 1.2, false)
	setObjectCamera('card'..i, 'camHUD')
	addLuaSprite('card'..i)
    end

    for _, i in pairs({'iconBasil', 'iconCarrie', 'iconIto', 'iconFlag'}) do
	addLuaSprite(i) end

    for i = 0, 3 do
	makeLuaText('healthTxt'..i, '40', 0, (i*160)+109, 623)
	setTextFont('healthTxt'..i, 'PressStart2P.ttf')
	setTextSize('healthTxt'..i, 15)
	setTextColor('healthTxt'..i, '87E6FA')
	setProperty('healthTxt'..i..'.fieldWidth', 60)
	setProperty('healthTxt'..i..'.borderSize', 2)
	setProperty('healthTxt'..i..'._defaultFormat.letterSpacing', 9.5)
	runHaxeCode("game.getLuaObject('healthTxt"..i.."').updateDefaultFormat();")
	addLuaText('healthTxt'..i)
	table.insert(healthGroup, 'healthTxt'..i)

	makeLuaText('spTxt'..i, '25', 0, (i*160)+109, 670)
	setTextFont('spTxt'..i, 'PressStart2P.ttf')
	setTextSize('spTxt'..i, 15)
	setTextColor('spTxt'..i, '87E6FA')
	setProperty('spTxt'..i..'.fieldWidth', 60)
	setProperty('spTxt'..i..'.borderSize', 2)
	setProperty('spTxt'..i..'._defaultFormat.letterSpacing', 9.5)
	runHaxeCode("game.getLuaObject('spTxt"..i.."').updateDefaultFormat();")
	addLuaText('spTxt'..i)
    end

    if downscroll then
	setProperty('clock.y', getProperty('clock.y') - 580)
	setProperty('timeTxt.y', getProperty('timeTxt.y') - 580)
	setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {280, 150, 390, 130})
    else
	setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {280, -340, 390, -280})
    end

    snapCamFollowToPos(900, 400)
end

function onCountdownTick(tick)
    if tick % 2 == 0 then callMethod('ito.dance', {''}) end
    callMethod('carrie.dance', {''})
    callMethod('basil.dance', {''})
end

function onBeatHit()
    local anim1 = getProperty('ito.animation.curAnim.name')
    if not anim1:find('sing') and curBeat % 2 == 0 then callMethod('ito.dance', {''}) end

    local anim2 = getProperty('carrie.animation.curAnim.name')
    if not anim2:find('sing') then callMethod('carrie.dance', {''}) end

    local anim3 = getProperty('basil.animation.curAnim.name')
    if not anim3:find('sing') then callMethod('basil.dance', {''}) end
end

local animIndex = {{-1, 0}, {0, 1}, {0, -1}, {1, 0}}
function onUpdate(elapsed)
    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].alpha', 0.001) end

    -- for some reason, only worked with rhc
    runHaxeCode([[
	var curTime = Conductor.songPosition - ClientPrefs.data.noteOffset;
	if (curTime < 0) curTime = 0;
	setVar('songPercent', (curTime / game.songLength));

	getVar('newBar').percent = getVar('songPercent');
    ]])

    for i = 1, #healthGroup do
	setTextString(healthGroup[i], tonumber(math.floor(getProperty('health') * 20)))

	if tonumber(getProperty('health') * 20) > 20 then
	    setTextColor(healthGroup[i], '87e6fa')
	elseif tonumber(getProperty('health') * 20) > 10 then
	    setTextColor(healthGroup[i], '78a824')
	else
	    setTextColor(healthGroup[i], 'b44836')
	end
    end

    setProperty('iconFlag.animation.curAnim.curFrame', (getProperty('healthBar.percent') < 20) and 1 or 0)
    setProperty('iconIto.animation.curAnim.curFrame', (getProperty('healthBar.percent') < 20) and 1 or 0)
    setProperty('iconCarrie.animation.curAnim.curFrame', (getProperty('healthBar.percent') < 20) and 1 or 0)
    setProperty('iconBasil.animation.curAnim.curFrame', (getProperty('healthBar.percent') < 20) and 1 or 0)

    for _, i in pairs({'ito', 'carrie', 'basil', 'boyfriend', 'dad'}) do
	if getProperty(i..'.animation.curAnim.name') == (i == 'dad' and 'die' or 'win') and getProperty(i..'.animation.curAnim.finished') then
	    setProperty(i..'.animation.curAnim.paused', true)
	end
    end

    for i=0,7 do
	if getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'noAnimation', true)
	end
    end

    -- yea, that's maybe confusing
    charCamX = getMidpointX(targetChar) + 150 + getProperty(targetChar..'.cameraPosition[0]')
    charCamY = getMidpointY(targetChar) + getProperty(targetChar..'.cameraPosition[1]')
    for i = 0, 3 do
	if mustHitSection and not getVar('playerSing') and targetChar ~= 'boyfriend' and stringStartsWith(getProperty(targetChar..'.animation.curAnim.name'), getProperty('singAnimations')[i+1]) then
	    setProperty('camFollow.x', charCamX + animIndex[i+1][1] * 15)
	    setProperty('camFollow.y', charCamY + animIndex[i+1][2] * 15)
	elseif mustHitSection and not getVar('playerSing') and targetChar ~= 'boyfriend' and stringStartsWith(getProperty(targetChar..'.animation.curAnim.name'), 'idle') then
	    setProperty('camFollow.x', charCamX) setProperty('camFollow.y', charCamY)
	end
    end
    if targetChar == 'boyfriend' then setVar('playerSing', true) else setVar('playerSing', false) end
end

function onEvent(name, v1, v2)
    if name == 'Switch Bloxxers' then
	multiplePlayers = false
	allPlayers = false
	if v1 == 'flag' then targetChar = 'boyfriend'
	elseif v1 == 'ito' then targetChar = 'ito'
	elseif v1 == 'carrie' then targetChar = 'carrie'
	elseif v1 == 'basil' then targetChar = 'basil'
	elseif v1 == 'everyone' then
	    targetChar = 'boyfriend'
	    allPlayers = true
	end

	curPlayer = v1

	if v2 == 'ito' then
	    secondChar = 'ito'
	    multiplePlayers = true
	elseif v2 == 'carrie' then
	    secondChar = 'carrie'
	    multiplePlayers = true
	elseif v2 == 'basil' then
	    secondChar = 'basil'
	    multiplePlayers = true
	end
    end

    if name == 'Block Tales Win' then
	if v1 == 'die' then
	    runTimer('grr', 1.1)
	    playAnim('dad', 'explode')
	    setProperty('dad.specialAnim', true)
	    function onTimerCompleted(tag) if tag == 'grr' then
		setProperty('dad.animation.curAnim.paused', true) end
	    end
	elseif v1 == 'win' then
	    for _, i in pairs({'boyfriend', 'ito', 'carrie', 'basil'}) do
		playAnim(i, 'win')
		setProperty(i..'.specialAnim', true)
		setProperty(i..'.animation.curAnim.paused', true)
	    end
	end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if multiplePlayers then
	setProperty(targetChar..'.holdTimer', 0)
	setProperty(secondChar..'.holdTimer', 0)
	playAnim(secondChar, getProperty('singAnimations')[noteData+1], true)
    elseif allPlayers then
	for _, i in pairs({'ito', 'carrie', 'basil'}) do
	    playAnim(i, getProperty('singAnimations')[noteData+1], true)
	    setProperty(i..'.holdTimer', 0)
	end
    end

    playAnim(targetChar, getProperty('singAnimations')[noteData+1], true)
    setProperty(targetChar..'.holdTimer', 0)
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', ogOffs)
end