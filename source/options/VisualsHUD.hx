package options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VisualsHUD extends BaseOptionsMenu
{
	public function new()
	{
		title = 'UI Visuals';
		description = 'Options for Gameplay UI';
		rpcTitle = 'UI Visuals Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('UI Skin:',
			"Changes the look of the UI. Affects Combo, Ratings, Healthbar and Timebar.",
			'uiSkin',
			'string',
			'Rhythm Engine',
			['Default', 
			'Rhythm Engine',
			'StepMania Classic']);
		addOption(option);

		var option:Option = new Option('Judgement Counter',
			'Displays how many hits you got of each judgement rating',
			'judgeCounter',
			'bool',
		false);
		addOption(option);

		var option:Option = new Option('Lock Rating/Combo',
			"If checked, locks the popup of combo and ratings to the x-axis of the strumline.",
			'popupScoreLocked',
			'bool',
		false);
		addOption(option);

		var option:Option = new Option('Static HUD',
			"If checked, the HUD won't be affected by events that uses camHUD camera. May break some charts.\nAffects all objects that can be moved using CustomizeUI",
			'staticHUD',
			'bool',
		false);
		addOption(option);

		var option:Option = new Option('Hide Healtbar Icons',
			'If checked, hides icons.',
			'hideIcons',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}
