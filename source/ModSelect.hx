package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;


using StringTools;

class ModSelect extends MusicBeatState
{
	var logoBl:FlxSprite;
	var menuItems:Array<String> = ['Normal', 'Dusttale'];
	var text:FlxText;
	var curSelected:Int = 0;
	private var grpControls:FlxTypedGroup<Alphabet>;	
	var mod:Bool = false;
	var danceLeft:Bool = false;
	
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
			

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...menuItems.length)
			{ 
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			}						

				#if mobileC
				addVirtualPad(UP_DOWN, A_B);
				#end

		super.create();
	}
	function changeSelection(change:Int = 0)
	{

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;


/*		switch (curSelected)
		{
					
		} */


		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	override function beatHit()
		{
			super.beatHit();

	
			FlxG.log.add(curBeat);
	
		}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);


		if (controls.ACCEPT)
			{
				var daSelected:String = menuItems[curSelected];
	
				switch (daSelected)
				{
					case "Normal":
						FlxG.switchState(new StoryMenuState());							
					case "Dusttale":
						FlxG.switchState(new mods.DusttaleStoryMenu());							
				}
			
			}
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
	}											
}