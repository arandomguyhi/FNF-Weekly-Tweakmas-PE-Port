local path = '../TweakAssets/stages/Tweakmas/Third Edition/boss/'
local videoPath = callMethodFromClass('backend.Paths', 'video', {'indomitablecutscene'})

luaDebugMode = true
function onCreate()
    setProperty('skipCountdown', true)

    makeLuaSprite('bg', path..'background')
    setProperty('bg.x', getProperty('bg.x') - 650)
    setProperty('bg.y', getProperty('bg.y') - 100)
    addLuaSprite('bg')

    makeAnimatedLuaSprite('crowd', path..'crowd', 1375, 200)
    addAnimationByPrefix('crowd', 'idle', 'crowd', 12, true)
    playAnim('crowd', 'idle')
    addLuaSprite('crowd')

    makeLuaSprite('tables', path..'tabels')
    setProperty('tables.y', getProperty('tables.y') + 1200)
    addLuaSprite('tables')

    makeLuaSprite('lights', path..'lights')
    setProperty('lights.x', getProperty('lights.x') + 1375)
    addLuaSprite('lights')

    makeLuaSprite('overlay', path..'gradient')
    setBlendMode('overlay', 'add')
    setProperty('overlay.x', getProperty('overlay.x') - 650)
    setProperty('overlay.y', getProperty('overlay.y') - 100)
    addLuaSprite('overlay', true)

    if buildTarget ~= 'windows' then
        createInstance('rickVideo', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('rickVideo', 'camOther')
        scaleObject('rickVideo', 1.1, 1.1)
		addInstance('rickVideo')
    end
end

function onStartCountdown()
    if not played then
        played = true

        if buildTarget == 'windows' then
            makeVideoSprite('defnotarickroll', 'indomitablecutscene', 0, 0, 'other')
            scaleObject('defnotarickroll', 1.1, 1.1)
        else
            callMethod('rickVideo.startVideo', {videoPath, false})
            runHaxeCode([[
                // i hope this works
                getVar('rickVideo').finishCallback = function()
                {
                    game.camHUD.flash(FlxColor.WHITE, 2);
                    game.camGame.visible = true;
                    game.camHUD.visible = true;
                }
            ]])
        end
        runTimer('startCount', 13.5125)

        return Function_Stop
    end
    return Function_Continue
end

function onTimerCompleted(tag)
    if tag == 'startCount' then
        startCountdown()
    end
end