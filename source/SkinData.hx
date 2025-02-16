//Based of Forever Engine
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class SkinData {
    public static function getNoteFile(file:String, folder:String, skin:String = 'Default') {
        skin = Paths.formatToSongPath(skin);
        #if MODS_ALLOWED
        if (FileSystem.exists(Paths.modFolders('images/$file.png'))) { //og psych engine modpack
            return file;
        }
        #end
        var path = 'noteskins/$skin/$folder/$file';
        if (!Paths.fileExists('images/$path.png', IMAGE)) {
            path = 'noteskins/default/$folder/$file';
        }
        if (!Paths.fileExists('images/$path.png', IMAGE)) {
            path = 'noteskins/default/base/$file';
        }
        if (!Paths.fileExists('images/$path.png', IMAGE)) {
            path = (folder == 'pixel' && Paths.fileExists('images/pixelUI/$file.png', IMAGE) ? 'pixelUI' : '') + file;
        }
        return path;
    }

    public static function getUIFile(file:String, folder:String, skin:String = 'Default') {
        skin = Paths.formatToSongPath(skin);
        var path = 'uiskins/$skin/$folder/$file';
        #if MODS_ALLOWED
        if (FileSystem.exists(Paths.modFolders('images/$file.png'))) { //og psych engine modpack
            return file;
        }
        #end
        //trace(path);
        if (!Paths.fileExists('images/$path.png', IMAGE)) {
            path = 'uiskins/default/$folder/$file';
            //trace(path);
        }
        if (!Paths.fileExists('images/$path.png', IMAGE)) {
            path = 'uiskins/default/base/$file';
            //trace(path);
        }
        if (!Paths.fileExists('images/$path.png', IMAGE)) {
            path = (folder == 'pixel' && Paths.fileExists('images/pixelUI/$file.png', IMAGE) ? 'pixelUI' : '') + file;
            //trace(path);
        }
        return path;
    }
}