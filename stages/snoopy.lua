setVar('fuckmychunguslife', false)
local path = '../TweakAssets/stages/Tweakmas/First Edition/peanuts/'

function onCreate()
    makeAnimatedLuaSprite('sky', path..'sky', -50, -275)
    addAnimationByPrefix('sky', 'idle', 'sky', 3, true)
    playAnim('sky', 'idle')
    setScrollFactor('sky', 0.75, 0.75)
    addLuaSprite('sky')

    makeLuaSprite('ground', path..'ground')
    setProperty('ground.antialiasing', false)
    addLuaSprite('ground')

    makeAnimatedLuaSprite('house', path..'house', 477, 1001)
    addAnimationByPrefix('house', 'idle', 'house', 3, true)
    playAnim('house', 'idle')
    setProperty('house.antialiasing', false)
    addLuaSprite('house')

    makeLuaSprite('blackScreen')
    makeGraphic('blackScreen', screenWidth + 2, screenHeight, '000000')
    setObjectCamera('blackScreen', 'other')
    addLuaSprite('blackScreen')

    makeAnimatedLuaSprite('woodstock', path..'woodstock', 1050, 700)
    addAnimationByPrefix('woodstock', 'idle', 'idle', 24, true)
    addAnimationByPrefix('woodstock', 'flyIn', 'flyin', 24, false)
    addAnimationByPrefix('woodstock', 'flyOut', 'flyout', 24, false)
    setProperty('woodstock.antialiasing', false)
    setProperty('woodstock.visible', false)
    addLuaSprite('woodstock')

    setProperty('skipCountdown', true)
end

function onCreatePost()
    setProperty('camHUD.alpha', 0)
    snapCamFollowToPos(975, 500, true)
end

local s = 1
local woodY = 675
function onUpdate(elapsed)
    if getVar('fuckmychunguslife') then
	s = s + elapsed

	-- hard to my eyes too
	setProperty('woodstock.y', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('woodstock.y'), woodY + (math.cos(s) * 30), callMethodFromClass('flixel.math.FlxMath', 'bound', {1, 0, elapsed * 4})}))
    end
end

function onEvent(name, v1, v2)
    if name == 'LL Events' then
	if v1 == 'intro' then
	    startTween('camieFollowe', 'camFollow', {y = 1375}, 3.25, {ease = 'smoothStepInOut', startDelay = 1, onComplete = 'startTheSong'})
	    function startTheSong()
		doTweenAlpha('hudie', 'camHUD', 1, 2, 'expoOut')
		startTween('zoomin', 'game', {defaultCamZoom = 0.85, ['camGame.zoom'] = 0.85}, 1, {ease = 'expoOut'})
		setProperty('isCameraOnForcedPos', false)
	    end

	    startTween('unblackie', 'blackScreen', {alpha = 0}, 3.5, {ease = 'expoOut', startDelay = 0.5})
	    startTween('zoomin', 'game', {defaultCamZoom = 0.75, ['camGame.zoom'] = 0.75}, 3, {ease = 'smoothStepInOut', startDelay = 1})
	end

	if v1 == 'hi lil fella' then
	    setProperty('woodstock.visible', true)
	    playAnim('woodstock', 'flyIn')

	    runHaxeCode([[
		var woodstock = game.getLuaObject('woodstock');

		woodstock.animation.finishCallback = function() {
		    woodstock.animation.play('idle');
		    setVar('fuckmychunguslife', true);
		}
	    ]])
	end

	if v1 == 'bye lil fella' then
	    setVar('fuckmychunguslife', false)
	    playAnim('woodstock', 'flyOut')

	    runHaxeCode([[
		game.getLuaObject('woodstock').animation.finishCallback = function() {
		    game.getLuaObject('woodstock').visible = false;
		}
	    ]])
	end

	if v1 == 'middle camera' then
	    if v2 == 'on' then
		setProperty('isCameraOnForcedPos', true)
		callMethod('camFollow.setPosition', {975, 1350})
		startTween('zoom', 'game', {defaultCamZoom = 0.75}, 1, {ease = 'expoOut'})
	   elseif v2 == 'off' then
		setProperty('isCameraOnForcedPos', false)
		startTween('zoom', 'game', {defaultCamZoom = 0.85}, 1, {ease = 'expoOut'})
	   end
	end
    end
end