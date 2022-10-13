package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import ui.Mobilecontrols;
import ModchartState;
import sys.io.File;
import openfl.Assets;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxAxes;
#if android
import extension.videoview.VideoView;
#end
import ui.FlxVirtualPad;

#if windows
import Discord.DiscordClient;
#end
#if sys
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	var _pad:FlxVirtualPad;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;
	var dance:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	//dusttale
	var dustdoof:dialogues.DustDialBox;
	public static var judgementIlumination:FlxSprite;
	public static var pressSpace:FlxSprite;
	public static var miss:FlxSprite;
	public static var hit:FlxSprite;
	public static var attack:FlxSprite;
	public static var coolGlitch:FlxSprite;
	public static var blackthing:FlxSprite;
	public static var blasters:FlxSprite;
	public static var papyrus:FlxSprite;
	var dustsound:FlxSound;
	public static var canHit:Bool = false;
	public static var isAttacking:Bool = false;
	var dustAccumulated:Int = 0;
	var healthBarColor1:FlxColor;
	var iconP1Prefix:String;
	var iconP2Prefix:String;
	var kr:FlxSprite;
	var DustCloud1:FlxSprite;
	public static var attackedSans:Bool = false;

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end


	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;
		attackedSans = false;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'the-murderer':
				dialogue = CoolUtil.coolTextFile(Paths.txt('the-murderer/dialogue'));
			case 'red-megalovania':
				dialogue = CoolUtil.coolTextFile(Paths.txt('red-megalovania/dialogue'));
			case 'drowning':
				dialogue = CoolUtil.coolTextFile(Paths.txt('drowning/dialogue'));
			case 'anthropophobia':
				dialogue = CoolUtil.coolTextFile(Paths.txt('anthropophobia/dialogue'));
			case 'd.i.e':
				dialogue = CoolUtil.coolTextFile(Paths.txt('d.i.e/dialogue'));
			case 'psychotic-breakdown':
				dialogue = CoolUtil.coolTextFile(Paths.txt('psychotic-breakdown/dialogue'));
		}

		switch(SONG.stage)
		{			case 'judgementhall':
			{
				defaultCamZoom = 0.6;
				curStage = 'judgementhall';
				var bg:FlxSprite = new FlxSprite(-267.35, -370.7).loadGraphic(Paths.image('judgementhall/bg', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.screenCenter(Y);

				judgementIlumination = new FlxSprite(-267.35, -370.7).loadGraphic(Paths.image('judgementhall/ilumination', 'shared'));
				judgementIlumination.antialiasing = true;
				judgementIlumination.scrollFactor.set(1, 1);
				judgementIlumination.active = false;
				judgementIlumination.screenCenter(Y);


				

				add(bg);

				
				var glitchEffect = new FlxGlitchEffect(17,16,0.2,FlxGlitchDirection.HORIZONTAL);
				var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
				coolGlitch = glitchSprite;
				add(coolGlitch);
				coolGlitch.x = bg.x;
				coolGlitch.y = bg.y;
				coolGlitch.visible = false;

				papyrus = new FlxSprite(1000, 30);
					papyrus.frames = Paths.getSparrowAtlas('characters/paps');
					papyrus.animation.addByPrefix('idle', 'Pap idle', 24, true);
					papyrus.scrollFactor.set(1, 1);
					papyrus.antialiasing = true;
					papyrus.setPosition(0, 0);
					papyrus.alpha = 0;
					papyrus.animation.play('idle');

					add(papyrus);


					

				blackthing = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		  	    blackthing.scrollFactor.set();
		   	
		  	 	blackthing.visible = false;
		  	 	blackthing.alpha = 1;

		  	 	
		  	 		pressSpace = new FlxSprite(0, 600).loadGraphic(Paths.image('press', 'shared'));
					pressSpace.antialiasing = true;
					pressSpace.scrollFactor.set();
					pressSpace.active = false;
					pressSpace.screenCenter(X);
					pressSpace.screenCenter(Y);
					pressSpace.visible = false;

					miss = new FlxSprite(0, 0).loadGraphic(Paths.image('miss', 'shared'));
					miss.antialiasing = true;
					miss.scrollFactor.set(1, 1);
					miss.screenCenter(X);
					miss.screenCenter(Y);
					miss.updateHitbox();
					miss.active = false;
					miss.visible = false;

					hit = new FlxSprite(0, 0).loadGraphic(Paths.image('-20', 'shared'));
					hit.antialiasing = true;
					hit.scrollFactor.set(1, 1);
					hit.screenCenter(X);
					hit.screenCenter(Y);
					hit.updateHitbox();
					hit.active = false;
					hit.visible = false;

					attack = new FlxSprite(0, 0).loadGraphic(Paths.image('attack', 'shared'));
					attack.antialiasing = true;
					attack.scrollFactor.set(1, 1);
					attack.screenCenter(X);
					attack.screenCenter(Y);
					attack.updateHitbox();
					attack.active = false;
					attack.visible = false;
		  	 	

			}

			case 'judgementhall-paps':
			{
				defaultCamZoom = 0.6;
				curStage = 'judgementhall';
				var bg:FlxSprite = new FlxSprite(-267.35, -370.7).loadGraphic(Paths.image('judgementhall/paps', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.screenCenter(Y);

				judgementIlumination = new FlxSprite(-267.35, -370.7).loadGraphic(Paths.image('judgementhall/ilumination', 'shared'));
				judgementIlumination.antialiasing = true;
				judgementIlumination.scrollFactor.set(1, 1);
				judgementIlumination.active = false;
				judgementIlumination.screenCenter(Y);


				

				add(bg);

				
				var glitchEffect = new FlxGlitchEffect(13,10,0.2,FlxGlitchDirection.HORIZONTAL);
				var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
				coolGlitch = glitchSprite;
				add(coolGlitch);
				coolGlitch.x = bg.x;
				coolGlitch.y = bg.y;
				coolGlitch.visible = true;

			}

			case 'judgementhall-chara': //literally the same as paps because we don't have time to do fancy things
			{
				defaultCamZoom = 0.6;
				curStage = 'judgementhall';
				var bg:FlxSprite = new FlxSprite(-267.35, -370.7).loadGraphic(Paths.image('judgementhall/chara', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.screenCenter(Y);

				judgementIlumination = new FlxSprite(-267.35, -370.7).loadGraphic(Paths.image('judgementhall/ilumination', 'shared'));
				judgementIlumination.antialiasing = true;
				judgementIlumination.scrollFactor.set(1, 1);
				judgementIlumination.active = false;
				judgementIlumination.screenCenter(Y);


				

				add(bg);

				
				var glitchEffect = new FlxGlitchEffect(13,10,0.2,FlxGlitchDirection.HORIZONTAL);
				var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
				coolGlitch = glitchSprite;
				add(coolGlitch);
				coolGlitch.x = bg.x;
				coolGlitch.y = bg.y;
				coolGlitch.visible = true;

			}

			case 'snowdin_cave':
			{
				defaultCamZoom = 0.65;
				curStage = 'snowdin_cave';
				var bg:FlxSprite = new FlxSprite(-182.05, -192.85).loadGraphic(Paths.image('snowdin_cave'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;			

				add(bg);
			}

			case 'waterfall':
			{
				defaultCamZoom = 0.65;
				curStage = 'waterfall';
				var bg:FlxSprite = new FlxSprite(-368.9, -439.8).loadGraphic(Paths.image('waterfall/waterfallBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;			

				add(bg);


			
					papyrus = new FlxSprite(1000, 30);
					papyrus.frames = Paths.getSparrowAtlas('characters/paps');
					papyrus.animation.addByPrefix('idle', 'Pap idle', 24, true);
					papyrus.scrollFactor.set(1, 1);
					papyrus.antialiasing = true;
					papyrus.setPosition(0, 0);
					papyrus.alpha = 0;
					papyrus.animation.play('idle');

					add(papyrus);
				


			}

			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-undyne':
				gfVersion = 'gf-undyne';
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			//Dusttale
			case "sans":
				dad.setPosition(162.4, 76.65);
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y - 50);
			case "sansWorried":
				dad.setPosition(162.4, 76.65);
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y - 50);
			case "sansUpset":
				dad.setPosition(162.4, 76.65);
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y - 100);
			case "sansMad":
				dad.setPosition(162.4, 76.65);
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y - 50);
			case "paps":
				dad.setPosition(-29.3, -86);
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case "chara":
				dad.setPosition(19.4, 142.4);
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
							
		}

		
		boyfriend = new Boyfriend(770, 450, SelectCharacter.selectedChar);
		switch (SelectCharacter.selectedChar)
		{

			case 'spooky':
				boyfriend.y = 250;
			case 'pico':	
				boyfriend.y = 450;
			case 'dad':
				boyfriend.y = 150;
				boyfriend.x = 850;
			case 'dad':
				boyfriend.y = 150;
				boyfriend.x = 850;	
			case 'mom':
				boyfriend.y = 150;
				boyfriend.x = 850;		
			case 'monster':
				boyfriend.y = 150;
				boyfriend.x = 850;	
			case 'monster-christmas':
				boyfriend.y = 150;
				boyfriend.x = 850;	
			case 'senpai':
				boyfriend.y = 350;
				boyfriend.x = 900;	
				camPos.set(boyfriend.getGraphicMidpoint().x + 300, boyfriend.getGraphicMidpoint().y);	
			case 'senpai-angry':
				boyfriend.y = 350;
				boyfriend.x = 950;	
				camPos.set(boyfriend.getGraphicMidpoint().x + 300, boyfriend.getGraphicMidpoint().y);
																														
		} 

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'judgementhall':
				boyfriend.setPosition(1080.75, 458.75);
				gf.setPosition(638.2, 125.6);
			case 'judgementhall-paps':
				boyfriend.setPosition(1080.75, 458.75);
				gf.setPosition(638.2, 125.6);
			case 'judgementhall-chara':
				boyfriend.setPosition(1080.75, 458.75);
				gf.setPosition(6638.2, 6125.6);
			case 'snowdin_cave':
				if (boyfriend.curCharacter == 'pico')
					boyfriend.setPosition(1094.05, 408.75);
				else
					boyfriend.setPosition(1094.05, 458.75);

				gf.setPosition(642.2, 125.6);
			case 'waterfall':
				boyfriend.setPosition(1094.05, 458.75);
				switch(gf.curCharacter)
				{
					case 'gf':
					gf.setPosition(642.2, 125.6);

					case 'gf-undyne':
					gf.setPosition(401.9, 40.05);

				}
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);
		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}


		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		dustdoof = new dialogues.DustDialBox(false, dialogue);
		dustdoof.scrollFactor.set();
		dustdoof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

	    DustCloud1 = new FlxSprite(0, 0).loadGraphic(Paths.image('Dust_image'));
		DustCloud1.scrollFactor.set();
		DustCloud1.antialiasing = true;
		DustCloud1.visible = true;
		DustCloud1.setGraphicSize(Std.int(DustCloud1.width * 1));
		DustCloud1.alpha = 0;

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " - ", 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		blasters = new FlxSprite(0,0);
		blasters.frames = Paths.getSparrowAtlas('gasterBlaster');
        blasters.animation.addByPrefix('shoot', 'shoot', 24, false);
        blasters.setGraphicSize(Std.int(blasters.width * 0.7));
        blasters.setPosition(-600, 75);
        blasters.visible = false;

        if (FlxG.save.data.downscroll)
			{
				blasters.setPosition(-600, -500);
			}
	

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		blasters.cameras = [camHUD];	
		DustCloud1.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		add(blasters);
		add(DustCloud1);


		#if mobileC
			mcontrols = new Mobilecontrols();
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPad(mcontrols._virtualPad, FULL, NONE);
				case HITBOX:
					controls.setHitBox(mcontrols._hitbox);
				default:
			}
			_pad = new FlxVirtualPad(NONE, A);
			
			trackedinputs = controls.trackedinputs;
			controls.trackedinputs = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];
			_pad.cameras = [camcontrol];

			mcontrols.visible = false;

			switch(curSong){
			case 'anthropophobia':
				add(_pad);
			}
			add(mcontrols);
		#end


		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case 'drowning' | 'd.i.e':
					dialogueShit(dustdoof);
				case 'the-murderer':
					dialogueShit(dustdoof);
				case 'red-megalovania':
					dialogueShit(dustdoof);
				case 'psychotic-breakdown':
					dialogueShit(dustdoof);
				case 'anthropophobia':
					dialogueShit(dustdoof);
				default:
				if (FileSystem.exists(Paths.txt("dialogues/" + SONG.song.toLowerCase() + "dialogue"))){
					startCountdown();
				}
				else{
					startCountdown();
				}
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}
	function dialogueShit(?dialogueBox:dialogues.DustDialBox):Void
		{
			if (dialogueBox != null)
				{
					inCutscene = true;	
					add(dialogueBox);
				}
				else
					startCountdown();
		}
	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		// pre lowercasing the song name (schoolIntro)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		if (songLowercase == 'roses' || songLowercase == 'thorns')
		{
			remove(black);

			if (songLowercase == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (songLowercase == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if sys
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{

		#if mobileC
		mcontrols.visible = true;
		#end
	
		
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if sys
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			switch(SelectCharacter.selectedChar){
				case "spooky":
				{
					dance = !dance;
					if (dance)
						boyfriend.playAnim('danceRight');
					else
						boyfriend.playAnim('danceLeft');
				}
				default:
					boyfriend.playAnim('idle');
				}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if sys
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.SPACE #if mobileC || _pad.buttonA.justPressed #end && (SONG.song.toLowerCase() == 'anthropophobia'))
		{
			attack.visible = false;

			boyfriend.playAnim("slash");

			new FlxTimer().start(1, function(swagTimer:FlxTimer)
				{
					isAttacking = false;
				});

			if (isAttacking == false)
			{
				if (canHit == true)
				{
					canHit = false;
					isAttacking = true;

					FlxG.sound.play(Paths.sound('slash_effect'));

					FlxG.camera.shake(0.025, 0.1, null, true, FlxAxes.XY);

					if(isStoryMode)
					{
						attackedSans = true;
					}
					hit.alpha = 1;
					health += 4;
					hit.visible = true;

					new FlxTimer().start(0.5, function(swagTimer:FlxTimer)
					{
						new FlxTimer().start(0.01, function(swagTimer:FlxTimer)
						{
							hit.alpha -= 0.01;

							if (hit.alpha > 0)
							{
								swagTimer.reset();
							}
							
						});
					});

					

				} 
				else
				{
					miss.alpha = 1;
					miss.visible = true;
					isAttacking = true;

					new FlxTimer().start(0.5, function(swagTimer:FlxTimer)
					{

						new FlxTimer().start(0.01, function(swagTimer:FlxTimer)
						{
							miss.alpha -= 0.01;

							if (miss.alpha > 0)
							{
								swagTimer.reset();
							}
							
						});

					});
				} 
			}
		}

		//chara drain mechanic in last hope

		if (curSong == 'last-hope' && health > 0.3)
		{
			
			health -= 0.0003;

		}

		switch (dustAccumulated)
		{
			case 0:
			DustCloud1.alpha = 0;

			case 1:
			DustCloud1.alpha = 0.1;

			case 2:
			DustCloud1.alpha = 0.2;

			case 3:
			DustCloud1.alpha = 0.3;

			case 4:
			DustCloud1.alpha = 0.4;

			case 5:
			DustCloud1.alpha = 0.5;

			case 6:
			DustCloud1.alpha = 0.6;

			case 7:
			DustCloud1.alpha = 0.7;

			case 8:
			DustCloud1.alpha = 0.8;

			case 9:
			DustCloud1.alpha = 0.9;

			case 10:
			DustCloud1.alpha = 1;
		}

		if (DustCloud1.alpha == 1)
		{
			health -= 2;
		}


		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER  #if android || FlxG.android.justReleased.BACK #end  && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if sys
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if sys
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if sys
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end


				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end
				switch(SelectCharacter.selectedChar){
					case 'senpai' | 'senpai-angry':
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 300 + offsetY);
					default:
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);
				}
				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}
		FlxG.watch.addQuick("bf.x", boyfriend.x);
		FlxG.watch.addQuick("bf.y", boyfriend.y);


		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{

		#if mobileC
		mcontrols.visible = false;
		#end

		if (!loadRep)
			trace('hi');
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{

						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					// pre lowercasing the next story song name
					var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
						switch (nextSongLowercase) {
							case 'dad-battle': nextSongLowercase = 'dadbattle';
							case 'philly-nice': nextSongLowercase = 'philly';
						}
					trace(nextSongLowercase + difficulty);

					// pre lowercasing the song name (endSong)
					var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
					if (songLowercase == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					switch(curSong){
						#if android
						case "red-megalovania":	
						VideoView.playVideo(SUtil.getPath() + 'assets/assets/videos/redmegalovania.mp4');
						VideoView.onCompletion = function()
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
						}
						case "psychotic-breakdown":						
						VideoView.playVideo(SUtil.getPath() + 'assets/assets/videos/psychoticbreakdown.mp4');
						VideoView.onCompletion = function()
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
						}
						case "anthropophobia":						
						VideoView.playVideo(SUtil.getPath() + 'assets/assets/videos/psychoticbreakdown.mp4');
						VideoView.onCompletion = function()
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
						}						
						#end
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					}
					
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				/*if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				}  */
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function gasterBlasters():Void
		{
			
			 blasters.visible = true;
	
			blasters.animation.play('shoot');
			FlxG.sound.play(Paths.sound('blaster_shoot'));
	
			new FlxTimer().start(0.35 , function(tmr:FlxTimer)
				{
					health = 0.1;
				});
		}
	
		function charaslash():Void
		{
			dad.playAnim('slash', false);
	
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				FlxG.camera.shake(0.0100, 0.35, null, true, FlxAxes.XY);
				camHUD.shake(0.0100, 0.35, null, true, FlxAxes.XY);
				health -= 0.75;
				FlxG.sound.play(Paths.sound('slash_effect'));
			});		
			
		}
	
		function PhantomEffect():Void
		{
	
			FlxG.sound.play(Paths.sound('idk'));
			new FlxTimer().start(0.01, function(swagTimer:FlxTimer)
					{
						
						if (camHUD.alpha <= 0.05)
						{
							trace("done");
							new FlxTimer().start(10, function(swagTimer:FlxTimer)
							{
								new FlxTimer().start(0.01, function(swagTimer:FlxTimer)
								{
									camHUD.alpha += 0.01;
									if (camHUD.alpha != 1)
									{
										swagTimer.reset();
									}
								});
							});
	
						} else
						{
							camHUD.alpha -= 0.01;
							swagTimer.reset();
							trace("repeat");
						}
						
					});
			
		}
	
	
	
		function DustCloud():Void
		{
			dustAccumulated++;
	
			trace(dustAccumulated);
	
			new FlxTimer().start(35 , function(tmr:FlxTimer)
			{
				dustAccumulated--;
				trace(dustAccumulated);
			});
	
	
		
	
	
	
	
			dustsound = new FlxSound().loadEmbedded(Paths.sound('dust'));
			dustsound.play();
			dustsound.volume = 1;
			new FlxTimer().start(0.5 , function(tmr:FlxTimer)
			{
			dustsound;
			});
		}
	
		function HealthDrain():Void
		{
			kr.visible = true;
				
	
			iconP1Prefix = 'bfKR';
			remove(iconP1);
			iconP1 = new HealthIcon('bfKR', false);
			iconP1.y = healthBar.y - (iconP1.height / 3.5);
			iconP1.flipX = true;
			 iconP1.cameras = [camHUD];
			add(iconP1);
			healthBar.createFilledBar(0xFF999999, 0xFFf23dc8);
			boyfriend.playAnim('singUPmiss', true);
			FlxG.sound.play(Paths.sound("bone"), 1);
			boyfriend.playAnim('singUPmiss', true);
			new FlxTimer().start(0.001, function(tmr:FlxTimer)	
			{
			boyfriend.playAnim('singUPmiss', true);
			});
	
			var healthDrained:Float = 0;
	
			new FlxTimer().start(0.0001, function(swagTimer:FlxTimer)
				{
					health -= 0.0008;
					healthDrained += 0.0008;
					if (healthDrained < 0.5)
					{
						swagTimer.reset();
					} else
					{
						kr.visible = false;
						healthDrained = 0;
	
						if (boyfriend.curCharacter == 'bf-chara')
						{
								iconP1Prefix = 'bf-chara';
								remove(iconP1);
								iconP1 = new HealthIcon('bf-chara', false);
								iconP1.y = healthBar.y - (iconP1.height / 3.5);
								iconP1.flipX = true;
								 iconP1.cameras = [camHUD];
								add(iconP1);
								healthBar.createFilledBar(0xFF999999, 0xFFe81a1a);
						} else 
						{
								iconP1Prefix = 'bf';
								remove(iconP1);
								iconP1 = new HealthIcon('bf', false);
								iconP1.y = healthBar.y - (iconP1.height / 3.5);
								iconP1.flipX = true;
								 iconP1.cameras = [camHUD];
								add(iconP1);
								healthBar.createFilledBar(0xFF999999, 0xFF51d8fb);
						}
	
					}
				});
	
		}
	
		function papyrusAlpha():Void
		{
			dad.alpha = 0.8;
		}
	
		function flipAllShits():Void
		{
			
				new FlxTimer().start(0.0001, function(swagTimer:FlxTimer)
				{
					FlxTween.tween(FlxG.camera, {angle: -20}, 1, {ease: FlxEase.quadOut});
					FlxTween.tween(camHUD, {angle: 20}, 1, {ease: FlxEase.quadOut});
	
					new FlxTimer().start(1, function(swagTimer:FlxTimer)
					{
						FlxTween.tween(FlxG.camera, {angle: 20}, 2, {ease: FlxEase.quadInOut});
						FlxTween.tween(camHUD, {angle: -20}, 2, {ease: FlxEase.quadInOut});
	
							new FlxTimer().start(2, function(swagTimer:FlxTimer)
							{
								FlxTween.tween(FlxG.camera, {angle: 0}, 1, {ease: FlxEase.quadInOut});
								FlxTween.tween(camHUD, {angle: 0}, 1, {ease: FlxEase.quadInOut});
							});
					});
	
					
	
	
				});
			
	
			
		}
	
	
	
		function flipCamUp():Void
		{
			FlxG.sound.play(Paths.sound('cameraFlip'));
	
				//impulse tween
				FlxTween.tween(FlxG.camera, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
				//FlxTween.tween(camHUD, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
	
				//animations
				new FlxTimer().start(0.025, function(tmr:FlxTimer)	
				{
					boyfriend.playAnim('hit', false);
					dad.playAnim('swingUP', false);
				});
	
				//actual rotation tween
				new FlxTimer().start(0.15, function(tmr:FlxTimer)	
				{
					FlxTween.tween(FlxG.camera, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
					//FlxTween.tween(camHUD, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
				});
	
				//camera shake
				new FlxTimer().start(0.30, function(tmr:FlxTimer)	
				{
					FlxG.camera.shake(0.025, 0.1, null, true, FlxAxes.XY);
					boyfriend.playAnim('idle');
					dad.playAnim('idle');
				});
		}
	
		function ArrowFunnyUp():Void
		{
			FlxG.sound.play(Paths.sound('cameraFlip'));
	
				//impulse tween
				FlxTween.tween(camHUD, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
	
				//animations
				new FlxTimer().start(0.025, function(tmr:FlxTimer)	
				{
					boyfriend.playAnim('hit', false);
					dad.playAnim('swingUP', false);
				});
	
				//actual rotation tween
				new FlxTimer().start(0.15, function(tmr:FlxTimer)	
				{
					FlxTween.tween(camHUD, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
				});
	
				//camera shake
				new FlxTimer().start(0.30, function(tmr:FlxTimer)	
				{
					FlxG.camera.shake(0.025, 0.1, null, true, FlxAxes.XY);
					boyfriend.playAnim('idle');
					dad.playAnim('idle');
				});
		}
	
		function ArrowFunnyDown():Void
		{
			FlxG.sound.play(Paths.sound('cameraFlip'));
	
				//impulse tween
				FlxTween.tween(camHUD, {angle: 210}, 0.15, {ease: FlxEase.quadInOut});
	
				//animations
				new FlxTimer().start(0.025, function(tmr:FlxTimer)	
				{
					boyfriend.playAnim('hit', false);
					dad.playAnim('swingDOWN', false);
				});
	
				//actual rotation tween
				new FlxTimer().start(0.15, function(tmr:FlxTimer)	
				{
					FlxTween.tween(camHUD, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
				});
	
				//camera shake
				new FlxTimer().start(0.30, function(tmr:FlxTimer)	
				{
					FlxG.camera.shake(0.025, 0.1, null, true, FlxAxes.XY);
					boyfriend.playAnim('idle');
					dad.playAnim('idle');
				});
		}
	
		function flipCamDown():Void
		{
			FlxG.sound.play(Paths.sound('cameraFlip'));
	
				//impulse tween
				FlxTween.tween(FlxG.camera, {angle: 210}, 0.15, {ease: FlxEase.quadInOut});
				//FlxTween.tween(camHUD, {angle: 210}, 0.15, {ease: FlxEase.quadInOut});
	
				//animations
				new FlxTimer().start(0.025, function(tmr:FlxTimer)	
				{
					boyfriend.playAnim('hit', false);
					dad.playAnim('swingDOWN', false);
				});
	
				//actual rotation tween
				new FlxTimer().start(0.15, function(tmr:FlxTimer)	
				{
					FlxTween.tween(FlxG.camera, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
					//FlxTween.tween(camHUD, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
				});
	
				//camera shake
				new FlxTimer().start(0.30, function(tmr:FlxTimer)	
				{
					FlxG.camera.shake(0.025, 0.1, null, true, FlxAxes.XY);
					boyfriend.playAnim('idle');
					dad.playAnim('idle');
				});
		}

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if sys
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end


		if (curSong.toLowerCase() == 'anthropophobia')
			{
				switch(curStep)
				{
					case 1:
						pressSpace.visible = true;
					case 90:
						pressSpace.visible = false;
					case 114:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 134:
						canHit = false;
						attack.visible = false;
					case 452:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 472:
						canHit = false;
						attack.visible = false;
					case 681:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 701:
						canHit = false;
						attack.visible = false;
					case 1184:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 1204:
						canHit = false;
						attack.visible = false;
					case 1216:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 1236:
						canHit = false;
						attack.visible = false;
					case 1280:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 1300:
						canHit = false;
						attack.visible = false;
					case 2080:
						canHit = true;
						attack.visible = true;
						FlxG.sound.play(Paths.sound('warning'));
					case 2100:
						canHit = false;
						attack.visible = false;

				}
			}
			if (curStep == 159 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}	
		
				if (curStep == 415 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}	
		
				if (curStep == 544 && curSong == 'anthropophobia')
				{
					FlxG.camera.shake(0.010, 8.35, null, true, FlxAxes.XY);
					camHUD.shake(0.010, 8.35, null, true, FlxAxes.XY);
		
				}	
		
				if (curStep == 672 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}	
		
				if (curStep == 672 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				
		
				if (curStep == 816 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}		
		
				if (curStep == 828 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 840 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}	
		
				if (curStep == 859 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 868 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}	
		
				if (curStep == 877 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 884 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}	
		
				if (curStep == 895 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 928 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 991 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1118 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 1118 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1184 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 1184 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1216 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1247 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1280 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1472 && curSong == 'anthropophobia')
				{
					FlxTween.tween(FlxG.camera, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
		
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyUp();
		
				}
		
				if (curStep == 1488 && curSong == 'anthropophobia')
				{
					FlxTween.tween(FlxG.camera, {angle: 210}, 0.15, {ease: FlxEase.quadInOut});
		
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyDown();
		
				}
		
				if (curStep == 1496 && curSong == 'anthropophobia')
				{
					FlxTween.tween(FlxG.camera, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyUp();
		
				}
		
				if (curStep == 1504 && curSong == 'anthropophobia')
				{
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyDown();
		
				}
		
				if (curStep == 1519 && curSong == 'anthropophobia')
				{
					FlxTween.tween(FlxG.camera, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyUp();
		
				}
		
				if (curStep == 1517 && curSong == 'anthropophobia')
				{
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyDown();
		
				}
		
				if (curStep == 1532 && curSong == 'anthropophobia')
				{
					FlxTween.tween(FlxG.camera, {angle: -30}, 0.15, {ease: FlxEase.quadInOut});
					new FlxTimer().start(0.15, function(tmr:FlxTimer)	
					{
						FlxTween.tween(FlxG.camera, {angle: 180}, 0.15, {ease: FlxEase.quadInOut});
					});
					ArrowFunnyUp();
		
				}
		
				if (curStep == 1532 && curSong == 'anthropophobia')
				{
					ArrowFunnyDown();
					flipCamDown();
		
				}	
				
		
				if (curStep == 1526 && curSong == 'anthropophobia')
				{
					ArrowFunnyDown();
		
				}
		
		
				if (curStep == 1600 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 1632 && curSong == 'anthr opophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 1657 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 1664 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 1672 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 1678 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1680 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 1684 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}


		
				if (curStep == 1688 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 1692 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 1696 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1711 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1728 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1744 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1776 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1791 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
				if (curStep == 1824 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1887 && curSong == 'anthropophobia')
				{
					flipCamUp();
		
				}
		
				if (curStep == 1903 && curSong == 'anthropophobia')
				{
					gasterBlasters();
		
				}	
		
				if (curStep == 1951 && curSong == 'anthropophobia')
				{
					flipCamDown();
		
				}
		
		switch (SONG.song.toLowerCase())
		{
			case 'the-murderer':
				switch (curStep)
				{
					case 442:
						flipCamUp();
						SONG.speed = 2.8;
					case 635:
						flipCamDown();
						SONG.speed = 2.4;
					case 894:
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 4, {ease: FlxEase.quadInOut});
						new FlxTimer().start(4 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 1.2;
						});
					case 1085:
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, 8, {ease: FlxEase.quadInOut});
						new FlxTimer().start(8 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 0.65;
						});
					case 1143:
						flipCamUp();
						SONG.speed = 2.8;
					case 1337:
						flipCamDown();
						SONG.speed = 2.4;
				}
			case 'red-megalovania':
				switch (curStep)
				{
					case 880:
						papyrus.setPosition(-298.7, -275.95);
						new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
						{
							papyrus.alpha += 0.1;
		
							if (papyrus.alpha < 0.4)
							{
								swagTimer.reset();
							}
						});
					case 1154:
						new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
						{
							papyrus.alpha -= 0.1;
		
							swagTimer.reset();
							
						});
					case 319,1160,1724,2148:
						flipCamUp();
					case 740,1444,2003,2288:
						flipCamDown();
				}
			case 'drowning':
				switch (curStep) 
				{
					case 269,1040:
						flipCamUp();
					case 399,1166:
						flipCamDown();
					case 252:
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 1, {ease: FlxEase.quadInOut});
						new FlxTimer().start(1 , function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2, {ease: FlxEase.quadInOut});
						});
					case 528:
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 15, {ease: FlxEase.quadInOut});
						new FlxTimer().start(15 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 1.2;
						});
					case 656:
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, 15, {ease: FlxEase.quadInOut});
						new FlxTimer().start(15 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 0.65;
						});
				}
			case 'psychotic-breakdown':
				switch (curStep)
				{
					case 512,954,1600:
						flipCamUp();
					case 635,1216,1728:
						flipCamDown();
				}
			case 'd.i.e':
				switch (curStep)
				{
					case 11,204,527,652,1165,1216,1224,1284,1282:
						gasterBlasters();
					case 272:
						FlxG.camera.shake(0.010, 16, null, true, FlxAxes.XY);
						camHUD.shake(0.010, 16, null, true, FlxAxes.XY);
						coolGlitch.visible = true;
						new FlxTimer().start(16, function(tmr:FlxTimer)	
						{
							coolGlitch.visible = false;
						});
					case 1280:
						gasterBlasters();
						flipCamUp();
					case 528,1286,1292:
						flipCamUp();
					case 656,1283,1289,1424:
						flipCamDown();
				}
			case 'reality-check':
				switch (curStep)
				{
					case 1232:
						blackthing.visible = true;
					case 1248:
						blackthing.visible = false;
					case 1648:
						FlxG.camera.shake(0.025, 7, null, true, FlxAxes.XY);
						camHUD.shake(0.005, 7, null, true, FlxAxes.XY);
					case 1768:
						FlxG.camera.shake(0.03, 5, null, true, FlxAxes.XY);
						camHUD.shake(0.01, 5, null, true, FlxAxes.XY);
						blackthing.alpha = 0;
						blackthing.visible = true;
			
			
						new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
							{	
								if (blackthing.alpha < 1)
								{
									blackthing.alpha += 0.03;
									swagTimer.reset();
								}
								
							});
					case 1821:
						new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
							{	
								if (blackthing.alpha > 0)
								{
									blackthing.alpha -= 0.1;
									swagTimer.reset();
								}
								
							});
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5, {ease: FlxEase.quadInOut});
						new FlxTimer().start(2 , function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5, {ease: FlxEase.quadInOut});
						});
					case 1264:
						remove(dad);
						dad = new Character(0, 0, 'sans');
						dad.setPosition(162.4, 76.65);
						add(dad);
					case 1815: 
						coolGlitch.visible = true;
						remove(dad);
						dad = new Character(0, 0, 'sansMad');
						dad.setPosition(162.4, 76.65);
						add(dad);
			
						papyrus.setPosition(-298.7, -275.95);
						new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
							{
								papyrus.alpha += 0.1;
			
								if (papyrus.alpha < 0.7)
								{
									swagTimer.reset();
								}
							});
					case 240,752,1721,2220:
						flipCamUp();
					case 503,1247:
						flipCamUp();
						gasterBlasters();
					case 368,1769,2348:
						flipCamDown();
					case 880,616:
						flipCamDown();
						gasterBlasters();
					case 423,687,1391,1519,1835:
						gasterBlasters();
				}
			case 'hallucinations':
				switch (curStep)
				{
					case 938:
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 1.5, {ease: FlxEase.quadInOut});
						new FlxTimer().start(1.5 , function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2, {ease: FlxEase.quadInOut});
						});
					case 1231:
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 1.5, {ease: FlxEase.quadInOut});
						new FlxTimer().start(1.5 , function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2, {ease: FlxEase.quadInOut});
						});
					case 1747:
						FlxTween.tween(FlxG.camera, {zoom: 1.2}, 1.5, {ease: FlxEase.quadInOut});
						new FlxTimer().start(1.5 , function(tmr:FlxTimer)
						{
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2, {ease: FlxEase.quadInOut});
						});
					case 570:
						flipAllShits();
						FlxG.camera.shake(0.025, 3.6, null, true, FlxAxes.XY);
						camHUD.shake(0.005, 3.6, null, true, FlxAxes.XY);
			
			
			
						new FlxTimer().start(3.6, function(swagTimer:FlxTimer)
						{
							if (curStep >= 926)
							{
								FlxTween.tween(FlxG.camera, {angle: 0}, 1, {ease: FlxEase.quadInOut});
								FlxTween.tween(camHUD, {angle: 0}, 1, {ease: FlxEase.quadInOut});
							}
							
								else
							{
								flipAllShits();
								FlxG.camera.shake(0.025, 3.6, null, true, FlxAxes.XY);
								camHUD.shake(0.005, 3.6, null, true, FlxAxes.XY);
							
								swagTimer.reset();
							}
							
						});
					case 1241:
						flipAllShits();
						FlxG.camera.shake(0.025, 3.6, null, true, FlxAxes.XY);
						camHUD.shake(0.005, 3.6, null, true, FlxAxes.XY);

						new FlxTimer().start(3.6, function(swagTimer:FlxTimer)
							{
								
								if (curStep >= 1728)
								{
									FlxTween.tween(FlxG.camera, {angle: 0}, 1, {ease: FlxEase.quadInOut});
									FlxTween.tween(camHUD, {angle: 0}, 1, {ease: FlxEase.quadInOut});
								}
								 else
								{
									flipAllShits();
									FlxG.camera.shake(0.025, 3.6, null, true, FlxAxes.XY);
									camHUD.shake(0.005, 3.6, null, true, FlxAxes.XY);
									swagTimer.reset();
								}
								
							});
					case 1800:
						new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
						{
							dad.alpha -= 0.01;
							iconP2.alpha -= 0.01;
							swagTimer.reset();
						});
				}
		}
		//last hope

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;


	
	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if sys
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			switch(SelectCharacter.selectedChar){
			case "spooky":
			{
				dance = !dance;
				if (dance)
					boyfriend.playAnim('danceRight');
				else
					boyfriend.playAnim('danceLeft');
			}
			default:
				boyfriend.playAnim('idle');
			}
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
