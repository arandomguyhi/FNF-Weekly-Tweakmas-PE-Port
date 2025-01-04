local path = '../TweakAssets/stages/Tweakmas/First Edition/persona/dialogue/'

local dialogue = {
    {'joker', '0', 'So Futaba, what did Sojiro get you today?'},
    {'futaba', '2', 'Sojiro? You mean Santa, right?'},
    {'joker', '1', '...oh.'},
    {'futaba', '1', 'Be for realz, Joker! Who do you think delivers the presents?\nEats the cookies? Drinks the milk? Mwehehehe!!'},
    {'futaba', '0', 'These phenomena only have one real answer and you know it.'},
    {'joker', '1', "You can't be serious... Listen, Santa isn't--"},
    {'futaba', '0', "Nope! Don't even try it! Not listeniiiing!"},
    {'joker', '2', 'Oh boy...'}
}

local dialogueIndex = 0
local prevChar = nil
local isDialogueFinished = false

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg') makeGraphic('bg', screenWidth + 2, screenHeight + 2, '000000')
    setProperty('bg.alpha', 0.5)
    setObjectCamera('bg', 'camOther')
    addLuaSprite('bg')

    makeLuaSprite('portrait', nil, 50, 330)
    setObjectCamera('portrait', 'camOther')
    addLuaSprite('portrait')

    makeLuaSprite('bubble', nil, 130, 410)
    setObjectCamera('bubble', 'camOther')
    addLuaSprite('bubble')

    makeLuaText('text', '', 0, getProperty('bubble.x') + 310, getProperty('bubble.y') + 160)
    setTextFont('text', 'Arsenal-Bold.ttf')
    setTextSize('text', 22)
    setTextAlignment('text', 'left')
    setObjectCamera('text', 'camOther')
    addLuaText('text')

    playSound('personaloop', 1, 'diaSong')
end

function onStartCountdown()
    if not allowCountdown then
	if not isDialogueFinished then
	    nextDialogue() end
	return Function_Stop
    end
    return Function_Continue
end

function onUpdatePost()
    if (keyboardJustPressed('ENTER') or touchedScreen()) and not isDialogueFinished then
	playSound('personasfx')
	nextDialogue()
    end
end

function nextDialogue()
    dialogueIndex = dialogueIndex + 1
    if dialogueIndex > #dialogue then
	endDialogue()
	return
    end

    local curDialogue = dialogue[dialogueIndex]

    loadGraphic('portrait', path..curDialogue[1]..curDialogue[2], false)
    setGraphicSize('portrait', getProperty('portrait.width') * 1.2, getProperty('portrait.height') * 1.2, false)

    if prevChar ~= curDialogue[1] then
	loadGraphic('bubble', path..'dialoguebox_'..curDialogue[1], false)
	setGraphicSize('bubble', getProperty('bubble.width') * 0.75, getProperty('bubble.height') * 0.75, false)
    end

    setTextString('text', curDialogue[3])

    prevChar = curDialogue[1]
end

function endDialogue()
    if isDialogueFinished then return end

    isDialogueFinished = true

    allowCountdown = true startCountdown()
    stopSound('diaSong')
    killAllObjects()
end

function killAllObjects()
    removeLuaSprite('bg')
    removeLuaSprite('portrait')
    removeLuaSprite('bubble')
    removeLuaText('text')
end

-- this worked somehow lol
function touchedScreen()
    local mX, mY = getMouseX('camOther') + getProperty('camOther.scroll.x'), getMouseY('camOther') + getProperty('camOther.scroll.y')
    local x, y = getProperty('camOther.x'), getProperty('camOther.y')
    return mouseClicked() and (mX > x) and (mX < x + screenWidth) and (mY > y) and (mY < y + screenHeight)
end