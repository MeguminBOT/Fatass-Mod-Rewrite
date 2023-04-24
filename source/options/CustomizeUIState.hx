package options;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

using StringTools;

class CustomizeUIState extends MusicBeatState
{
	var boyfriend:Character;
	var gf:Character;
	var dad:Character;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	var holdTime:Float = 0;
	var lastBeatHit:Int = -1;

	var STRUM_X = 42;
	var STRUM_X_MIDDLESCROLL = -278;

	var timeBarBG:FlxSprite;
	var timeBar:FlxBar;
	var timeTxt:FlxText;
	var health:Float = 1;

	var judgeCounterTxt:FlxText;
	var healthBar:FlxBar;
	var healthBarBG:FlxSprite;
	var iconP1:HealthIcon;
	var iconP2:HealthIcon;
	var scoreTxt:FlxText;
	var botplayTxt:FlxText;

	var helpTxt:FlxText;
	var selectedObject:FlxObject = null;
	var selectedObjectPositionText:FlxText;
	var prevMouseX:Float = 0;
	var prevMouseY:Float = 0;
	var opm:ObjectPositionManager;

	override public function create()
	{
		FlxG.mouse.visible = true;
		// Cameras
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

		var date = Date.now(); // Get current date and time
		var minutes:String = Std.string(date.getMinutes()); // Get minutes as string
		var seconds:String = Std.string(date.getSeconds()); // Get seconds as string
		if (seconds.length == 1) seconds = "0" + seconds; // Add leading zero if seconds is a single digit number

		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("rubik.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 1;
		timeTxt.borderSize = 2;
		timeTxt.text = minutes + ":" + seconds; // Set text to display minutes and seconds from the users system clock
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		timeBarBG = new FlxSprite(0, timeTxt.y + 8).loadGraphic(Paths.image('uiskins/default/base/timeBar'));
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 1;
		timeBarBG.color = FlxColor.BLACK;

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this, 'health', 0, 2);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 400;
		timeBar.cameras = [camHUD];

		judgeCounterTxt = new FlxText(0, 0);
        judgeCounterTxt.text = 'Perfect Sicks: 233' + '\nSicks: 46 ' + '\nGoods: 1 ' + '\nBads: 0' + '\nShits: 0';
		judgeCounterTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgeCounterTxt.scrollFactor.set();
		judgeCounterTxt.borderSize = 1.25;
		judgeCounterTxt.x = 565;
		judgeCounterTxt.y = 565;
		judgeCounterTxt.cameras = [camHUD];

		healthBarBG = new FlxSprite().loadGraphic(Paths.image('uiskins/default/base/healthBar'));
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;
		healthBarBG.cameras = [camHUD];

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.cameras = [camHUD];

		var iconOffset:Int = 26;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP1.y = healthBar.y - 75;
		iconP1.cameras = [camHUD];

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
		iconP2.y = healthBar.y - 75;
		iconP2.cameras = [camHUD];

		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "Score: 1024000 | Misses: 0 | Rating: Very Good (99.84%) - GFC", 20);
		scoreTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.cameras = [camHUD];

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("rubik.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}
		botplayTxt.cameras = [camHUD];

		add(judgeCounterTxt);
		add(healthBar);
		add(healthBarBG);
		add(iconP1);
		add(iconP2);
		add(scoreTxt);
		add(botplayTxt);
		add(timeBar);
		add(timeBarBG);
		add(timeTxt);

		Conductor.changeBPM(128.0);
		FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);

		helpTxt = new FlxText(0, 0);
		helpTxt.text = 
		"Press and hold down the Left Mouse Button to move an object\nHold Shift+LMB or Shift+MScrollWheel to rotate the object\n\nPress ACCEPT to hide this text";
		helpTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		helpTxt.scrollFactor.set();
		helpTxt.borderSize = 2;
		helpTxt.x = 400;
		helpTxt.y = 250;
		helpTxt.visible = true;
		helpTxt.cameras = [camHUD];
		add(helpTxt);

		selectedObjectPositionText = new FlxText(-100, -100, 100, "");
		selectedObjectPositionText.scrollFactor.x = 0;
		selectedObjectPositionText.scrollFactor.y = 0;
		selectedObjectPositionText.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(selectedObjectPositionText);

		super.create();
		opm = new ObjectPositionManager(judgeCounterTxt, healthBar, healthBarBG, iconP1, iconP2, scoreTxt, botplayTxt, timeTxt, timeBar, timeBarBG);
		opm.loadPositions();
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}

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
		lastBeatHit = curBeat;
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed) {
			var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(camHUD);
			
			if (judgeCounterTxt.overlapsPoint(mousePos)) {
				selectObject(judgeCounterTxt);
			}
			else if (healthBarBG.overlapsPoint(mousePos)) {
				selectObject(healthBarBG);
			}
			else if (healthBar.overlapsPoint(mousePos)) {
				selectObject(healthBar);
			}
			else if (iconP1.overlapsPoint(mousePos)) {
				selectObject(iconP1);
			}
			else if (iconP2.overlapsPoint(mousePos)) {
				selectObject(iconP2);
			}
			else if (scoreTxt.overlapsPoint(mousePos)) {
				selectObject(scoreTxt);
			}
			else if (botplayTxt.overlapsPoint(mousePos)) {
				selectObject(botplayTxt);
			}
			else if (timeTxt.overlapsPoint(mousePos)) {
				selectObject(timeTxt);
			}
			else if (timeBarBG.overlapsPoint(mousePos)) {
				selectObject(timeBarBG);
			}
			else if (timeBar.overlapsPoint(mousePos)) {
				selectObject(timeBar);
			}
			// else if (rating.overlapsPoint(mousePos)) {
			// 	selectObject(rating);
			// }
			// else if (comboNums.overlapsPoint(mousePos)) {
			// 	selectObject(comboNums);
			// }
			else {
				deselectObject();
			}
		}

		if (selectedObject != null) {
			selectedObjectPositionText.text = "X: " + selectedObject.x + "\n" + "Y: " + selectedObject.y;
			selectedObjectPositionText.x = FlxG.mouse.x - 100;
			selectedObjectPositionText.y = FlxG.mouse.y - 100;
			if (FlxG.keys.pressed.SHIFT) {
				selectedObjectPositionText.text = "Angle: " + selectedObject.angle;
				if (FlxG.mouse.justMoved) {
					var deltaAngle:Float = (FlxG.mouse.screenY - prevMouseY) * 5;
					selectedObject.angle += deltaAngle;
					selectedObject.angle = selectedObject.angle % 360;
					moveSelectedObject(0, 0, deltaAngle);
				} else if (FlxG.mouse.wheel != 0) {
					var deltaAngle:Float = FlxG.mouse.wheel * 5;
					selectedObject.angle += deltaAngle;
					selectedObject.angle = selectedObject.angle % 360;
				}
			} else if (FlxG.mouse.justMoved) {
				var deltaX:Float = FlxG.mouse.screenX - prevMouseX;
				var deltaY:Float = FlxG.mouse.screenY - prevMouseY;
				moveSelectedObject(deltaX, deltaY, 0);
			}
		}

		if (FlxG.mouse.justReleased) {
			deselectObject();
			selectedObjectPositionText.text = "";
		}

		if(controls.RESET)
		{
			holdTime = 0;
			opm.loadDefaultPositions();
		}

		if(controls.BACK)
		{
			persistentUpdate = false;
			CustomFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new options.OptionsState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
			FlxG.mouse.visible = false;
		}

		if(controls.ACCEPT)
		{
			holdTime = 0;
			helpTxt.visible = !helpTxt.visible;
		}

		var multP1:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(multP1, multP1);
		iconP1.updateHitbox();

		var multP2:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(multP2, multP2);
		iconP2.updateHitbox();

		Conductor.songPosition = FlxG.sound.music.time;

		prevMouseX = FlxG.mouse.screenX;
		prevMouseY = FlxG.mouse.screenY;
		super.update(elapsed);
	}

	function selectObject(obj:FlxObject):Void {
		selectedObject = obj;
	}

	function deselectObject():Void {
		selectedObject = null;
	}

	private function moveSelectedObject(deltaX:Float, deltaY:Float, deltaAngle:Float):Void {
		if (selectedObject != null) {
			selectedObject.x += deltaX;
			selectedObject.y += deltaY;
			selectedObject.angle += deltaAngle;

			// Save the new position
			var objectName:String = getObjectIdentifier(selectedObject);
			if (objectName != null) {
				var singleObjectPosition:Array<ObjectPosition> = [{
					name: objectName,
					x: selectedObject.x,
					y: selectedObject.y,
					angle: selectedObject.angle
				}];
				opm.updateObjectPosition(singleObjectPosition);
				opm.savePositions();
			}
		}
	}

	private function getObjectIdentifier(obj:FlxObject):String {
		if (obj == judgeCounterTxt) return "judgeCounterTxt";
		else if (obj == healthBarBG) return "healthBarBG";
		else if (obj == healthBar) return "healthBar";
		else if (obj == iconP1) return "iconP1";
		else if (obj == iconP2) return "iconP2";
		else if (obj == scoreTxt) return "scoreTxt";
		else if (obj == botplayTxt) return "botplayTxt";
		else if (obj == timeTxt) return "timeTxt";
		else if (obj == timeBarBG) return "timeBarBG";
		else if (obj == timeBar) return "timeBar";
		// else if (obj == rating) return "rating";
		// else if (obj == comboNums) return "comboNums";
		else return null;
	}
}

typedef ObjectPosition = {
	var name:String;
	var x:Float;
	var y:Float;
	var angle:Float;
}
