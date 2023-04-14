package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef MetaData =
{
	var song:String;
	var bpm:Float;
	var speed:Float;
	var artist:String;
	var isRemix:Bool;
	var mod:String;
	var charter:String;
	var hasCustomNotes:Bool;
	var hasCustomMechanics:Bool;
	var hasFlashingLights:Bool;
}

class ChartMetaData
{
	public var song:String;
	public var bpm:Float;
	public var speed:Float = 1;
	public var artist:String = '';
	public var isRemix:Bool = false;
	public var mod:String = '';
	public var charter:String = '';
	public var hasCustomNotes:Bool = false;
	public var hasCustomMechanics:Bool = false;
	public var hasFlashingLights:Bool = false;

	public static function loadFromJson(jsonInput:String, ?folder:String):MetaData
	{
		var rawJson = null;
		
		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson(formattedFolder + '/' + formattedSong);
		if(FileSystem.exists(moddyFile)) {
			rawJson = File.getContent(moddyFile).trim();
		}
		#end

		if(rawJson == null) {
			#if sys
			rawJson = File.getContent(Paths.json(formattedFolder + '/' + formattedSong)).trim();
			#else
			rawJson = Assets.getText(Paths.json(formattedFolder + '/' + formattedSong)).trim();
			#end
		}

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		var metadataJson:Dynamic = parseJSONshit(rawJson);
		return metadataJson;
	}

	public static function parseJSONshit(rawJson:String):ChartMetaData
	{
		var metadataShit:ChartMetaData = cast Json.parse(rawJson).song;
		return metadataShit;
	}
}
