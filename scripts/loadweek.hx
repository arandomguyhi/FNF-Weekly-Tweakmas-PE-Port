// Original script made by Detective Baldi

import backend.Song;

import backend.Difficulty;

import states.LoadingState;

createGlobalCallback('loadWeek', function(?songList:Array<String>, ?difficultyInt:Int)
{
	if (songList == null || songList.length < 1)
	    songList = [PlayState.SONG.song];
		
	if (difficultyInt == null || difficultyInt == -1)
	    difficultyInt = PlayState.storyDifficulty;
		
	game.persistentUpdate = false;
	
	FlxG.sound.music.pause();
	FlxG.sound.music.volume = 0;
	
	if (game.vocals != null)
	{
	    game.vocals.pause();
	    game.vocals.volume = 0;
	}
	
	FlxG.camera.followLerp = 0;

	PlayState.storyPlaylist = songList;
	PlayState.isStoryMode = true;
	
	var difficultyString:String = Difficulty.getFilePath(difficultyInt);
	
	if (difficultyString == null)
	    difficultyString = '';
		
	PlayState.storyDifficulty = difficultyInt;
	
	PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficultyString, PlayState.storyPlaylist[0].toLowerCase());
	
	PlayState.campaignScore = 0;
	PlayState.campaignMisses = 0;

	new FlxTimer().start(0.75, function() {
	    LoadingState.loadAndSwitchState(new PlayState(), true);
	});
});