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

using StringTools;

typedef ObjectPosition = {
    var name:String;
    var x:Float;
    var y:Float;
}

class ObjectPositionManager {

	//For accessing in other classes or LUA.
	public static var instance:ObjectPositionManager;

	//Objects
	var judgeCounterTxt:FlxText;
	var healthBar:FlxBar;
	var healthBarBG:FlxSprite;
	var iconP1:HealthIcon;
	var iconP2:HealthIcon;
	var scoreTxt:FlxText;
	var botplayTxt:FlxText;
	// var rating:FlxSprite;
	// var comboNums:FlxSpriteGroup;

	public function new
		(judgeCounterTxt:FlxText, 
		healthBar:FlxBar, 
		healthBarBG:FlxSprite, 
		iconP1:HealthIcon, 
		iconP2:HealthIcon, 
		scoreTxt:FlxText, 
		botplayTxt:FlxText) {

		instance = this;
		
		this.judgeCounterTxt = judgeCounterTxt;
		this.healthBar = healthBar;
		this.healthBarBG = healthBarBG;
		this.iconP1 = iconP1;
		this.iconP2 = iconP2;
		this.scoreTxt = scoreTxt;
		this.botplayTxt = botplayTxt;
		// this.rating = rating;
		// this.comboNums = comboNums;
	}

	function createObjectPositionsArray():Array<ObjectPosition> {
		return [
            {
				name: "judgeCounterTxt",
				x: judgeCounterTxt.x,
				y: judgeCounterTxt.y
			},
			{
				name: "healthBarBG",
				x: healthBarBG.x,
				y: healthBarBG.y
			},
			{
				name: "healthBar",
				x: healthBar.x,
				y: healthBar.y
			},
            {
				name: "iconP1",
				x: iconP1.x,
				y: iconP1.y
			},
            {
				name: "iconP2",
				x: iconP2.x,
				y: iconP2.y
			},
            {
				name: "scoreTxt",
				x: scoreTxt.x,
				y: scoreTxt.y
			},
			{
				name: "botplayTxt",
				x: botplayTxt.x,
				y: botplayTxt.y
			},
		];
	}
	
	public function updateObjectPosition(objectPositions:Array<ObjectPosition>):Void {
		for (position in objectPositions) {
			switch (position.name) {
				case "judgeCounterTxt":
					judgeCounterTxt.x = position.x;
					judgeCounterTxt.y = position.y;
				case "healthBarBG":
					healthBarBG.x = position.x;
					healthBarBG.y = position.y;
				case "healthBar":
					healthBar.x = position.x;
					healthBar.y = position.y;
				case "iconP1":
					iconP1.x = position.x;
					iconP1.y = position.y;
				case "iconP2":
					iconP2.x = position.x;
					iconP2.y = position.y;
				case "scoreTxt":
					scoreTxt.x = position.x;
					scoreTxt.y = position.y;
				case "botplayTxt":
					botplayTxt.x = position.x;
					botplayTxt.y = position.y;
				// case "rating":
				// 	rating.x = position.x;
				// 	rating.y = position.y;
				// case "comboNums":
				// 	comboNums.x = position.x;
				// 	comboNums.y = position.y;	
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
		
		saveJSONToFile(json, "positions.json");
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
		var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("positions.json");
		if (objectPositions != null) {
			updateObjectPosition(objectPositions);
		}
	}

	public function loadDefaultPositions():Void {
        var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("default_positions.json");
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