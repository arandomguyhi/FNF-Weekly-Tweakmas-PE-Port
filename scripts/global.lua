luaDebugMode = true

initSaveData('saveScore')
setDataFromSave('saveScore', 'curWeek', getDataFromSave('saveScore', 'curWeek'))
local curWeek = getDataFromSave('saveScore', 'curWeek')

-- leave me alone ok, i know this is dumb :sob:
for i = 1,3 do
	setDataFromSave('saveScore', 'tweakmas'..i, 0+(getDataFromSave('saveScore', 'tweakmas'..i) == nil and 0 or getDataFromSave('saveScore', 'tweakmas'..i)))
	setDataFromSave('saveScore', 'bestScorie'..i, 0+(getDataFromSave('saveScore', 'bestScorie'..i) == nil and 0 or getDataFromSave('saveScore', 'bestScorie'..i)))
end
flushSaveData('saveScore')

initSaveData('mainMenu')
setDataFromSave('mainMenu', 'wasStoryMode', getDataFromSave('mainMenu', 'wasStoryMode') == nil and true or getDataFromSave('mainMenu', 'wasStoryMode')) -- repeating the dumb logic :fire:
setDataFromSave('mainMenu', 'wasFreeplay', getDataFromSave('mainMenu', 'wasFreeplay') == nil and false or getDataFromSave('mainMenu', 'wasFreeplay'))
flushSaveData('mainMenu')

precacheImage('noteSplashes/noteSplashes')

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

function onSpawnNote(i)
    setPropertyFromGroup('notes', i, 'noteSplashData.useRGBShader', false)
end

function onEvent(name, value1, value2)
	if name == 'Set Cam Zoom' then
		setProperty('defaultCamZoom', tonumber(value1))
	end
	
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
	if not isStoryMode then
		callMethodFromClass('backend.Highscore', 'saveScore', {songName, score, difficulty, rating})
		setDataFromSave('mainMenu', 'wasFreeplay', true)
		loadSong('Main Menu')

		return Function_Stop
	end

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