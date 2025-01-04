local path = '../TweakAssets/stages/Tweakmas/Second Edition/fart/'

function onCreate()
    makeLuaSprite('bg', path..'bg')
    scaleObject('bg', 1.5, 1.5)
    addLuaSprite('bg')

    makeAnimatedLuaSprite('jonesy', path..'jonesy', 100, 400)
    addAnimationByPrefix('jonesy', 'idle', 'idle', 12, true)
    addAnimationByPrefix('jonesy', 'look', 'look', 12, true)
    playAnim('jonesy', 'idle')
    addLuaSprite('jonesy')

    makeLuaText('you', 'YOU', 0, 275, 300)
    setTextFont('you', 'vcr.ttf')
    setTextSize('you', 50)
    setProperty('you.borderSize', 3)
    setProperty('you.alpha', 0.001)
    setObjectCamera('you', 'hud')
    addLuaText('you')
end

function onCreatePost()
    setProperty('comboGroup.visible', false)
    for i = 0,3 do
	setProperty('playerStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i])
	setProperty('opponentStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i])
    end

    snapCamFollowToPos(1300, 710)
end

function onSongStart()
    scaleObject('you', 0.2, 0.2, false)

    startTween('youTween', 'you', {alpha = 1, ['scale.x'] = 1, ['scale.y'] = 1}, 1, {ease = 'expoOut', onComplete = 'youAlreadyKnow'})
    function youAlreadyKnow()
	startTween('youTween', 'you', {alpha = 0, ['scale.x'] = 0.2, ['scale.y'] = 0.2}, 1, {startDelay = 2, ease = 'expoIn'})
    end
end

function onStepHit()
    if curStep == 1616 then
	setProperty('camGame.visible', false)
	startTween('bzl', 'camHUD', {alpha = 0}, 4, {ease = 'quadInOut'})
    end
end

function onUpdate()
    setProperty('camZooming', true)
    if not getProperty('isCameraOnForcedPos') then
	setProperty('defaultCamZoom', mustHitSection and 0.6 or 0.725)
    end
end

function onUpdatePost()
    P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    setProperty('iconP1.x',P1Mult - 115)
    setProperty('iconP1.origin.x', 230)
    setProperty('iconP1.flipX',true) 

    setProperty('iconP2.x',P2Mult + 100)
    setProperty('iconP2.origin.x', -100)
    setProperty('iconP2.flipX',true)
    setProperty('healthBar.flipX',true)
end

function onEvent(name)
    if name == 'Toon Town Events' then
	playAnim('jonesy', 'look')
	triggerEvent('Play Animation', 'shocked', 'bf')
	triggerEvent('Play Animation', 'shock', 'dad')
	setProperty('isCameraOnForcedPos', true)
	startTween('camPosTween', 'camFollow', {x = 1500, y = 800}, 0.25, {ease = 'smoothStepInOut'})
	setProperty('defaultCamZoom', 0.45)
    end
end