package;

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
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import haxe.Json;
import haxe.format.JsonParser;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

typedef ObjectPosition = {
    var name: String;
    var x: Float;
    var y: Float;
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
	var botplaySine:Float = 0;

    public function new() {
		instance = this;
    }

	private function getObjectIdentifier(obj:FlxObject):String {
		if (obj == judgeCounterTxt) return "judgeCounterTxt";
		else if (obj == healthBarBG) return "healthBarBG";
		else if (obj == healthBar) return "healthBar";
		else if (obj == iconP1) return "iconP1";
		else if (obj == iconP2) return "iconP2";
		else if (obj == scoreTxt) return "scoreTxt";
		else if (obj == botplayTxt) return "botplayTxt";
		else return null;
	}

	function loadPositions():Void {
        var objectPositions:Array<ObjectPosition> = getObjectPositionsFromJson("positions.json");
        if (objectPositions != null) {
            setObjectPositions(objectPositions);
        }
    }

	function getObjectPositionsFromJson(fileName:String):Array<ObjectPosition> {
        var json:String = loadJSONFromFile(fileName);
        if (json == null) return null;

        try {
            var objectPositions:Array<ObjectPosition> = Json.parse(json);
            return objectPositions;
        } catch (e:Dynamic) {
            trace('Error loading JSON file: ' + e);
            return null;
        }
    }
	
	function setObjectPositions(objectPositions:Array<ObjectPosition>):Void {
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
				default:
			}
		}
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
		];
	}
	
	public function savePositions():Void {
        var objectPositions:Array<ObjectPosition> = createObjectPositionsArray();
        var json:String = Json.stringify(objectPositions);
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
    
	function loadJSONFromFile(fileName:String):String {
		var rawJson = null;
		try {
			var formattedPath:String = 'config/' + fileName;
	
			#if MODS_ALLOWED
			var moddyFile:String = Paths.modsJson(formattedPath);
			if (FileSystem.exists(moddyFile)) {
				rawJson = File.getContent(moddyFile).trim();
			}
			#end
	
			if (rawJson == null) {
				#if sys
				rawJson = File.getContent(Paths.json(formattedPath)).trim();
				#else
				rawJson = Assets.getText(Paths.json(formattedPath)).trim();
				#end
			}
	
			while (!rawJson.endsWith("}")) {
				rawJson = rawJson.substr(0, rawJson.length - 1);
			}
	
			return rawJson;
		} catch (e:Dynamic) {
			trace('Error loading JSON file: ' + e);
			return null;
		}
	}
	
}