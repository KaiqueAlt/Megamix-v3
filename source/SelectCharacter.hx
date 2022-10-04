package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import Song.SwagSong;

class SelectCharacter extends MusicBeatState
{
	var text:Alphabet;
	var icon:HealthIcon;
    var grpCharText:FlxTypedGroup<CharacterItem>;
	var SONG:SwagSong;
	var rightArrow:FlxSprite;
	var leftArrow:FlxSprite;
	public static var selectedChar:String = 'bf';
	var curChar = 0;

    override function create(){
	var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
	rightArrow = new FlxSprite(0, 0);
	rightArrow.frames = ui_tex;
	rightArrow.animation.addByPrefix('idle', 'arrow right');
	rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
	rightArrow.animation.play('idle');
//	rightArrow.setGraphicSize(Std.int(rightArrow.width * 3));
	rightArrow.x = 900;
	rightArrow.screenCenter(Y);

	leftArrow = new FlxSprite(0, 0);
	leftArrow.frames = ui_tex;
	leftArrow.animation.addByPrefix('idle', 'arrow left');
	leftArrow.animation.addByPrefix('press', "arrow push left", 24, false);
	leftArrow.animation.play('idle');
//	rightArrow.setGraphicSize(Std.int(rightArrow.width * 3));
	leftArrow.x = 350;
	leftArrow.screenCenter(Y);	
	

    var collorBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFF008000);
	collorBG.screenCenter();
    
	icon = new HealthIcon(selectedChar, true);
	icon.setGraphicSize(Std.int(icon.width * 2));
	icon.screenCenter(X);
	icon.y = 300;
	
	text = new Alphabet(0, 0, "Choose your Character", true);
	text.screenCenter(X);
	text.y = 50;

	
    grpCharText = new FlxTypedGroup<CharacterItem>();
    add(grpCharText);

	add(text);	
	add(collorBG);
	add(icon);
	add(rightArrow);
	add(leftArrow);
    super.create();
    }
    override function update(elapsed:Float){
		if (controls.LEFT_P)
			changeSelected(-1);
		if (controls.RIGHT_P)
			changeSelected(1);
        if (controls.ACCEPT)
            LoadingState.loadAndSwitchState(new PlayState(), true);

		if (controls.RIGHT_P)
			rightArrow.animation.play('press')
		else
			rightArrow.animation.play('idle');

		if (controls.LEFT_P)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');

		rightArrow.animation.play('idle');
        
        super.update(elapsed);
    }
	function changeSelected(change:Int = 0):Void
		{
			curChar += change;
		
			var bullShit:Int = 0;
	
			for (item in grpCharText.members)
			{
				item.targetY = bullShit - curChar;
				if (item.targetY == Std.int(0))
					item.alpha = 1;
				else
					item.alpha = 0.6;
				bullShit++;
			}
			switch(curChar){
			case 0:
				selectedChar = 'bf';
			case 1:
				selectedChar = 'dad';		
			case 2:
				selectedChar = 'spooky';		
			case 3:
				selectedChar = 'pico';	
			case 4:
				selectedChar = 'monster';					
			case 5:
				selectedChar = 'mom';	
			case 6:
				selectedChar = 'senpai';
			case 7:
				selectedChar = 'senpai-angry';
			case 8:
				selectedChar = 'spirit';														

			}
		icon.animation.play(selectedChar);
		FlxG.sound.play(Paths.sound('scrollMenu'));
		}	
}



class CharacterItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var character:FlxSprite;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, charNumber:Int)
	{
		super(x, y);
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17 * (60 / FlxG.save.data.fpsCap));

		if (isFlashing)
			flashingInt += 1;
	
	}
}