package;

import haxe.Http;
import haxe.io.BytesInput;
import haxe.io.File;
import haxe.zip.Uncompress;
import haxe.ui.Toolkit;
import haxe.ui.core.Screen;
import haxe.ui.core.Component;
import haxe.ui.components.VBox;
import haxe.ui.components.Label;
import haxe.ui.components.Button;

using StringTools;

class DownloadSubState extends Component {

	var modList:Array<String>;
	var modButtons:Array<Button>;
	
	public function new(modList:Array<String>) {
		super();
		this.modList = modList;
		modButtons = [];
		
		// Create a VBox to hold the mod buttons
		var vbox = new VBox();
		vbox.setStyle("padding", 10);
		addChild(vbox);
		
		// Add a label to the top of the menu
		var titleLabel = new Label("Select a mod to download:");
		titleLabel.setStyle("fontSize", 24);
		vbox.addChild(titleLabel);
		
		// Create a button for each mod in the list
		for (mod in modList) {
			var button = new Button(mod);
			button.setStyle("marginBottom", 10);
			button.onClick = function() downloadMod(button.text);
			vbox.addChild(button);
			modButtons.push(button);
		}
		
		// Set the size of the menu based on the number of mods
		setActualSize(Screen.width, Screen.height);
		vbox.setActualSize(Screen.width, modList.length * 50 + 100);
	}
	
	function downloadMod(modName:String):Void {
		// Check if the mod file already exists
		var modFile = new haxe.io.File("mods/" + modName + ".zip");
		if (modFile.exists()) {
			trace("Mod file already exists, skipping download");
			return;
		}
		
		// Send a request to download the mod file
		var http = new haxe.Http("https://github.com/MeguminBOT/Fatass-Mod-Download-Test/releases/download/test/" + modName + ".zip");
		http.onData = function(data:String) {
			// The mod file has been downloaded, save it to disk and unzip it
			var file = new haxe.io.File("mods/" + modName + ".zip");
			file.write(data);
			file.close();
			trace("Mod download complete");
			
			var zip = new haxe.zip.Uncompress(new haxe.io.BytesInput(haxe.io.Bytes.ofString(data)));
			var outputDir = new haxe.io.File("mods/" + modName);
			outputDir.createDirectory();
			zip.extractTo(outputDir.getPath());
			trace("Mod unzipped to: " + outputDir.getPath());
		};
		http.onError = function(msg:String) {
			// Handle any errors that occur during the download process
			trace("Error downloading mod: " + msg);
		};
		http.onStatus = function(status:Int) {
			// Handle HTTP status codes
			if (status >= 400) {
				trace("HTTP error: " + status);
				http.setError("HTTP error: " + status);
			}
		};
		http.onProgress = function(current:Int, total:Int) {
			// Update progress tracking
			trace("Download progress: " + current + " / " + total);
		};
		http.setTimeout(10000); // Set a 10 second timeout for the HTTP request
		http.request();
	}
}

class DownloadMain {
	static function downloading() {
		// Populate the mod list with some example mods
		var modList = ["rnf", "Mod 2", "Mod 3"];
				
		// Create the mod menu and add it to the screen
		var modMenu = new ModMenu(modList);
		var screen = Screen.instance;
		screen.addComponent(modMenu);	
		Toolkit.init();
		Toolkit.layout();
		screen.show();
	}
}