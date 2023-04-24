package;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CategoryFile =
{
	var categoryName:String;
	var categoryCharacter:String;
	var color:Int;
	var weekFiles:Array<String>; // List of week file names in this category
}

class CategoryData {
	public var categoryName:String = "";
	public var categoryCharacter:String = "";
	public var color:Int = -7179779;
	public var weekFiles:Array<String> = []; // List of week file names in this category

	public var fileName:String;

	public function new(categoryFile:CategoryFile, fileName:String) {
		categoryName = categoryFile.categoryName;
		categoryCharacter = categoryFile.categoryCharacter;
		color = categoryFile.color;
		weekFiles = categoryFile.weekFiles;

		this.fileName = fileName;
	}

	// Load a single category file from JSON
	public static function loadCategoryFile(fileName:String):CategoryFile {
		return Json.parse(FileSystem.getContent(fileName));
	}

	// Load all category files from the categories directory
	public static function loadCategories():Array<CategoryData> {
		var categories:Array<CategoryData> = [];
		for (file in FileSystem.readDirectory(Paths.getPreloadPath('categories'))) {
			var path = haxe.io.Path.join([Paths.getPreloadPath('categories'), file]);
			if (!sys.FileSystem.isDirectory(path) && file.endsWith('.json')) {
				var categoryFile:CategoryFile = loadCategoryFile(path);
				var categoryData:CategoryData = new CategoryData(categoryFile, path);
				categories.push(categoryData);
			}
		}
		return categories;
	}
}