package;

import flixel.FlxObject;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

class ObjectPositionManager {
    
    public function new() {
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
		var json:String = loadJSONFromFile("positions.json");
		if (json != null) {
			var objectPositions:Array<Dynamic> = Json.parse(json);
			setObjectPositions(objectPositions);
		}
	}
	
	function setObjectPositions(objectPositions:Array<Dynamic>):Void {
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
					iconP1.x = iconP1.x;
					iconP1.y = iconP1.y;
                case "iconP2":
					iconP2.x = iconP2.x;
					iconP2.y = iconP2.y;
                case "scoreTxt":
					scoreTxt.x = scoreTxt.x;
					scoreTxt.y = scoreTxt.y;
                case "botplayTxt":
					botplayTxt.x = botplayTxt.x;
					botplayTxt.y = botplayTxt.y;
				default:
			}
		}
	}
	
	function createObjectPositionsArray():Array<Dynamic> {
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
	
	function savePositions():Void {
		var objectPositions:Array<Dynamic> = createObjectPositionsArray();
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
        #if sys
        var filePath = 'config/' + fileName;
        if (!sys.FileSystem.exists(filePath)) return null;
    
        var file = sys.io.File.read(filePath, false);
        var json:String = file.readString();
        file.close();
        return json;
        #end
    
        return null;
    }
    
}