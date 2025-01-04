local path = '../TweakAssets/stages/Tweakmas/Second Edition/tf2/'

function onCreate()
    makeAnimatedLuaSprite('fireBG', path..'FireBG', 125, -100)
    addAnimationByPrefix('fireBG', 'Idle', 'Idle', 17, true)
    playAnim('fireBG', 'Idle')

    makeLuaSprite('bg', path..'bg') addLuaSprite('bg')
    addLuaSprite('fireBG')
    makeLuaSprite('bombCart', path..'BombCartProm', 450, 640) addLuaSprite('bombCart')
end

function onCreatePost()
    snapCamFollowToPos(1000, 565, true)
    setObjectOrder('dadGroup', getObjectOrder('gfGroup'))

    for i = 0,3 do
	setProperty('playerStrums.members['..i..'].x', 412 + (112 * i))
    end
end

function onUpdatePost()
    for i = 0,3 do setPropertyFromGroup('opponentStrums', i, 'alpha', 0) end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'Duet' then
	playAnim('gf', getProperty('singAnimations')[noteData+1], true)
	setProperty('gf.holdTimer', 0)
    end
end