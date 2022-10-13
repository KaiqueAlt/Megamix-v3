package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('NewIconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 0], 0, false, isPlayer);
		animation.add('bf-car', [0, 0], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 0], 0, false, isPlayer);
		animation.add('bf-pixel', [20, 20], 0, false, isPlayer);
		animation.add('spooky', [1, 2], 0, false, isPlayer);
		animation.add('pico', [3, 4], 0, false, isPlayer);
		animation.add('mom', [5, 6], 0, false, isPlayer);
		animation.add('mom-car', [5, 6], 0, false, isPlayer);
		animation.add('tankman', [7, 8], 0, false, isPlayer);
		animation.add('face', [9, 10], 0, false, isPlayer);
		animation.add('dad', [11, 12], 0, false, isPlayer);
		animation.add('senpai', [21, 21], 0, false, isPlayer);
		animation.add('senpai-angry', [21, 21], 0, false, isPlayer);
		animation.add('spirit', [22, 22], 0, false, isPlayer);
		animation.add('bf-old', [13, 14], 0, false, isPlayer);
		animation.add('gf', [15], 0, false, isPlayer);
		animation.add('gf-christmas', [15], 0, false, isPlayer);
		animation.add('gf-pixel', [15], 0, false, isPlayer);
		animation.add('parents-christmas', [16, 17], 0, false, isPlayer);
		animation.add('monster', [18, 19], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('sans', [23, 24], 0, false, isPlayer);
		animation.add('sansWorried', [23, 24], 0, false, isPlayer);
		animation.add('sansUpset', [23, 24], 0, false, isPlayer);
		animation.add('sansMad', [23, 24], 0, false, isPlayer);
		animation.add('sansTired', [23, 24], 0, false, isPlayer);
		animation.add('sansWinning', [23, 24], 0, false, isPlayer);
		animation.add('lock', [10, 11], 0, false, isPlayer);
		animation.add('paps', [29, 30], 0, false, isPlayer);
		animation.add('bfKR', [0], 0, false, isPlayer);
		animation.add('bf-chara', [25, 26], 0, false, isPlayer);
		animation.add('chara', [27, 28], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
