local path = '../TweakAssets/stages/Tweakmas/Third Edition/tyler/'

local otherChars = false
local charToSing = ''

local function lerp(a,b,t)
    return a+(b-a)*t
end

local function bound(v,min,max)
    return math.max(min,math.min(max,v))
end

setProperty('camZoomingMult', 0)
setProperty('camZoomingDecay', 0)

addHaxeLibrary('Type')

luaDebugMode = true
function onCreate()
    makeLuaSprite('wolfBG', path..'wolf')
    setGraphicSize('wolfBG', 1280)
    screenCenter('wolfBG')
    addLuaSprite('wolfBG')

    makeAnimatedLuaSprite('sam', path..'sam')
    addAnimationByPrefix('sam', 'idle', 'sam', 4, true)
    playAnim('sam', 'idle')
    screenCenter('sam', 'X')
    setProperty('sam.x', getProperty('sam.x') + 1280 / 4)
    setProperty('sam.y', 960 / 8)
    setProperty('sam.alpha', 0.6)
    addLuaSprite('sam')

    makeLuaSprite('flowerSky', path..'flowerSky')
    scaleObject('flowerSky', 1.5, 1.5)
    screenCenter('flowerSky')
    setProperty('flowerSky.visible', false)
    setProperty('flowerSky.y', getProperty('flowerSky.y') - 350)
    addLuaSprite('flowerSky')

    makeLuaSprite('colorBG') makeGraphic('colorBG', 1280, 960, 'ffffff')
    setProperty('colorBG.color', 0xF7B4C6)
    setProperty('colorBG.y', getProperty('colorBG.y') + 121 - 600)
    setProperty('colorBG.alpha', 0.0000001)
    addLuaSprite('colorBG')

    if shadersEnabled then
        createInstance('igorShader', 'shaders.ColorSwap')
        setProperty('igorShader.saturation', -1)
        setProperty('igorShader.brightness', 0)
    end

    createInstance('igor', 'objects.Character', {-19.5, -600, 'igor'})
    screenCenter('igor', 'X')
    setProperty('igor.x', getProperty('igor.x') + (screenWidth / 4) - 25)
    setProperty('igor.y', getProperty('igor.y') + 360)
    if shadersEnabled then
        runHaxeCode("game.getLuaObject('igor').shader = getVar('igorShader').shader;")
    end
    addInstance('igor')
    setProperty('igor.alpha', 0.0000001)

    makeLuaSprite('flowerBG', path..'flowerBack')
    scaleObject('flowerBG', 1.25, 1.25)
    screenCenter('flowerBG')
    setProperty('flowerBG.visible', false)
    addLuaSprite('flowerBG')

    makeLuaSprite('flowerFG', path..'flowerFront')
    scaleObject('flowerFG', 1.325, 1.325)
    screenCenter('flowerFG')
    setProperty('flowerFG.y', getProperty('flowerFG.y') + 190)
    setScrollFactor('flowerFG', 1.25, 1.25)
    setProperty('flowerFG.visible', false)
    addLuaSprite('flowerFG', true)

    makeLuaSprite('flowerOverlay', path..'flower overlay')
    setObjectCamera('flowerOverlay', 'camHUD')
    scaleObject('flowerOverlay', 1.25, 1.25)
    addLuaSprite('flowerOverlay')

    makeLuaSprite('chromakopia', path..'Chromakopia')
    screenCenter('chromakopia', 'X')
    setProperty('chromakopia.y', getProperty('chromakopia.y') - 350)
    setProperty('chromakopia.y', getProperty('chromakopia.y') - 315)
    addLuaSprite('chromakopia')

    createInstance('stchroma', 'objects.Character', {-19.5, -600, 'stchroma'})
    screenCenter('stchroma', 'X')
    setProperty('stchroma.x', getProperty('stchroma.x') + (screenWidth / 4) - 25)
    setProperty('stchroma.y', getProperty('stchroma.y') + 550)
    setProperty('stchroma.y', getProperty('stchroma.y') + getProperty('stchroma.height'))
    setProperty('stchroma.alpha', 0.000001)
    addInstance('stchroma')
end

function onCreatePost()
    setPropertyFromClass('flixel.FlxG', 'camera.height', 720-125)
    setPropertyFromClass('flixel.FlxG', 'camera.y', getPropertyFromClass('flixel.FlxG', 'camera.y')+125/2)
    setProperty('camHUD.height', 657)

    setProperty('camHUD.zoom', 0.61)

    for i = 0,3 do
        setProperty('playerStrums.members['..i..'].x', 435 + (112 * i))
        setProperty('playerStrums.members['..i..'].y', _G['defaultPlayerStrumY'..i] - 100)
    end

    for _,i in pairs({'comboGroup', 'timeBar', 'timeTxt', 'healthBar', 'scoreTxt', 'iconP1', 'iconP2'}) do
        setProperty(i..'.visible', false)
    end

    makeLuaSprite('lbar')
    makeGraphic('lbar', 275, screenHeight, '000000')
    setObjectCamera('lbar', 'other')
    addLuaSprite('lbar')

    makeLuaSprite('rbar', nil, screenWidth-275)
    makeGraphic('rbar', 275, screenHeight, '000000')
    setObjectCamera('rbar', 'other')
    addLuaSprite('rbar')

    screenCenter('boyfriendGroup')
    setProperty('dad.visible', false)
    setProperty('gf.visible', false)

    snapCamFollowToPos(1280 / 2, 960 / 1.8, true)

    screenCenter('flowerOverlay')
    setProperty('flowerOverlay.y', getProperty('flowerOverlay.y') + 12.5)
    setProperty('flowerOverlay.x', 1280)

    makeLuaText('branding', 'ALL SONGS WRITTEN, PRODUCED, AND ARRANGED BY TYLER OKONMA', 0, 0, 999)
    setTextFont('branding', 'tyler.otf')
    setTextSize('branding', 32)
    setTextColor('branding', '000000')
    setProperty('branding.borderSize', 0)
    screenCenter('branding', 'X')
    setProperty('branding.y', 1025 - 600)
    setObjectOrder('branding', getObjectOrder('noteGroup'))
    addLuaText('branding')
    setProperty('branding.visible', false)

    makeLuaText('flowerBrand', '')
    setTextFont('flowerBrand', 'flower boy.ttf')
    setTextSize('flowerBrand', 32)
    setTextColor('flowerBrand', 'DF968D')
    runHaxeCode("game.modchartTexts['flowerBrand'].borderStyle = Type.resolveEnum('flixel.text.FlxText.FlxTextBorderStyle').SHADOW;")
    setTextString('flowerBrand', 'ALL SONGS WRITTEN AND\nPRODUCED BY TYLER OKONMA')
    screenCenter('flowerBrand', 'X')
    setProperty('flowerBrand.y', screenHeight)
    setProperty('flowerBrand.alpha', 0.0001)
    addLuaText('flowerBrand')

    addCharacterToList('flower', 0)
end

function onUpdatePost(elapsed)
    if getProperty('camZooming') then
        setProperty('camGame.zoom', lerp(getProperty('camGame.zoom'), getProperty('camGame.zoom'), bound(1 - (elapsed * 3.125 * 1 * playbackRate), 0, 1)))
        setProperty('camHUD.zoom', lerp(0.61, getProperty('camHUD.zoom'), bound(1 - (elapsed * 3.125 * 1 * playbackRate), 0, 1)))
    end

    for i = 0, 3 do
        setProperty('opponentStrums.members['..i..'].alpha', 0)
    end
end

function onSpawnNote()
    if otherChars then
        for i = 0, 7 do
            if getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'noAnimation', true)
            end
        end
    end
end

function onStepHit()
    if curStep == 632 then
        flowerTransition()
    elseif curStep == 1200 then
        igorTransition()
    elseif curStep == 1984 then
        chromakopiaTransition1()
    elseif curStep == 2018 then
        chromakopiaTransition2()
    end
end

function flowerTransition()
    local stepSize = stepCrochet / 1000

    startTween('flower', 'flowerOverlay', {x = (screenWidth - getProperty('flowerOverlay.width')) / 2}, stepSize * 8, {ease = 'quartIn', onComplete = 'flowerTransitionComplete'})

    function flowerTransitionComplete()
        triggerEvent('Change Character', 'bf', 'flower')
        screenCenter('boyfriend')

        local camX = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]')
        local camY = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
        snapCamFollowToPos(camX, camY, false)

        setProperty('camZooming', true)
        runHaxeCode([[
            FlxTween.num(1.6-0.69, 1.75-0.69, ]]..stepSize..[[ * 4, {ease: FlxEase.quartOut, onUpdate: (t)->{
                FlxG.camera.zoom = t.value;
                game.defaultCamZoom = t.value;
            }});
        ]])

        setProperty('wolfBG.visible', false)
        setProperty('flowerSky.visible', true)
        setProperty('flowerBG.visible', true)
        setProperty('flowerFG.visible', true)

        startTween('flowerOut', 'flowerOverlay', {x = -getProperty('flowerOverlay.width')}, stepSize * 8, {ease = 'quartOut', onComplete = 'flowerBrand'})
        function flowerBrand()
            startTween('flowertween', 'flowerBrand', {alpha = 1, y = getProperty('flowerBrand.y') - 125}, stepSize * 8, {ease = 'quadOut'})
        end
    end
end

function igorText()
    setProperty('flowerSky.visible', false)
    setProperty('branding.visible', true)
end

function igorTransition()
    local stepSize = stepCrochet / 1000

    setProperty('isCameraOnForcedPos', true)
    otherChars = true
    charToSing = 'igor'
    runHaxeCode([[
        FlxTween.num(game.camFollow.y, 62, ]]..stepSize..[[ * (64 + 32), {ease: FlxEase.quadInOut, onUpdate: (t)->{
            game.camFollow.y = t.value;
        }});
        FlxTween.num(game.camFollow.x, 1280 / 2, ]]..stepSize..[[ * (64 + 32), {ease: FlxEase.quadInOut, onUpdate: (t)->{
            game.camFollow.x = t.value;
        }});

        FlxTween.num(1.75-0.69, 0.62, ]]..stepSize..[[ * 128, {ease: FlxEase.quadInOut, onUpdate: (t)->{
            FlxG.camera.zoom = t.value;
            game.defaultCamZoom = t.value;
        }});

        FlxTween.num(getVar('igorShader').saturation, 0, 6, {startDelay: ]]..stepSize..[[ * 128, ease: FlxEase.quadInOut, onUpdate: (fuck)->{ getVar('igorShader').saturation = fuck.value; }});
    ]])
    startTween('igorAlpha', 'igor', {alpha = 1}, stepSize * 32, {ease = 'quadInOut'})

    doTweenAlpha('colorr', 'colorBG', 1, stepSize * (64 + 32))
    startTween('byeflowie', 'flowerBG', {alpha = 0}, stepSize * (64 + 32), {startDelay = stepSize * 32})
    for _,fuck in pairs({'boyfriend', 'flowerBrand', 'flowerFG'}) do startTween('byee'.._, fuck, {alpha = 0}, stepSize * 64, {startDelay = stepSize * 32}) end
end

function chromakopiaTransition1()
    doTweenColor('greenie', 'colorBG', '00853C', (stepCrochet / 1000) * 32)
    doTweenAlpha('byeigor', 'igor', 0, (stepCrochet / 1000) * 32)
end

function chromakopiaTransition2()
    charToSing = 'stchroma'
    setProperty('branding.visible', true)

    startTween('hiii', 'stchroma', {y = (getProperty('stchroma.y') - getProperty('stchroma.height')) + 50, alpha = 1}, (stepCrochet / 1000) * 16, {ease = 'quintOut'})
    startTween('bzl', 'chromakopia', {y = getProperty('chromakopia.y') + 180}, (stepCrochet / 1000) * 16, {ease = 'quintOut'})
    startTween('BZ', 'branding', {y = 80}, (stepCrochet / 1000) * 16, {ease = 'quintOut'})
    debugPrint(getProperty('branding.y'))
end

function goodNoteHit(id, noteData)
    if otherChars then
        playAnim(charToSing, getProperty('singAnimations')[noteData+1], true)
        setProperty(charToSing..'.holdTimer', 0)
    end
end