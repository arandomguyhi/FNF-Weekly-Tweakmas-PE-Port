local skipIntro = false
local anaisSinging = false
local path = '../TweakAssets/stages/Tweakmas/First Edition/gumball/'

function onCreate()
    makeLuaSprite('fuck', path..'gumballweekly_bg')
    addLuaSprite('fuck')

    setProperty('skipCountdown', true)
end

function onCreatePost()
    createInstance('anais', 'objects.Character', {1400, 700, 'anais'})
    setProperty('anais.flipX', not getProperty('anais.flipX'))
    addInstance('anais', true)

    setProperty('gf.flipX', false)

    if not skipIntro then
	initLuaShader('3D')

	setProperty('camGame.visible', false)

	makeLuaSprite('frames', path..'gbframe_1')
	setObjectCamera('frames', 'camOther')
	setProperty('frames.visible', false)
	addLuaSprite('frames')

	makeLuaSprite('overlay', path..'gbframe_2overlay')
	scaleObject('overlay', 0.625, 0.625)
	screenCenter('overlay')
	setObjectCamera('overlay', 'camOther')
	setProperty('overlay.visible', false)
	addLuaSprite('overlay')

	setProperty('camHUD.visible', false)
	runHaxeCode([[
	    var sh = game.createRuntimeShader('3D');
	    camGame.setFilters([new ShaderFilter(sh)]);
	    setVar('sh', sh);
	]])
    end
end

function onStepHit()
    if curStep == 11 then
	changeFrame(1)
	setProperty('frames.visible', true)
	setProperty('overlay.visible', true)
    elseif curStep == 43 then changeFrame(2)
    elseif curStep == 75 then changeFrame(3)
    elseif curStep == 138 then changeFrame(4)
    elseif curStep == 183 then changeFrame(5)
    elseif curStep == 198 then
	for s, n in pairs({'frames', 'overlay'}) do
	    startTween('tween'..s, n, {alpha = 0}, 2, {ease = 'circInOut'})
	end
    end

    if curStep == 224 then
	setProperty('camGame.visible', true)
	runHaxeCode("getVar('sh').setFloat('zpos', 1);")
    elseif curStep == 228 then
	runHaxeCode("getVar('sh').setFloat('yrot', -1);")
    elseif curStep == 230 then
	runHaxeCode("getVar('sh').setFloat('yrot', 1);")
    elseif curStep == 232 then
	setProperty('camHUD.visible', true)
	runHaxeCode([[
	    getVar('sh').setFloat('zpos', 0);
	    getVar('sh').setFloat('yrot', 0);
	]])
	cameraFlash('camHUD', 'FFFFFF', 1)
    end

    if curStep == 1608 then
	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)
    end
end

function onSpawnNote()
    for i = 0,7 do
	if getPropertyFromGroup('notes', i, 'mustPress') and getPropertyFromGroup('notes', i, 'noteType') == 'Anais Note' then
	    setPropertyFromGroup('notes', i, 'noAnimation', true)
	end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'Anais Note' then
	anaisSinging = true
	setProperty('anais.holdTimer', 0)
	playAnim('anais', getProperty('singAnimations')[noteData+1], true)
    else anaisSinging = false
    end
    setVar('playerSing', noteType == 'Anais Note' and true or false)
end

function onBeatHit()
    local anim = getProperty('anais.animation.curAnim.name')
    if not anim:find('sing') and curBeat % 2 == 0 then callMethod('anais.dance', {''}) end
end

function changeFrame(frame)
    loadGraphic('frames', path..'gbframe_'..frame, false)
    scaleObject('frames', 0.75, 0.75)
    screenCenter('frames')
end


-- adapting it to work on anais!!!!!!!!!!!
local animIndex2 = {{-1, 0}, {0, 1}, {0, -1}, {1, 0}}
function onUpdate()
    anaisX = getMidpointX('anais') + 100 + getProperty('anais.cameraPosition[0]')
    anaisY = getMidpointY('anais') - 100 + getProperty('anais.cameraPosition[1]')

    for i = 0, 3 do
	if mustHitSection and anaisSinging then
	    if stringStartsWith(getProperty('anais.animation.curAnim.name'), getProperty('singAnimations')[i+1]) then
		setProperty('camFollow.x', anaisX + animIndex2[i+1][1] * 15)
		setProperty('camFollow.y', anaisY + animIndex2[i+1][2] * 15)
	    elseif stringStartsWith(getProperty('anais.animation.curAnim.name'), 'idle') then
		setProperty('camFollow.x', anaisX) setProperty('camFollow.y', anaisY)
	    end
	end
    end
end