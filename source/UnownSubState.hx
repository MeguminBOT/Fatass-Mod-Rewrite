package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.FlxCamera;

using StringTools;

class UnownSubState extends MusicBeatSubstate
{
	var selectedWord:String;
	var realWord:String = '';
	var position:Int = 0;
	var words:Array<String> = [
		'IM DEAD',
		'EERIE NOISE',
		'LEAVE HURRY',
		'HE DIED',
		'DYING',
		'GOLD',
		'SILVER',
		'DONT BELONG',
		'ABANDONED',
		'NOT WANTED',
		'TIRESOME',
		'USELESS',
		'GRUESOME',
		'NIGHTMARE',
		'GET OUT',
		'HOPELESS',
		'NOT WELCOME',
		'NO MORE',
		'CAN YOU SEE',
		'WHERE',
		'HELP',
		'GOODBYE',
		'IT FAILED',
		'I SEE YOU',
		'FUTILE',
		'FORSAKEN',
		'CEASE',
		'GIVE UP',
		'HIDEOUS',
		'ABOMINABLE',
		'SUFFER',
		'LOST',
		'FORGOTTEN',
		'NEVER ENDING',
		'NIGHTMARE',
		'MEMORIES',
		'HURRY'
	];
	var onePercentWords:Array<String> = [
		'NICE COCK',
		'SUS AF',
		'BOOB LOL',
		'LMAO GOTTEM',
		'RATIO',
		"GOO",
		'POGGERS',
		'BUSSY',
		'RUN STREAMER'
	];
	var zeropointonePercentWords:Array<String> = [
		'HI SHUBS',
		'HI ASH',
		'HI LULU',
		'HI LILY',
		'HI ROXBEIGE',
		'MY BUSSY IS POGGING',
		'ZEROPOINTONEWORD'
	];

	var lines:FlxTypedGroup<FlxSprite>;
	var unowns:FlxTypedSpriteGroup<FlxSprite>;
	public var win:Void->Void = null;
	public var lose:Void->Void = null;
	var timer:Int = 10;
	var timerTxt:FlxText;
	public function new(theTimer:Int = 15, word:String = '')
	{
		timer = theTimer;
		super();
		var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
		overlay.alpha = 0.4;
		add(overlay);

		if (FlxG.random.int(0, 100) == 50)
			words = onePercentWords;

		if (FlxG.random.int(0, 1000) == 50)
			words = zeropointonePercentWords;
		
		selectedWord = words[FlxG.random.int(0, words.length - 1)];
		
		if (word != '')
			selectedWord = word;
		//i forgor if there's a function to do this
		selectedWord = selectedWord.toUpperCase();
		var splitWord = selectedWord.split(' ');
		
		var dum:Bool = false;
		for (i in splitWord) {
			realWord += i;
		}
		trace(realWord);
		
		lines = new FlxTypedGroup<FlxSprite>();
		add(lines);

		unowns = new FlxTypedSpriteGroup<FlxSprite>();
		add(unowns);
		
		var realThing:Int = 0;
		for (i in 0...selectedWord.length) {
			if (!selectedWord.isSpace(i)) 
			{
				var unown:FlxSprite = new FlxSprite(0, 90);
				//unown.x += 350 - (35 * selectedWord.length);
				//var thing = 1 - (0.05 * selectedWord.length); 
				if (260 - (15 * selectedWord.length) <= 0)
					unown.x += 40 * i;
				else
					unown.x += (260 - (15 * selectedWord.length)) * i;
				var realScale = 1 - (0.05 * selectedWord.length); 
				if (realScale < 0.2)
					realScale = 0.2;
				unown.scale.set(realScale, realScale);
				unown.updateHitbox();
				unown.frames = Paths.getSparrowAtlas('unownAlphabet', 'shared');
				unown.animation.addByPrefix('idle', selectedWord.charAt(i), 24, true);
				unown.animation.play('idle');
				unowns.add(unown);

				var line:FlxSprite = new FlxSprite(unown.x, unown.y).loadGraphic(Paths.image('unownLine', 'shared'));
				line.y += 500;
				line.scale.set(unown.scale.x, unown.scale.y);
				line.updateHitbox();
				line.ID = realThing;
				lines.add(line);
				realThing++;
			}
		}

		unowns.screenCenter(X);
		for (i in 0...lines.length) {
			lines.members[i].x = unowns.members[i].x;
		}

		timerTxt = new FlxText(FlxG.width / 2 - 5, 430, 0, '0', 32);
		timerTxt.alignment = 'center';
		timerTxt.font = Paths.font('rubik.ttf');
		add(timerTxt);
		timerTxt.text = Std.string(timer);
	}


	function correctLetter() {
		position++;
		if (position >= realWord.length) {
			close();
			win();
			FlxG.sound.play(Paths.sound('unownCorrect', 'shared'));
		}
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (i in lines) {
			if (i.ID == position) {
				FlxFlicker.flicker(i, 1.3, 1, true, false);
			} else if (i.ID < position) {
				i.visible = false;
				i.alpha = 0;
			}
		}
		if (FlxG.keys.justPressed.ANY) {
			if (realWord.charAt(position) == '?') {
				if (FlxG.keys.justPressed.SLASH && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('unownBuzzer', 'shared'));
			} else if (realWord.charAt(position) == '!') {
				if (FlxG.keys.justPressed.ONE && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('unownBuzzer', 'shared'));
			} else {
				if (FlxG.keys.anyJustPressed([FlxKey.fromString(realWord.charAt(position))])) {
					correctLetter();
				} else
					FlxG.sound.play(Paths.sound('unownBuzzer', 'shared'));
			}
		}
		/*if (FlxG.keys.justPressed.Z) {
			close();
			win();
		}*/
	}

	override function beatHit()
	{
		super.beatHit();
		if (timer > 0)
			timer--;
		else {
			close();
			lose();
			
		}
		timerTxt.text = Std.string(timer);
	}

	override public function close() {
		FlxG.autoPause = true;
		super.close();
	}
}
