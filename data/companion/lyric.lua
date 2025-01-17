function onCreatePost()
    makeLuaText('text1', '')
    setObjectCamera('text1', 'other')
    setTextFont('text1', 'vcr.ttf')
    setTextSize('text1', 32)
    screenCenter('text1', 'X')
    setProperty('text1.borderSize', 2)
    setProperty('text1.y', 450)
    addLuaText('text1')

    makeLuaText('text2', '')
    setObjectCamera('text2', 'other')
    setTextFont('text2', 'vcr.ttf')
    setTextSize('text2', 32)
    screenCenter('text2', 'X')
    setProperty('text2.borderSize', 2)
    setProperty('text2.y', 500)
    addLuaText('text2')
end

function onEvent(eventName, value1, value2)
    if eventName == 'lyric' then
        setTextString('text1', value1)
        setTextString('text2', value2)
        screenCenter('text1', 'X')
        screenCenter('text2', 'X')

        if value2 == '' then setProperty('text1.y', 500)
        else setProperty('text1.y', 450) end
    end
end