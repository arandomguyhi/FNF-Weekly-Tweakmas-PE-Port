local path = '../TweakAssets/stages/Tweakmas/Second Edition/pp/'

function onCreate()
    makeAnimatedLuaSprite('bgLeft', path..'bfleft', -2100, -90)
    setScrollFactor('bgLeft', 0.9, 0.9)
    addAnimationByPrefix('bgLeft', 'idle', 'bfleft', 24, true)

    makeLuaSprite('blackScreen', nil, -600, -290)
    makeGraphic('blackScreen', 1, 1, 'ffffff')
    scaleObject('blackScreen', 2300, 1220)
    addLuaSprite('blackScreen')

    addLuaSprite('bgLeft')
    makeLuaSprite('floor', path..'floor', -409.2, -54.45) addLuaSprite('floor')
    makeAnimatedLuaSprite('bgRight', path..'bgright', 954, -1) addAnimationByPrefix('bgRight', 'idle', 'bgright', 24, true)
    addLuaSprite('bgRight')
    makeAnimatedLuaSprite('gfPark', path..'gfpark', 476, -67) addAnimationByPrefix('gfPark', 'idle', 'idle', 24, true)
    addLuaSprite('gfPark')
end

function onCreatePost()
    snapCamFollowToPos(585, 200)
end