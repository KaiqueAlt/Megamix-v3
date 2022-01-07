package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;

class SelectCharacter extends MusicBeatState
{
    var grpCharText:FlxTypedGroup<CharacterItem>;
    var characters:Array<Dynamic> = [
		['boyfriend'],
	];

    override function create(){
    var collorBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFF00FFFF);
    add(collorBG);

    var boyfriend:FlxSprite = new FlxSprite();
    boyfriend.frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
    boyfriend.animation.addByPrefix('idle', "BF idle dance", 24);
    boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.8));
    boyfriend.y += 60;
    boyfriend.x += 450;
    boyfriend.animation.play('idle');
    add(boyfriend);

    grpCharText = new FlxTypedGroup<CharacterItem>();
    add(grpCharText);

    for (i in 0...characters.length)
		{
			var charThing:CharacterItem = new CharacterItem(0, collorBG.y + collorBG.height + 10, i);
			charThing.y += ((charThing.height + 20) * i);
			charThing.targetY = i;
			grpCharText.add(charThing);

			charThing.screenCenter(X);
			charThing.antialiasing = true;
		}



    super.create();
    }
    override function update(elapsed:Float){
        if (controls.ACCEPT){
            LoadingState.loadAndSwitchState(new PlayState(), true);
        }

        super.update(elapsed);
    }
}



class CharacterItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var character:FlxSprite;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, charName:Int)
	{
		super(x, y);
		character = new FlxSprite().loadGraphic(Paths.image('character/char' + charName));
		add(character);
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
	
		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			character.color = 0xFF33ffff;
		else if (FlxG.save.data.flashing)
			character.color = FlxColor.WHITE;
	}
}