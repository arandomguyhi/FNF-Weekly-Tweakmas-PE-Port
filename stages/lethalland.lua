local path = '../TweakAssets/stages/Tweakmas/Second Edition/lethal/'

local targetChar = 'boyfriend'
luaDebugMode = true
function onCreatePost()
    ogOffs = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')

    makeLuaSprite('shower', nil, -100, -100)
    makeGraphic('shower', screenWidth * 2, screenHeight * 2, '000000')
    addLuaSprite('shower', true)

    for _, i in pairs({'scoreTxt', 'timeTxt'}) do
	setTextFont(i, 'lethil.otf') end
    setTextSize('scoreTxt', 25)

    makeLuaText('aab', 'SONG 5: Dead End', -1, 60, 200)
    setTextFont('aab', 'lethil.otf') setTextSize('aab', 50) setProperty('aab.color', callMethodFromClass('psychlua.CustomFlxColor', 'fromRGB', {126, 200, 255}))
    makeLuaText('bba', '\n \n \nMUSIC: Cloverderus, theWAHbox, Kreagato\n\nCHART: Cloverderus\n\nART: Loggo, Dollie, DerpDrawz\n\nCODE: Srife5, Loggo, TheOrda\n\nVOICE ACTING: Cloverderus, MochaDrawss', -1, 60, 200)
    setTextFont('bba', 'lethil.otf') setTextSize('bba', 25) setProperty('bba.color', callMethodFromClass('psychlua.CustomFlxColor', 'fromRGB', {126, 200, 255}))
    setProperty('aab.alpha', 0)
    setProperty('bba.alpha', 0)
    makeLuaText('bt', '2 lb', -1, 1100, getProperty('scoreTxt.y'))
    setTextFont('bt', 'lethil.otf') setTextSize('bt', 25) setTextColor('bt', 'FF0000')
    setProperty('bt.borderSize', 1.25)
    setProperty('bt.visible', not hideHud)

    for _, i in pairs({'bt', 'aab', 'bba'}) do
	setBlendMode(i, 'ADD')
	addLuaText(i)
    end

    setBlendMode('scoreTxt', 'ADD')
    setProperty('dad.visible', false)
    setProperty('iconP2.visible', false)

    runHaxeCode([[
	var healthB = new objects.Bar(0, FlxG.height * (!ClientPrefs.data.downScroll ? 0.89 : 0.11), 'healthBar', function() return game.health, 0, 2);
	healthB.screenCenter();
	healthBar.y -= healthBar.height/2;
	healthB.y = healthBar.y;
	healthB.y += healthB.height-5;

	healthB.cameras = [game.camHUD];
	healthB.setColors(FlxColor.fromRGB(0, 0, 0), FlxColor.fromRGB(63, 121, 106));
	timeBar.setColors(FlxColor.fromRGB(255, 255, 0), FlxColor.fromRGB(0, 0, 0));
	timeBar.scale.set(1.5, 0.5);
	healthB.leftToRight = false;
	uiGroup.insert(uiGroup.members.indexOf(iconP1), healthB);
    ]])

    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {-100, -100, -100, -100})
end

local animIndex = {{-1, 0}, {0, 1}, {0, -1}, {1, 0}}
function onUpdate()
    setTextString('scoreTxt', getProperty('scoreTxt.text'):upper())

    for i=0,7 do
	if getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'noAnimation', true)
	end
    end

    charCamX = getMidpointX(targetChar) + getProperty(targetChar..'.cameraPosition[0]')
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

function onStepHit()
    if curStep == 1 then
	setProperty('bba.alpha', 1) setProperty('aab.alpha', 1)
    elseif curStep == 24 then
	runHaxeCode([[
	    import flixel.effects.FlxFlicker;
	    FlxFlicker.flicker(game.modchartTexts.get('bba'), 0.6, 0.1, false);
	    FlxFlicker.flicker(game.modchartTexts.get('aab'), 0.6, 0.1, false);
	]])
    elseif curStep == 18 then
	setProperty('shower.alpha', 0)
    end

    if curStep == 272 then
	cameraFlash('camGame', '000000', 5)
	setProperty('dad.visible', true)
	setProperty('iconP2.visible', true)
    end
end

function onCreate()
    makeLuaSprite('bg', path..'lethalbg')
    addLuaSprite('bg')
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'Duet' then
	playAnim('gf', getProperty('singAnimations')[noteData+1], true)
	setProperty('gf.holdTimer', 0)
    end

    playAnim(targetChar, getProperty('singAnimations')[noteData+1], true)
    setProperty(targetChar..'.holdTimer', 0)
end

function onEvent(name, v1, v2)
    if name == 'Switch Player' then
	if v1 == 'john' then
	    targetChar = 'gf'
	    setVar('playerSing', false)
	elseif v1 == 'jones' then
	    targetChar = 'boyfriend'
	    setVar('playerSing', true)
	end
    end
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', ogOffs)
end