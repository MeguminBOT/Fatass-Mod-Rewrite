/*----------- ModularUI -----------*/
/*----------- CustomizeUI Menu -----------*/

/*----------- by AutisticLulu -----------*/
/*----------- for Rhythm Engine -----------*/

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
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

using StringTools;

typedef ObjectPosition = {
	var name:String;
	var x:Float;
	var y:Float;
	var angle:Float;
}

class CustomizeUIState extends MusicBeatState
{
	// Cameras.
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;

	// For character idle animations.
	var lastBeatHit:Int = -1;

	// Characters.
	var boyfriend:Character;
	var gf:Character;
	var dad:Character;

	// Stage.
	var stageBG:BGSprite;
	var stageFront:BGSprite;

	// Copied vars and offsets from PlayState to ensure correct positions.
	var STRUM_X = 42;
	var STRUM_X_MIDDLESCROLL = -278;
	var iconOffset:Int = 26;
	var multP1:Float;
	var multP2:Float;
	var health:Float = 1;
	
	// Help Text.
	var helpBG:FlxSprite;
	var helpTxt:FlxText;

	// UI Tab Box.
	var UI_box:FlxUITabMenu;
	var tipTxt:FlxText;
	var healthBarLinkToggle:FlxUICheckBox;
	var timeBarLinkToggle:FlxUICheckBox;
	var iconLinkToggle:FlxUICheckBox;

	// Bools for linking movable objects.
	var healthBarLinked:Bool = false;
	var timeBarLinked:Bool = false;
	var iconLinked:Bool = false;

	// Moveable Objects.
	var judgeCounterTxt:FlxText;
	var healthBar:FlxBar;
	var healthBarBG:FlxSprite;
	var iconP1:HealthIcon;
	var iconP2:HealthIcon;
	var scoreTxt:FlxText;
	var botplayTxt:FlxText;
	var timeTxt:FlxText;
	var timeBarBG:FlxSprite;
	var timeBar:FlxBar;

	// Handling of Objects.
	var objectName:String;
	var selectedObject:FlxObject = null;
	var selectedObjectPositionText:FlxText;
	var singleObjectPosition:Array<ObjectPosition>;
	
	// Mouse Variables.
	var mousePos:FlxPoint;
	var prevMouseX:Float = 0;
	var prevMouseY:Float = 0;
	var deltaX:Float;
	var deltaY:Float;
	var deltaAngle:Float;

	// Instance of ModularUI's Object Position Manager
	var opm:ObjectPositionManager;

	override public function create()
	{
		// Show mouse pointer.
		FlxG.mouse.visible = true;

		// Pause Main Menu Music
		FlxG.sound.pause();

		// Force updating
		persistentUpdate = true;

		// Camera Setup.
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

		// Week 1 Stage.
		stageBG = new BGSprite('stageback', -600, -200, 0.9, 0.9);
		add(stageBG);

		stageFront = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);

		// Characters.
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

		// Get current date and time.
		var date = Date.now();
		var minutes:String = Std.string(date.getMinutes());
		var seconds:String = Std.string(date.getSeconds());
		if (seconds.length == 1) seconds = "0" + seconds; // Add leading zero if seconds is a single digit number.

		// Timebar Text Object.
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("rubik.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 1;
		timeTxt.borderSize = 2;
		timeTxt.text = minutes + ":" + seconds; // Sets the timebar text to display minutes and seconds from the users system clock.
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;
		timeTxt.cameras = [camHUD];

		// Timebar Sprite Object.
		timeBarBG = new FlxSprite(0, timeTxt.y + 8).loadGraphic(Paths.image('uiskins/default/base/timeBar'));
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 1;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.cameras = [camHUD];

		// Timebar Object.
		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this, 'health', 0, 2);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 400;
		timeBar.cameras = [camHUD];

		// Judgement Counter Object.
		judgeCounterTxt = new FlxText(0, 0);
		judgeCounterTxt.text = 'Perfects: 233' + '\nSicks: 46 ' + '\nGoods: 1 ' + '\nBads: 0' + '\nShits: 0';
		judgeCounterTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgeCounterTxt.scrollFactor.set();
		judgeCounterTxt.borderSize = 1.25;
		judgeCounterTxt.x = 565;
		judgeCounterTxt.y = 565;
		judgeCounterTxt.cameras = [camHUD];

		// Healthbar Sprite Object.
		healthBarBG = new FlxSprite().loadGraphic(Paths.image('uiskins/default/base/healthBar'));
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;
		healthBarBG.cameras = [camHUD];

		// Healthbar Object.
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.cameras = [camHUD];

		// BF Icon Object.
		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP1.y = healthBar.y - 75;
		iconP1.cameras = [camHUD];

		// Dad Icon Object.
		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
		iconP2.y = healthBar.y - 75;
		iconP2.cameras = [camHUD];

		// Score Text Object.
		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "Score: 1024000 | Misses: 0 | Rating: Very Good (99.84%) - GFC", 20);
		scoreTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.cameras = [camHUD];

		// Botplay Text Object.
		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("rubik.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}
		botplayTxt.cameras = [camHUD];

		// Add objects to the screen.
		add(timeBarBG);
		add(timeBar);
		add(timeTxt);
		add(healthBarBG);
		add(healthBar);
		add(iconP1);
		add(iconP2);
		add(scoreTxt);
		add(botplayTxt);
		add(judgeCounterTxt);

		// Darken the screen to make text more readable.
		helpBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		helpBG.alpha = 0.7;
		helpBG.visible = true;
		helpBG.cameras = [camHUD];
		add(helpBG);

		// Help text on how to use the ModularUI.
		helpTxt = new FlxText(0, 0);
		helpTxt.text = 
		"How to use:
		\nPress and hold down the Left Mouse Button to move an object.\nHold Shift+LMB or Shift+MScrollWheel to rotate the object.\nPress ENTER to get started.
		\nNOTE: Currently, if you rotate healthbar,\nthen character icons will be hidden due to temporary issue.
		\nYou can toggle this text by pressing ENTER again.
		\nPressing TAB will toggle the UI Menu on the right side.\nMoving objects are disabled when the TAB menu or this text is shown.";
		helpTxt.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		helpTxt.scrollFactor.set();
		helpTxt.borderSize = 2;
		helpTxt.x = 400;
		helpTxt.y = 250;
		helpTxt.visible = true;
		helpTxt.cameras = [camHUD];
		add(helpTxt);

		// Text showing current position.
		selectedObjectPositionText = new FlxText(-100, -100, 100, "");
		selectedObjectPositionText.scrollFactor.x = 0;
		selectedObjectPositionText.scrollFactor.y = 0;
		selectedObjectPositionText.setFormat(Paths.font("rubik.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(selectedObjectPositionText);

		// Create UI Tab Box.
		var tabs = [
			{name: "General", label: 'General'},
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(300, 425);
		UI_box.x = 950;
		UI_box.y = 25;
		UI_box.scrollFactor.set();
		UI_box.visible = true;

		tipTxt = new FlxText(UI_box.x, UI_box.y + UI_box.height + 8, 0, "", 16);
		tipTxt.setFormat(Paths.font("rubik.ttf"), 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipTxt.borderSize = 2;
		tipTxt.scrollFactor.set();
		tipTxt.text = "'Enter' toggles the help text and UI Box.\n'TAB' toggles the UI Box and this text.\n'R' will reset to default positions";
		add(tipTxt);

		add(UI_box);
		addGeneralUI();

		// Miscellaneous.
		reloadHealthBarColors();
		Conductor.changeBPM(128.0);
		FlxG.sound.playMusic(Paths.music('offsetSong'), 1, true);

		super.create();

		// Create instance of ModularUI's Object Position Manager.
		opm = new ObjectPositionManager(judgeCounterTxt, healthBar, healthBarBG, iconP1, iconP2, scoreTxt, botplayTxt, timeTxt, timeBar, timeBarBG);
		opm.loadPositions(); // Loads positions from config/user_positions.json.
	}

	// UI Tab Box items
	function addGeneralUI():Void
	{
		// Tab setup.
		var tab_group_general = new FlxUI(null, UI_box);
		tab_group_general.name = "General";

		// Text for Upscroll & Downscroll Presets
		var defaultPresetTxt:FlxText = new FlxText(10, 10, 150, "Load Default Presets:");
		tab_group_general.add(defaultPresetTxt);

		// Button to force load default preset for Upscroll
		var upscrollPreset:FlxButton = new FlxButton(10, 25, "Upscroll", function() {
			opm.loadUpscrollPositions();
		});
		tab_group_general.add(upscrollPreset);

		// Button to force load default preset for Downscroll
		var downscrollPreset:FlxButton = new FlxButton(10, 50, "Downscroll", function() {
			opm.loadDownscrollPositions();
		});
		tab_group_general.add(downscrollPreset);

		// Checkbox to link Healthbar and Healthbar Sprite together.
		healthBarLinkToggle = new FlxUICheckBox(10, 75, null, null, "Link Healthbar Objects", 100,
			function() {
				healthBarLinked = healthBarLinkToggle.checked;
			}
		);
		tab_group_general.add(healthBarLinkToggle);

		// Checkbox to link Timebar and Timebar Sprite together.
		timeBarLinkToggle = new FlxUICheckBox(10, 100, null, null, "Link Timebar Objects", 100,
			function() {
				timeBarLinked = timeBarLinkToggle.checked;
			}
		);
		tab_group_general.add(timeBarLinkToggle);

		// Checkbox to link Dad and BF icons together.
		iconLinkToggle = new FlxUICheckBox(10, 125, null, null, "Link Icon Objects", 100,
			function() {
				iconLinked = iconLinkToggle.checked;
			}
		);
		tab_group_general.add(iconLinkToggle);

		// Text showing upcoming features.
		var upcomingFeatures:FlxText = new FlxText(10, 300, 250, "");
		upcomingFeatures.text = "Planned features include:\n* Resize UI\n* Change shape of time/healthbar\nProper Icons/Ratings/Combo support\n* Splitting scoreTxt into multiple objects";
		tab_group_general.add(upcomingFeatures);

		UI_box.addGroup(tab_group_general);
	}

	// Sets healthbar colors to Dad/BF icons.
	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}

	// Characters idle dance.
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
			dad.dance();
		}
		lastBeatHit = curBeat;
	}

	override public function update(elapsed:Float)
	{
		// If the UI Tab Box is hidden and the user presses the left mouse button.
		if (!UI_box.visible && FlxG.mouse.justPressed) { 

			// Get mouse pointer's position on the screen.
			mousePos = FlxG.mouse.getScreenPosition(camHUD); 
			
			/* There's probably a much more efficient way to handle this, but it works for now. */
			// Determine which object to select.
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
			else {
				deselectObject();
			}
		}

		// Check if there's a selected object
		if (selectedObject != null) {

			// Display the selected object's current position.
			selectedObjectPositionText.text = "X: " + selectedObject.x + "\n" + "Y: " + selectedObject.y;

			// Set the position of the text to follow the mouse cursor.
			selectedObjectPositionText.x = FlxG.mouse.x - 100;
			selectedObjectPositionText.y = FlxG.mouse.y - 100;

			// While SHIFT key is pressed, rotation functionality is enabled.
			if (FlxG.keys.pressed.SHIFT) {

				// Display the selected object's current angle.
				selectedObjectPositionText.text = "Angle: " + selectedObject.angle;

				// Rotate the selected object by moving the mouse.
				if (FlxG.mouse.justMoved) {
					deltaAngle = (FlxG.mouse.screenY - prevMouseY) * 5;
					selectedObject.angle += deltaAngle;
					selectedObject.angle = selectedObject.angle % 360;
					moveSelectedObject(0, 0, deltaAngle);

				// Rotate the selected object using mouse scroll wheel.
				} else if (FlxG.mouse.wheel != 0) {
					deltaAngle = FlxG.mouse.wheel * 5;
					selectedObject.angle += deltaAngle;
					selectedObject.angle = selectedObject.angle % 360;
				}

			// Move the selected object by moving the mouse.	
			} else if (FlxG.mouse.justMoved) {
				deltaX = FlxG.mouse.screenX - prevMouseX;
				deltaY = FlxG.mouse.screenY - prevMouseY;
				moveSelectedObject(deltaX, deltaY, 0);
			}
		}

		// If "Link Healthbar Objects" is checked, move both the Healthbar and Healthbar Sprite at the same time.
		if (healthBarLinked) {
			healthBar.x = healthBarBG.x + 4;
			healthBar.y = healthBarBG.y + 4;
			healthBar.angle = healthBarBG.angle;
		}

		// If "Link Timebar Objects" is checked, move both the Timebar and Timebar Sprite at the same time.
		if (timeBarLinked) {
			timeBar.x = timeBarBG.x + 4;
			timeBar.y = timeBarBG.y + 4;
			timeBar.angle = timeBarBG.angle;
		}

		// If "Link Icon Objects" is checked, move Dad and BF icons at the same time.
		if (iconLinked) {
			iconP1.x = iconP2.x + 104;
			iconP1.y = iconP2.y;
			iconP1.angle = iconP2.angle;
		}

		// When the user releases left mouse button.
		if (FlxG.mouse.justReleased) {

			// Deselect object
			deselectObject();

			// Stop displaying the selected object's current position.
			selectedObjectPositionText.text = "";
		}

		// When the user presses the RESET button.
		if(controls.RESET) {

			// Get default positions from JSON.
			opm.loadDefaultPositions();
		}

		// When the user presses the BACK button.
		if(controls.BACK) {

			// Go back to the options menu.
			persistentUpdate = false;
			CustomFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new options.OptionsState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
			FlxG.mouse.visible = false;
		}

		// When the user presses the ENTER key.
		if(FlxG.keys.justPressed.ENTER) {

			// Toggle Help Information.
			helpBG.visible = !helpBG.visible;
			helpTxt.visible = !helpTxt.visible;
		}

		// When the user presses the TAB key.
		if(FlxG.keys.justPressed.TAB) {

			// Toggle the UI Tab Box.
			UI_box.visible = !UI_box.visible;
			tipTxt.visible = !tipTxt.visible;
		}

		// Positioning for BF icon based on health.
		multP1 = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(multP1, multP1);
		iconP1.updateHitbox();

		// Positioning for Dad icon based on health.
		multP2 = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(multP2, multP2);
		iconP2.updateHitbox();

		/* Set the previous mouse position to be the current mouse position before any updates are made. 
		This is done so that we can calculate the change in the mouse position from the previous frame to the current frame. */
		prevMouseX = FlxG.mouse.screenX;
		prevMouseY = FlxG.mouse.screenY;

		// For the onBeat function.
		Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	// Select Object function.
	function selectObject(obj:FlxObject):Void {
		selectedObject = obj;
	}

	// Deselect Object function.
	function deselectObject():Void {
		selectedObject = null;
	}

	// Move Object Function.
	private function moveSelectedObject(deltaX:Float, deltaY:Float, deltaAngle:Float):Void {

		// Check if there's a selected object.
		if (selectedObject != null) {

			// Move the object by the given deltas.
			selectedObject.x += deltaX;
			selectedObject.y += deltaY;
			selectedObject.angle += deltaAngle;

			// Save the new position of the object.
			objectName = getObjectIdentifier(selectedObject);
			if (objectName != null) {

				// Create an array for a single object to store the updated position of the object.
				singleObjectPosition = [{
					name: objectName,
					x: selectedObject.x,
					y: selectedObject.y,
					angle: selectedObject.angle
				}];

				// Update the position of the object in the Object Position Manager.
				opm.updateObjectPosition(singleObjectPosition);

				// Save position to config/user_positions.json.
				opm.savePositions();
			}
		}
	}

	/* There's probably a much more efficient way to handle this, but it works for now. */
	// Identify the object.
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
		else return null;
	}
}

