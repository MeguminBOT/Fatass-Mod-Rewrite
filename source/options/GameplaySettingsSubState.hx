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

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard. Can be buggy with some controllers.',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'Centers the playfield in the middle of the screen',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'Hides the opponents notes.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Lane Transparency',
			"Changes the transparency of the area behind the playfield\n0 = No background, 1 = Completely black.",
			'underlay',
			'float',
		true);
		option.displayFormat = '%v';
		option.scrollSpeed = 100;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.minValue = 0;
		option.maxValue = 1;
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"You won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"Pressing Reset won't do anything.",
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Accuracy System',
			'Changes the accuracy system.\nEtterna Accuracy System uses "Wife3" Scoring/Accuracy, which is the same as Complex Accuracy in Kade Engine.',
			'inputSystem',
			'string',
			'Etterna',
			['Etterna', 'PsychEngine']);
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Plays a sound whenever you hit a note. \nLike in osu!',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Hitsound Type:', //To Do: Find a easier way to handle this, perhaps adding something that hides the first part of the file name aswell.
			"What kind hitsound would you prefer?",
			'hitsoundType',
			'string',
			'hitsound_default',
			['hitsound_default', 
			'hitsound_default with kick',
			'hitsound_ping pong',
			'hitsound_click',
			'hitsound_tsuzumi drum',
			'hitsound_drop',
			'hitsound_kick muddy',
			'hitsound_kick bassy1',
			'hitsound_kick bassy2',
			'hitsound_kick bassy3',
			'hitsound_osu default soft',
			'hitsound_osu default normal']);
		addOption(option);
		option.onChange = onChangeHitsoundType;

		var option:Option = new Option('Note Skin:', //To Do: Find a easier way to handle this, perhaps adding something that hides the first part of the file name aswell.
			"What kind hitsound would you prefer?",
			'noteskinType',
			'string',
			'Fatass',
			['Fatass', 
			'FNF']);
		addOption(option);
	
		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit the notes\nHigher values mean you have to hit later.',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Perfect Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Perfect Sick!" in milliseconds.\nPerfect Sicks are blue.',
			'perfectWindow',
			'int',
			22);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 4.5;
		option.maxValue = 22;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 9;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 18;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 27;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound(ClientPrefs.hitsoundType), ClientPrefs.hitsoundVolume);
	}

	function onChangeHitsoundType()
	{
		FlxG.sound.play(Paths.sound(ClientPrefs.hitsoundType), ClientPrefs.hitsoundVolume);
	}
}