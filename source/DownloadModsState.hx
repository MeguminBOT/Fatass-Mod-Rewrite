package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIInputText;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;
import haxe.zip.Entry;
#if sys
import sys.FileSystem;
import sys.io.File;
import sys.thread.Thread;
#end
import CustomFadeTransition;
import Controls;

using StringTools;

private class ZipHandler 
{
	public static function saveUncompressed(zipPath:String, savePath:String):Void {
		var zipReader = new haxe.zip.Reader(File.read(zipPath));
		var fileList:haxe.ds.List<Entry> = zipReader.read();

		if(!savePath.endsWith('/')) savePath += '/';
		if(!FileSystem.exists('${savePath}')) FileSystem.createDirectory('${savePath}');

		for(file in fileList) {
			if(file.fileName.endsWith('/')) { FileSystem.createDirectory(savePath + file.fileName); continue; }
			final fileData:Null<haxe.io.Bytes> = uncompressFile(file);

			File.saveBytes(savePath + file.fileName, fileData);
		}
	}

	public static function uncompressFile(file:Entry):Null<haxe.io.Bytes> {
		if(!file.compressed)
			return file.data; //File is already uncompressed

		var c = new haxe.zip.Uncompress(-15);
		var s = haxe.io.Bytes.alloc(file.fileSize);
		var r = c.execute(file.data,0,s,0);
		c.close();
		if( !r.done || r.read != file.data.length || r.write != file.fileSize )
			throw 'Invalid compressed data for ${file.fileName}';
		file.compressed = false;
		file.dataSize = file.fileSize;
		file.data = s;
		return file.data;
	}
}

private typedef DownloadMetadata = {
	var link:String;
	var modpack:String;
	var author:String;
	var fileName:String;
}

class DownloadModsState extends MusicBeatState
{
	var modpacks:Array<DownloadMetadata>;
	var input:FlxUIInputText;
	var downloadButton:FlxButton;
	var urlRegex = ~/^(http|https):\/\/[a-z0-9\-\.]+\.[a-z]{2,}(\/.*)?$/i;
	var url:String;
	private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];

	override function create(){
		FlxG.mouse.visible = true;

		// Load modpack metadata from server
		var http = new Http("https://raw.githubusercontent.com/MeguminBOT/Rhythm-Engine-Wiki/main/modpackDownloadList.json");
		http.onData = function(data:String) {
			modpacks = Json.parse(data);
		
			// Create UI elements for each modpack
			var buttonGroup:FlxTypedGroup<FlxButton> = new FlxTypedGroup<FlxButton>();
			for (index => metadata in modpacks) {
				var button:FlxButton = new FlxButton(100, 200 + index * 50, metadata.modpack, function(){ downloadModpack(metadata); });
				button.label.setFormat("vcr.ttf", 16, FlxColor.WHITE, "center");
				buttonGroup.add(button);
			}
			add(buttonGroup);
		};
		http.request();

		// Create input for custom modpack URL
		input = new FlxUIInputText(100, 500, 400, "Enter direct modpack URL");
		add(input);
		blockPressWhileTypingOn.push(input);
		// Create download button for custom modpack URL
		downloadButton = new FlxButton(550, 500, "Download", function(){ downloadCustomModpack(url); });
		add(downloadButton);


		var bg = new FlxSprite().loadGraphic(Paths.image("menuBGBlue"));
		add(bg);

		super.create();
	}

	private function downloadModpack(metadata:DownloadMetadata):Void {
		try {
			// Download and extract modpack
			var request = new Http(metadata.link);
			var progressBar:FlxBar;
	
			progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
			add(progressBar);
			var directory:String = Paths.mods();
			var savePath:String = directory + metadata.modpack;
			var zipPath:String = directory + metadata.fileName;

			request.onStatus = function(status:Int) {
				if (progressBar == null) {
					progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
					add(progressBar);
				}
				progressBar.value = status / 100; // The value should be between 0 and 1
			};
	
			request.onBytes = function(data:haxe.io.Bytes) {
				if (request.responseHeaders.exists("Content-Length")) {
					var size:Int = Std.parseInt(request.responseHeaders.get("Content-Length"));
					if (data.length == size){
						if(!FileSystem.exists('${zipPath.replace(metadata.fileName, "")}')) FileSystem.createDirectory('${zipPath.replace(metadata.fileName, "")}');
						File.saveBytes(zipPath, data);
						ZipHandler.saveUncompressed(zipPath, savePath);
						FileSystem.deleteFile(zipPath);
					}
				}
			};
			
			request.request(false);
			if (progressBar != null) {
				remove(progressBar);
			}
		} catch (e:Dynamic) {
			trace("Error downloading modpack: " + e);
		}
	}

	private function downloadCustomModpack(url:String):Void {
		try {
	        // Get url from the text input field and get the filename from the URL
			url = input.text;
			var fileName:String = url.substr(url.lastIndexOf("/") + 1);
	
			// Download and extract modpack
			var request = new Http(url);
			var progressBar:FlxBar;
			progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
			add(progressBar);
	
			var directory:String = Paths.mods();
			var savePath:String = directory + fileName;
			var zipPath:String = directory + fileName;
	
			request.onStatus = function(status:Int) {
				if (progressBar == null) {
					progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
					add(progressBar);
				}
				progressBar.value = status / 100; // The value should be between 0 and 1
			};

			request.onBytes = function(data:haxe.io.Bytes) {
				if (request.responseHeaders.exists("Content-Length")) {
					var size:Int = Std.parseInt(request.responseHeaders.get("Content-Length"));
					if (data.length == size){
						if(!FileSystem.exists('${zipPath.replace(fileName, "")}')) FileSystem.createDirectory('${zipPath.replace(fileName, "")}');
						File.saveBytes(zipPath, data);
						
						// Check if the MIME type is application/zip or not
						if (request.responseHeaders.exists("Content-Type")) {
							var mimeType:String = request.responseHeaders.get("Content-Type");
							if (mimeType == "application/zip" || mimeType == "application/octet-stream") {
								ZipHandler.saveUncompressed(zipPath, savePath);
							} else {
								// Handle the error here
								trace("Invalid MIME type: " + mimeType);
							}
						} else {
							// Handle the error here
							trace("Content-Type header not found");
						}
						
						FileSystem.deleteFile(zipPath);
					}
				}
			};

			request.request(false);
			if (progressBar != null) {
				remove(progressBar);
			}
		} catch (e:Dynamic) {
			trace("Error downloading custom modpack: " + e);
		}
	}

	override function update(elapsed:Float)
	{
		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				blockInput = true;
				break;
			}
		}
		
		if(controls.BACK)
		{
			{
				MusicBeatState.switchState(new MainMenuState());
			}
		}
		super.update(elapsed);
	}
}
