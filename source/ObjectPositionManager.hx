package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import haxe.Json;
import haxe.format.JsonParser;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import ClientPrefs;

using StringTools;

typedef ObjectPosition = {
	var name:String;
	var x:Float;
	var y:Float;
	var angle:Float;
}

class ObjectPositionManager {

	//For accessing in other classes or LUA.
	public static var instance:ObjectPositionManager;

	//Objects
	var judgeCounterTxt:FlxText;
	var healthBar:FlxBar;
	var healthBarBG:FlxSprite;
	// var iconP1:HealthIcon;
	// var iconP2:HealthIcon;
	var scoreTxt:FlxText;
	var botplayTxt:FlxText;
	var timeBar:FlxBar;
	var timeBarBG:FlxSprite;
	var timeTxt:FlxText;
	// var rating:FlxSprite;
	// var comboNums:FlxSpriteGroup;

	public function new
		(judgeCounterTxt:FlxText, 
		healthBar:FlxBar, 
		healthBarBG:FlxSprite, 
		//iconP1:HealthIcon, 
		//iconP2:HealthIcon, 
		scoreTxt:FlxText, 
		botplayTxt:FlxText,
		timeTxt:FlxText,
		timeBar:FlxBar,
		timeBarBG:FlxSprite) {

		instance = this;
		
		this.judgeCounterTxt = judgeCounterTxt;
		this.healthBar = healthBar;
		this.healthBarBG = healthBarBG;
		// this.iconP1 = iconP1;
		// this.iconP2 = iconP2;
		this.scoreTxt = scoreTxt;
		this.botplayTxt = botplayTxt;
		this.timeTxt = timeTxt;
		this.timeBar = timeBar;
		this.timeBarBG = timeBarBG;
		// this.rating = rating;
		// this.comboNums = comboNums;
	}

	function createObjectPositionsArray():Array<ObjectPosition> {
		return [
            {
				name: "judgeCounterTxt",
				x: judgeCounterTxt.x,
				y: judgeCounterTxt.y,
				angle: judgeCounterTxt.angle
			},
			{
				name: "healthBarBG",
				x: healthBarBG.x,
				y: healthBarBG.y,
				angle: healthBarBG.angle
			},
			{
				name: "healthBar",
				x: healthBar.x,
				y: healthBar.y,
				angle: healthBar.angle
			},
            // {
			// 	name: "iconP1",
			// 	x: iconP1.x,
			// 	y: iconP1.y,
			// 	angle: iconP1.angle
			// },
            // {
			// 	name: "iconP2",
			// 	x: iconP2.x,
			// 	y: iconP2.y,
			// 	angle: iconP2.angle
			// },
            {
				name: "scoreTxt",
				x: scoreTxt.x,
				y: scoreTxt.y,
				angle: scoreTxt.angle
			},
			{
				name: "botplayTxt",
				x: botplayTxt.x,
				y: botplayTxt.y,
				angle: botplayTxt.angle
			},
			{
				name: "timeTxt",
				x: timeTxt.x,
				y: timeTxt.y,
				angle: timeTxt.angle
			},
			{
				name: "timeBarBG",
				x: timeBarBG.x,
				y: timeBarBG.y,
				angle: timeBarBG.angle
			},
			{
				name: "timeBar",
				x: timeBar.x,
				y: timeBar.y,
				angle: timeBar.angle
			},
		];
	}
	
	public function updateObjectPosition(objectPositions:Array<ObjectPosition>):Void {
		for (position in objectPositions) {
			switch (position.name) {
				case "judgeCounterTxt":
					judgeCounterTxt.x = position.x;
					judgeCounterTxt.y = position.y;
					judgeCounterTxt.angle = position.angle;
				case "healthBarBG":
					healthBarBG.x = position.x;
					healthBarBG.y = position.y;
					healthBarBG.angle = position.angle;
				case "healthBar":
					healthBar.x = position.x;
					healthBar.y = position.y;
					healthBar.angle = position.angle;
				// case "iconP1":
				// 	iconP1.x = position.x;
				// 	iconP1.y = position.y;
				// 	iconP1.angle = position.angle;
				// case "iconP2":
				// 	iconP2.x = position.x;
				// 	iconP2.y = position.y;
				// 	iconP2.angle = position.angle;
				case "scoreTxt":
					scoreTxt.x = position.x;
					scoreTxt.y = position.y;
					scoreTxt.angle = position.angle;
				case "botplayTxt":
					botplayTxt.x = position.x;
					botplayTxt.y = position.y;
					botplayTxt.angle = position.angle;
				case "timeTxt":
					timeTxt.x = position.x;
					timeTxt.y = position.y;
					timeTxt.angle = position.angle;
				case "timeBarBG":
					timeBarBG.x = position.x;
					timeBarBG.y = position.y;
					timeBarBG.angle = position.angle;
				case "timeBar":
					timeBar.x = position.x;
					timeBar.y = position.y;
					timeBar.angle = position.angle;
				// case "rating":
				//     rating.x = position.x;
				//     rating.y = position.y;
				//     rating.angle = position.angle;
				// case "comboNums":
				//     comboNums.x = position.x;
				//     comboNums.y = position.y;
				//     comboNums.angle = position.angle;    
				default:
			}
		}
	}

	public function getObjectPositionsFromJson(fileName:String):Array<ObjectPosition> {
		var json:String = loadJSONFromFile(fileName);
		if (json == null) return null;
	
		try {
			var objectPositions:Array<ObjectPosition> = Json.parse(json);
			return objectPositions;
		} catch (e:Dynamic) {
			return null;
		}
	}

	public function savePositions():Void {
		var objectPositions:Array<ObjectPosition> = createObjectPositionsArray();
		var json:String = Json.stringify(objectPositions, null, "   ");
		
		saveJSONToFile(json, "user_positions.json");
	}

	function saveJSONToFile(json:String, fileName:String):Void {
		#if sys
		var filePath = 'config/' + fileName;
		var file = sys.io.File.write(filePath, false);
		file.writeString(json);
		file.close();
		#end
	}

	public function loadPositions():Void {
		var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("user_positions.json");
		if (objectPositions != null) {
			updateObjectPosition(objectPositions);
		}
	}

	public function loadDefaultPositions():Void {
		if (ClientPrefs.downScroll == false) {
        	loadUpscrollPositions();
		} else {
			loadDownscrollPositions();
		}
    }

	public function loadUpscrollPositions():Void {
        var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("default_positions_upscroll.json");
        if (objectPositions != null) {
            updateObjectPosition(objectPositions);
			savePositions();
        }
    }

	public function loadDownscrollPositions():Void {
        var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("default_positions_downscroll.json");
        if (objectPositions != null) {
            updateObjectPosition(objectPositions);
			savePositions();
        }
    }
    
	function loadJSONFromFile(fileName:String):String {
		var rawJson = null;
		try {
			var formattedPath:String = 'config/' + fileName;
			#if sys
			if (sys.FileSystem.exists(formattedPath)) {
				rawJson = File.getContent(formattedPath).trim();
			}
	
			while (!rawJson.endsWith("}") && !rawJson.endsWith("]")) {
				rawJson = rawJson.substr(0, rawJson.length - 1);
			}
	
			var parsedJson = Json.parse(rawJson);
			var formattedJson = Json.stringify(parsedJson, "  ");
			#end
			return rawJson;
			
		} catch (e:Dynamic) {
			return null;
		}
	}
}