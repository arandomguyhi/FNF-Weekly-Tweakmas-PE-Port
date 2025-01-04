--feito por Marcelo gamer Oficial
function onCreatePost()
if not middlescroll then
--opponent
noteTweenX('Movement X 0', 0, defaultPlayerStrumX0, 0.0001)
noteTweenX('Movement X 1', 1, defaultPlayerStrumX1, 0.0001)
noteTweenX('Movement X 2', 2, defaultPlayerStrumX2, 0.0001)
noteTweenX('Movement X 3', 3, defaultPlayerStrumX3, 0.0001)
--player
noteTweenX('Movement X 4', 4, defaultOpponentStrumX0, 0.0001)
noteTweenX('Movement X 5', 5, defaultOpponentStrumX1, 0.0001)
noteTweenX('Movement X 6', 6, defaultOpponentStrumX2, 0.0001)
noteTweenX('Movement X 7', 7, defaultOpponentStrumX3 , 0.0001)
end
end
function onUpdatePost()
--theorda ajeita esse bagulho aqui
P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
setProperty('iconP1.x',P1Mult - 110)
setProperty('iconP1.origin.x', 240)
setProperty('iconP1.flipX',true) 

setProperty('iconP2.x',P2Mult + 110)
setProperty('iconP2.origin.x', -100)
setProperty('iconP2.flipX',true)
setProperty('healthBar.flipX',true)
end
function onEvent(n,v1,v2)
if n == 'Regular Show Events' then
if v1 == 'bye mord' then
setProperty('scoreTxt.visible',false)
setProperty('timeBar.visible',false)
setProperty('healthBar.visible',false)
setProperty('healthBarBG.visible',false)
setProperty('timeTxt.visible',false)
setProperty('iconP1.visible',false)
setProperty('iconP2.visible',false)
end
if v1 == 'switch scene' then
setProperty('scoreTxt.visible',true)
setProperty('timeBar.visible',true)
setProperty('healthBar.visible',true)
setProperty('healthBarBG.visible',true)
setProperty('timeTxt.visible',true)
setProperty('iconP1.visible',true)
setProperty('iconP2.visible',true)
end
end
end