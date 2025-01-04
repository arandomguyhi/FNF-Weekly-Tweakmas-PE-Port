import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.BGSprite;
import flixel.FlxSprite;
import flixel.text.FlxTextBorderStyle;

var bg1:BGSprite;
var bg2:BGSprite;
var sineOn:Bool = false;
var radians:Float = 0;
var bfY:Float;
var dadY:Float;
var you:FlxText;
var black:FlxSprite;
var present:FlxSprite;

var stagePath = '../TweakAssets/stages/Tweakmas/First Edition/regular/';

function onCreate()
{
    game.addCharacterToList('rigby', 0);
    game.addCharacterToList('quilljin_2', 1);
    game.skipCountdown = true;

    bg1 = new BGSprite(stagePath + 'regularshowtile', -200, -1000, 0.8, 0.8);
    bg1.scale.set(3.0, 3.0);
    bg1.updateHitbox();
    game.addBehindGF(bg1);

    bg2 = new BGSprite(stagePath + 'regularshowtile', -200, -1000, 0.8, 0.8);
    bg2.scale.set(3.0, 3.0);
    bg2.updateHitbox();
    bg2.y += bg1.height;
    game.addBehindGF(bg2);

    present = new FlxSprite(2370, 1310);
    present.frames = Paths.getSparrowAtlas(stagePath + 'rg_box');
    present.animation.addByPrefix('boyfriend', 'box24_rigby0', 24, true);
    present.animation.addByPrefix('dad', 'box24_quillgan0', 24, true);
    present.alpha = 0.001;
    game.addBehindGF(present);

    you = new FlxText(275, 300).setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    you.borderSize = 3;
    you.text = 'YOU';
    you.alpha = 0.001;
    you.cameras = [game.camOther];
    add(you);

    black = new FlxSprite().makeGraphic(FlxG.width + 2, FlxG.height, FlxColor.BLACK);
    black.cameras = [game.camOther];
    add(black);
}

function onCreatePost()
{
    game.callOnLuas('snapCamFollowToPos', [2500, 1400, true]);
    game.camHUD.alpha = 0;
    game.camGame.zoom = 0.7;

    bfY = game.boyfriend.y;
    dadY = game.dad.y;
    sineOn = true;
}

function onSongStart()
{
    FlxTween.tween(black, {alpha: 0}, 7);
    FlxTween.tween(game.camGame, {zoom: 0.3}, 7, {ease: FlxEase.sineOut});
}

function onUpdatePost(elapsed:Float)
{
    radians += elapsed;

    bg1.y -= 9000 * elapsed;
    if (bg1.y < -6000) bg1.y += bg1.height * 2;
    bg2.y -= 9000 * elapsed;
    if (bg2.y < -6000) bg2.y += bg2.height * 2;

    if (sineOn)
    {
        game.boyfriend.y = 25 * Math.sin(radians) + bfY;
        game.dad.y = 25 * Math.sin(radians + Math.PI) + dadY;
    }
}

function onMoveCamera(turn:String)
{
    present.animation.play(turn);
}

function onEvent(name:String, v1:String, v2:String)
{
    if (name == 'Regular Show Events')
    {
        switch (v1) 
        {
            case 'hud on':
                you.scale.set(0.2, 0.2);

                // gulp
                FlxTween.tween(you.scale, {x: 1, y: 1}, 1, {ease: FlxEase.expoOut});
                FlxTween.tween(you, {alpha: 1}, 1, {ease: FlxEase.expoOut, onComplete: function(twn:FlxTween) {
                    FlxTween.tween(game.camHUD, {alpha : 1}, 1);
                    FlxTween.tween(you, {alpha : 0}, 1, {startDelay : 2, ease : FlxEase.expoIn});
                    FlxTween.tween(you.scale, {x: 0.2, y: 0.2}, 1, {startDelay : 2, ease: FlxEase.expoIn});
                }});

            case 'unlock cam':
                game.isCameraOnForcedPos = false;
                game.camZooming = true;

            case 'bye mord':
                game.camGame.visible = false;
                game.defaultCamZoom = 0.9;

            case 'switch scene':
                game.camGame.visible = true;
                sineOn = false;
		game.callOnLuas('snapCamFollowToPos', [present.x + 250, present.y + 70, false]);

                game.triggerEvent('Change Character', 0, 'rigby');
                game.triggerEvent('Change Character', 1, 'quilljin_2');

		game.healthBar.setColors(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), FlxColor.fromRGB(boyfriend.healthColorArray[0],boyfriend.healthColorArray[1],boyfriend.healthColorArray[2]));

                game.boyfriend.x += 750;
                game.boyfriend.y -= 35;

                game.dad.x -= 15;
                game.dad.y += 10;

                present.alpha = 1;
        }
    }
}