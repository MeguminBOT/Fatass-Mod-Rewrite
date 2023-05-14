/*----------- ModularUI -----------*/
/*----------- Object Position Manager -----------*/

/*----------- by AutisticLulu -----------*/
/*----------- for Rhythm Engine -----------*/

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

	// Objects.
	var judgeCounterTxt:FlxText;
	var healthBar:FlxBar;
	var healthBarBG:FlxSprite;
	var iconP1:HealthIcon;
	var iconP2:HealthIcon;
	var scoreTxt:FlxText;
	var botplayTxt:FlxText;
	var timeBar:FlxBar;
	var timeBarBG:FlxSprite;
	var timeTxt:FlxText;

	public function new
		(judgeCounterTxt:FlxText, 
		healthBar:FlxBar, 
		healthBarBG:FlxSprite, 
		iconP1:HealthIcon, 
		iconP2:HealthIcon, 
		scoreTxt:FlxText, 
		botplayTxt:FlxText,
		timeTxt:FlxText,
		timeBar:FlxBar,
		timeBarBG:FlxSprite) {

		instance = this;
		
		this.judgeCounterTxt = judgeCounterTxt;
		this.healthBar = healthBar;
		this.healthBarBG = healthBarBG;
		this.iconP1 = iconP1;
		this.iconP2 = iconP2;
		this.scoreTxt = scoreTxt;
		this.botplayTxt = botplayTxt;
		this.timeTxt = timeTxt;
		this.timeBar = timeBar;
		this.timeBarBG = timeBarBG;
	}

	/* There's probably a much more efficient way to handle this, but it works for now. */
	// Create an array to store the positions of the objects.
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
            {
				name: "iconP1",
				x: iconP1.x,
				y: iconP1.y,
				angle: iconP1.angle
			},
            {
				name: "iconP2",
				x: iconP2.x,
				y: iconP2.y,
				angle: iconP2.angle
			},
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
	
	/* There's probably a much more efficient way to handle this, but it works for now. */
	// Update the position of the object in the array.
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
				case "iconP1":
					iconP1.x = position.x;
					iconP1.y = position.y;
					iconP1.angle = position.angle;
				case "iconP2":
					iconP2.x = position.x;
					iconP2.y = position.y;
					iconP2.angle = position.angle;
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
				default:
			}
		}
	}

	// Get object positions using Json files.
	public function getObjectPositionsFromJson(fileName:String):Array<ObjectPosition> {

		// Load the Json data from the specified file.
		var json:String = loadJSONFromFile(fileName);

		// If there is no data, return null.
		if (json == null) return null;
	
		try {
			// Parse the Json data into an array of objects.
			var objectPositions:Array<ObjectPosition> = Json.parse(json);
			return objectPositions;

		} catch (e:Dynamic) {
			// If there was an error parsing the Json data, return null.
			return null;
		}
	}

	// Save object positions using a Json file.
	public function savePositions():Void {

		// Convert object array into Json data.
		var objectPositions:Array<ObjectPosition> = createObjectPositionsArray();
		var json:String = Json.stringify(objectPositions, null, "   ");
		
		// Save the data to the specified json file.
		saveJSONToFile(json, "user_positions.json");
	}

	// Save the object positions using a Json file.
	function saveJSONToFile(json:String, fileName:String):Void {
		#if sys
		// Store Json files in a separate folder in the root directory of the game.
		var filePath = 'config/' + fileName;

		// Update the Json data.
		var file = sys.io.File.write(filePath, false);
		file.writeString(json);
		file.close();
		#end
	}

	// Load the object positions from "user_positions.json".
	// Used to get the position information in PlayState and CustomizeUI menu.
	public function loadPositions():Void {
		var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("user_positions.json");
		if (objectPositions != null) {
			updateObjectPosition(objectPositions);
		}
	}

	// Get default object positions from Json.
	// Used to reset the positions of objects in the CustomizeUI menu.
	// They're separated into different functions to easily be called in Lua or HScript in the future.
	public function loadDefaultPositions():Void {
		if (ClientPrefs.downScroll == false) {
        	loadUpscrollPositions();
		} else {
			loadDownscrollPositions();
		}
    }

	// Load the default object positions for upscroll players.
	public function loadUpscrollPositions():Void {
        var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("default_positions_upscroll.json");
        if (objectPositions != null) {
            updateObjectPosition(objectPositions);
			savePositions();
        }
    }

	// Load the default object positions for downscroll players.
	public function loadDownscrollPositions():Void {
        var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("default_positions_downscroll.json");
        if (objectPositions != null) {
            updateObjectPosition(objectPositions);
			savePositions();
        }
    }
    
	// Load Json data from file.
	function loadJSONFromFile(fileName:String):String {

		// Initializing rawJson.
		var rawJson = null;

		try {
			// Sets the directory path.
			var formattedPath:String = 'config/' + fileName;
			
			#if sys
			// Check if the file exists.
			if (sys.FileSystem.exists(formattedPath)) {

				// Get Json data as a string and trim it
				rawJson = File.getContent(formattedPath).trim();
			}
	
			// Removing any trailing characters that are not part of the Json data.
			while (!rawJson.endsWith("}") && !rawJson.endsWith("]")) {
				rawJson = rawJson.substr(0, rawJson.length - 1);
			}
	
			// Parse the raw Json string into a Json object.
			var parsedJson = Json.parse(rawJson);

			// Format the parsed Json with indentations.
			var formattedJson = Json.stringify(parsedJson, "  ");
			#end
			return rawJson;
			
		} catch (e:Dynamic) {
			// If there was an error, return null.
			return null;
		}
	}
}