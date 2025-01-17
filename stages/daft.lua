local path = '../TweakAssets/stages/Tweakmas/Third Edition/Daftpunk/'

local fuckyes = false

local strength = 32
local  mosaicMult = -1
local flashBeat = 8

--local cu = -1

local function lerp(a,b,t)
    return a+(b-a)*t
end

local function bound(v,min,max)
    return math.max(min,math.min(max,v))
end

setProperty('camZoomingMult', 0)
setProperty('camZoomingDecay', 0)

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', path..'background')
    screenCenter('bg')
    setProperty('bg.x', getProperty('bg.x')-19.5)
    addLuaSprite('bg')

    makeLuaSprite('ceiling', path..'Cellingshit')
    screenCenter('ceiling', 'X')
    setProperty('ceiling.x', getProperty('ceiling.x')-19.5)
    setProperty('ceiling.y', getProperty('ceiling.y') - 250)
    addLuaSprite('ceiling')

    makeLuaSprite('dsotm', path..'Pyramid')
    screenCenter('dsotm', 'X')
    setProperty('dsotm.x', getProperty('dsotm.x')-19.5)
    setProperty('dsotm.y', getProperty('dsotm.y') - 75)
    addLuaSprite('dsotm')

    makeLuaSprite('flash1', path..'flash', 200, -200)
    setProperty('flash1.angle', 45)
    setBlendMode('flash1', 'add')
    addLuaSprite('flash1')

    local originalPosition1 = {x = -200, y = -200}
    startTween('flashie1', 'flash1', {angle = -45, x = originalPosition1.x - 225, y = originalPosition1.y + 100}, 3, {ease = 'quadInOut', type = 'pingpong'})

    makeLuaSprite('flash', path..'flash', 605, -250)
    setProperty('flash.angle', -45)
    setBlendMode('flash', 'add')
    addLuaSprite('flash')

    local originalPosition = {x = 975, y = -200}
    startTween('flashie', 'flash', {angle = 45, x = originalPosition.x + 225, y = originalPosition.y + 100}, 3, {ease = 'quadInOut', type = 'pingpong'})

    makeLuaSprite('floor', path..'Floor')
    setProperty('floor.y', 615)
    setProperty('floor.x', getProperty('floor.x') - 18)
    addLuaSprite('floor')

    makeAnimatedLuaSprite('speakers', path..'Speakers')
    addAnimationByPrefix('speakers', 'bop', 'Speakers', 24, false)
    playAnim('speakers', 'bop')
    screenCenter('speakers')
    setProperty('speakers.x', getProperty('speakers.x')-19.5)
    setProperty('speakers.y', getProperty('speakers.y') + 125)
    addLuaSprite('speakers')

    makeAnimatedLuaSprite('robot1', path..'DaftPunk')
    addAnimationByPrefix('robot1', 'bop', 'IdleLeft', 24, false)
    playAnim('robot1', 'bop')
    setProperty('robot1.x', getProperty('robot1.x') + 300)
    setProperty('robot1.y', getProperty('robot1.y') + 225)
    addLuaSprite('robot1')

    makeAnimatedLuaSprite('robot2', path..'DaftPunk')
    addAnimationByPrefix('robot2', 'bop', 'IdleRight', 24, false)
    playAnim('robot2', 'bop')
    setProperty('robot2.x', getProperty('robot2.x') + 600)
    setProperty('robot2.y', getProperty('robot2.y') + 45)
    addLuaSprite('robot2')

    makeLuaSprite('spotlights', path..'SpotlightsFInal')
    screenCenter('spotlights')
    setProperty('spotlights.x', getProperty('spotlights.x')-19.5)
    setProperty('spotlights.y', getProperty('spotlights.y') + 400)
    addLuaSprite('spotlights', true)

    if shadersEnabled then
        initLuaShader('mosaic')
        initLuaShader('bloom')

        makeLuaSprite('bloom')
        setSpriteShader('bloom', 'bloom')

        setShaderFloat('bloom', 'Size', 0)
        setShaderFloat('bloom', 'dim', 2)
        setShaderFloat('bloom', 'Directions', 16)

        makeLuaSprite('mosaic')
        setSpriteShader('mosaic', 'mosaic')

        runHaxeCode([[
            var bloomShader = game.getLuaObject('bloom').shader;
            var mosaicShader = game.getLuaObject('mosaic').shader;

            FlxG.camera.setFilters([new ShaderFilter(bloomShader), new ShaderFilter(mosaicShader)]);
            game.camHUD.setFilters([new ShaderFilter(mosaicShader)]); 
        ]])
    end
end

function onBeatHit()
    for _,i in pairs({'speakers', 'robot1', 'robot2'}) do
        playAnim(i, 'bop', true)
    end

    if getProperty('dad.animation.name') == 'idle' then
        setProperty('dad.animation.curAnim.curFrame', 0)
    end
    if getProperty('boyfriend.animation.name') == 'idle' then
        setProperty('boyfriend.animation.curAnim.curFrame', 0)
    end

    strength = strength + mosaicMult
    if strength <= 0 then strength = 1 end
    setShaderFloatArray('mosaic', 'uBlocksize', {strength, strength})

    if curBeat % flashBeat == 0 then
        local from = fuckyes and 0.5 or 1
        local from2 = fuckyes and 9 or 4
        runHaxeCode([[
            FlxTween.num(]]..from..[[, 2, (Conductor.stepCrochet / 1000) * 8, {onUpdate: (t)->{
                game.callOnLuas('updateTweenFloat', ['bloom', 'dim', t.value]);
            }});
            FlxTween.num(]]..from2..[[, 2, (Conductor.stepCrochet / 1000) * 8, {onUpdate: (t)->{
                game.callOnLuas('updateTweenFloat', ['bloom', 'Size', t.value]);
            }});
        ]])
    end

    if curStep >= 876 and curStep < 1280 then
        if getProperty('camZooming') then
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.02)
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015)
        end

        local cu = -1
        for i = 0,3 do
            cu=cu*-1

            setProperty('playerStrums.members['..i..'].x', getVar('x'..i) + (curBeat % 2 == 0 and -75 or 75))
            setProperty('playerStrums.members['..i..'].y', getVar('y'..i) + 30*cu)
            setProperty('playerStrums.members['..i..'].scale.y', getVar('sY'..i) + (curBeat % 4 == 0 and -0.5 or 0.5)*cu)
            startTween('scale'..i, 'playerStrums.members['..i..']', {x = getVar('x'..i), y = getVar('y'..i), ['scale.y'] = getVar('sY'..i)}, (stepCrochet/1000)*2, {ease = 'cubeOut'})
        end
    end
end

function onCreatePost()
    setPropertyFromClass('flixel.FlxG', 'camera.height', 720-125)
    setPropertyFromClass('flixel.FlxG', 'camera.y', getPropertyFromClass('flixel.FlxG', 'camera.y')+125/2)
    setProperty('camHUD.height', 657)

    setProperty('camHUD.zoom', 0.61)

    screenCenter('healthBar', 'X')
    screenCenter('scoreTxt', 'X')
    screenCenter('timeBar', 'X')
    screenCenter('timeTxt', 'X')

    setProperty('dad.danceEveryNumBeats', 1)
    setProperty('boyfriend.danceEveryNumBeats', 1)

    screenCenter('dad')
    setProperty('dad.x', getProperty('dad.x')-19.5)
    setProperty('dad.y', getProperty('dad.y') + 200)

    screenCenter('boyfriend')
    setProperty('boyfriend.y', getProperty('boyfriend.y') + 375)
    setProperty('boyfriend.x', getProperty('boyfriend.x') + 10-19.5)

    makeLuaSprite('lbar')
    makeGraphic('lbar', 275, screenHeight, '000000')
    setObjectCamera('lbar', 'other')
    addLuaSprite('lbar')

    makeLuaSprite('rbar', nil, screenWidth-275)
    makeGraphic('rbar', 275, screenHeight, '000000')
    setObjectCamera('rbar', 'other')
    addLuaSprite('rbar')

    for i = 0,3 do
        setProperty('playerStrums.members['..i..'].x', 435 + (112 * i))
        setProperty('playerStrums.members['..i..'].y', _G['defaultPlayerStrumY'..i] - 90)

        runHaxeCode([[
            for (strum in opponentStrums) {
                strum.camera = camGame;
                strum.scrollFactor.set(1,1);
            }
        ]])

        setProperty('opponentStrums.members['..i..'].x', getProperty('opponentStrums.members['..i..'].x')+315)
        setProperty('opponentStrums.members['..i..'].y', getProperty('opponentStrums.members['..i..'].y')+425)
        setPropertyFromGroup('opponentStrums', i, 'downScroll', true)

        setVar('x'..i, getProperty('playerStrums.members['..i..'].x'))
        setVar('y'..i, getProperty('playerStrums.members['..i..'].y'))
        setVar('sY'..i, getProperty('playerStrums.members['..i..'].scale.y'))
    end
    setObjectOrder('noteGroup', getObjectOrder('flash1'))
    setObjectOrder('uiGroup', getObjectOrder('noteGroup'))

    setProperty('timeBar.y', getProperty('timeBar.y')-90)
    setProperty('timeTxt.y', getProperty('timeTxt.y')-90)

    setProperty('healthBar.y', getProperty('healthBar.y') + 130)
    setProperty('scoreTxt.y', getProperty('scoreTxt.y') + 130)
    setProperty('iconP1.iconOffsets[1]', -130)
    setProperty('iconP2.iconOffsets[1]', -130)

    loadGraphic('healthBar.bg', path..'Bar', false)
    scaleObject('healthBar.bg', 1.0325, 0.85)
    screenCenter('healthBar.bg', 'X')
    setProperty('healthBar.bg.offset.x', getProperty('healthBar.bg.offset.x')+5)
    setProperty('healthBar.bg.offset.y', getProperty('healthBar.bg.offset.y')+5)

    snapCamFollowToPos(1280 / 2, (720 / 2) - 100, false)

    setProperty('comboGroup.visible', false)
end

function onSongStart()
    cameraFlash('camGame', '000000', 12)

    runHaxeCode([[
        FlxTween.num(1.6, 0.75, 12, {ease: FlxEase.quadOut, onUpdate: (t)->{
            FlxG.camera.zoom = t.value;
        }});
    
        new FlxTimer().start((Conductor.stepCrochet / 1000) * 124, ()->{
            game.isCameraOnForcedPos = false;
        });
    ]])
end

function onUpdatePost(elapsed)
    if getProperty('camZooming') then
        setProperty('camGame.zoom', lerp(0.61, getProperty('camGame.zoom'), bound(1 - (elapsed * 3.125 * 1 * playbackRate), 0, 1)))
        setProperty('camHUD.zoom', lerp(0.61, getProperty('camHUD.zoom'), bound(1 - (elapsed * 3.125 * 1 * playbackRate), 0, 1)))
    end
end

function onSpawnNote()
    runHaxeCode([[
        for (note in game.notes) {
            if (!note.mustPress) {
                note.camera = camGame;
                note.scrollFactor.set(1,1);
            }
        }
    ]])
end

local fuck = false
local counter = 0
function onSectionHit()
    counter = counter + 1
    if counter % 2 == 0 then
        fuck = not fuck
        altTime = not fuck

        callMethod('iconP2.changeIcon', {fuck and 'bot1' or 'bot2'})
        setProperty('iconP2.iconOffsets[1]', -130)
    end
end

function updateTweenFloat(n,u,v)
    setShaderFloat(n,u,v)
end

function onStepHit()
    if curStep == 830 then flashBeat = 9999
    elseif curStep == 891 then fuckyes = true flashBeat = 4
    elseif curStep == 1216 then
        mosaicMult = 2

        setProperty('camZooming', false)
        runHaxeCode([[
            FlxTween.num(0.7, 1.2, (Conductor.stepCrochet / 1000) * 48, {ease: FlxEase.quadOut, onUpdate: (t)->{
                FlxG.camera.zoom = t.value;
            }});
            game.camHUD.fade(FlxColor.BLACK, (Conductor.stepCrochet / 1000) * 48);
        ]])
    end
end

function opponentNoteHit(id,noteData)
    if altTime then
        playAnim('dad', getProperty('singAnimations')[noteData+1]..'-alt', true)
        setProperty('dad.holdTimer', 0)
    end
end