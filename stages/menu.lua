-- HEY, WHAT U LOOKIN FOR?????????????????????
-- this still in work, come back in tweak 3!!

local assetPath = '../TweakAssets/menus/mainmenu/'

local canClick = true
local norbertcanIdle = false -- this is maybe dumb, but fuck it

local optionGrp = {}
local options = {
    'freeplay',
    'credits',
    'options',
    'left',
    'right',
    'play'
}

local curWeek = 1
local loadedWeeks = {
    {'tweakmas1', 'TheTweakBeforeChristmas'},
    {'tweakmas2', 'SquadUp'}
}

local weekList = { -- everything in order
    ['tweakmas1'] = {
	    songs = {'Little Love', 'Hook To Grind', 'Team Effort', 'Garlic Soul', 'The Lie', 'A Regular Christmas Song'},
	    icons = {'charlie', 'futaba', 'alph', 'grinch', 'simian', 'quillgin'}
    },
    ['tweakmas2'] = {
	    songs = {'Frostburn', 'Hot Drop'},
	    icons = {'king', 'picopark', 'sunspot', 'hr', 'employees', 'tf2'}
    }
}

local grpSongs = {}
local iconArray = {}

local curSelected = 0

local isMMenu = true
local isFreeplay = false

-- saving the assets in tables to be easier to return them
local titleAssets = {} -- not sure if i'm doing title state, but i'll let it here
local mainMenuAssets = {}
local freeplayAssets = {}

initSaveData('mainMenu')
setDataFromSave('mainMenu', 'wasStoryMode', true)
setDataFromSave('mainMenu', 'wasFreeplay', false)
flushSaveData('mainMenu')

local wasStoryMode = getDataFromSave('mainMenu', 'wasStoryMode')

luaDebugMode = true
function onCreate()
    setProperty('skipCountdown', true)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

    ---------------- MAIN MENU ----------------
    makeLuaSprite('bg', assetPath..'bg', -7, -4)
    setObjectCamera('bg', 'other')
    addLuaSprite('bg', true)
    table.insert(mainMenuAssets, 'bg')

    makeLuaText('tweakTxt', 'TWEAKMAS 0', 0, 1080, 40)
    setTextSize('tweakTxt', 27)
    setTextFont('tweakTxt', 'vcr.ttf')
    setProperty('tweakTxt.borderSize', 0)
    setObjectCamera('tweakTxt', 'other')
    addLuaText('tweakTxt', true)
    table.insert(mainMenuAssets, 'tweakTxt')

    makeLuaText('weekScore', 'SCORE:0', 0, 850, 0)
    setTextSize('weekScore', 27)
    setTextFont('weekScore', 'vcr.ttf')
    setProperty('weekScore.borderSize', 0)
    setProperty('weekScore.y', getProperty('tweakTxt.y'))
    setObjectCamera('weekScore', 'other')
    addLuaText('weekScore', true)
    table.insert(mainMenuAssets, 'weekScore')

    makeLuaSprite('weeklogo', assetPath..'logos/placeholder', 173, 213)
    setObjectCamera('weeklogo', 'other')
    addLuaSprite('weeklogo', true)
    table.insert(mainMenuAssets, 'weeklogo')

    makeAnimatedLuaSprite('norbert', assetPath..'norbert', 840, 260)
    addAnimationByPrefix('norbert', 'intro', 'intro', 24, false)
    addAnimationByPrefix('norbert', 'idle', 'idle', 24, false)
    addAnimationByPrefix('norbert', 'start', 'start', 24, false)
    setObjectCamera('norbert', 'other')
    addLuaSprite('norbert', true)
    table.insert(mainMenuAssets, 'norbert')

    runTimer('norbertIntro', 0.5)

    makeLuaSprite('bar') makeGraphic('bar', 1233, 141, '000000')
    screenCenter('bar', 'X')
    setProperty('bar.y', 553.45)
    setObjectCamera('bar', 'other')
    addLuaSprite('bar', true)
    table.insert(mainMenuAssets, 'bar')

    makeLuaText('newsTxt1', 'BREAKING NEWS!!! BREAKING NEWS!!! ', 0, 1060, 562)
    setTextSize('newsTxt1', 40)
    setTextFont('newsTxt1', 'VCR OSD Mono')
    setTextColor('newsTxt1', 'ffffff')
    setObjectCamera('newsTxt1', 'other')
    addLuaText('newsTxt1', true)
    startTween('newsTween', 'newsTxt1', {x = -734}, 4.25, {type = 'looping'})
    table.insert(mainMenuAssets, 'newsTxt1')

    makeLuaText('newsTxt2', 'BREAKING NEWS!!! BREAKING NEWS!!! ', 0, 40, 562)
    setTextSize('newsTxt2', 40)
    setTextFont('newsTxt2', 'VCR OSD Mono')
    setTextColor('newsTxt2', 'ffffff')
    setProperty('newsTxt2.x', getProperty('newsTxt1.x'))
    setObjectCamera('newsTxt2', 'other')
    addLuaText('newsTxt2', true)
    startTween('newsnewsTween', 'newsTxt2', {x = -734}, 4.25, {startDelay = 2, type = 'looping'})
    table.insert(mainMenuAssets, 'newsTxt2')

    makeLuaSprite('border', assetPath..'border', -19, -23)
    --setObjectCamera('border', 'other')
    addLuaSprite('border', true)
    table.insert(mainMenuAssets, 'border')

    makeAnimatedLuaSprite('fwlogo', assetPath..'weeklylogo', 17.4, 498)
    addAnimationByPrefix('fwlogo', 'idle', 'logobop0', 24, false)
    setObjectCamera('fwlogo', 'other')
    addLuaSprite('fwlogo', true)
    table.insert(mainMenuAssets, 'fwlogo')

    for i = 1, #options do
	    makeAnimatedLuaSprite('button'..i, assetPath..'button_'..options[i])
	    addAnimationByPrefix('button'..i, 'idle', options[i]..'0', 24, false)
	    addAnimationByPrefix('button'..i, 'hover', options[i]..' hover0', 24, false)
	    setProperty('button'..i..'.x', 262 * i - 218)
	    setProperty('button'..i..'.y', 41)
	    setProperty('button'..i..'.ID', i)
	    setObjectCamera('button'..i, 'other')
	    addLuaSprite('button'..i, true)

	    table.insert(optionGrp, 'button'..i)
	    table.insert(mainMenuAssets, 'button'..i)
    end

    setProperty(optionGrp[4]..'.x', 60)
    setProperty(optionGrp[4]..'.y', 250)
    setProperty(optionGrp[5]..'.x', 729)
    setProperty(optionGrp[5]..'.y', getProperty(optionGrp[4]..'.y'))
    setProperty(optionGrp[6]..'.x', 1046)
    setProperty(optionGrp[6]..'.y', 491)


    for _, i in pairs(mainMenuAssets) do
	    if getDataFromSave('mainMenu', 'wasStoryMode') then
            setProperty(i..'.visible', true)
            setProperty('norbert.visible', false)

            changeWeek()
            canClick = true
	    else
	        cancelTimer('norbertIntro')
	        setProperty(i..'.visible', false)
	        canClick = false
	    end
    end
    

    ---------------- FREEPLAY ----------------
    makeLuaSprite('freeplaybg', 'menuDesat')
    screenCenter('freeplaybg')
    setObjectCamera('freeplaybg', 'other')
    addLuaSprite('freeplaybg')
    table.insert(freeplayAssets, 'freeplaybg')

    for i = 1,2 do
        cu = weekList['tweakmas'..i].songs
        bunda = weekList['tweakmas'..i].icons
        for a = 1,#cu do table.insert(grpSongs, cu[a]) end
        for a = 1,#bunda do table.insert(iconArray, bunda[a])end
    end

    for i = 1, #grpSongs do
	    createInstance('songText'..i, 'objects.Alphabet', {75, (10*i)+175, grpSongs[i], true, false})
	    setProperty('songText'..i..'.isMenuItem', true)
	    setProperty('songText'..i..'.changeX', false)
	    setProperty('songText'..i..'.targetY', i)
	    setObjectCamera('songText'..i, 'other')
	    addInstance('songText'..i)

	    if getProperty('songText'..i..'.width') > 980 then
	        local textScale = 980 / getProperty('songText'..i..'.width')
	        setProperty('songText'..i..'.scale.x', textScale)
	    end

	    createInstance('icon'..i, 'objects.HealthIcon', {iconArray[i]})
	    runHaxeCode("getVar('icon"..i.."').sprTracker = getVar('songText"..i.."');")
	    setObjectCamera('icon'..i, 'other')
	    addInstance('icon'..i)

        table.insert(freeplayAssets, 'songText'..i)
        table.insert(freeplayAssets, 'icon'..i)
    end

    makeLuaText('scoreText', '', 0, screenWidth * 0.7, 5)
    setTextSize('scoreText', 32)
    setTextFont('scoreText', 'vcr.ttf')
    setProperty('scoreText.borderSize', 0)
    setObjectCamera('scoreText', 'other')
    table.insert(freeplayAssets, 'scoreText')

    makeLuaSprite('scoreBG', nil, getProperty('scoreText.x') - 6, 0)
    makeGraphic('scoreBG', 1, 66, '000000')
    setProperty('scoreBG.alpha', 0.6)
    setObjectCamera('scoreBG', 'other')
    addLuaSprite('scoreBG')
    table.insert(freeplayAssets, 'scoreBG')

    makeLuaText('diffText', '< NORMAL >', 0, getProperty('scoreText.x'), getProperty('scoreText.y') + 36)
    setTextSize('diffText', 24)
    setTextFont('diffText', 'vcr.ttf')
    setProperty('diffText.borderSize', 0)
    setObjectCamera('diffText', 'other')
    addLuaText('diffText')
    table.insert(freeplayAssets, 'diffText')

    addLuaText('scoreText')

    if getDataFromSave('mainMenu', 'wasFreeplay') then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
        for _, i in pairs(freeplayAssets) do
            setProperty(i..'.visible', true) end
        changeSelection()
    else
        for _, i in pairs(freeplayAssets) do
            setProperty(i..'.visible', false) end
    end

    makeLuaSprite('transitionSpr')
    makeGraphic('transitionSpr', screenWidth, screenHeight, '000000')
    setObjectCamera('transitionSpr', 'other')
    setProperty('transitionSpr.alpha', 0.001)
    addLuaSprite('transitionSpr', true)
end

function onCreatePost()
    setProperty('camGame.visible', false) setProperty('camHUD.visible', false)
end

function onBeatHit()
    playAnim('fwlogo', 'idle', true)

    if norbertcanIdle then
	    setProperty('norbert.offset.x', 0) setProperty('norbert.offset.y', 0)
	    playAnim('norbert', 'idle', true)
    end
end

local holdTime = 0

function onUpdate()
    if isMMenu then
        if getProperty('norbert.animation.curAnim.name') == 'intro' and getProperty('norbert.animation.curAnim.finished') then
	        norbertcanIdle = true
        end

        for _, i in pairs(optionGrp) do
	        if mouseOverlaps(i, 'camOther') then
	            playAnim(i, 'hover')
	            if mouseClicked() and canClick then selectOption(getProperty(i..'.ID')) end
	        else
	            playAnim(i, 'idle')
	        end
        end
    end

    if isFreeplay then
        if keyJustPressed('up') then
            changeSelection(-1)
            holdTime = 0
        elseif keyJustPressed('down') then
            changeSelection(1)
            holdTime = 0
        end

        if keyboardJustPressed('SPACE') then
            loadSong(grpSongs[curSelected+1])
        elseif getProperty('controls.BACK') then
            playSound('cancelMenu')

            startTween('transIn', 'transitionSpr', {alpha = 1}, 0.25, {})
            runTimer('loadMMenu', 1)
        end
    end
end

function selectOption(id)
    canClick = false
    id = options[id]

    if id == 'play' then
	    selectWeek()
	    playSound('confirmMenu')
	    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)

	    norbertcanIdle = false
	    setProperty('norbert.offset.x', 77) setProperty('norbert.offset.y', 11)
	    playAnim('norbert', 'start')
    elseif id == 'freeplay' then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
        startTween('transIn', 'transitionSpr', {alpha = 1}, 0.25, {})
        runTimer('loadFreeplay', 1)
    elseif id == 'left' then
	    changeWeek(-1)
	    canClick = true
    elseif id == 'right' then
	    changeWeek(1)
	    canClick = true
    end
end

function changeWeek(change) if change == nil then change = 0 end
    curWeek = curWeek + change

    if curWeek > #loadedWeeks then
	    curWeek = 1
    elseif curWeek < 1 then
	    curWeek = #loadedWeeks end

    loadGraphic('weeklogo', assetPath..'logos/'..loadedWeeks[curWeek][2], false)

    setTextString('weekScore', 'SCORE:'..getDataFromSave('saveScore', 'bestScorie'..curWeek))
    setTextString('tweakTxt', 'TWEAKMAS '..curWeek)

    setDataFromSave('saveScore', 'curWeek', curWeek)
end

local selectedWeek = false

function selectWeek()
    local weekToPlay = weekList['tweakmas'..curWeek]
    loadWeek(weekToPlay.songs, -1)

    setDataFromSave('saveScore', 'tweakmas'..curWeek, 0)
end

function changeSelection(change, playSoundie)
    if change == nil then change = 0 end
    if playSoundie == nil then playSoundie = true end

    curSelected = callMethodFromClass('flixel.math.FlxMath', 'wrap', {curSelected + change, 0, #grpSongs - 1})

    if playSoundie then
        playSound('scrollMenu', 0.4) end

    local bullShit = 0

    for _, i in pairs(iconArray) do
        setProperty('icon'.._..'.alpha', 0.6)
    end
    setProperty('icon'.. curSelected+1 ..'.alpha', 1)

    for _, item in pairs(grpSongs) do
        setProperty('songText'.._..'.targetY', bullShit - curSelected)
        bullShit = bullShit + 1

        setProperty('songText'.._..'.alpha', 0.6)

        if getProperty('songText'.._..'.targetY') == 0 then
            setProperty('songText'.._..'.alpha', 1)
        end
    end

    local bestScore = callMethodFromClass('backend.Highscore', 'getScore', {grpSongs[curSelected+1], 0})
    local bestRating = callMethodFromClass('backend.Highscore', 'getRating', {grpSongs[curSelected+1], 0})
    local ratingSplit = string.sub(math.floor((bestRating*10000)), 1, 2)..'.'..string.sub(math.floor((bestRating*10000)), 2, 3)

    setTextString('scoreText', 'PERSONAL BEST: '..bestScore..' ('.. ratingSplit ..'%)')
    positionHighscore()
end

function positionHighscore()
    setProperty('scoreText.x', screenWidth - getProperty('scoreText.width') - 6)

    setProperty('scoreBG.scale.x', screenWidth - getProperty('scoreText.x') + 6)
    setProperty('scoreBG.x', screenWidth - (getProperty('scoreBG.scale.x') / 2))
    setProperty('diffText.x', tonumber(getProperty('scoreBG.x') + (getProperty('scoreBG.width') / 2)))
    setProperty('diffText.x', getProperty('diffText.x') - (getProperty('diffText.width') / 2))
end

function onTimerCompleted(tag)
    if tag == 'norbertIntro' then
	    setProperty('norbert.visible', true)
	    setProperty('norbert.offset.x', 1393) setProperty('norbert.offset.y', 154)
	    playAnim('norbert', 'intro')
    end

    if tag == 'loadMMenu' then
        isFreeplay = false
        
        isMMenu = true
        canClick = true

        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
        
        setDataFromSave('mainMenu', 'wasStoryMode', true)
        setDataFromSave('mainMenu', 'wasFreeplay', false)
        startTween('transOut', 'transitionSpr', {alpha = 0.001}, 0.25, {startDelay = 0.15})
        
        for _, i in pairs(freeplayAssets) do
            setProperty(i..'.visible', false) end
        for _, i in pairs(mainMenuAssets) do
            setProperty(i..'.visible', true) end
        curWeek = 1
        changeWeek()
    end

    if tag == 'loadFreeplay' then
        isFreeplay = true
        isMMenu = false

        setDataFromSave('mainMenu', 'wasStoryMode', false)
        setDataFromSave('mainMenu', 'wasFreeplay', true)
        startTween('transOut', 'transitionSpr', {alpha = 0.001}, 0.25, {startDelay = 0.15})

        for _, i in pairs(freeplayAssets) do
            setProperty(i..'.visible', true) end
        for _, i in pairs(mainMenuAssets) do
            setProperty(i..'.visible', false) end
        curSelected = 0
        changeSelection()
    end
end

function mouseOverlaps(obj, camera)
    local mX, mY = getMouseX(camera or 'camHUD') + getProperty(camera..'.scroll.x'), getMouseY(camera or 'camHUD') + getProperty(camera..'.scroll.y')
    local x, y = getProperty(obj..'.x'), getProperty(obj..'.y')
    local width, height = getProperty(obj..'.width'), getProperty(obj..'.height')
    return (mX > x) and (mX < x + width) and (mY > y) and (mY < y + height)
end