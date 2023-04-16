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
	var artist:String;
	var mod:String;
	var bpm:Float;
	var isRemix:String;
	var charter:String;
	var hasCustomNotes:String;
	var hasCustomMechanics:String;
	var hasFlashingLights:String;
	var extraComment:String;
}

class ChartMetaData
{
	public var song:String;
	public var artist:String = '';
	public var mod:String = '';
	public var bpm:Float;
	public var isRemix:String = '';
	public var charter:String = '';
	public var hasCustomNotes:String = '';
	public var hasCustomMechanics:String = '';
	public var hasFlashingLights:String = '';
	public var extraComment:String = '';

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
