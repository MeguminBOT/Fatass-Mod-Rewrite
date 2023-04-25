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
    var index:Int = 0;

    override function create(){
        FlxG.mouse.visible = true;

        // Load modpack metadata from JSON file
        modpacks = Json.parse(File.getContent("mods/modpackDownloadList.json"));

        // Create UI elements for each modpack
        var buttonGroup:FlxSpriteGroup = new FlxSpriteGroup();
        for (metadata in modpacks) {
            var button:FlxButton = new FlxButton(100, 200 + index * 50, metadata.modpack, function(){ downloadModpack(metadata); });
            button.label.setFormat("rubik.ttf", 16, FlxColor.WHITE, "center");
            buttonGroup.add(button);
            index++;
        }
        add(buttonGroup);

        // Create input for custom modpack URL
        input = new FlxUIInputText(100, 500, 400, "Enter direct modpack URL");
        add(input);

        // Create download button for custom modpack URL
        var downloadButton:FlxButton = new FlxButton(550, 500, "Download");
        add(downloadButton);

        var urlRegex = ~/^(http|https):\/\/[a-z0-9\-\.]+\.[a-z]{2,}(\/.*)?$/i;
        if (urlRegex.match(input.text)) {
            // show download button
        } else {
            // hide download button
        }

        var bg = new FlxSprite().loadGraphic(Paths.image("menuBGBlue"));
        add(bg);

        super.create();
    }

    private function downloadModpack(metadata:DownloadMetadata):Void {
        try {
            // Download and extract modpack
            var request = new Http(metadata.link);
            var progressBar:FlxBar;
            request.onBytes = function(data:haxe.io.Bytes) {
                var zipPath:String = "modpacks/" + metadata.fileName;
                var savePath:String = Paths.mods();
                progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
                add(progressBar);
                ZipHandler.saveUncompressed(zipPath, savePath);
            };
            request.onStatus = function(status:Int) {
                if (progressBar == null) {
                    progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
                    add(progressBar);
                }
                progressBar.value = status / 100; // The value should be between 0 and 1
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
            // Extract file name from URL
            var fileName:String = url.substr(url.lastIndexOf("/") + 1);
        
            // Download and extract modpack
            var request = new Http(url);
            var progressBar:FlxBar;
            request.onBytes = function(data:haxe.io.Bytes) {
                var zipPath:String = "modpacks/" + fileName;
                var savePath:String = Paths.mods();
                progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
                add(progressBar);
                ZipHandler.saveUncompressed(zipPath, savePath);
                modpacks.push({ link: url, modpack: fileName.substr(0, fileName.lastIndexOf(".")), author: "", fileName: fileName });
            };
            request.onStatus = function(status:Int) {
                if (progressBar == null) {
                    progressBar = new FlxBar(0, 0, FlxG.width, 20, null, 0, 1, false);
                    add(progressBar);
                }
                progressBar.value = status / 100; // The value should be between 0 and 1
            };
            request.request(false);
            if (progressBar != null) {
                remove(progressBar);
            }
        } catch (e:Dynamic) {
            trace("Error downloading custom modpack: " + e);
        }
    }
}
