package;

import flixel.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxInputText;
import haxe.Json;
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.errors.IOError;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

class DownloadState extends MusicBeatState {

    var background:FlxSprite;
    var packButtons:Array<FlxButton>;
    var customUrlInput:FlxInputText;
    var downloadButton:FlxButton;
    var packs:Array<String> = ["https://github.com/MeguminBOT/Fatass-Mod-Download-Test/releases/download/test/rnf.zip", "https://www.example.com/pack2.zip"];

    override public function create():Void {
        super.create();
        background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(background);

        packButtons = [];
        for (i in 0...packs.length) {
            var button = new FlxButton(FlxG.width / 2 - 40, 50 * (i + 1), "Download Pack " + (i + 1), downloadPack(i));
            button.label.color = 0xFFFFFFFF;
            add(button);
            packButtons.push(button);
        }

        customUrlInput = new FlxInputText(FlxG.width / 2 - 150, FlxG.height - 80, 300, 30, "Custom URL");
        add(customUrlInput);

        downloadButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height - 40, "Download Custom", downloadCustom);
        downloadButton.label.color = 0xFFFFFFFF;
        add(downloadButton);
    }

    function downloadPack(index:Int):Void {
        var url = packs[index];
        var loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, function(e:Event):Void {
            var data = e.target.data;
            var bytes = ByteArray(data);
            var zip = new ZipFile(bytes);

            // Loop over all entries in the zip file
            for (entry in zip.entryList) {
                var filename = entry.name;
                var content = zip.getInput(entry);
                var imageBytes = ByteArray(content.readAll());
                var image = BitmapData.fromBytes(imageBytes);

                // Do something with the image, e.g. display it
                var sprite = new FlxSprite(50, 50);
                sprite.pixels = image;
                add(sprite);
            }
        });
        loader.load(new URLRequest(url));
    }

    function downloadCustom():Void {
        var url = customUrlInput.text;
        var loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, function(e:Event):Void {
            var data = e.target.data;
            var bytes = ByteArray(data);
            var zip = new ZipFile(bytes);

            // Loop over all entries in the zip file
            for (entry in zip.entryList) {
                var filename = entry.name;
                var content = zip.getInput(entry);
                var imageBytes = ByteArray(content.readAll());
                var image = BitmapData.fromBytes(imageBytes);

                // Do something with the image, e.g. display it
                var sprite = new FlxSprite(50, 50);
                sprite.pixels = image;
                add(sprite);
            }
        });
        loader.load(new URLRequest(url));
    }

    override public function destroy():Void {
        super.destroy();
        background = null;
        packButtons = null;
        customUrlInput = null;
        downloadButton = null;
        packs = null;
    }
}
