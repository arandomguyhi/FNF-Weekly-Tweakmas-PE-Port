local intensity = 15 -- maybe ill do a setVar instead later
local animIndex = {{-1, 0}, {0, 1}, {0, -1}, {1, 0}}

setVar('playerSing', true)
setVar('opponentSing', true)

function onUpdate()
    if getProperty('isCameraOnForcedPos') then return end

    if callMethod('gf.exists', {''}) then -- i forgot gf is null in some songs
	gfCamX = getMidpointX('gf') + getProperty('gf.cameraPosition[0]')
	gfCamY = getMidpointY('gf') + getProperty('gf.cameraPosition[1]')
    end

    dadCamX = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
    dadCamY = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
    bfCamX = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]')
    bfCamY = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')

    for i = 0, 3 do
	if (mustHitSection and getVar('playerSing') or getVar('opponentSing')) and stringStartsWith(getProperty(((gfSection and 'gf') or mustHitSection and 'boyfriend' or 'dad')..'.animation.curAnim.name'), getProperty('singAnimations')[i+1]) then
	    setProperty('camFollow.x', ((gfSection and gfCamX) or mustHitSection and bfCamX or dadCamX) + animIndex[i+1][1] * intensity)
	    setProperty('camFollow.y', ((gfSection and gfCamY) or mustHitSection and bfCamY or dadCamY) + animIndex[i+1][2] * intensity)
	elseif (mustHitSection and getVar('playerSing') or getVar('opponentSing')) and stringStartsWith(getProperty(((gfSection and 'gf') or not mustHitSection and 'dad' or 'boyfriend')..'.animation.curAnim.name'), 'idle') then
	    setProperty('camFollow.x', (gfSection and gfCamX) or not mustHitSection and dadCamX or bfCamX) setProperty('camFollow.y', (gfSection and gfCamY) or mustHitSection and bfCamY or dadCamY)
	end
    end
end