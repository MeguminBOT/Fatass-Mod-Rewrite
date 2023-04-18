package options;

import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxStringUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxSave;
import flixel.animation.FlxAnimationController;
import animateatlas.AtlasFrameMaker;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.FlxBasic;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;
import haxe.Json;
import PlayState;
import Note;
import StageData;
import StrumNote;
import Paths;
import Conductor.Rating;
import SkinData;
#if sys
import sys.FileSystem;
import sys.io.File;
#end


using StringTools;

class CustomizeUIState extends MusicBeatState
{
	var boyfriend:Character;
	var gf:Character;
	var dad:Character;

	var coolText:FlxText;
	var rating:FlxSprite;
	var comboNums:FlxSpriteGroup;

	var barPercent:Float = 0;
	var delayMin:Int = 0;
	var delayMax:Int = 500;
	var timeTxt:FlxText;
	var beatText:Alphabet;
	var beatTween:FlxTween;

	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;
	public var notes:FlxTypedGroup<Note>;
	private var strumLine:FlxSprite;

	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	//public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	//public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;
	public var timeBarBG:FlxSprite;
	public var timeBar:FlxBar;
	public var numScore:FlxSprite;
	public var comboSpr:FlxSprite;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	public var scoreTxt:FlxText;

	public var defaultCamZoom:Float = 1.05;

	//Fat-Ass Stuff
	public var laneunderlay:FlxSprite;
	public var laneunderlayOpponent:FlxSprite;
	public var judgeCounterTxt:FlxText;


    /////////////////////////////

	override public function create()
	{
	
		FlxG.mouse.visible = true;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;
		FlxG.camera.scroll.set(120, 130);

		persistentUpdate = true;
		FlxG.sound.pause();



		// Stage
		var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
		add(bg);

		var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);
		if(!ClientPrefs.lowQuality) {
			var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
			stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
			stageLight.updateHitbox();
			add(stageLight);
			var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
			stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
			stageLight.updateHitbox();
			stageLight.flipX = true;
			add(stageLight);

			var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			add(stageCurtains);
		}

		// Characters
		gf = new Character(400, 130, 'gf');
		gf.x += gf.positionArray[0];
		gf.y += gf.positionArray[1];
		gf.scrollFactor.set(0.95, 0.95);
		boyfriend = new Character(770, 100, 'bf', true);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		dad = new Character(100, 100, 'dad');
		dad.x += dad.positionArray[0];
		dad.y += dad.positionArray[1];
		add(gf);
		add(boyfriend);
		add(dad);

        strumLine = new FlxSprite((ClientPrefs.middleScroll) ? STRUM_X_MIDDLESCROLL : STRUM_X + ClientPrefs.strumlineOffsetX, 50 + ClientPrefs.strumlineOffsetY).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150 + ClientPrefs.strumlineOffsetY;
		strumLine.scrollFactor.set();

		//Fat-Ass Mod: Lane Underlay
		laneunderlayOpponent = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2);
		laneunderlayOpponent.alpha = 0.5;
		laneunderlayOpponent.color = FlxColor.BLACK;
		laneunderlayOpponent.scrollFactor.set();

		laneunderlay = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2);
		laneunderlay.alpha = 0.5;
		laneunderlay.color = FlxColor.BLACK;
		laneunderlay.scrollFactor.set();

		//Fat-Ass Mod: Judgement Counter
		judgeCounterTxt = new FlxText(0, 0);
        judgeCounterTxt.text = 'Perfect Sicks: 233' + '\nSicks: 46 ' + '\nGoods: 1 ' + '\nBads: 0' + '\nShits: 0';
		judgeCounterTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgeCounterTxt.scrollFactor.set();
		judgeCounterTxt.borderSize = 1.25;
		judgeCounterTxt.x = 565;
		judgeCounterTxt.y = 565;
		add(judgeCounterTxt);

		if (!ClientPrefs.middleScroll)
		{
			add(laneunderlayOpponent);
		}
		add(laneunderlay);
		
        timeBarBG = new FlxSprite().loadGraphic(Paths.image('uiskins/default/base/timeBar'));
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
        add(timeBarBG);

		timeBar = new FlxBar(0, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this, 'barPercent', delayMin, delayMax);
		timeBar.scrollFactor.set();
		timeBar.screenCenter(X);
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
        add(timeBar);

		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("rubik.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.borderSize = 2;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;
        add(timeTxt);

        //strumLineNotes = new FlxTypedGroup<StrumNote>();
		//add(strumLineNotes);
		trace (opponentStrums);
		trace (playerStrums);
		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();
    
        healthBarBG = new FlxSprite().loadGraphic(Paths.image('uiskins/default/base/healthBar'));
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, (LEFT_TO_RIGHT), Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
		healthBar.scrollFactor.set();
		add(healthBar);

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		add(iconP2);
		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "Score: 1024000 | Misses: 0 | Rating: Very Good (99.84%) - GFC", 20);
		scoreTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		add(scoreTxt);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("rubik.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

        laneunderlay.x = playerStrums.members[0].x - 25;
        laneunderlayOpponent.x = opponentStrums.members[0].x - 25;
        laneunderlay.screenCenter(Y);
        laneunderlayOpponent.screenCenter(Y);

		Conductor.changeBPM(128.0);
		FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);

		
        rating = new FlxSprite().loadGraphic(Paths.image('uiskins/default/base/sick'));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
        add(rating);

		comboSpr = new FlxSprite().loadGraphic(Paths.image('uiskins/default/base/combo'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = FlxG.random.int(200, 300);
		comboSpr.velocity.y -= FlxG.random.int(140, 160);
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];
		comboSpr.y += 60;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

        comboNums = new FlxSpriteGroup();
  
        add(comboNums);

		var seperatedScore:Array<Int> = [];
		for (i in 0...3)
		{
			seperatedScore.push(FlxG.random.int(0, 9));
		}
        var daLoop:Int = 0;
        for (i in seperatedScore)
        {
            numScore = new FlxSprite(43 * daLoop).loadGraphic(Paths.image('uiskins/default/base/num' + i));
 
            numScore.screenCenter();
            numScore.x = coolText.x + (43 * daLoop) - 90;
            numScore.y += 80;

            numScore.x += ClientPrefs.comboOffset[2];
            numScore.y -= ClientPrefs.comboOffset[3];

            numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
            daLoop++;
		}
				//strumLineNotes.cameras = [camHUD];
		//grpNoteSplashes.cameras = [camHUD];
		//notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		rating.cameras = [camHUD];
		comboSpr.cameras = [camHUD];
		comboNums.cameras = [camHUD];
		numScore.cameras = [camHUD];
		laneunderlay.cameras = [camHUD];
		laneunderlayOpponent.cameras = [camHUD];
		judgeCounterTxt.cameras = [camOther];
		super.create();
	}

    public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
		healthBar.updateBar();
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	var holdTime:Float = 0;
	var onComboMenu:Bool = true;
	var holdingObjectType:Null<Bool> = null;

	var startMousePos:FlxPoint = new FlxPoint();
	var startComboOffset:FlxPoint = new FlxPoint();

	override public function update(elapsed:Float)
	{
		botplaySine += 180 * elapsed;
        botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		if(controls.BACK)
		{
			if(zoomTween != null) zoomTween.cancel();
			if(beatTween != null) beatTween.cancel();

			persistentUpdate = false;
			CustomFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new options.OptionsState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
			FlxG.mouse.visible = false;
		}

		Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}

	var zoomTween:FlxTween;
	var lastBeatHit:Int = -1;
	override public function beatHit()
	{
		super.beatHit();

		if(lastBeatHit == curBeat)
		{
			return;
		}

		if(curBeat % 2 == 0)
		{
			boyfriend.dance();
			gf.dance();
		}
		
		if(curBeat % 4 == 2)
		{
			FlxG.camera.zoom = 1.15;

			if(zoomTween != null) zoomTween.cancel();
			zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
				{
					zoomTween = null;
				}
			});

			beatText.alpha = 1;
			beatText.y = 320;
			beatText.velocity.y = -150;
			if(beatTween != null) beatTween.cancel();
			beatTween = FlxTween.tween(beatText, {alpha: 0}, 1, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
				{
					beatTween = null;
				}
			});
		}

		lastBeatHit = curBeat;
	}
}
