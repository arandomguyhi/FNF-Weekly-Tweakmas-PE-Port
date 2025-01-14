local path = '../TweakAssets/stages/Tweakmas/Third Edition/jack/'

local objects = {}
local curObject = 0

function onCreate()
    setProperty('skipCountdown', true)

    makeLuaSprite('rainbg', path..'jacknightbg')
    updateHitbox('rainbg')
    addLuaSprite('rainbg')

    makeLuaSprite('rain1', path..'scrollrain')
    setProperty('rain1.visible', false)

    makeLuaSprite('rain2', path..'scrollrain')
    setProperty('rain2.y', getProperty('rain2.y') - getProperty('rain1.height'))
    setProperty('rain2.visible', false)

    addLuaSprite('rain1')
    addLuaSprite('rain2')

    makeLuaSprite('blackbg', path..'black screen', -200, -400)
    scaleObject('blackbg', 3, 3)
    addLuaSprite('blackbg')

    makeLuaSprite('bg', path..'jackbg')
    updateHitbox('bg')
    addLuaSprite('bg')
end

function onCreatePost()
    ogOffs = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')

    setProperty('defaultCamZoom', 1.55)
    snapCamFollowToPos(getProperty('bg.x') + (getProperty('bg.width') / 2), getProperty('bg.y') + (getProperty('bg.height') / 2) + 10, true)

    if shadersEnabled then
        initLuaShader('vhs')

        runHaxeCode([[
            var vhs = game.createRuntimeShader('vhs');
            var filter:ShaderFilter = new ShaderFilter(vhs);
            game.camGame._filters = [];
            game.camGame._filters.push(filter);
            game.camHUD._filters = [];
            game.camHUD._filters.push(filter);
        ]])
    end

    for i = 0, 6 do
        makeLuaSprite('object'..i, path..'props/'..i, -100, -100)
        scaleObject('object'..i, 1.2, 1.2)
        setProperty('object'..i..'.alpha', 0.001)
        addLuaSprite('object'..i, true)
        table.insert(objects, 'object'..i)
    end

    setProperty(objects[1]..'.x', -85)
    setProperty(objects[1]..'.y', 250)
    setProperty(objects[2]..'.x', getProperty(objects[1]..'.x') + 40)
    setProperty(objects[2]..'.y', getProperty(objects[1]..'.y') - 140)
    setProperty(objects[3]..'.x', getProperty(objects[2]..'.x') + 150)
    setProperty(objects[3]..'.y', getProperty(objects[2]..'.y') - 100)
    setProperty(objects[4]..'.x', getProperty(objects[3]..'.x') + 220)
    setProperty(objects[4]..'.y', getProperty(objects[3]..'.y') - 90)
    setProperty(objects[5]..'.x', getProperty(objects[4]..'.x') + 160)
    setProperty(objects[5]..'.y', getProperty(objects[4]..'.y') + 45)
    setProperty(objects[6]..'.x', getProperty(objects[5]..'.x') + 170)
    setProperty(objects[6]..'.y', getProperty(objects[5]..'.y') + 100)
    setProperty(objects[7]..'.x', getProperty(objects[6]..'.x') + 100)
    setProperty(objects[7]..'.y', getProperty(objects[6]..'.y') + 180)

    makeLuaSprite('black') makeGraphic('black', screenWidth + 2, screenHeight, '000000')
    setProperty('black.visible', false)
    setObjectCamera('black', 'camHUD')
    addLuaSprite('black')

    makeLuaSprite('hopscotch', path..'hopscotch')
    setProperty('hopscotch.visible', false)
    setObjectCamera('hopscotch', 'other')
    addLuaSprite('hopscotch')

    setTextFont('scoreTxt', 'arialbd.ttf')
    setProperty('scoreTxt.borderSize', 0)
    setTextFont('timeTxt', 'arialbd.ttf')
    setProperty('timeTxt.borderSize', 0)

    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {100, -50, 200, -20})
end

function onUpdate()
    setTextString('scoreTxt', getProperty('scoreTxt.text'):upper())
end
  
function onUpdatePost(elapsed)
    if getProperty('rain1.visible') then
        setProperty('rain1.y', getProperty('rain1.y') + 350 * elapsed)
        if getProperty('rain1.y') > 600 then
            setProperty('rain1.y', getProperty('rain1.y') - getProperty('rain1.height') * 2)
        end
        setProperty('rain2.y', getProperty('rain2.y') + 350 * elapsed)
        if getProperty('rain2.y') > 600 then
            setProperty('rain2.y', getProperty('rain2.y') - getProperty('rain2.height') * 2)
        end
    end
end

function onEvent(name, v1, v2)
    if name == 'Jack Events' then
        if v1 == 'bg1' then
            startTween('zoomin', 'game', {defaultCamZoom = 1.1, ['camGame.zoom'] = 1.1}, 1.5, {ease = 'sineOut'})
            doTweenAlpha('alphie', 'bg', 0.000001, 1.5, 'sineOut')
            startTween('camPos', 'camFollow', {y = getProperty('camFollow.y') - 100}, 1.5, {ease = 'sineOut'})
        elseif v1 == 'obj' then
            curObject = curObject + 1
            startTween('hi'..curObject, objects[curObject], {alpha = 1}, 1.5, {ease = 'sineOut'})
        elseif v1 == 'black' then
            setProperty('black.visible', true)
            for i = 1,#objects do
                setProperty(objects[i]..'.visible', false)end
            setProperty('defaultCamZoom', 1.55)
            setProperty('camFollow.y', getProperty('camFollow.y') + 100)
        elseif v1 == 'bg2' then
            setProperty('black.visible', false)
            setProperty('blackbg.visible', false)
            setProperty('rain1.visible', true)
            setProperty('rain2.visible', true)
        elseif v1 == 'wait' then
            for _, i in pairs({'rainbg', 'rain1', 'rain2'}) do
                startTween('que'.._, i, {alpha = 0.0000001}, 1.5, {ease = 'sineOut'})
            end
        elseif v1 == 'bg3' then
            setProperty('rainbg.visible', false)
            setProperty('rain1.visible', false)
            setProperty('rain2.visible', false)
            doTweenAlpha('bgback', 'bg', 0.4, 1.5, 'sineOut')
        elseif v1 == 'hop' then
            setProperty('hopscotch.visible', false)
        elseif v1 == 'blackend' then
            setProperty('black.visible', true)
            setObjectCamera('black', 'other')
            setProperty('hopscotch.visible', true)
        end
    end
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', ogOffs)
end