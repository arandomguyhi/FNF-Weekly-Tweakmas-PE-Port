local path = '../TweakAssets/stages/Tweakmas/Third Edition/femtanyl/'
local videoPath = callMethodFromClass('backend.Paths', 'video', {'femtanyl2'})

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', path..'femtanylBG')
    updateHitbox('bg')
    addLuaSprite('bg')

    makeAnimatedLuaSprite('idk', path..'zombae', 820, 545)
    addAnimationByPrefix('idk', 'idle', 'zombae0', 24, true)
    updateHitbox('idk')
    addLuaSprite('idk')

    if buildTarget ~= 'windows' then
        createInstance('backVideo', 'backend.VideoSpriteManager', {0, 0, 1280, screenHeight*1.25})
		setObjectCamera('backVideo', 'camGame')
        setObjectOrder('backVideo', getObjectOrder('dadGroup'))
        screenCenter('backVideo')
        setProperty('backVideo.x', getProperty('backVideo.x') + 250)
        setProperty('backVideo.y', getProperty('backVideo.y') + 200)
        setBlendMode('backVideo', 'subtract')
		addInstance('backVideo')
    end
end

function onCreatePost()
    snapCamFollowToPos(881, 575, true)

    setProperty('iconP1.iconOffsets[1]', 35)
    setProperty('iconP2.iconOffsets[1]', 15)
end

function onStepHit()
    if curStep == 1280 then
        altTime = true

        if buildTarget == 'windows' then
            makeVideoSprite('ohyeah', 'femtanyl2', 0, 0, 'game', true)
            setObjectOrder('ohyeah', getObjectOrder('dadGroup'))
            scaleObject('ohyeah', 2, 2)
            screenCenter('ohyeah')
            setProperty('ohyeah.x', getProperty('ohyeah.x') - 220)
            setProperty('ohyeah.y', getProperty('ohyeah.y')-25)
            setBlendMode('ohyeah', 'subtract')
        else
            callMethod('backVideo.startVideo', {videoPath, true})
        end
    elseif curStep == 1536 then
        setProperty('camGame.visible', false)
        setProperty('camHUD.visible', false)
    end
end

function opponentNoteHit(id,noteData)
    if altTime then
        playAnim('dad', getProperty('singAnimations')[noteData+1]..'-alt', true)
        setProperty('dad.holdTimer', 0)
    end
end