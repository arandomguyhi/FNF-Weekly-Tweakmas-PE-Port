function onCreatePost()
    makeLuaText('text', '')
    setTextFont('text', 'vcr.ttf')
    setTextSize('text', 32)
    screenCenter('text', 'X')
    setProperty('text.borderSize', 2)
    setProperty('text.y', 500)
    addLuaText('text')
end

function onEvent(name, v1)
    if name == 'lyric' then
	setTextString('text', v1)
	updateHitbox('text')
	screenCenter('text', 'X')
    end
end