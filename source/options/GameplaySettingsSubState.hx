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
		description = 'Options that directly affects your gameplay';
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
	
		var option:Option = new Option('Accuracy Complexity Level',
			"Changes the complexity level of accuracy calculations, \nOnly works if Accuracy System is Etterna,\nHigh is the most accurate but also the harshest, purely based of Etterna.\nNormal is a mix between Psych default and Kade's Complex Accuracy.",
			'inputComplexity',
			'string',
			'High',
			['High', 'Normal']);
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
			'default',
			['default', 
			'default with kick',
			'ping pong',
			'click',
			'tsuzumi drum',
			'drop',
			'kick muddy',
			'kick bassy1',
			'kick bassy2',
			'kick bassy3',
			'osu soft',
			'osu normal']);
		addOption(option);
		option.onChange = onChangeHitsoundType;

		var option:Option = new Option('Custom Note Sounds',
			"Uncheck this if you don't want Custom Notes to play sounds.\nOnly works on mods optimized for Rhythm Engine",
			'customNoteSound',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Custom Sound Events',
			"Uncheck this if you don't want charts to play sounds.\nOnly works on mods optimized for Rhythm Engine",
			'customSoundEvent',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Custom Mechanic Events',
			"Uncheck this if you don't want custom mechanics like Unown in Monochrome.\nOnly works on mods optimized for Rhythm Engine",
			'customMechanicEvent',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Custom Strumline Placement',
			"Uncheck this if you don't want charts to move the strumline.\nThis is only for keeping the strumline on the right/middle(If middleScroll).\nDoes not disable any displacements of the strumline.\nOnly works on mods optimized for Rhythm Engine",
			'customStrumPlacement',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Custom Song Scripts',
			"Uncheck this if you don't want charts to use custom scripts at all.\nDoes only affect scripts that aren't needed.\nOnly works on mods optimized for Rhythm Engine",
			'customSongScripts',
			'bool',
			true);
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
		FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.hitsoundType), ClientPrefs.hitsoundVolume);
	}

	function onChangeHitsoundType()
	{
		FlxG.sound.play(Paths.sound('hitsounds/' + ClientPrefs.hitsoundType), ClientPrefs.hitsoundVolume);
	}
}

