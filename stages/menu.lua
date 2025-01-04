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
	songs = {'Frostburn', 'Park', 'Hot Drop', 'Final Wager', 'Dead End', 'Dying Wish'},
	icons = {'king', 'picopark', 'sunspot', 'hr', 'employees', 'tf2'}
    }
}

luaDebugMode = true
function onCreate()
    setProperty('skipCountdown', true)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

    makeLuaSprite('bg', assetPath..'bg', -7, -4)
    setObjectCamera('bg', 'other')
    addLuaSprite('bg', true)

    makeLuaText('tweakTxt', 'TWEAKMAS 0', 0, 1080, 40)
    setTextSize('tweakTxt', 27)
    setTextFont('tweakTxt', 'VCR OSD Mono')
    setTextColor('tweakTxt', 'ffffff')
    setObjectCamera('tweakTxt', 'other')
    addLuaText('tweakTxt', true)

    makeLuaSprite('weeklogo', assetPath..'logos/placeholder', 173, 213)
    setObjectCamera('weeklogo', 'other')
    addLuaSprite('weeklogo', true)

    makeAnimatedLuaSprite('norbert', assetPath..'norbert', 840, 260)
    addAnimationByPrefix('norbert', 'intro', 'intro', 24, false)
    addAnimationByPrefix('norbert', 'idle', 'idle', 24, false)
    addAnimationByPrefix('norbert', 'start', 'start', 24, false)
    setProperty('norbert.visible', false)
    setObjectCamera('norbert', 'other')
    addLuaSprite('norbert', true)

    runTimer('norbertIntro', 0.5)
    function onTimerCompleted(tag) if tag == 'norbertIntro' then
	setProperty('norbert.visible', true)
	setProperty('norbert.offset.x', 1393) setProperty('norbert.offset.y', 154)
	playAnim('norbert', 'intro')
    end end

    makeLuaSprite('bar') makeGraphic('bar', 1233, 141, '000000')
    screenCenter('bar', 'X')
    setProperty('bar.y', 553.45)
    setObjectCamera('bar', 'other')
    addLuaSprite('bar', true)

    makeLuaText('newsTxt1', 'BREAKING NEWS!!! BREAKING NEWS!!! ', 0, 1060, 562)
    setTextSize('newsTxt1', 40)
    setTextFont('newsTxt1', 'VCR OSD Mono')
    setTextColor('newsTxt1', 'ffffff')
    setObjectCamera('newsTxt1', 'other')
    addLuaText('newsTxt1', true)
    startTween('newsTween', 'newsTxt1', {x = -734}, 4.25, {type = 'looping'})

    makeLuaText('newsTxt2', 'BREAKING NEWS!!! BREAKING NEWS!!! ', 0, 40, 562)
    setTextSize('newsTxt2', 40)
    setTextFont('newsTxt2', 'VCR OSD Mono')
    setTextColor('newsTxt2', 'ffffff')
    setProperty('newsTxt2.x', getProperty('newsTxt1.x'))
    setObjectCamera('newsTxt2', 'other')
    addLuaText('newsTxt2', true)
    startTween('newsnewsTween', 'newsTxt2', {x = -734}, 4.25, {startDelay = 2, type = 'looping'})

    makeLuaSprite('border', assetPath..'border', -19, -23)
    setObjectCamera('border', 'other')
    addLuaSprite('border', true)

    makeAnimatedLuaSprite('fwlogo', assetPath..'weeklylogo', 17.4, 498)
    addAnimationByPrefix('fwlogo', 'idle', 'logobop0', 24, false)
    setObjectCamera('fwlogo', 'other')
    addLuaSprite('fwlogo', true)

    for i = 1, #options do
	makeAnimatedLuaSprite('button'..i, assetPath..'button_'..options[i])
	addAnimationByPrefix('button'..i, 'idle', options[i]..'0', 24, false)
	addAnimationByPrefix('button'..i, 'hover', options[i]..' hover0', 24, false)
	setProperty('button'..i..'.x', 262 * i - 214)
	setProperty('button'..i..'.y', 41)
	setProperty('button'..i..'.ID', i)
	setObjectCamera('button'..i, 'other')
	addLuaSprite('button'..i, true)
	table.insert(optionGrp, 'button'..i)
    end

    setProperty(optionGrp[4]..'.x', 60)
    setProperty(optionGrp[4]..'.y', 250)
    setProperty(optionGrp[5]..'.x', 729)
    setProperty(optionGrp[5]..'.y', getProperty(optionGrp[4]..'.y'))
    setProperty(optionGrp[6]..'.x', 1046)
    setProperty(optionGrp[6]..'.y', 491)

    changeWeek()
end

function onCreatePost()
    for _, i in pairs({'camGame', 'camHUD', 'camOther'}) do
	setProperty(i..'.width', getProperty(i..'.width') - 10)
	setProperty(i..'.x', getProperty(i..'.x') + 20)
	setProperty(i..'.zoom', getProperty(i..'.zoom') + 0.015)
    end
    setProperty('camGame.visible', false) setProperty('camHUD.visible', false)
end

function onBeatHit()
    playAnim('fwlogo', 'idle', true)

    if norbertcanIdle then
	setProperty('norbert.offset.x', 0) setProperty('norbert.offset.y', 0)
	playAnim('norbert', 'idle', true)
    end
end

function onUpdate()
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
    debugPrint(curWeek)

    if curWeek > #loadedWeeks then
	curWeek = 1
    elseif curWeek < 1 then
	curWeek = #loadedWeeks end

    loadGraphic('weeklogo', assetPath..'logos/'..loadedWeeks[curWeek][2], false)
end

local selectedWeek = false
function selectWeek()
    local weekToPlay = weekList['tweakmas'..curWeek]
    loadWeek(weekToPlay.songs, -1)
end

function mouseOverlaps(obj, camera)
    local mX, mY = getMouseX(camera or 'camHUD') + getProperty(camera..'.scroll.x'), getMouseY(camera or 'camHUD') + getProperty(camera..'.scroll.y')
    local x, y = getProperty(obj..'.x'), getProperty(obj..'.y')
    local width, height = getProperty(obj..'.width'), getProperty(obj..'.height')
    return (mX > x) and (mX < x + width) and (mY > y) and (mY < y + height)
end