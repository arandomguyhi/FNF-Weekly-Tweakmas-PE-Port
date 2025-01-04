import flixel.text.FlxText;
// not the best code ever but it works and that's what matter!!!!1!!!!!!!1
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import tjson.TJSON;

var text:FlxText;
var bg:FlxSprite;
var padding:Float = 10;
var elements = [];

function onCreate() {
    var path = Paths.getPath('data/' + Paths.formatToSongPath(game.songName.toLowerCase()) + '/metadata.json', 'TEXT', null, true);
    var metadata = TJSON.parse(File.getContent(path));
    setVar('metadata', metadata);

    var font:Null<String> = metadata.card.font;
    if (font == null) font = 'vcr.ttf';

    var size:Null<Int> = metadata.card.fontSize;
    if (size == null) size = 24;

    text = new FlxText(padding, padding).setFormat(Paths.font(font), size, FlxColor.WHITE, 'left');
    text.antialiasing = ClientPrefs.data.antialiasing;
    text.text = metadata.card.name + '\n\nSong: ' + metadata.credits.music.join(', ') + '\nChart: ' + metadata.credits.chart.join(', ');
        
    bg = new FlxSprite().makeGraphic(Std.int(text.width + (padding * 2)), Std.int(text.height + (padding * 2)), FlxColor.BLACK);
    bg.alpha = 0.8;

    elements.push(bg);
    elements.push(text);

    add(bg);
    add(text);

    for (card in elements) {
	card.cameras = [game.camOther];
	card.screenCenter(0x10);
	card.x = -card.width;
    }
    setVar('cardbg', bg);
    setVar('cardtext', text);
}

function cardAnim() {
    for (card in elements) {
	var initX:Float = card.x;

    	FlxTween.tween(card, {x: initX + card.width}, 0.65, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween) {
	    FlxTween.tween(card, {x: initX}, 0.65, {ease: FlxEase.cubeInOut, startDelay: getVar("metadata").card.duration, onComplete: function(twn:FlxTween) {
		card.destroy();
	    }});
	}});
    }
}

function onBeatHit() {
    if (curBeat == getVar('metadata').card.expandBeat && getVar('metadata').card.expandBeat > 0)
	cardAnim();
}
function onSongStart(){ if (getVar('metadata').card.expandBeat == 0) cardAnim(); }