local path = '../TweakAssets/stages/Tweakmas/First Edition/grinch/'

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', path..'bg')
    updateHitbox('bg')
    addLuaSprite('bg')
end

function onCreatePost()
    snapCamFollowToPos(getProperty('bg.x') + (getProperty('bg.width') / 2), getProperty('bg.y') + (getProperty('bg.width') / 2), false)

    setProperty('cardbg.x', getProperty('cardbg.x') + 160)
    setProperty('cardtext.x', getProperty('cardtext.x') + 160)

    for i = 0, 3 do
	if not middlescroll then
	    setPropertyFromGroup('opponentStrums', i, 'x', getPropertyFromGroup('opponentStrums', i, 'x') + 80)
	    setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - 60)
	end
    end

    makeLuaSprite('leftbar') makeGraphic('leftbar', 160, 720, '000000')
    setObjectCamera('leftbar', 'camOther')
    addLuaSprite('leftbar', true)

    makeLuaSprite('rightbar', nil, screenWidth - 160) makeGraphic('rightbar', 162, 720, '000000')
    setObjectCamera('rightbar', 'camOther')
    addLuaSprite('rightbar', true)
end