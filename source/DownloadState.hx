package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButtonMode;

class DownloadState extends MainMenuState {
    override public function create():Void {
        super.create();

        var title = new FlxText(0, 50, FlxG.width, "Content");
        title.alignment = "center";
        add(title);


        var downloadButton = new FlxButton(0, 200, "Download Content", onDownloadContent);
        downloadButton.x = (FlxG.width - downloadButton.width) / 2;
        add(downloadButton);
    }

    private function onDownloadContent():Void {
        FlxG.switchState(new DownloadSubState());
    }
}
