package;

import flixel.math.FlxPoint.FlxCallbackPoint;
#if desktop
import Discord.DiscordClient;
#end
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import editors.ChartingState;
import flash.text.TextField;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

class FreeplaySelectState extends MusicBeatState {
	public static var categories:Array<CategoryMetaData> = [
		new CategoryMetaData("all", 0, "pico", FlxColor.fromRGB(0, 255, 0)),
		new CategoryMetaData("vanilla", 0, "bf", FlxColor.fromRGB(135, 206, 250)),
		new CategoryMetaData("test", 0, "gf", FlxColor.fromRGB(255, 0, 0))
	];
    
	var selector:FlxText;
	public static var curSelected:Int = 0;

	private var iconArray:Array<HealthIcon> = [];

	private var grpCategories:FlxTypedGroup<Alphabet>;

	var currentCategoryName:Alphabet;
	
	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

    override function create()
		{
			//Paths.clearStoredMemory();
			//Paths.clearUnusedMemory();
			
			persistentUpdate = true;
			PlayState.isStoryMode = false;
	
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("In the Menus", null);
			#end
	
			bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			add(bg);
			bg.screenCenter();
	
			grpCategories = new FlxTypedGroup<Alphabet>();
			add(grpCategories);
	
			for (i in 0...categories.length)
			{
				var categoryText:Alphabet = new Alphabet(90, 320, categories[i].categoryName, true);
				categoryText.isMenuItem = true;
				categoryText.targetY = i - curSelected;
				grpCategories.add(categoryText);
	
				var maxWidth = 980;
				if (categoryText.width > maxWidth)
				{
					categoryText.scaleX = maxWidth / categoryText.width;
				}
				categoryText.snapToPosition();
				var icon:HealthIcon = new HealthIcon(categories[i].categoryCharacter);
				icon.sprTracker = categoryText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
	
				// categoryText.x += 40;
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				// categoryText.screenCenter(X);
			}
	
			if(curSelected >= categories.length) curSelected = 0;
			bg.color = categories[curSelected].color;
			intendedColor = bg.color;
			
			changeSelection();
	
			var textBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 100, 0xFF000000);
			textBG.alpha = 0.6;
			add(textBG);

			var selectedCategoryText:Alphabet = new Alphabet(0, 50, "Selected Category", true);
			selectedCategoryText.scaleX = 0.5;
			selectedCategoryText.scaleY = 0.5;
			selectedCategoryText.screenCenter(X);
			add(selectedCategoryText);

			var selectedCategoryTextColon:Alphabet = new Alphabet(0, -110, ":", false);
			selectedCategoryTextColon.scaleX = 0.5;
			selectedCategoryTextColon.scaleY = 0.5;
			selectedCategoryTextColon.screenCenter(X);
			selectedCategoryTextColon.x += 210;
			add(selectedCategoryTextColon);


			currentCategoryName = new Alphabet(0, -25, "", false);
			currentCategoryName.screenCenter(X);
			currentCategoryName.alignment = Alphabet.Alignment.CENTERED;
			currentCategoryName.scaleX = 0.5;
			currentCategoryName.scaleY = 0.5;
			add(currentCategoryName);

			super.create();
		}
	
		override function closeSubState() {
			changeSelection(0, false);
			persistentUpdate = true;
			super.closeSubState();
		}
	
		var instPlaying:Int = -1;
		public static var vocals:FlxSound = null;
		var holdTime:Float = 0;
		override function update(elapsed:Float)
		{
			currentCategoryName.text = categories[curSelected].categoryName;

			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
	
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;
			var accepted = controls.ACCEPT;
			var space = FlxG.keys.justPressed.SPACE;
			var ctrl = FlxG.keys.justPressed.CONTROL;
	
			var shiftMult:Int = 1;
			if(FlxG.keys.pressed.SHIFT) shiftMult = 3;
	
			if(categories.length > 1)
			{
				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}
	
				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
	
					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
	
				if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				}
			}
	
			if (controls.BACK)
			{
				persistentUpdate = false;
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}	
			else if (accepted)
			{
				MusicBeatState.switchState(new FreeplayState());
			}
			super.update(elapsed);
		}

		function changeSelection(change:Int = 0, playSound:Bool = true)
		{
			if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = categories.length - 1;
			if (curSelected >= categories.length)
				curSelected = 0;
				
			var newColor:Int = categories[curSelected].color;
			if(newColor != intendedColor) {
				if(colorTween != null) {
					colorTween.cancel();
				}
				intendedColor = newColor;
				colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
				});
			}
	
			var bullShit:Int = 0;
	
			for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0.6;
			}
	
			iconArray[curSelected].alpha = 1;
	
			for (item in grpCategories.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0.6;
				//item.setGraphicSize(Std.int(item.width * 0.8));
	
				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}
		}
	}

class CategoryMetaData
{
	public var categoryName:String = "";
	public var week:Int = 0;
	public var categoryCharacter:String = "";
	public var color:Int = -7179779;

	public function new(category:String, week:Int, categoryCharacter:String, color:Int)
	{
		this.categoryName = category;
		this.week = week;
		this.categoryCharacter = categoryCharacter;
		this.color = color;
	}
}