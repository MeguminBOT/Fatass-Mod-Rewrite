package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var opponentStrums:Bool = true;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var shaders:Bool = true;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var controllerMode:Bool = false;
	public static var hitsoundVolume:Float = 0;
	public static var pauseMusic:String = 'NONE';
	public static var checkForUpdates:Bool = true;
	public static var comboStacking = true;
	public static var discordRPC:String = 'Normal';
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'hiddenmode' => false,
		'mirrormode' => false,
		'opponentplay' => false,
		'doubleplay' => false,
		'doubleplaytype' => 'Player'
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var perfectWindow:Int = 22;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Fat-Ass Features
	public static var underlay:Float = 0;
	public static var hitsoundType:String = 'default';
	public static var inputSystem:String = "Etterna";
	public static var inputComplexity:String = "Normal";
	public static var customNoteSound:Bool = true;
	public static var customSoundEvent:Bool = true;
	public static var customMechanicEvent:Bool = true;
	public static var customStrumPlacement:Bool = true;
	public static var customSongScripts:Bool = true;
	public static var noteSkin:String = 'Rhythm Engine';
	public static var uiSkin:String = 'Rhythm Engine';
	public static var judgeCounter:Bool = true;
	public static var strumlineOffsetY:Float = 0;
	public static var strumlineOffsetX:Float = 0;
	public static var hideIcons:Bool = false;
	public static var staticHUD:Bool = false;
	public static var disableStages:Bool = false;
	public static var popupScoreLocked:Bool = false;
	public static var cacheOnGPU:Bool = false;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [D, LEFT],
		'note_down'		=> [F, DOWN],
		'note_up'		=> [J, UP],
		'note_right'	=> [K, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.opponentStrums = opponentStrums;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.shaders = shaders;
		FlxG.save.data.framerate = framerate;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.perfectWindow = perfectWindow;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.pauseMusic = pauseMusic;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.comboStacking = comboStacking;

		//Fat-Ass Features
		FlxG.save.data.underlay = underlay;
		FlxG.save.data.hitsoundType = hitsoundType;
		FlxG.save.data.inputSystem = inputSystem;
		FlxG.save.data.inputComplexity= inputComplexity;
		FlxG.save.data.customNoteSound = customNoteSound;
		FlxG.save.data.customSoundEvent = customSoundEvent;
		FlxG.save.data.customMechanicEvent = customMechanicEvent;
		FlxG.save.data.customStrumPlacement = customStrumPlacement;
		FlxG.save.data.customSongScripts = customSongScripts;
		FlxG.save.data.noteSkin = noteSkin;
		FlxG.save.data.uiSkin = uiSkin;
		FlxG.save.data.judgeCounter = judgeCounter;
		FlxG.save.data.strumlineOffsetY = strumlineOffsetY;
		FlxG.save.data.strumlineOffsetX = strumlineOffsetX;
		FlxG.save.data.hideIcons = hideIcons;
		FlxG.save.data.staticHUD = staticHUD;
		FlxG.save.data.disableStages = disableStages;
		FlxG.save.data.popupScoreLocked = popupScoreLocked;
		FlxG.save.data.cacheOnGPU = cacheOnGPU;
		
		// Better Discord RPC
		FlxG.save.data.discordRPC = discordRPC;
		#if desktop  // Putting this here so the game does it only when saved and not on as onChange (Giving proper time to the rpc to shutdown)  - Nex
		if (discordRPC == 'Deactivated' && DiscordClient.isInitialized) DiscordClient.shutdown();
		else if (discordRPC != 'Deactivated' && !DiscordClient.isInitialized) DiscordClient.initialize();
		#end

		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('rhythmengine_controls_v2', CoolUtil.getSavePath()); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.opponentStrums != null) {
			opponentStrums = FlxG.save.data.opponentStrums;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.shaders != null) {
			shaders = FlxG.save.data.shaders;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.perfectWindow != null) {
		perfectWindow = FlxG.save.data.perfectWindow;
		}
		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}
		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}
		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.controllerMode != null) {
			controllerMode = FlxG.save.data.controllerMode;
		}
		if(FlxG.save.data.hitsoundVolume != null) {
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		}
		if(FlxG.save.data.pauseMusic != null) {
			pauseMusic = FlxG.save.data.pauseMusic;
		}
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}
		if (FlxG.save.data.checkForUpdates != null)
		{
			checkForUpdates = FlxG.save.data.checkForUpdates;
		}
		if (FlxG.save.data.comboStacking != null) {
			comboStacking = FlxG.save.data.comboStacking;
		}
		if(FlxG.save.data.discordRPC != null)
			discordRPC = FlxG.save.data.discordRPC;

		// Fat-Ass Features
		if (FlxG.save.data.underlay != null)
		{
				underlay = FlxG.save.data.underlay;
		}
		if(FlxG.save.data.hitsoundType != null) 
		{
				hitsoundType = FlxG.save.data.hitsoundType;
		}
		if(FlxG.save.data.inputSystem != null)
		{
			inputSystem = FlxG.save.data.inputSystem;
		}
		if(FlxG.save.data.inputComplexity != null)
		{
			inputComplexity = FlxG.save.data.inputComplexity;
		}
		if(FlxG.save.data.customNoteSound != null)
		{
			customNoteSound = FlxG.save.data.customNoteSound;
		}
		if(FlxG.save.data.customSoundEvent != null)
		{
			customSoundEvent = FlxG.save.data.customSoundEvent;
		}
		if(FlxG.save.data.customMechanicEvent != null)
		{
			customMechanicEvent = FlxG.save.data.customMechanicEvent;
		}
		if(FlxG.save.data.customStrumPlacement != null)
		{
			customStrumPlacement = FlxG.save.data.customStrumPlacement;
		}
		if(FlxG.save.data.customSongScripts != null)
		{
			customSongScripts = FlxG.save.data.customSongScripts;
		}
		if(FlxG.save.data.noteSkin != null)
		{
			noteSkin = FlxG.save.data.noteSkin;
		}
		if(FlxG.save.data.uiSkin != null)
		{
			uiSkin = FlxG.save.data.uiSkin;
		}
		if(FlxG.save.data.judgeCounter != null)
		{
			judgeCounter = FlxG.save.data.judgeCounter;
		}
		if(FlxG.save.data.strumlineOffsetY != null)
		{
			strumlineOffsetY = FlxG.save.data.strumlineOffsetY;
		}
		if(FlxG.save.data.strumlineOffsetX != null)
		{
			strumlineOffsetX = FlxG.save.data.strumlineOffsetX;
		}
		if(FlxG.save.data.hideIcons != null)
		{
			hideIcons = FlxG.save.data.hideIcons;
		}
		if(FlxG.save.data.staticHUD != null)
		{
			staticHUD = FlxG.save.data.staticHUD;
		}
		if(FlxG.save.data.disableStages != null)
		{
			disableStages = FlxG.save.data.disableStages;
		}
		if(FlxG.save.data.popupScoreLocked != null)
		{
			popupScoreLocked = FlxG.save.data.popupScoreLocked;
		}
		if(FlxG.save.data.cacheOnGPU != null) {
			cacheOnGPU = FlxG.save.data.cacheOnGPU;
		}

		var save:FlxSave = new FlxSave();
		save.bind('rhythmengine_controls_v2', CoolUtil.getSavePath());
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
