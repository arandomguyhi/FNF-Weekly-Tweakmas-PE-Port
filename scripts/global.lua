luaDebugMode = true

initSaveData('saveScore')
setDataFromSave('saveScore', 'curWeek', getDataFromSave('saveScore', 'curWeek'))
local curWeek = getDataFromSave('saveScore', 'curWeek')

-- leave me alone ok, i know this is dumb :sob:
for i = 1,2 do
	setDataFromSave('saveScore', 'tweakmas'..i, getDataFromSave('saveScore', 'tweakmas'..i))
	setDataFromSave('saveScore', 'bestScorie'..i, getDataFromSave('saveScore', 'bestScorie'..i))
end

flushSaveData('saveScore')

function onCreate()
	for i,k in pairs({'tweakmas', 'bestScorie'}) do
		if getDataFromSave('saveScore', k..i) == nil then
			setDataFromSave('saveScore', k..i, 0)
		end
	end
end

function onCreatePost()
    runHaxeCode([[
	createGlobalCallback('snapCamFollowToPos', function(xpos:Float, ypos:Float, ?isForced:Bool) {
	    game.camGame.scroll.x = xpos - (FlxG.width / 2);
	    game.camGame.scroll.y = ypos - (FlxG.height / 2);
	    game.camFollow.setPosition(xpos, ypos);
	    game.isCameraOnForcedPos = isForced;
	});
    ]])
end

function onEvent(name, value1, value2)
    if name == 'Camera Zoom' then
		local val1 = tonumber(value1)

		local targetZoom = getProperty('defaultCamZoom') * val1
		if value2 ~= '' then
	   		local split = stringSplit(value2, ',')
			local duration = 0
	    	local leEase = 'linear'
	    	if split[1] ~= nil then duration = tonumber(split[1]) end
	    	if split[2] ~= nil then leEase = split[2] end

	    	if duration > 0 then
				startTween('camTween', 'game', {['camGame.zoom'] = targetZoom}, duration, {ease = 'circOut'})
	    	else
				setProperty('defaultCamZoom', targetZoom)
	    	end
		end
		setProperty('defaultCamZoom', targetZoom)
    end

    if name == 'HUD Fade' then
		local leAlpha = tonumber(value1)
		local duration = tonumber(value2)

		if duration > 0 then
	    	startTween('camHUDAlphaTween', 'camHUD', {alpha = leAlpha}, duration, {ease = 'linear'})
		else
	    	setProperty('camHUD.alpha', leAlpha)
		end
    end
end

function onEndSong()
    if isStoryMode then
		setPropertyFromClass('states.addons.transition.FlxTransitionableState', 'skipNextTransIn', false)
		setPropertyFromClass('states.addons.transition.FlxTransitionableState', 'skipNextTransOut', false)

		setDataFromSave('saveScore', 'tweakmas'..curWeek, getDataFromSave('saveScore', 'tweakmas'..curWeek) + score)

		if getPropertyFromClass('states.PlayState', 'storyPlaylist.length') <= 1 then
	    	callMethodFromClass('backend.Highscore', 'saveScore', {songName, score, difficulty, rating})

			if getDataFromSave('saveScore', 'tweakmas'..curWeek) > getDataFromSave('saveScore', 'bestScorie'..curWeek) then
				setDataFromSave('saveScore', 'bestScorie'..curWeek, getDataFromSave('saveScore', 'tweakmas'..curWeek))
				flushSaveData('saveScore')
			end

	    	setDataFromSave('mainMenu', 'wasStoryMode', true)
	    	loadSong('Main Menu')

	    	return Function_Stop
		end
    end
    return Function_Continue
end