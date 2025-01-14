local path = '../TweakAssets/stages/Tweakmas/Third Edition/femtanyl/'

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', path..'femtanylBG')
    updateHitbox('bg')
    addLuaSprite('bg')

    makeAnimatedLuaSprite('idk', path..'zombae', 820, 545)
    addAnimationByPrefix('idk', 'idle', 'zombae0', 24, true)
    updateHitbox('idk')
    addLuaSprite('idk')
end

function onCreatePost()
    snapCamFollowToPos(881, 575, true)

    setProperty('iconP1.iconOffsets[1]', 35)
    setProperty('iconP2.iconOffsets[1]', 15)
end

function onStepHit()
    if curStep == 1280 then
        setProperty('dad.idleSuffix', '-alt')
        altTime = true

        makeVideoSprite('ohyeah', 'femtanyl2', 0, 0, 'game', true)
        setGraphicSize('ohyeah', screenWidth, screenHeight * 1.25, false)
        --screenCenter('ohyeah')
        setProperty('ohyeah.x', getProperty('ohyeah.x') + 250)
        setProperty('ohyeah.y', getProperty('ohyeah.y') + 200)
        --setBlendMode('ohyeah', 'subtract')
    elseif curStep == 1536 then
        setProperty('camGame.visible', false)
        setProperty('camHUD.visible', false)
    end
end

function opponentNoteHit(id,noteData)
    if altTime then
        playAnim('dad', getProperty('singAnimations')[noteData+1]..'-alt', true)
    end
end