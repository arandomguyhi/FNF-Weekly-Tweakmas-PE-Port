local path = '../TweakAssets/stages/Tweakmas/Third Edition/jamiepaige/'

local tetoPoseSuffix = ''

luaDebugMode = true
function onCreate()
    if shadersEnabled then
        initLuaShader('vhs')

        makeLuaSprite('vhs')
        setSpriteShader('vhs', 'vhs')
    end

    setProperty('skipCountdown', true)

    makeLuaSprite('BG', path..'bg', 125, -100)
    setScrollFactor('BG', 0.85, 1)
    addLuaSprite('BG')

    makeLuaSprite('cylinder', path..'cylinder', 1189, 101)
    setScrollFactor('cylinder', 0.85, 0.85)
    setProperty('cylinder.alpha', 0.00000001)
    addLuaSprite('cylinder')

    makeLuaSprite('sphere', path..'sphere', 652, -19)
    setScrollFactor('sphere', 0.9, 0.9)
    setProperty('sphere.alpha', 0.0000001)
    addLuaSprite('sphere')

    makeLuaSprite('cube', path..'cube', 937, 300)
    setScrollFactor('cube', 0.9, 0.9)
    setProperty('cube.alpha', 0.00000001)
    addLuaSprite('cube')

    makeLuaSprite('cone', path..'cone', 1361, 253)
    setScrollFactor('cone', 0.85, 0.85)
    setProperty('cone.alpha', 0.000000001)
    addLuaSprite('cone')

    makeLuaSprite('torus', path..'torus', 176, 116)
    setScrollFactor('torus', 0.9, 0.9)
    setProperty('torus.alpha', 0.000001)
    addLuaSprite('torus')

    makeLuaSprite('blackScreen') makeGraphic('blackScreen', 1, 1, '000000')
    scaleObject('blackScreen', screenWidth + 2, screenHeight)
    setObjectCamera('blackScreen', 'other')
    addLuaSprite('blackScreen')
end

function onCreatePost()
    ogOffs = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')

    setProperty('dad.alpha', 0.000001)
    setProperty('iconP2.alpha', 0.0001)
    snapCamFollowToPos(568, 610.5)
    setProperty('camZooming', true)
    setProperty('camGame.zoom', 1.5)
    setProperty('defaultCamZoom', 1.5)
    setProperty('boyfriend.cameraPosition[0]', 250)
    setProperty('boyfriend.cameraPosition[1]', 65)
    setProperty('iconP1.iconOffsets[1]', -20)
    setProperty('iconP2.iconOffsets[1]', -10)
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {505, -120, 600, -120})
end

function opponentNoteHit(id, noteData)
    playAnim('dad', getProperty('singAnimations')[noteData+1]..tetoPoseSuffix, true)
    setProperty('dad.holdTimer', 0)
end

function onUpdatePost()
    P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    setProperty('iconP1.x',P1Mult - 115)
    setProperty('iconP1.origin.x', 230)
    setProperty('iconP1.flipX',true) 

    setProperty('iconP2.x',P2Mult + 100)
    setProperty('iconP2.origin.x', -100)
    setProperty('iconP2.flipX',true)
    setProperty('healthBar.flipX',true)
end

function onSongStart()
    doTweenAlpha('unblack', 'blackScreen', 0, 5, 'smoothStepInOut')
end

function onEvent(name, v1, v2)
    if name == 'Companion Events' then
        if v1 == 'shapes' then
            setProperty('isCameraOnForcedPos', true)
            startTween('camZoom', 'game', {defaultCamZoom = 0.95}, 4, {ease = 'smoothStepInOut'})
            startTween('camPos', 'camFollow', {x = 900, y = 500}, 4, {ease = 'smoothStepInOut'})
            for _, i in pairs({'cube', 'sphere', 'cone', 'torus', 'cylinder'}) do
                startTween('shapesTween'.._, i, {alpha = 1}, 3, {ease = 'quadOut'})
            end
        elseif v1 == 'back to jamie' then
            startTween('camZoomAgain', 'game', {defaultCamZoom = 1.5}, 4, {ease = 'smoothStepInOut'})
            startTween('camPosAgain', 'camFollow', {x = 568, y = 610.5}, 4, {ease = 'smoothStepInOut', onComplete = 'forceCamera'})
            function forceCamera() setProperty('isCameraOnForcedPos', false) end
        elseif v1 == 'zoom out' then
            setProperty('isCameraOnForcedPos', true)
            startTween('camZoomOut', 'game', {defaultCamZoom = 0.95}, 4, {ease = 'smoothStepInOut'})
            startTween('OMG TETOOOO', 'camFollow', {x = 900, y = 535}, 4, {ease = 'smoothStepInOut'})
            setProperty('dad.alpha', 1)
            startTween('TETOREVEAL', 'iconP2', {alpha = 1}, 2.5, {ease ='quadOut', startDelay = 2})
        elseif v1 == 'reveal over' then
            setProperty('isCameraOnForcedPos', false)
            setProperty('defaultCamZoom', 1.1)
            setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {125, 0, 200, 0})
            setProperty('boyfriend.cameraPosition[0]', 40)
            setProperty('boyfriend.cameraPosition[1]', 0)
        elseif v1 == 'black screen' then
            if v2 == 'on' then
                setProperty('blackScreen.visible', true)
                setProperty('blackScreen.alpha', 1)
            elseif v2 == 'off' then
                setProperty('blackScreen.visible', false)
                setProperty('blackScreen.alpha', 0.001)
            end
        elseif v1 == 'shader' then
            if v2 == 'on' then
                if shadersEnabled then
                    runHaxeCode([[
                        game.camGame.setFilters([new ShaderFilter(game.getLuaObject('vhs').shader)]);
                        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('vhs').shader)]);
                    ]])
                end
            elseif v2 == 'off' then
                if shadersEnabled then
                    runHaxeCode([[
                        game.camGame.filters = [];
                        game.camHUD.filters = [];
                    ]])
                end
            end
        elseif v1 == 'middle cam' then
            if v2 == 'on' then
                setProperty('isCameraOnForcedPos', true)
                callMethod('camFollow.setPosition', {900, 535})
            elseif v2 == 'off' then
                setProperty('isCameraOnForcedPos', false)
            end
        elseif v1 == 'color change' then
            if v2 == 'first drop' then
                setProperty('BG.color', 0x00E798)
                setProperty('cube.color', 0xFFFB04)
                setProperty('torus.color', 0xFF9300)
                setProperty('cone.color', 0xFF9300)
                setProperty('cylinder.color', 0xFFFB04)
                setProperty('sphere.color', 0xF8598E)
            elseif v2 ==  'interlude' then
                setProperty('BG.color', 0xF8598E)
                setProperty('cube.color', 0x0004FF)
                setProperty('torus.color', 0x4C9AFF)
                setProperty('cone.color', 0x4C9AFF)
                setProperty('cylinder.color', 0x0004FF)
                setProperty('sphere.color', 0xF8598E)
            elseif v2 == 'rot for clout' then
                setProperty('BG.color', 0xFF4646)
                setProperty('cube.color', 0xFFFFFF)
                setProperty('torus.color', 0xFFFFFF)
                setProperty('cone.color', 0xFFFFFF)
                setProperty('cylinder.color', 0xFFFFFF)
                setProperty('sphere.color', 0xFFFFFF)
            elseif v2 == 'hawk tuah' then
                setProperty('cube.color', 0x00A2FF)
                setProperty('torus.color', 0x00FF7F)
                setProperty('cone.color', 0x00FF7F)
                setProperty('cylinder.color', 0x00FF7F)
                setProperty('sphere.color', 0x00A2FF)
            elseif v2 == 'gay shapes' then
                setProperty('BG.color', 0x8400FF)
                setProperty('cube.color', 0xFFEE00)
                setProperty('torus.color', 0xFF2C2C)
                setProperty('cone.color', 0x5549F8)
                setProperty('cylinder.color', 0x15FF00)
                setProperty('sphere.color', 0xFF8800)
            elseif v2 == 'white' then
                setProperty('BG.color', 0xFFFFFF)
                setProperty('cube.color', 0xFFFFFF)
                setProperty('torus.color', 0xFFFFFF)
                setProperty('cone.color', 0xFFFFFF)
                setProperty('cylinder.color', 0xFFFFFF)
                setProperty('sphere.color', 0xFFFFFF)
            elseif v2 == 'green and red' then
                setProperty('BG.color', 0xFF2C2C)
                setProperty('cube.color', 0x3DF337)
                setProperty('torus.color', 0x3DF337)
                setProperty('cone.color', 0x3DF337)
                setProperty('cylinder.color', 0x3DF337)
                setProperty('sphere.color', 0x3DF337)
            elseif v2 == 'green and red alt' then
                setProperty('BG.color', 0xC8FFDD)
                setProperty('cube.color', 0xFF2C2C)
                setProperty('torus.color', 0x3DF337)
                setProperty('cone.color', 0xFF2C2C)
                setProperty('cylinder.color', 0x3DF337)
                setProperty('sphere.color', 0xFF2C2C)
            end
        elseif v1 == 'Change Pose Suffix' then
            tetoPoseSuffix = v2
            triggerEvent('Alt Idle Animation', 'dad', v2)
        end
    end

    if name == 'Set Cam Zoom' then
	debugPrint('hi?')
end
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', ogOffs)
end