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
import haxe.Timer;
import haxe.zip.Entry;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLRequest;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
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
	var logo:String;
}

class DownloadModsState extends MusicBeatState
{
	// UI Stuff.
	var modpacks:Array<DownloadMetadata>;
	var progressBar:FlxBar;
	var progressTxt:FlxText;
	var blockInput:Bool = false;

	// Download stuff.
	var receivedBytes:Int = 0;
	var totalBytes:Int = 0;
	var downloadedMB:Float;
	var totalMB:Float;
	var percent:Int;

	//var input:FlxUIInputText;
	//var downloadButton:FlxButton;
	//var urlRegex = ~/^(http|https):\/\/[a-z0-9\-\.]+\.[a-z]{2,}(\/.*)?$/i;
	//var url:String;
	//private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];

	override function create() {
		FlxG.mouse.visible = true;

		var bg = new FlxSprite().loadGraphic(Paths.image("menuBG"));
		add(bg);

		// Load modpack metadata from github repository.
		var http = new Http("https://raw.githubusercontent.com/MeguminBOT/Rhythm-Engine-Wiki/main/modpackDownloadList.json");
		http.onData = function(data:String) {
			modpacks = Json.parse(data);
	
			// Create UI elements for each modpack.
			var buttonGroup:FlxTypedGroup<FlxButton> = new FlxTypedGroup<FlxButton>();
			var logoGroup:FlxSpriteGroup = new FlxSpriteGroup();
			var rowLength:Int = 10; // number of objects per row.
			var rowIndex:Int = 0;
			var colIndex:Int = 0;
			for (index => metadata in modpacks) {
				var button:FlxButton = new FlxButton(50 + colIndex * 150, 50 + rowIndex * 65, 'Download', function() { downloadModpack(metadata); });
				button.label.setFormat("rubik.ttf", 8, FlxColor.BLACK, "center");
				buttonGroup.add(button);
	
				var loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event) {
					var bitmap:Bitmap = event.target.content;
					var sprite:FlxSprite = new FlxSprite(0, 0, bitmap.bitmapData);
					sprite.scale.x = 0.5;
					sprite.scale.y = 0.5;
					sprite.x = button.x + 50;
					sprite.y = button.y + (button.height - sprite.height) / 2;
					logoGroup.add(sprite);
				});
				loader.load(new URLRequest(metadata.logo));
	
				rowIndex++;
				if (rowIndex >= rowLength) {
					colIndex++;
					rowIndex = 0;
				}
			}
			add(buttonGroup);
			add(logoGroup);
		};
		http.request();

		// Create progress bar.
		progressBar = new FlxBar(0, 0, FlxG.width, 20, null, totalBytes, 100, false);

		// Create progress text.
		progressTxt = new FlxText(0, 250, FlxG.width, "");
		progressTxt.setFormat("rubik.ttf", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
		/* 	
		// Create input for custom modpack URL
		input = new FlxUIInputText(100, 500, 400, "Enter direct modpack URL");
		add(input);
		blockPressWhileTypingOn.push(input);

		// Create download button for custom modpack URL
		downloadButton = new FlxButton(550, 500, "Download", function(){ downloadCustomModpack(url); });
		add(downloadButton); 
		*/
		super.create();
	}

	private function downloadModpack(metadata:DownloadMetadata):Void {
		try {
			// Create the URLRequest object with the download link.
			var request = new URLRequest(metadata.link);
		
			// Create the URLLoader object to load the data.
			var urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

			// Path variables.
			var directory = Paths.mods();
			var savePath = directory + 'modpack_' + metadata.modpack;
			var zipPath:String = directory + metadata.fileName;

			// Add progress indicators.
			add(progressBar);
			add(progressTxt);
		
			// Listen for progress events.
			urlLoader.addEventListener(ProgressEvent.PROGRESS, function(event:Dynamic) {
				receivedBytes = event.bytesLoaded;
				totalBytes = event.bytesTotal;
				downloadedMB = Math.round((receivedBytes / 1000000) * 100) / 100;
				totalMB = Math.round((totalBytes / 1000000) * 100) / 100;
				percent = Math.round((receivedBytes / totalBytes) * 100);

				progressBar.value = percent;
				if (percent < 100) {
					progressTxt.text = "Downloading... " + Std.string(downloadedMB) + " MB" + "/" + Std.string(totalMB) + " MB";
				} else {
					progressTxt.text = "Completed download of: " + metadata.modpack + " (" + totalMB + " MB)";
				}
				blockInput = true;
			});
			
			// Listen for completion event.
			urlLoader.addEventListener(Event.COMPLETE, function(event:Event) {
				var data:haxe.io.Bytes = untyped urlLoader.data;
				if(!FileSystem.exists('${zipPath.replace(metadata.fileName, "")}')) FileSystem.createDirectory('${zipPath.replace(metadata.fileName, "")}');
				File.saveBytes(zipPath, data);
				ZipHandler.saveUncompressed(zipPath, savePath);
				blockInput = false;
			});
		
			// Listen for error event.
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent) {
				trace("Error downloading modpack: " + event.text);
			});
		
			// Start the download.
			urlLoader.load(request);
		} catch (e:Dynamic) {
			trace("Error downloading modpack: " + e);
			progressTxt.text = "Error downloading modpack";
		}
	}
	
	/* 
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
	*/

	override function update(elapsed:Float)
	{
		/*
		for (input in blockPressWhileTypingOn) {
			if(input.hasFocus) {
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				blockInput = true;
				break;
			}
		} 
		*/

		if (!blockInput)
		{
			if(controls.BACK)
			{
				{
					MusicBeatState.switchState(new MainMenuState());
				}
			}
		}
		super.update(elapsed);
	}
}
